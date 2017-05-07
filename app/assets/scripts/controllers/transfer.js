'use strict';

/**
 * @ngdoc function
 * @name geckoCliApp.controller:TransferCtrl
 * @description
 * # TransferCtrl
 * Controller of the geckoCliApp
 */
angular.module('geckoCliApp')
  .config(function($stateProvider) {
    $stateProvider.state('transfer', {
      url: '/transfer',
      templateUrl: 'assets/transfer/index.html',
      controller: 'TransferCtrl'
    })
  }).controller('TransferCtrl', function ($scope, Lead, $localStorage, $rootScope, toaster, $stateParams, SweetAlert, Rails, User) {
    var vm = this;
    var Id = $stateParams.id;
    
    $rootScope.$broadcast('disablefilterChanged');

    $scope.onvisiblesearch = function()
    {
        $scope.goSearch = !$scope.goSearch;
    }

    //Toolbar
    //Alterar para o parametro do crud
    $scope.toolbar = {
        controller: "transfer",
      transferencia: true,
      list: "transfer.list",
      addbutton: false,
      permissioncreate: "{'subject_class':'Group','action':'create'}"
    };

    $scope.userid = $localStorage.user.id;
    $scope.showModal = false;


    $scope.ontransfer = function(){
        $scope.showModal = true;
    }

    //Super Admin
    $scope.issuper = false;
    if($localStorage.user.roles.name == "Super Admin")
      $scope.issuper = true;

      //Form Filter
      $scope.isfilter = false;
    $scope.modelsearch = {data : null, users_id: null, orderby: 'leads.id asc', awesome: false, numberperpage: 10, remarked: 1}
    $scope.optionssearch = {}

    var filter_list = [
      {
        "name": "Indicações Asc.",
        "abbr": "leads.id asc"
      },
      {
        "name": "Indicações Desc.",
        "abbr": "leads.id desc"
      },
      {
        "name": "Consultor Cresc.",
        "abbr": "users.name asc"
      },
      {
        "name": "Consultor Desc.",
        "abbr": "users.name desc"
      },      {
        "name": "Cliente Cresc.",
        "abbr": "contacts.name asc"
      },
      {
        "name": "Cliente Desc.",
        "abbr": "contacts.name desc"
      }]

    var type_people = [
       {
        "name": "Todos",
        "abbr": "0"
      },
      {
        "name": "P. Física",
        "abbr": "F"
      },
      {
        "name": "P. Juridica",
        "abbr": "J"
      }
      ]


    $scope.fieldsssearch = [{
      className: 'row',
      fieldGroup: [
      {
        // this field's ng-model will be bound to vm.model.username
        key: 'data',
        type: 'input',
        className: 'col-xs-2',
        templateOptions: {
          type: 'date',
          required: false,
          label: 'Data Inicio'
        }
      },
      {
        // this field's ng-model will be bound to vm.model.username
        key: 'data_end',
        type: 'input',
        className: 'col-xs-2',
        templateOptions: {
          type: 'date',
          required: false,
          label: 'Data Fim'
        }
      },
      {
        key: 'type_people',
        type: 'ui-select',
        className: 'col-xs-2',
        templateOptions: {
          label: 'Tipo',
          valueProp: 'abbr',
          labelProp: 'name',
          options: type_people
        }
      }]},
      {
      className: 'row',
      fieldGroup: [
      {
        // this field's ng-model will be bound to vm.model.username
        key: 'numberperpage',
        type: 'input',
        className: 'col-xs-2',
        templateOptions: {
          type: 'number',
          required: true,
          label: 'Quantidade de Registro'
        }
      }
      ,
      {
          key: 'product_id',
          className: 'col-xs-2',
          templateUrl: 'assets/partials/customselect_small.html',
          templateOptions: {
            label: 'Produto',
            placeholder: 'Selecione um produto',
            "options": {
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
        {
          key: 'status_id',
          className: 'col-xs-2',
          templateUrl: 'assets/partials/customselect_small.html',
          templateOptions: {
            label: 'Status',
            placeholder: 'Selecione um status',
            "options": {
              type: "json",
              serverFiltering: true,
              transport: {
                read: {
                  url: "http://"+Rails.host + "/api/v1/lead/status?access_token="+$localStorage.token
                }
              }
            }
          }
        }]},
      {
        key: 'users_id',
        className: 'col-xs-7',
        templateUrl: 'assets/partials/customautocomplete.html',
        templateOptions: {
          label: 'Consultor',
          placeholder: '',
          required: false,
          options: {
            type: "json",
            serverFiltering: true,
            transport: {
              read: function(e){
                User.search(e.data.filter.filters[0].value).then(function(item){
                    e.success(item.data);
                });
              }
            }
          },
          templatenode: "<span style=&quot;display: inline-block; width: 170px;&quot;>${ data.name }</span>",
          selectitem: function (e) {
            if (e != undefined) {
                var dataItem = this.dataItem(e.item.index());
                //alert(dataItem.id);
                $scope.selecteditem = dataItem.id;
                $scope.modelsearch.users_id = dataItem.id;
            }
         }
        },
        "modelOptions": {
          "getterSetter": true,
          "allowInvalid": true
        }
      },
      {
        key: 'groups_id',
        className: 'col-xs-7',
        templateUrl: 'assets/partials/customselect.html',
        templateOptions: {
          label: 'Grupo',
          placeholder: 'Selecione um grupo',
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
      },
      {
        // this field's ng-model will be bound to vm.model.username
        key: 'remarked',
        type: 'checkbox',
        className: 'col-xs-2 check',
        templateOptions: {
          label: 'Remarcado'
        }
      }
    ];

    $scope.fieldchange = [{
        key: 'users_id',
        templateUrl: 'assets/partials/customautocomplete.html',
        templateOptions: {
          label: 'Corretor',
          placeholder: '',
          required: false,
          options: {
            type: "json",
            serverFiltering: true,
            transport: {
              read: function(e){
                User.search(e.data.filter.filters[0].value).then(function(item){
                    e.success(item.data);
                });
              }
            }
          },
          templatenode: "<span style=&quot;display: inline-block; width: 170px;&quot;>${ data.name }</span>",
          selectitem: function (e) {
            if (e != undefined) {
                var dataItem = this.dataItem(e.item.index());
                //alert(dataItem.id);
                $scope.modelchange.users_id = dataItem.id;
            }
         }
        },
        "modelOptions": {
          "getterSetter": true,
          "allowInvalid": true
        }
      }];

    $scope.modelchange = {users_id: null}
    $scope.optionschange = {}
    $scope.list = [];
    $scope.allSelected = true;

    $scope.submitfilter = function()
    {
      if($scope.modelsearch.groups_id != undefined && $scope.modelsearch.groups_id == '')
      {
        $scope.modelsearch.groups_id = 0;
      }
      if($scope.modelsearch.product_id != undefined && $scope.modelsearch.product_id == '')
      {
        $scope.modelsearch.product_id = 0;
      }
      $scope.modelsearch.page = 1;
        Lead.all($scope.modelsearch).then(function(list){
           $scope.list = list.data;
        });
    }
    var bool = true;
    $scope.toggleAll = function() {
        angular.forEach($scope.list, function(v, k) {
            v.checked = bool;
        });
        bool = !bool;
    }

    $scope.submitchange = function(){
        var itens = "";
        angular.forEach($scope.list, function(v, k) {
            if(v.checked){
                itens += v.id + ";";
            }
        });
        var str2 = itens.slice(0, -1) + '';
        console.log(str2);
        
        Lead.remarked($scope.modelchange.users_id, str2).then(function(data){
            toaster.success({title: 'Remarcação', body: 'Remarcação efetuada com sucesso.!', sound: false});
            $scope.showModal = false;
        });
    }
  });
