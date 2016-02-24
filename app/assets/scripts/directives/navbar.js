'use strict';

/**
 * @ngdoc directive
 * @name loopbackApp.directive:navbar
 * @description
 * # navbar
 */
angular.module('geckoCliApp')
  .directive('gogonavbar', function () {
    return {
      templateUrl: 'assets/elements/navbar.html',
      restrict: 'E'
    };
  });
