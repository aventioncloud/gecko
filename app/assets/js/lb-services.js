/**=========================================================
 * Module: filestyle.js
 * Initializes the fielstyle plugin
 =========================================================*/
(function() {
    'use strict';

    angular
        .module('naut')
        .factory('lbservices', lbservices);
    
    function lbservices() {

      controller.$inject = ['$scope', '$element'];
      return {
        restrict: 'A',
        controller: controller
      };

      function controller($scope, $element) {
        var options = $element.data();
        
        // old usage support
          options.classInput = $element.data('classinput') || options.classInput;
        
        $element.filestyle(options);
      }
    }
})();

//angular.js example for factory vs service
var app = angular.module('naut', []);
    
app.factory('testFactory', function(){
    return {
        sayHello: function(text){
            return "Factory says \"Hello " + text + "\"";
        },
        sayGoodbye: function(text){
            return "Factory says \"Goodbye " + text + "\"";
        }  
    }               
});