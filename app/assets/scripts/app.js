'use strict';

/**
 * @ngdoc overview
 * @name geckoCliApp
 * @description
 * # geckoCliApp
 *
 * Main module of the application.
 */
angular
  .module('geckoCliApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'ui.router', 
    'templates', 
    'ngStorage'
  ])
  .config(function ($httpProvider) {
    
    //$httpProvider.interceptors.push('tokenInterceptor');
    //$httpProvider.responseInterceptors.push('unauthorizedInterceptor');
    /*$routeProvider
      .when('/', {
        templateUrl: 'assets/main.html',
        controller: 'MainCtrl',
        controllerAs: 'main'
      })
      .when('/about', {
        templateUrl: 'assets/about.html',
        controller: 'AboutCtrl',
        controllerAs: 'about'
      })
      .otherwise({
        redirectTo: '/'
      });*/
  }).factory('tokenInterceptor', function(AccessToken, Rails) {
  return {
    request: function(config) {
      var token;
      alert(Rails.host);
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
