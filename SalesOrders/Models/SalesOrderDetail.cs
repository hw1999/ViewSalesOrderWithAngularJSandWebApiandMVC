using System;

namespace SalesOrders.Models
{
    public class SalesOrderDetail: ISalesOrderDetail
    {
        public int Id { get; set; }
        public int ProductID { get; set; }
        public int SalesOrderID { get; set; }
        public string CarrierTrackingNumber { get; set; }
        public int OrderQty { get; set; }
        public int SpecialOfferID { get; set; }
        public double UnitPrice { get; set; }
        public double UnitPriceDiscount { get; set; }
        public double LineTotal { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}