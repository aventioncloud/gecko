/**=========================================================
 * Module: FormInputController.js
 * Controller for input components
 =========================================================*/

(function() {
    'use strict';

    angular
        .module('naut')
        .controller('PagesController', PagesController);
    /* @ngInject */
    function PagesController($scope, Restangular, $localStorage, $location) {
        
        var vm = this;
        
        vm.email;
        vm.password;
        
        vm.login = function(){
            Restangular.configuration.defaultRequestParams.common.access_token = '3c9445acedd6432ba0d36c5751eff23551837ddfe9fa0f694509c223e66f7fb4';
            // First way of creating a Restangular object. Just saying the base URL
            var baseAccounts = Restangular.all('application');
            
            // This will query /accounts and return a promise.
            baseAccounts.getList().then(function(accounts) {
              $scope.allAccounts = accounts;
              console.log(accounts);
            });
            $location.path('/app/dashboard');
        };
    }
    PagesController.$inject = ['$scope', 'Restangular', '$localStorage', '$location'];

})();