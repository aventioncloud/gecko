'use strict';

/**
 * @ngdoc directive
 * @name loopbackApp.directive:barleft
 * @description
 * # barleft
 */
angular.module('geckoCliApp')
  .directive('barleft', function () {
    return {
      templateUrl: 'assets/elements/barleft.html',
      restrict: 'E'
    };
  });
