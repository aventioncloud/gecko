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
    'formly', 
    'formlyBootstrap',
    'oitozero.ngSweetAlert',
    'kendo.directives',
    'ui.select'
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
      name: 'ui-select',
      extends: 'select',
      template: '<ui-select ng-model="model[options.key]" theme="bootstrap" ng-required="{{to.required}}" ng-disabled="{{to.disabled}}" reset-search-input="false"> <ui-select-match placeholder="{{to.placeholder}}"> {{$select.selected[to.labelProp || \'name\']}} </ui-select-match> <ui-select-choices group-by="to.groupBy" repeat="option[to.valueProp || \'value\'] as option in to.options | filter: $select.search"> <div ng-bind-html="option[to.labelProp || \'name\'] | highlight: $select.search"></div> </ui-select-choices> </ui-select>'
    })

    formlyConfigProvider.setType({
      name: 'input-loader',
      extends: 'input',
      wrapper: ['loader']
    });
    
    formlyConfigProvider.setType({
      name: 'multiselect',
      extends: 'select',
      defaultOptions: {
        ngModelAttrs: {
          'true': {
            value: 'multiple'
          }
        }
      }
    })

    /*fformlyConfigProvider.setWrapper({
      template: '<formly-transclude></formly-transclude><div my-messages="options"></div>',
      types: ['input', 'checkbox', 'select', 'textarea', 'radio', 'input-loader']
    });*/
    
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
