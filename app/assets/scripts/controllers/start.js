'use strict';

/**
 * @ngdoc function
 * @name geckoCliApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the geckoCliApp
 */
angular.module('geckoCliApp')
  .controller('StartCtrl', function ($scope, Rails) {
    $scope.theme = Rails.theme;
    $scope.title = Rails.title;
    $scope.isfilter = false;
    $scope.openfilter = false;
    
    window.loading_screen.finish();
    
    $scope.filterclick = function(){
      $scope.openfilter = !$scope.openfilter;
      $scope.$broadcast('clickfilterChanged', $scope.openfilter); 
    }
    
    function enablefilterVisibility()
    {
      $scope.isfilter = true;
    }
    
    function disaablefilterVisibility()
    {
      $scope.isfilter = false;
    }
    
    $scope.$on('enablefilterChanged', enablefilterVisibility);
    $scope.$on('disablefilterChanged', disaablefilterVisibility);
    
    $scope.toolbar = [];
  });
