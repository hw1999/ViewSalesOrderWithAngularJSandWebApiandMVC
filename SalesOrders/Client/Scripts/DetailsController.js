(function (app) {

    var DetailsController = function ($scope, $routeParams, salesOrderService) {

        salesOrderService.getSalesOrderDetail($routeParams.id)
            .success(function (salesOrderDetails) {
                $scope.salesOrderDetails = salesOrderDetails;
                    });        

        $scope.collapse = function (event, ids) {
            $(event.target).toggleClass("glyphicon-chevron-down");

            salesOrderService.getProduct(ids)
                .success(function (products) {
                    $scope.products = products;
                });
        };

        $scope.ShowIt = function (salesOrderDetailID, productID) {
            var ids = salesOrderDetailID.toString() + ',' + productID.toString();

            salesOrderService.getProduct(ids)
                .success(function (products) {
                    $scope.products = products;
                });
        };

    };
    DetailsController.$inject = ["$scope", "$routeParams", "salesOrderService"];

    app.controller("DetailsController", DetailsController);

}(angular.module("TheSalesOrders")));