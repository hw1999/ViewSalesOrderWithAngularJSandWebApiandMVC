
namespace SalesOrders.Models
{
    interface IProduct
    {
        int Id { get; set; }
        string Name { get; set; }
        string ProductNumber { get; set; }
        int Quantity { get; set; }
        double UnitPrice { get; set; }
        double Discount { get; set; }
        double LineTotal { get; set; }
    }
}
