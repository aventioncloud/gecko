'use strict';

/**
 * @ngdoc overview
 * @name geckoCliApp
 * @description
 * # geckoCliApp
 *
 * Main module of the application.
 */
function testInterceptor(AccessToken, Rails) {
  return {
    request: function(config) {
      return config;
    },

    requestError: function(config) {
      return config;
    },

    response: function(res) {
      return res;
    },

    responseError: function(res) {
      return res;
    }
  }
}
angular
  .module('geckoCliApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'ui.router', 
    'ngStorage'
  ])
  .config(function ($httpProvider, $stateProvider, $urlRouterProvider) {
    
    
    $httpProvider.interceptors.push('tokenInterceptor');
    $httpProvider.interceptors.push('unauthorizedInterceptor');

  }).factory('tokenInterceptor', function(AccessToken, Rails) {
  return {
    request: function(config) {
      var token;
      if (config.url.indexOf("//" + Rails.host) === 0) {
        token = AccessToken.get();
        if (token) {
          config.headers['Authorization'] = "Bearer " + token;
        }
      }
      return config;
    }
  };
  }).factory('unauthorizedInterceptor', function($q, $injector) {
    return function(promise) {
      var error, success;
      success = function(response) {
        return response;
      };
      error = function(response) {
        if (response.status === 401) {
          $injector.get('$state').go('401');
        }
        return $q.reject(response);
      };
      return promise.then(success, error);
    };
  });
