using System;

namespace SalesOrders.Models
{
    interface ISalesOrderDetail
    {
       int Id { get; set; }
       int ProductID { get; set; }
       int SalesOrderID { get; set; }       
       string CarrierTrackingNumber { get; set; }
       int OrderQty { get; set; }
       int SpecialOfferID { get; set; }
       double UnitPrice { get; set; }
       double UnitPriceDiscount { get; set; }
       double LineTotal { get; set; }
       DateTime ModifiedDate { get; set; }

    }
}
