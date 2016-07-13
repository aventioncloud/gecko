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
  }).controller('UserCtrl', function ($scope, $location, $rootScope, permissions, User, $filter, ngTableParams, Role, Rails, $localStorage, toaster, $stateParams, SweetAlert, Product) {

    var vm = this;
    var Id = $stateParams.id;

    $rootScope.$broadcast('disablefilterChanged');

    //Toolbar
    //Alterar para o parametro do crud
    $scope.toolbar = {
      controller: "user",
      add: "user.add",
      list: "user.list",
      graph: true,
      permissioncreate: "{'subject_class':'User','action':'create'}"
    };

    $scope.onvisiblesearch = function()
    {
        $scope.goGraph = false;
        $scope.goGraphpj = false;
        $scope.goSearch = !$scope.goSearch;
    }
    $scope.onvisiblegraph = function()
    {
        $scope.goGraph = !$scope.goGraph;
        $scope.goGraphpj = false;
        $scope.goSearch = false;
    }

    $scope.onvisiblegraphpj = function()
    {
        $scope.goGraph = false;
        $scope.goGraphpj = !$scope.goGraphpj;
        $scope.goSearch = false;
    }

    $scope.creategraphqueue = function() {

        $("#chart").kendoChart({
            chartArea: {
                width: 800,
                height: 400
            },
            title: {
                text: "Fila Pessoa Física"
            },
            legend: {
                position: "top"
            },
            seriesDefaults: {
                labels: {
                    template: "Leads: #= dataItem.leadnumber #",
                    position: "outsideEnd",
                    visible: true,
                    background: "transparent"
                }
            },
            dataSource: {
                transport: {
                    read: {
                        url: "http://" + Rails.host + "/api/v1/user/graphqueue?tipo=PF&access_token=" + $localStorage.token,
                        dataType: "json"
                    }
                }
            },
            series: [{
                type: "column",
                field: "leadnumber",
                categoryField: "name",
                explodeField: "explode"
            }],
            tooltip: {
                visible: true,
                template: "#= dataItem.name # : #= dataItem.leadnumber #"
            }
        });

        $("#chart2").kendoChart({
            chartArea: {
                width: 800,
                height: 400
            },
            title: {
                text: "Fila Pessoa Juridíca"
            },
            legend: {
                position: "top"
            },
            seriesDefaults: {
                labels: {
                    template: "Leads: #= dataItem.leadnumber #",
                    position: "outsideEnd",
                    visible: true,
                    background: "transparent"
                }
            },
            dataSource: {
                transport: {
                    read: {
                        url: "http://" + Rails.host + "/api/v1/user/graphqueue?tipo=PJ&access_token=" + $localStorage.token,
                        dataType: "json"
                    }
                }
            },
            series: [{
                type: "column",
                field: "leadnumber",
                categoryField: "name",
                explodeField: "explode"
            }],
            tooltip: {
                visible: true,
                template: "#= dataItem.name # : #= dataItem.leadnumber #"
            }
        });
    }

    $scope.onloadgraphuser = function(id){
        //debugger;
        var classgraph = ".graphuser_"+id.toString();
        $(classgraph).kendoChart({
            chartArea: {
                width: 500,
                height: 400
            },
            title: {
                text: "Qtd. Leads por Status"
            },
            legend: {
                position: "top"
            },
            seriesDefaults: {
                labels: {
                    template: "#= dataItem.item #: #= dataItem.value #",
                    position: "outsideEnd",
                    visible: true,
                    background: "transparent"
                }
            },
            dataSource: {
                transport: {
                    read: {
                        url: "http://" + Rails.host + "/api/v1/user/graphstatus?user_id="+id.toString()+"&access_token=" + $localStorage.token,
                        dataType: "json"
                    }
                }
            },
            series: [{
                type: "donut",
                field: "value",
                categoryField: "item",
                explodeField: "explode"
            }],
            tooltip: {
                visible: true,
                template: "#= dataItem.item # : #= dataItem.value #"
            }
        });
    }

    $scope.onloadhistuser = function(id){

    }

    $scope.onloaddadosuser = function(id){

    }

    //$scope.creategraphqueue();

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
      $scope.filter.group_id = undefined;
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
          {name: 'email', value: 'E-mail'},
          {name: 'group', value: 'Grupo'}
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
          {name: 'active', value: 'Ativo'},
          {name: 'group', value: 'Grupo'}
      ];
    }

    $scope.optionsselectitem = $scope.filteroptions[0];

    //Get Users All
    $scope.loadgrid = function()
    {
      User.all()
        .then(function(data) {
          $scope.data = data.data;
            $scope.creategraphqueue();
          $scope.tableParams = new ngTableParams({
                page: 1,            // show first page
                count: 100,          // count per page
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
          $scope.filter.group_id = undefined;
      }
      else if($scope.optionsselectitem.name === 'active'){

          $scope.filter.active = $scope.isInvertedSearch ? 'S' : 'N';
          $scope.filter.name = undefined;
          $scope.filter.email = undefined;
          $scope.filter.group_id = undefined;
      }
      else if($scope.optionsselectitem.name === 'group')
      {
          $scope.filter.group_id = term;
          $scope.filter.name = undefined;
          $scope.filter.email = undefined;
          $scope.filter.active = undefined;
      }
      else
      {
          $scope.filter.email = term;
          $scope.filter.name = undefined;
          $scope.filter.active = undefined;
          $scope.filter.group_id = undefined;
      }
    }


    //Create model form
    $scope.model = {};
    $scope.options = {};
    $scope.model.products = [];
    //Alterar para o parametro do crud
    $scope.fields = [
      {
        className: 'row large',
        fieldGroup: [
        {
        // this field's ng-model will be bound to vm.model.username
          className: 'col-xs-7',
          key: 'name',
          type: 'input',
          templateOptions: {
            label: 'Nome',
            required: true
          }
        },
        {
          className: 'col-xs-7',
          key: 'email',
          type: 'input',
          templateOptions: {
            width: '200px',
            type: 'email',
            label: 'E-mail',
            required: true,
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
        }],
      },
      {
      className: 'row large',
      fieldGroup: [
        {
          className: 'col-xs-7',
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
          key: 'group_id',
          className: 'col-xs-7',
          templateUrl: 'assets/partials/customselect.html',
          templateOptions: {
            label: 'Grupo',
            placeholder: 'Selecione um grupo',
            required: true,
            "options": {
              type: "json",
              serverFiltering: true,
              transport: {
                read: {
                  url: "http://"+Rails.host + "/api/v1/group?access_token="+$localStorage.token
                }
              }
            }
          }
        }
      ]},
      {
      className: 'row large',
      fieldGroup: [
        {
          key: 'password',
          className: 'col-xs-7',
          type: 'input',
          templateOptions: {
            type: 'password',
            label: 'Senha'
          },
          expressionProperties: {
            'templateOptions.required': 'model.id === undefined'
          }
        },
        {
          // this field's ng-model will be bound to vm.model.username
          key: 'celular',
          className: 'col-xs-7',
          type: 'input',
          templateOptions: {
            label: 'Celular'
          }
        }
      ]},
      {
        className: 'row large',
        fieldGroup: [
        {
          // this field's ng-model will be bound to vm.model.username
          key: 'isemail',
          className: 'col-xs-7',
          type: 'checkbox',
          templateOptions: {
            label: 'Recebe e-mail'
          }
        },
        {
          // this field's ng-model will be bound to vm.model.username
          key: 'islead',
          className: 'col-xs-7',
          type: 'checkbox',
          templateOptions: {
            label: 'Permite mais de 20 produtos'
          }
        }
        ]},
        {
          key: 'products',
          templateUrl: 'assets/partials/custommultiselect.html',
          templateOptions: {
            label: 'Produtos',
            required: false,
            selectOptions: {
              placeholder: "Selecione os produtos...",
              dataTextField: "name",
              dataValueField: "id",
              valuePrimitive: true,
              autoBind: false,
              dataSource: {
                  type: "json",
                  serverFiltering: true,
                  transport: {
                      read: {
                          url: "http://"+Rails.host + "/api/v1/product?access_token="+$localStorage.token
                      }
                  }
              }
        }
          },
          "modelOptions": {
            "getterSetter": true,
            "allowInvalid": true
          }
        },
    ];

    //Edit form
    if(Id){
      User.get(Id).then(function(data){
        data.data.isemail = data.data.isemail == "true" ? true : false;
        data.data.islead = data.data.islead == "true" ? true : false;
        var itens = new Array();
        for(var i = 0;i < data.data.products.length;i++)
        {
          itens[i] = data.data.products[i].id;
        }
        data.data.products = itens;
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
              //cadastra o vinculo com produto;
              if($scope.model.products.length > 0){
                var productsvar = "";
                for(var i = 0;i < $scope.model.products.length;i++)
                {
                  productsvar += $scope.model.products[i] +",";
                }
                productsvar = productsvar.slice(0, -1);
                var _value = { user_id: data.data.id, products: productsvar};
                User.linkproduct(_value).then(function(data)
                {
                    toaster.success({title: "Cadastro", body:"Cadastro salvo com sucesso."});
                    $location.path('/user');
                });
              } else {
                toaster.success({title: "Cadastro", body:"Cadastro salvo com sucesso."});
                $location.path('/user');
              }
          }
          else{
              toaster.error({title: "Cadastro", body:"Error ao cadastradar. Erro 1001."});
          }
        });
      else
        User.put($scope.model).then(function(data){
          if (data) {
              //cadastra o vinculo com produto;
              if($scope.model.products.length > 0){
                var productsvar = "";
                for(var i = 0;i < $scope.model.products.length;i++)
                {
                  productsvar += $scope.model.products[i] +",";
                }
                productsvar = productsvar.slice(0, -1);
                var _value = { user_id: $scope.model.id, products: productsvar};
                User.linkproduct(_value).then(function(data)
                {
                  toaster.success({title: "Cadastro", body:"Cadastro alterado com sucesso."});
                  $location.path('/user');
                });
              } else {
                toaster.success({title: "Cadastro", body:"Cadastro alterado com sucesso."});
                $location.path('/user');
              }
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
    $scope.newItemType = 'bill';
    $scope.change = function () {
        alert($scope.newItemType);
    };

    //Atendimento
    $scope.atendimento = function(id, tipo, ativa) {
       var itemativo = 'N';
       if(ativa == undefined || ativa == null || ativa == 'N')
        itemativo = 'S';

        var _value = { user_id: id, atendimento: tipo, active: itemativo};
        User.atendimento(_value).then(function(data) {
          toaster.success({title: 'Atendimento', body: 'Atendimento alterado com sucesso.!', sound: false});
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
