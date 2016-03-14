angular.module('geckoCliApp').factory('viewsWatcherFactory', [
    '$http',
    '$timeout',
    function($http, $timeout) {

        var _ifMobile = (function(){
            return window.innerWidth < 850;
        })();

        return {
            get : function(id) {
                return $timeout(function(){
                    var path = id;
                    if (_ifMobile) {
                        path = id.split('/');
                        path.splice(path.length-1,0,'mobile');
                    }
                    if (Array.isArray(path)) {
                        path = path.join('/');
                    }
                    return {templateName : path};
                }, 0);
            }
        };
    }
]);