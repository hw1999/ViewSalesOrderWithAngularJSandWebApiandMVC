using System;

namespace SalesOrders.Models
{
    interface ISalesOrder
    {
        int Id { get; set; }
        string CustomerName { get; set; }
        string AccountNumber { get; set; }
        string ShipToAddress { get; set; }
        string ShipMethod { get; set; }
        double SubTotal { get; set; }
        double Tax { get; set; }
        double Freight { get; set; }
        double Total { get; set; }
        DateTime OrderDate { get; set; }
        DateTime DueDate { get; set; }
        DateTime ShipDate { get; set; }

    }
}
