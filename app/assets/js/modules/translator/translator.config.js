/**=========================================================
 * Module: TranslateConfig.js
 =========================================================*/

(function() {
    'use strict';

    angular
        .module('naut')
        .config(translateConfig);
    /* @ngInject */
    function translateConfig($translateProvider) {

      $translateProvider.useStaticFilesLoader({
        prefix: 'assets/langs/',
        suffix: '.json'
      });
      $translateProvider.preferredLanguage('pt');
      $translateProvider.useLocalStorage();
    }
    translateConfig.$inject = ['$translateProvider'];

})();
