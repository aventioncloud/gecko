'use strict';


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
  }).factory('unauthorizedInterceptor', function($q, $injector, $location) {
    return {
      responseError: function(response) {
        if (response.status === 401 && response.config.url.indexOf("role/me") === -1) {
          $location.path('/unauthorized');
        }
        return $q.reject(response);
        return response;
      }
    }
  });
    
    
    
    
    /*
    
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
  });*/
