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
    window.loading_screen.finish();
  });
