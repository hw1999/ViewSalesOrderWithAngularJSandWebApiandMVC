using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using SalesOrders.Models;
using System.Data.SqlClient;

namespace SalesOrders.Controllers
{
    public class SalesOrderController : ApiController
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SalesOrderConnectionString"].ConnectionString;

        //http://localhost:6128/api/SalesOrder/GetSalesOrder?search=3/12/2014,3/13/2014,3/24/2014,3/25/2014,3/19/2014,3/20/2014,,
        [HttpGet("{search}", RouteName ="GetSalesOrder")]
        // GET api/SalesOrder/GetSalesOrder?search=?
        public IEnumerable<SalesOrder> GetSalesOrder(string search)
        {   
            string strDefault = "3/12/2014,3/13/2014,3/24/2014,3/25/2014,3/19/2014,3/20/2014,,";
            string strUndefined = "undefined";

            if (search == null || search.Trim().Length ==0 ) 
            {
                search = strDefault;
            }
            else if (search.ToString().ToLower() == strUndefined)
            {
                search = strDefault;
            }

            string[] items = search.Split(',');
            string orderDateFrom = items[0];
            string orderDateTo = items[1];
            string dueDateFrom = items[2];
            string dueDateTo = items[3];
            string shipDateFrom = items[4];
            string shipDateTo = items[5];
            string customerName = items[6];

            List<SalesOrder> salesOrders = new List<SalesOrder>();

            try
            {                
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand command = new SqlCommand())
                    {                        
                        command.Connection = connection;
                        connection.Open();
                        command.CommandText = "dbo.GetSalesOrderInfo";
                        command.CommandType = System.Data.CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@OrderDateFrom", orderDateFrom);
                        command.Parameters.AddWithValue("@OrderDateTo", orderDateTo);
                        command.Parameters.AddWithValue("@DueDateFrom", dueDateFrom);
                        command.Parameters.AddWithValue("@DueDateTo", dueDateTo);
                        command.Parameters.AddWithValue("@ShipDateFrom", shipDateFrom);
                        command.Parameters.AddWithValue("@ShipDateTo", shipDateTo);
                        command.Parameters.AddWithValue("@CustomerName", customerName);

                        SqlDataReader reader = command.ExecuteReader();

                        while (reader.Read())
                        {
                            SalesOrder salesOrder = new SalesOrder();

                            salesOrder.Id = Convert.ToInt32( reader["SalesOrderID"].ToString());
                            salesOrder.CustomerName = reader["CustomerName"].ToString();
                            salesOrder.AccountNumber = reader["AccountNumber"].ToString();
                            salesOrder.ShipToAddress = reader["ShipToAddress"].ToString();                            
                            salesOrder.ShipMethod = reader["ShipMethod"].ToString();
                            salesOrder.SubTotal = Convert.ToDouble( reader["SubTotal"].ToString());
                            salesOrder.Tax = Convert.ToDouble(reader["Tax"].ToString());
                            salesOrder.Freight = Convert.ToDouble(reader["Freight"].ToString());
                            salesOrder.Total = Convert.ToDouble(reader["Total"].ToString());
                            salesOrder.OrderDate = Convert.ToDateTime(reader["OrderDate"].ToString());
                            salesOrder.DueDate = Convert.ToDateTime(reader["DueDate"].ToString());
                            salesOrder.ShipDate = Convert.ToDateTime(reader["ShipDate"].ToString());

                            salesOrders.Add(salesOrder);
                        }

                        if (!reader.IsClosed)
                            reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {                
                throw new HttpResponseException(HttpStatusCode.ExpectationFailed);
            }

            return salesOrders.AsEnumerable();
        }

        //http://localhost:6128/api/SalesOrder/GetSalesOrderDetail?salesOrderID=43662
        [HttpGet("{salesOrderID}", RouteName = "GetSalesOrderDetail")]
        // GET api/SalesOrder/GetSalesOrderDetail?salesOrderID=3
        public IEnumerable<SalesOrderDetail> GetSalesOrderDetail(int salesOrderID)
        {
            List<SalesOrderDetail> salesOrderDetails = new List<SalesOrderDetail>();

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand command = new SqlCommand())
                    {
                        command.Connection = connection;
                        connection.Open();
                        command.CommandText = "dbo.GetSalesOrderDetail";
                        command.CommandType = System.Data.CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@SalesOrderID", salesOrderID);                        

                        SqlDataReader reader = command.ExecuteReader();

                        while (reader.Read())
                        {
                            SalesOrderDetail salesOrderDetail = new SalesOrderDetail();

                            salesOrderDetail.Id = Convert.ToInt32(reader["SalesOrderDetailID"].ToString());
                            salesOrderDetail.ProductID = Convert.ToInt32( reader["ProductID"].ToString());
                            salesOrderDetail.SalesOrderID = Convert.ToInt32( reader["SalesOrderID"].ToString());
                            salesOrderDetail.CarrierTrackingNumber = reader["CarrierTrackingNumber"].ToString();
                            salesOrderDetail.OrderQty = Convert.ToInt32( reader["OrderQty"].ToString());
                            salesOrderDetail.SpecialOfferID = Convert.ToInt32(reader["SpecialOfferID"].ToString());
                            salesOrderDetail.UnitPrice = Convert.ToDouble(reader["UnitPrice"].ToString());
                            salesOrderDetail.UnitPriceDiscount = Convert.ToDouble(reader["UnitPriceDiscount"].ToString());
                            salesOrderDetail.LineTotal = Convert.ToDouble(reader["LineTotal"].ToString());
                            salesOrderDetail.ModifiedDate = Convert.ToDateTime(reader["ModifiedDate"].ToString());
                            
                            salesOrderDetails.Add(salesOrderDetail);
                        }

                        if (!reader.IsClosed)
                            reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new HttpResponseException(HttpStatusCode.ExpectationFailed);
            }

            return salesOrderDetails.AsEnumerable();
        }
        
        //http://localhost:6128/api/SalesOrder/GetProduct?IDs=98939,707
        [HttpGet("{IDs}", RouteName = "GetProduct")]
        // GET api/SalesOrder/GetProduct?IDs=3,4
        public IEnumerable<Product> GetProduct(string ids)
        {
            string[] items = ids.Split(',');
            string salesOrderDetailID = items[0];
            string productID = items[1];

            List<Product> products = new List<Product>();

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand command = new SqlCommand())
                    {
                        command.Connection = connection;
                        connection.Open();
                        command.CommandText = "dbo.GetProductById";
                        command.CommandType = System.Data.CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@SalesOrderDetailID", salesOrderDetailID);
                        command.Parameters.AddWithValue("@productID", productID);                        

                        SqlDataReader reader = command.ExecuteReader();

                        while (reader.Read())
                        {
                            Product product = new Product();

                            product.Id = Convert.ToInt32(reader["ProductID"].ToString());
                            product.Name = reader["Name"].ToString();
                            product.ProductNumber = reader["ProductNumber"].ToString();
                            product.Quantity = Convert.ToInt32( reader["OrderQty"].ToString());
                            product.UnitPrice = Convert.ToDouble(reader["UnitPrice"].ToString());
                            product.Discount = Convert.ToDouble(reader["UnitPriceDiscount"].ToString());
                            product.LineTotal = Convert.ToDouble(reader["LineTotal"].ToString());

                            products.Add(product);
                        }

                        if (!reader.IsClosed)
                            reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new HttpResponseException(HttpStatusCode.ExpectationFailed);
            }

            return products.AsEnumerable();
        }
        
    }
}
