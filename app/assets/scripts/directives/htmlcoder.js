'use strict';

/**
 * @ngdoc filter
 * @name loopbackApp.filter:htmlcoder
 * @function
 * @description
 * # htmlcoder
 * Filter in the loopbackApp.
 */
angular.module('geckoCliApp')
  .filter('htmlcoder', function ($sce) {
    return function(input){
      var texto =  $sce.trustAsHtml(input);
      return texto;
    };
  });
