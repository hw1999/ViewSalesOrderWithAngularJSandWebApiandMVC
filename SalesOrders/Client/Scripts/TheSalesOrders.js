(function (app) {

    var config = function ($routeProvider) {
        $routeProvider
            .when("/list", { templateUrl: "/client/views/list.html", controller: "ListController"})
            .when("/details/:id", { templateUrl: "/client/views/details.html", controller: "DetailsController"})
            .otherwise({ redirectTo: "/list" });
    };
   config.$inject = ["$routeProvider"];

    app.config(config);
    app.constant("salesOrderApiUrl", "/api/SalesOrder/");

}(angular.module("TheSalesOrders", ["ngRoute", "ngResource", "ngAnimate"])));