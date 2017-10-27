using System;

namespace SalesOrders.Models
{
    public class SalesOrder : ISalesOrder
    {
        public int Id { get; set; }
        public string CustomerName { get; set; }
        public string AccountNumber { get; set; }
        public string ShipToAddress { get; set; }
        public string ShipMethod { get; set; }
        public double SubTotal { get; set; }
        public double Tax { get; set; }
        public double Freight { get; set; }
        public double Total { get; set; }
        public DateTime OrderDate { get; set; }
        public DateTime DueDate { get; set; }
        public DateTime ShipDate { get; set; }
        
    }
}