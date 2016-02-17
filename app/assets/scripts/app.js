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
    'ngStorage',
    'ngProgress',
    'toaster',
    'ngTable',
    'ngTableToCsv',
    'formly', 
    'formlyBootstrap',
    'oitozero.ngSweetAlert',
    'kendo.directives'
  ])
  .config(function ($httpProvider, $stateProvider, $urlRouterProvider, formlyConfigProvider) {
    $httpProvider.interceptors.push('tokenInterceptor');
    $httpProvider.interceptors.push('unauthorizedInterceptor');
    
    formlyConfigProvider.setWrapper({
      name: 'loader',
      template: [
        '<formly-transclude></formly-transclude>',
        '<span class="glyphicon glyphicon-refresh loader" ng-show="to.loading"></span>'
      ].join(' ')
    });

    formlyConfigProvider.setType({
      name: 'input-loader',
      extends: 'input',
      wrapper: ['loader']
    });

    formlyConfigProvider.setWrapper({
      template: '<formly-transclude></formly-transclude><div my-messages="options"></div>',
      types: ['input', 'checkbox', 'select', 'textarea', 'radio', 'input-loader']
    });
    
  })
  .run(function (Progress, $rootScope) {
        $rootScope.$on('$locationChangeSuccess', function () {
            Progress.start();
        });
    })
  .directive('myMessages', function() {
    return {
      templateUrl: 'custom-messages.html',
      scope: {options: '=myMessages'}
  }})
  .factory('tokenInterceptor', function(AccessToken, Rails) {
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
