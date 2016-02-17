angular.module('geckoCliApp').directive('hasVisible', ['$location', function ($location) {
        return {
            restrict: 'A',
            scope: false,
            link: function (scope, element, attributes) {
                function setVisble() {
                    var path = $location.path();
                    var value = attributes["hasVisible"];
                    var notPermissionFlag = value[0] === '!';
                    if(notPermissionFlag)
                    {
                        value = value.slice(1).trim();
                    }
                    if (path.slice(1).trim() == value && !notPermissionFlag)           
                        element.show();
                    else if(path.slice(1).trim() !== value && notPermissionFlag)
                        element.show();
                    else {
                        element.hide();
                    }
                }

                setVisble();

                scope.$on('$locationChangeSuccess', setVisble);
            }
        }
    }]);