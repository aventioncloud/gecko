'use strict';

/**
  * @ngdoc service
  * @name geckoCliApp.accessToken
  * @description
  * # accessToken
  * Service in the geckoCliApp.
 */
angular.module('geckoCliApp');

app.service('AccessToken', function($localStorage, $timeout) {
  return {
    get: function() {
      return $localStorage.token;
    },
    set: function(token) {
      return $localStorage.token = token;
    },
    "delete": function() {
      return delete $localStorage.token;
    }
  };
});