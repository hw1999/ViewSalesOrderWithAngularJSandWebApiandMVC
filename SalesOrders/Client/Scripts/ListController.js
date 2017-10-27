(function (app) {

    var ListController = function ($scope, salesOrderService) {
        
        $scope.formatDate = function (theDate) {
            var value = new Date(theDate);
            return value.getMonth() + 1 + "/" + value.getDate() + "/" + value.getFullYear();
        }

        $scope.searchString = '';
        
        salesOrderService.getSalesOrder($scope.searchString).success(function (salesOrders) {
            $scope.salesOrders = salesOrders;
        });

        $scope.SearchIt = function () {
            if ($scope.OrderDateFrom == undefined || $scope.OrderDateFrom == null || $scope.OrderDateFrom == '') {

                $scope.searchString = '';
            }
            else {

                if ($scope.CustomerName == undefined || $scope.CustomerName == null ) {
                    $scope.CustomerName = '';
                }

                $scope.searchString =
                    $scope.formatDate($scope.OrderDateFrom) + ',' +
                    $scope.formatDate($scope.OrderDateTo) + ',' +
                    $scope.formatDate($scope.DueDateFrom) + ',' +
                    $scope.formatDate($scope.DueDateTo) + ',' +
                    $scope.formatDate($scope.ShipDateFrom) + ',' +
                    $scope.formatDate($scope.ShipDateTo) + ',' +
                    $scope.CustomerName + ',';
            };

            salesOrderService.getSalesOrder($scope.searchString).success(function (salesOrders) {
                $scope.salesOrders = salesOrders;
            });
        }
    };

    

    ListController.$inject = ["$scope", "salesOrderService"];

    app.controller("ListController", ListController);

}(angular.module("TheSalesOrders")));