'use strict';

/**
 * @ngdoc directive
 * @name loopbackApp.directive:barleft
 * @description
 * # barleft
 */
angular.module('geckoCliApp')
  .directive('ngToolbar', function () {
    return {
      templateUrl: 'assets/elements/toolbar.html',
      restrict: 'E'
    };
  });