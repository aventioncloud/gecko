'use strict';

/**
 * @ngdoc function
 * @name geckoCliApp.controller:AboutCtrl
 * @description
 * # AboutCtrl
 * Controller of the geckoCliApp
 */
angular.module('geckoCliApp')
  .controller('AboutCtrl', function ($scope, $location, permissions, Progress, toaster) {
    setTimeout(function () {
            Progress.complete();
            
        }, 2000);
    toaster.success({title: "title", body:"text1"});
    $scope.$on('$routeChangeStart', function(scope, next, current) {
      var permission = next.$$route.permission;
      if(typeof permission === 'string' && !permissions.hasPermission(permission)) {
        $location.path('/unauthorized');
      }
    });
    
    var vm = this;
    // funcation assignment
    vm.onSubmit = onSubmit;

    // variable assignment
    vm.author = { // optionally fill in your info below :-)
      name: 'Kent C. Dodds',
      url: 'https://twitter.com/kentcdodds'
    };
    vm.exampleTitle = 'hideExpression'; // add this

    vm.model = {};
    vm.options = {};
    
    vm.fields = [
      {
        key: 'name',
        type: 'input',
        templateOptions: {
          required: true,
          label: 'Name'
        }
      },
      {
        key: 'iLikeTwix',
        type: 'checkbox',
        templateOptions: {
          label: 'I like twix',
        },
        hideExpression: '!model.name'
      }
    ];
    
    vm.originalFields = angular.copy(vm.fields);
    
    // function definition
    function onSubmit() {
      vm.options.updateInitialValue();
      alert(JSON.stringify(vm.model), null, 2);
    }
    
    
  });
