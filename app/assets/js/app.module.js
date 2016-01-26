/*!
 * 
 * Naut - Bootstrap Admin Theme + AngularJS
 * 
 * Author: @geedmo
 * Website: http://geedmo.com
 * License: https://wrapbootstrap.com/help/licenses
 * 
 */

angular
  .module('naut', [
    'ngRoute',
    'ngAnimate',
    'ngStorage',
    'ngCookies',
    'ngSanitize',
    'ngResource',
    'ui.bootstrap',
    'ui.router',
    'ui.utils',
    'oc.lazyLoad',
    'cfp.loadingBar',
    'tmh.dynamicLocale',
    'pascalprecht.translate',
    'restangular'
]).
  config(function($routeProvider, RestangularProvider) {
      var url = "http://"+$('body').data("url")+":3005/api/v1";
      RestangularProvider.setBaseUrl(url);
      RestangularProvider.setDefaultRequestParams({ access_token: '' })
  });
