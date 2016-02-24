'use strict';

/**
 * @ngdoc directive
 * @name loopbackApp.directive:listview
 * @description
 * # listview
 */
angular.module('geckoCliApp')
  .directive('listview', function () {
    return {
      templateUrl: 'assets/elements/balistview.html',
      restrict: 'E'
    };
  });
