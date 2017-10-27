(function(app) {

    var salesOrderService = function ($http, salesOrderApiUrl) {

        var getSalesOrder = function (searchString) {
            return $http.get(salesOrderApiUrl + 'GetSalesOrder?search=' + searchString);
        };

        var getSalesOrderDetail = function (id) {
            return $http.get(salesOrderApiUrl + 'GetSalesOrderDetail?salesOrderID=' + id);
        };

        var getProduct = function(ids) {
            return $http.get(salesOrderApiUrl + 'GetProduct?IDs=' + ids);
        };


        return {
            getSalesOrder: getSalesOrder,
            getSalesOrderDetail: getSalesOrderDetail,
            getProduct: getProduct
        };
    };
   
    salesOrderService.$inject = ["$http", "salesOrderApiUrl"];

    app.factory("salesOrderService", salesOrderService);

}(angular.module("TheSalesOrders")))