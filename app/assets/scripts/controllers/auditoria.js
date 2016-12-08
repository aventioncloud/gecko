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
        $stateProvider.state('auditoria', {
                abstract: true,
                url: '/auditoria',
                templateUrl: 'assets/auditoria/index.html',
                controller: 'AuditoriaCtrl'
            })
            .state('auditoria.list', {
                url: '',
                templateUrl: 'assets/auditoria/list.html',
                controller: 'AuditoriaCtrl'
            })
            .state('auditoria.add', {
                url: '/add',
                templateUrl: 'assets/auditoria/form.html',
                controller: 'AuditoriaCtrl'
            })
            .state('auditoria.edit', {
                url: '/:id/edit',
                templateUrl: 'assets/auditoria/form.html',
                controller: 'AuditoriaCtrl'
            });
    }).controller('AuditoriaCtrl', function ($scope, $location, permissions, $rootScope, User, $filter, ngTableParams, Role, Rails, $localStorage, toaster, $stateParams, SweetAlert, Group) {

    var vm = this;
    var Id = $stateParams.id;

    $rootScope.$broadcast('disablefilterChanged');

    //Toolbar
    //Alterar para o parametro do crud
    $scope.toolbar = {
        controller: "auditoria",
        add: "auditoria.add",
        list: "auditoria.list",
        permissioncreate: "{'subject_class':'Group','action':'create'}"
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
        $scope.globalSearchTerm = undefined;
    };

    $scope.optionsselect = function(item){
        $scope.optionsselectitem = item;
    };

    //Alterar para o parametro do crud
    if(!$scope.issuper){
        $scope.filter = {
            name: undefined
        };
        //Alterar para o parametro do crud
        $scope.filteroptions = [
            {name: 'name', value: 'Nome'}
        ];
    } else {
        //Super Admin
        $scope.filter = {
            name: undefined,
            active:  undefined
        };
        //Alterar para o parametro do crud
        $scope.filteroptions = [
            {name: 'name', value: 'Nome'},
            {name: 'active', value: 'Ativo'}
        ];
    }

    $scope.optionsselectitem = $scope.filteroptions[0];

    //Get Users All
    $scope.loadgrid = function()
    {
        Group.all()
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
            $scope.filter.active = undefined;
        }
        else if($scope.optionsselectitem.name === 'active'){

            $scope.filter.active = $scope.isInvertedSearch ? 'S' : 'N';
            $scope.filter.name = undefined;
        }
    }


    //Create model form
    $scope.model = {};
    $scope.options = {};
    $scope.selecteditem = undefined;
    //Alterar para o parametro do crud
    $scope.fields = [
        {
            // this field's ng-model will be bound to vm.model.username
            key: 'name',
            type: 'input',
            templateOptions: {
                required: true,
                label: 'Nome'
            }
        },
        {
            key: 'user_id',
            templateUrl: 'assets/partials/customautocomplete.html',
            templateOptions: {
                label: 'Responsável',
                placeholder: '',
                required: true,
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
                        $scope.model.user_id = dataItem.id;
                    }
                }
            },
            "modelOptions": {
                "getterSetter": true,
                "allowInvalid": true
            }
        },
        {
            key: 'dadgroup',
            templateUrl: 'assets/partials/customselect.html',
            templateOptions: {
                label: 'Grupo Pai',
                placeholder: 'Selecione um grupo pai',
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
    ];

    //Edit form
    if(Id){
        Group.get(Id).then(function(data){
            $scope.model = data.data;
            $scope.fields[1].templateOptions.placeholder = data.data.usuario;
        });
    }

    //Submit form
    //Alterar para o parametro do crud
    $scope.handleSubmit = function()
    {
        var model = $scope.model
        if($scope.model.id === undefined || $scope.model.id === null){
            Group.post($scope.model).then(function(data){
                if (data) {
                    toaster.success({title: "Cadastro", body:"Cadastro salvo com sucesso."});
                    $location.path('/group');
                }
                else{
                    toaster.error({title: "Cadastro", body:"Error ao cadastradar. Erro 1001."});
                }
            });
        } else
            Group.put($scope.model).then(function(data){
                if (data) {
                    toaster.success({title: "Cadastro", body:"Cadastro alterado com sucesso."});
                    $location.path('/group');
                }
                else{
                    toaster.error({title: "Cadastro", body:"Error ao alterar. Erro 1002."});
                }
            });
    };

    //Active
    $scope.actived = function(id) {
        Group.active(id).then(function(data) {
            toaster.success({title: 'Ativação', body: 'Grupo ativado com sucesso.!', sound: false});
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
                Group.delete(id).then(function(data) {
                    toaster.success({title: 'Remoção', body: 'Grupo foi removido.!', sound: false});
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
