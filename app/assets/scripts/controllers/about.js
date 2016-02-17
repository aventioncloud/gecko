'use strict';

/**
 * @ngdoc function
 * @name geckoCliApp.controller:AboutCtrl
 * @description
 * # AboutCtrl
 * Controller of the geckoCliApp
 */
angular.module('geckoCliApp')
  .controller('AboutCtrl', function ($scope, $location, permissions, Progress, toaster) {
    setTimeout(function () {
            Progress.complete();
            
        }, 2000);
    toaster.success({title: "title", body:"text1"});
    $scope.$on('$routeChangeStart', function(scope, next, current) {
      var permission = next.$$route.permission;
      if(typeof permission === 'string' && !permissions.hasPermission(permission)) {
        $location.path('/unauthorized');
      }
    });
  });
