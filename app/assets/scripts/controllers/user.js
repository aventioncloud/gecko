'use strict';

/**
 * @ngdoc function
 * @name geckoCliApp.controller:AboutCtrl
 * @description
 * # UserCtrl
 * Controller of the geckoCliApp
 */
angular.module('geckoCliApp')
  .config(function($stateProvider) {
    $stateProvider.state('user', {
      abstract: true,
      url: '/user',
      templateUrl: 'assets/user/index.html',
      controller: 'UserCtrl'
    })
    .state('user.list', {
      url: '',
      templateUrl: 'assets/user/list.html',
      controller: 'UserCtrl'
    })
    .state('user.add', {
      url: '/add',
      templateUrl: 'assets/user/form.html',
      controller: 'UserCtrl'
    })      
    .state('user.edit', {
      url: '/:id/edit',
      templateUrl: 'assets/user/form.html',
      controller: 'UserCtrl'
    });
  }).controller('UserCtrl', function ($scope, $location, permissions, User, $filter, ngTableParams, Role, Rails, $localStorage, toaster, $stateParams, SweetAlert) {

    var vm = this;
    var Id = $stateParams.id;
    
    //Toolbar
    //Alterar para o parametro do crud
    $scope.toolbar = {
      controller: "user",
      add: "user.add",
      list: "user.list"
    };
    
    //Super Admin
    $scope.issuper = false;
    if($localStorage.user.roles.name == "Super Admin")
      $scope.issuper = true;
      
    $scope.userid = $localStorage.user.id;
    

    //Valida se tem autorização para estar nesta funcionalidade.
    $scope.$on('$routeChangeStart', function(scope, next, current) {
      var permission = next.$$route.permission;
      if(typeof permission === 'string' && !permissions.hasPermission(permission)) {
        $location.path('/unauthorized');
      }
    });
    
    
    //Methodo e variavel para Filtro.
    $scope.closesearch = function(){
      //Alterar para o parametro do crud
      $scope.filter.name = undefined;
      $scope.filter.email = undefined;
      $scope.globalSearchTerm = undefined;
    };
    
    $scope.optionsselect = function(item){
      $scope.optionsselectitem = item;
    };
    
    //Alterar para o parametro do crud
    if(!$scope.issuper){
      $scope.filter = {
          name: undefined,
          email: undefined
      };
      //Alterar para o parametro do crud
      $scope.filteroptions = [
          {name: 'name', value: 'Nome'},
          {name: 'email', value: 'E-mail'}
      ];
    } else {
      //Super Admin
      $scope.filter = {
          name: undefined,
          email: undefined,
          active:  undefined
      };
      //Alterar para o parametro do crud
      $scope.filteroptions = [
          {name: 'name', value: 'Nome'},
          {name: 'email', value: 'E-mail'},
          {name: 'active', value: 'Ativo'}
      ];
    }
    
    $scope.optionsselectitem = $scope.filteroptions[0];
    
    //Get Users All
    $scope.loadgrid = function()
    {
      User.all()
        .then(function(data) {
          $scope.data = data.data;
          $scope.tableParams = new ngTableParams({
                page: 1,            // show first page
                count: 10,          // count per page
                filter: $scope.filter,
                sorting: {
                    name: 'asc'     // initial sorting
                }
            }, {
                total: $scope.data.length, // length of data
                getData: function($defer, params) {
                    // use build-in angular filter
                    var orderedData = params.sorting() ?
                                        $filter('orderBy')($scope.data, params.orderBy()) :
                                        $scope.data;
                                        
                    orderedData	= $filter('filter')(orderedData, params.filter());
            
                    $defer.resolve(orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count()));
                }
              });
      });
    }
    $scope.loadgrid();
    
    $scope.applyGlobalSearch = applyGlobalSearch;
    
    function applyGlobalSearch(){
      var term = $scope.globalSearchTerm;
      if ($scope.isInvertedSearch){
        term = "!" + term;
      }
      
      //Alterar para o parametro do crud
      if($scope.optionsselectitem.name === 'name')
      {
          $scope.filter.name = term; 
          $scope.filter.email = undefined; 
          $scope.filter.active = undefined;
      }
      else if($scope.optionsselectitem.name === 'active'){
          
          $scope.filter.active = $scope.isInvertedSearch ? 'S' : 'N'; 
          $scope.filter.name = undefined; 
          $scope.filter.email = undefined; 
      }
      else
      {
          $scope.filter.email = term; 
          $scope.filter.name = undefined; 
          $scope.filter.active = undefined;
      }
    }
    
    
    //Create model form
    $scope.model = {};
    $scope.options = {};
    //Alterar para o parametro do crud
    $scope.fields = [
      {
        // this field's ng-model will be bound to vm.model.username
        key: 'name',
        type: 'input',
        templateOptions: {
          label: 'Nome',
          maxlength: 150,
          required: true
        }
      },
      {
        key: 'email',
        type: 'input',
        templateOptions: {
          width: '200px',
          type: 'email',
          label: 'E-mail',
          required: true,
          maxlength: 150,
          onKeydown: function(value, options) {
            options.validation.show = false;
          },
          onBlur: function(value, options) {
            options.validation.show = null;
          }
        },
        asyncValidators: {
            uniqueUsername: {
              expression: function($viewValue, $modelValue, scope) {
                scope.options.templateOptions.loading = true;
                var idedit = 0;
                if($scope.model.id != undefined)
                  idedit = $scope.model.id
                return User.validemail($viewValue, idedit).then(function(data) {
                  scope.options.templateOptions.loading = false; 
                  if (data.data === "1") {
                    throw new Error('taken');
                  }
                }, 1000); 
              },
              message: '"Este e-mail já está cadastrado."'
            }
          },
          modelOptions: {
            updateOn: 'blur'
          }
      },
      {
        key: 'roles',
        templateUrl: 'assets/partials/customselect.html',
        templateOptions: {
          label: 'Perfil',
          placeholder: 'Selecione um perfil',
          required: true,
          "options": { 
            type: "json",
            serverFiltering: true,
            transport: {
              read: {
                url: "http://"+Rails.host + "/api/v1/role?access_token="+$localStorage.token
              }
            }
          }
        }
      },
      {
        key: 'password',
        type: 'input',
        templateOptions: {
          type: 'password',
          label: 'Senha',
          maxlength: 15,
          minlength: 8
        },
        expressionProperties: {
          'templateOptions.required': 'model.id === undefined'
        }
      }
    ];
    
    //Edit form
    if(Id){
      User.get(Id).then(function(data){
        $scope.model = data.data;
      });
    }
    
    //Submit form
    //Alterar para o parametro do crud
    $scope.handleSubmit = function()
    {
      var model = $scope.model
      if($scope.model.id === undefined || $scope.model.id === null)
        User.post($scope.model).then(function(data){
          if (data) {
              toaster.success({title: "Cadastro", body:"Cadastro salvo com sucesso."});
              $location.path('/user');
          }
          else{
              toaster.error({title: "Cadastro", body:"Error ao cadastradar. Erro 1001."});
          }
        });
      else
        User.put($scope.model).then(function(data){
          if (data) {
              toaster.success({title: "Cadastro", body:"Cadastro alterado com sucesso."});
              $location.path('/user');
          }
          else{
              toaster.error({title: "Cadastro", body:"Error ao alterar. Erro 1002."});
          }
        });
     };
     
     //Active
    $scope.actived = function(id) {
        User.active(id).then(function(data) {
          toaster.success({title: 'Ativação', body: 'Usuário ativado com sucesso.!', sound: false});
          $scope.loadgrid();
        });
    };
     
     //Delete
    $scope.delete = function(id) {
      SweetAlert.swal({
        title: 'Deseja remover este registro?',
        type: 'warning',
        confirmButtonText: "Sim",   cancelButtonText: "Não",
        showCancelButton: true,
        confirmButtonColor: '#89cb4e'
      }, function(isConfirm){
        if (isConfirm) {
          User.delete(id).then(function(data) {
            toaster.success({title: 'Remoção', body: 'Usuário foi removido.!', sound: false});
            $scope.loadgrid();
          });
        }
        else
        {
          return false;
        }
      });
    };
     
  });
