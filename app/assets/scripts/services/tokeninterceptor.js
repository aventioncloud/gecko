'use strict';

/**
  * @ngdoc service
  * @name geckoCliApp.tokenInterceptor
  * @description
  * # tokenInterceptor
  * Factory in the geckoCliApp.
 */
angular.module('geckoCliApp').factory('sessionInjector', ['SessionService', function(SessionService) {  
    var sessionInjector = {
        request: function(config) {
            if (!SessionService.isAnonymus) {
                config.headers['x-session-token'] = SessionService.token;
            }
            return config;
        }
    };
    return sessionInjector;
}]);