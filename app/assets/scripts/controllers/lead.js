'use strict';

/**
* @ngdoc function
* @name loopbackApp.controller:ContactCtrl
* @description
* # ContactCtrl
* Controller of the loopbackApp
*/
angular.module('geckoCliApp')

.config(function($stateProvider) {
  $stateProvider.state('lead', {
    abstract: true,
    url: '/lead',
    templateUrl: 'assets/lead/main.html',
    controller: 'LeadCtrl'
  })
  .state('lead.list', {
    url: '',
    templateUrl: 'assets/lead/list.html'
  })
  .state('lead.add', {
    url: '/add',
    templateUrl: 'assets/lead/form.html',
    controller: 'LeadCtrl'
  })
  .state('lead.edit', {
    url: '/:id/edit',
    templateUrl: 'assets/lead/form.html',
    controller: 'LeadCtrl'
  })
  .state('lead.details', {
    url: '/:id/details',
    templateUrl: 'assets/lead/details.html',
    controller: 'LeadCtrl'
  })
  .state('lead.view', {
    url: '/:id',
    templateUrl: 'assets/lead/view.html',
    controller: 'LeadCtrl'
  });
})
.controller('LeadCtrl', function ($scope, $location, permissions, User, $filter, ngTableParams, Role, Rails, $localStorage, toaster, $stateParams, SweetAlert, Product, $rootScope, Lead) {

    $rootScope.$on('$locationChangeSuccess', function() {
        $rootScope.actualLocation = $location.path();
    });        

    $rootScope.$watch(function () {return $location.path()}, function (newLocation, oldLocation) {
        if($rootScope.actualLocation === newLocation) {
            $('#mobileviews').show();
        }
    });
    
    $scope.isfilter = false;
    $scope.modelsearch = {data : null, users_id: null, orderby: 'leads.id desc'}
    $scope.optionssearch = {}
    
    var filter_list = [
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
    
    $scope.fieldsssearch = [
      {
        // this field's ng-model will be bound to vm.model.username
        key: 'data',
        type: 'input',
        templateOptions: {
          type: 'date',
          required: false,
          label: 'Data'
        }
      },
      {
        key: 'users_id',
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
                alert(dataItem.id);
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
        key: 'orderby',
        type: 'ui-select',
        templateOptions: {
          label: 'Filtro',
          valueProp: 'abbr',
          labelProp: 'name',
          options: filter_list
        }
      }
    ];
    
    $scope.submitfilter = function()
    {
      var listView = $("#listView").data("kendoListView");
      listView.dataSource.read();   // added line
      listView.refresh();
    }
    
    function clickfilterChanged(event, args)
    {
        $scope.isfilter = args;
    }
    
    $scope.$on('clickfilterChanged', clickfilterChanged);
    
    $scope.toolbar.length = 0;
    
    $rootScope.$broadcast('enablefilterChanged');

    var toolbaritem = {
      show: false,
      onhandler: function () {
        $scope.toolbar[0].show = false;
        $scope.toolbar[1].show = true;
        $('.checkbox').show();
      },
      icon: "fa-pencil"
    };

    $scope.toolbar.push(toolbaritem);

    var toolbaritem = {
      show: false,
      onhandler: function () {
        $scope.toolbar[0].show = true;
        $scope.toolbar[1].show = false;
        $('.checkbox').hide();
      },
      icon: "fa-trash-o"
    };

    $scope.toolbar.push(toolbaritem);

    $scope.filter = 'm';
    $scope.tag = '';

    $scope.limit = 300;
    $scope.skip = 0;

    $scope.crud;
    
    $scope.isupload = false;
    $scope.remover;

    $scope.usuario = $localStorage.user;

    var crudServiceBaseUrl = "http://unicoop.herokuapp.com/api";
    //var crudServiceBaseUrl = "http://dokkuapp.com:3005/api";

    var Id = $stateParams.id;

    var model = Lead;
    
    $scope.arquivo = "";

// selected fruits
    $scope.selection = [];
    
    
    /*var uploader = $scope.uploader = $fileUploader.create({
      scope: $scope,                          // to automatically update the html. Default: $rootScope
      url: '/api/containers/unicoop/upload',
      formData: [
        { key: 'value' }
      ],
      filters: [
        function (item) {                    // first user filter
          console.info('filter1');
          return true;
        }
      ]
    });
    
    uploader.bind('beforeupload', function (event, item) {
      $scope.isupload = true;
    });
    
    uploader.bind('afteraddingall', function (event, items) {
      console.info('After adding all files', items);
      $scope.isupload = true;
    });
    
    uploader.bind('complete', function (event, xhr, item, response) {
      console.info('Complete', xhr, item, response);
      $scope.arquivo = item.file.name;
    });*/
    
    

// toggle selection for a given fruit by name
    $scope.toggleSelection = function toggleSelection(itemName) {
      var idx = $scope.selection.indexOf(itemName);

      // is currently selected
      if (idx > -1) {
        $scope.selection.splice(idx, 1);
      }

      // is newly selected
      else {
        $scope.selection.push(itemName);
      }
    };

    $scope.refresh = function () {
      var listView = $("#listView").data("kendoListView");
      listView.dataSource.read();   // added line
      listView.refresh();
    };

    $scope.next = function () {
      $scope.skip = $scope.skip + $scope.limit;
      $scope.refresh();
    };

    $scope.back = function () {
      if ($scope.skip != 0) {
        $scope.skip = $scope.skip - $scope.limit;
        $scope.refresh();
      }
    };

    $scope.source = new kendo.data.DataSource({
      type: "json",
      serverFiltering: true,
      transport: {
        read: function (e) {
              list = [];
              Lead.all($scope.modelsearch).then(function(list){
                 e.success(list.data); 
              });
          }
          // on failure
          //e.error("XHR response", "status code", "error message");
      },
      pageSize: 300
    });

    function list(filter, tag) {
      $scope.filter = filter;
      if (filter == 't') {
        $scope.tag = tag;
        $scope.toolbar[0].show = true;
      }
      else {
        $scope.tag = '';
        $scope.toolbar[0].show = false;
        $scope.toolbar[1].show = false;
      }
      $scope.skip = 0;
      var listView = $("#listView").data("kendoListView");
      listView.dataSource.read();   // added line
      listView.refresh();
    }

    var quickview = [];

    $scope.barleftitem = {
      name: "Indicação",
      insertbutton: {
        name: "Nova Indicação",
        event: function () {
          //alert('oi');
        },
        href: ".add"
      },
      listitem: [{
        name: "Minhas Indicações",
        active: true,
        count: "10",
        icon: "pg-contact_book",
        event: function () {
          $scope.balistviewitem.groupitem[0].name = "Minhas Indicações";
          list('m')
        },
        item: []
      }]
    };

    function load() {
      $scope.balistviewitem = {};
      
      $scope.balistviewitem["groupitem"] = [];

      var iten = {};
      var contactiten = {};
      var contactitems = [];

      iten['name'] = "Minhas Indicações";
      iten['items'] = [];
      $scope.balistviewitem["groupitem"].push(iten);
      
      /*Contact.find(function (data) {
        if (data != undefined && data.length > 0) {
          $scope.balistviewitem["groupitem"] = [];

          var iten = {};
          var contactiten = {};
          var contactitems = [];

          iten['name'] = "Minhas Indicações";
          iten['items'] = [];

          for (var i = 0; i < data.length; i++) {
            contactiten = {};
            contactiten['index'] = i;
            contactiten['id'] = data[i].id;
            contactiten['header'] = data[i].phone;
            contactiten['text'] = data[i].name;
            contactiten['footer'] = data[i].email;
            contactiten['time'] = data[i].created;
            contactitems.push(contactiten);
          }

          iten['items'] = contactitems;
          $scope.balistviewitem["groupitem"].push(iten);
        }
      });*/
    }

    load();

    $scope.onDragComplete = function (data, evt) {
      console.log("drag success, data:", data);
    };

    $scope.onDropComplete = function (data, evt, quickitem) {

      var tagitem = {
        "principalid": data.id,
        "tag": quickitem.id,
        "typetag": "lead"
      };


      Tagpoint.upsert(tagitem, function () {
        toasty.pop.success({title: 'Indicações marcada.', msg: 'Indicações marcada com sucesso!', sound: false});
      });

      console.log("drop success, data:", data);
      console.log("item success, data:", quickitem);
    };

    /* Form config */

    $scope.Id = Id;

    $scope.item = {};

    $scope.myitems = [];

    $scope.isfavorite = false;

    $scope.win1visible = false;

    $scope.comment;

    $scope.leadhistory;

    $scope.leadproduct;
    
    $scope.mobileviews = false;
    
    $scope.isdelete = false;
    
    $('#mobileviews').show();
    
    function detectmob() { 
     if( navigator.userAgent.match(/Android/i)
     || navigator.userAgent.match(/webOS/i)
     || navigator.userAgent.match(/iPhone/i)
     || navigator.userAgent.match(/iPad/i)
     || navigator.userAgent.match(/iPod/i)
     || navigator.userAgent.match(/BlackBerry/i)
     || navigator.userAgent.match(/Windows Phone/i)
     ){
        return true;
      }
     else {
        return false;
      }
    }

    function loadoportuidade(Id, item)
    {
      if(detectmob())
      {
        $('#mobileviews').hide();
      }
      $scope.crud = true;
      $scope.item = {};
      $scope.item = item[0];
      //$scope.arquivo = data.return[0].file;
      
      /*Lead.leadDetails({leadid: Id}, function (data) {
        if (data.return.length > 0) {

          $scope.item = data.return[0];

          if (data.return[0].ownerid != user || (data.return[0].statusid == '54b9397ebcbf77a824cccb87' || data.return[0].statusid == '54b93988bcbf77a824cccb88')) {
            $scope.crud = false;
          }
          else {
            $scope.crud = true;
          }

          $scope.item.contactid = data.return[0].contact.name;
          $scope.contactid = data.return[0].contact.id;
          $scope.item.ownerid = data.return[0].user.firstName;
          $scope.ownerid = data.return[0].user.id;
          $scope.arquivo = data.return[0].file;

          LeadBook.find({filter: {where: {userid: user, leadid: Id}}}, function (itembook) {
            console.log('victor', itembook[0].favorite);
            $scope.isfavorite = itembook[0].favorite;
          });

          LeadHistory.find({filter: {where: {leadid: Id, statusid: {nin: ['54b93964bcbf77a824cccb85']}}, include: ['status', 'users'], order: 'id DESC'}}, function (itemhistory) {
            $scope.leadhistory = itemhistory;
          });

          Leadproduct.find({filter: {where: {leadid: Id}, include: ['product']}}, function (itemproduct) {
            $scope.leadproduct = itemproduct;
          });

        }
        else {
          toasty.pop.error({title: 'Problema no lead.', msg: 'Não foi encontrado este Lead!', sound: false})
        }
      });*/
    }

    if (Id) {
      Lead.get(Id).then(function (data) {
        if (data.data.length > 0) {
          var listView = $("#listView").data("kendoListView");
          listView.dataSource.read();   // added line
          listView.refresh();
          loadoportuidade(Id, data.data);
          /*if(data.data.status_id == "1")
          {
            if(data.return[0].ownerid != user || (data.return[0].statusid == '54b9397ebcbf77a824cccb87' || data.return[0].statusid == '54b93988bcbf77a824cccb88'))
            {
                var listView = $("#listView").data("kendoListView");
                listView.dataSource.read();   // added line
                listView.refresh();
                loadoportuidade(Id); 
            }
            else
            {
                Lead.upsert({id: Id, statusid: '54b93970bcbf77a824cccb86'}, function () {
                  LeadHistory.create({
                    "leadid": Id,
                    "statusid": "54b93970bcbf77a824cccb86",
                    "ownerid": user,
                    "created": new Date(),
                    "comment": "Cotação em andamento"
                  }, function () {
                    var listView = $("#listView").data("kendoListView");
                    listView.dataSource.read();   // added line
                    listView.refresh();
                    loadoportuidade(Id); 
                  });
                });
            }
          }
          else
          {
            loadoportuidade(Id);
          }
*/
        }
      });
    }

    $scope.contactid;
    $scope.ownerid;

    $scope.formFields = [
      {
        key: 'contactid',
        templateUrl: 'views/elements/customautocomplete.html',
        label: 'Contato',
        templatenode: "<span style=&quot;display: inline-block; width: 170px;&quot;>${ data.name } <${ data.email }></span>",
        selectitem: function (e) {
          if (e != undefined) {
            var dataItem = this.dataItem(e.item.index());
            alert(dataItem.id);
            $scope.contactid = dataItem.id;
          }
        },
        placeholder: 'Informe um contato',
        required: true,
        "options": {
          type: "json",
          serverFiltering: true,
          transport: {
            read: function (e) {
              //url: crudServiceBaseUrl + "/contacts?access_token="+LoopBackAuth.accessTokenId+ "&filter=%7B%22where%22%20%3A%20%7B%22companyid%22%20%3A%20%22"+$localStorage.companyid+"%22%7D%7D"
              Addressbook.search({
                search: e.data.filter.filters[0].value,
                userid: user,
                companyid: $localStorage.companyid
              }, function (data) {
                if (data.return != undefined) {
                  var list = [];
                  $scope.balistviewitem.groupitem.quantidade = data.return.length;
                  for (var i = 0; i < data.return.length; i++) {

                    var iten = {};
                    iten['id'] = data.return[i].contact.id;
                    iten['created'] = moment(data.return[i].created).format("DD/MM/YYYY");
                    iten['phone'] = data.return[i].contact.phone;
                    iten['name'] = data.return[i].contact.name;
                    iten['email'] = data.return[i].contact.email;
                    iten['letter'] = data.return[i].contact.letter;
                    list.push(iten);
                    //console.log(moment(data.return[i].created).format("DD/MM/YYYY"));
                  }
                  e.success(list);
                }
                else {
                  $scope.balistviewitem.groupitem.quantidade = nenhum;
                  e.success("");
                }
              });
            }
          }
        },
        "modelOptions": {
          "getterSetter": true,
          "allowInvalid": true
        }
      },
      {
        key: 'ownerid',
        templateUrl: 'views/elements/customautocomplete.html',
        label: 'Responsável',
        selectitem: function (e) {
          if (e != undefined) {
            var dataItem = this.dataItem(e.item.index());
            $scope.ownerid = dataItem.id;
          }
        },
        templatenode: "<span style=&quot;display: inline-block; width: 170px;&quot;>${ data.name }</span>",
        placeholder: 'Informe um responsável',
        "options": {
          type: "json",
          serverFiltering: true,
          transport: {
            read: function (e) {
              //url: crudServiceBaseUrl + "/contacts?access_token="+LoopBackAuth.accessTokenId+ "&filter=%7B%22where%22%20%3A%20%7B%22companyid%22%20%3A%20%22"+$localStorage.companyid+"%22%7D%7D"
              Customer.search({
                search: e.data.filter.filters[0].value,
                companyid: $localStorage.companyid
              }, function (data) {
                if (data != undefined) {
                  var list = [];
                  for (var i = 0; i < data.return.length; i++) {

                    var iten = {};
                    iten['id'] = data.return[i].id;
                    iten['name'] = data.return[i].firstName;
                    list.push(iten);
                  }
                  e.success(list);
                }
                else {
                  e.success("");
                }
              });
            }
          }
        },
        "modelOptions": {
          "getterSetter": true,
          "allowInvalid": true
        }
      },
      {
        key: 'groupid',
        templateUrl: 'views/group/customselect.html',
        label: 'Grupo',
        placeholder: 'Selecione um grupo',
        required: true,
        "options": {
          type: "json",
          serverFiltering: true,
          transport: {
            read: {
              url: "http://"+Rails.host + "/groups?access_token=" + $localStorage.token
            }
          }
        },
        "modelOptions": {
          "getterSetter": true,
          "allowInvalid": true
        }
      },

    {
      key: 'selectproduct',
      templateUrl: 'views/user/custommultiselect.html',
      label: 'Produtos',
      placeholder: 'Selecione os produtos',
      myitems: $scope.myitems,
      required: false,
      "options": {
        type: "json",
        serverFiltering: true,
        transport: {
          read: function(e){
            Product.find({filter : {where : {companyid: $localStorage.companyid}}}, function(data)
            {
              if (data != undefined) {
                e.success(data);
              }
              else {
                e.success("");
              }
            });
          }
        }
      },
      "modelOptions": {
        "getterSetter": true,
        "allowInvalid": true
      }
    },
    {
      key: 'title',
      type: 'text',
      label: 'Título',
      required: true
    },
    {
      key: 'description',
      type: 'textarea',
      label: 'Descrição',
      required: true
    }];

    $scope.formOptions = {
      uniqueFormId: true,
      hideSubmit: true
    };

    function upsert(itemup) {
      model.upsert(itemup, function (data) {
        console.log('selectproduct');
        console.log($scope.item.selectproduct);
        for(var i = 0; i < $scope.item.selectproduct.length; i++){

          var productitem = {};
          productitem['leadid'] = data.id;
          productitem['productid'] = $scope.item.selectproduct[i];

          Leadproduct.upsert(productitem, function()
          {

          }, function(error)
          {
            toasty.pop.error({title: 'Regra não salva.', msg: 'Problema ao cadastrar uma regra!', sound: false})
          });
        }
        toasty.pop.success({title: 'Indicação salva.', msg: 'Cadastrado com sucesso!', sound: false});
        load();
        var listView = $("#listView").data("kendoListView");
        listView.dataSource.read();   // added line
        listView.refresh();
        $state.go('app.lead.list');
      }, function (err) {
        console.log(err);
        if (err.status == 422) {
          toasty.pop.error({
            title: 'Campo E-mail.',
            msg: 'E-mail já cadastrado, favor informar um novo!',
            sound: false
          });
        }
        else {
          toasty.pop.error({
            title: 'Problema no contatos.',
            msg: 'Houve um erro ao cadastrar o seu contato, procure o administrador!',
            sound: false
          })
        }

      });
    }

    $scope.onSubmit = function () {
      var leaditem = $scope.item;
      debugger;
      var contact = {};
      if (leaditem.id == undefined || leaditem.id == '') {
        contact['companyid'] = $localStorage.companyid;
        contact['contactid'] = $scope.contactid;
        contact['groupid'] = leaditem.groupid;
        contact['title'] = leaditem.title;
        contact['description'] = leaditem.description;
        contact['statusid'] = "54b93964bcbf77a824cccb85";//Aberto
        contact['dtacreated'] = new Date();

        if ($scope.ownerid != undefined) {
          contact['ownerid'] = $scope.ownerid;
        }
        else {
          contact['ownerid'] = user;
        }

        //Save
        upsert(contact);
      }
      else {
        contact['id'] = leaditem.id;
        contact['contactid'] = $scope.contactid;
        contact['groupid'] = leaditem.groupid;
        contact['title'] = leaditem.title;
        contact['description'] = leaditem.description;
        if ($scope.ownerid != undefined) {
          contact['ownerid'] = $scope.ownerid;
        }

        Utility.removeproductbylead({leadid: leaditem.id}, function(){
          //Save
          upsert(contact);
        });
      }
    }

//Favorite
    $scope.onfavorite = function (itemId) {
      LeadBook.find({filter: {where: {userid: user, leadid: itemId}}}, function (data) {
        if (data.length > 0) {
          LeadBook.upsert({id: data[0].id, favorite: true}, function () {
            toasty.pop.success({
              title: 'Contato Favoritado.',
              msg: 'Contato adicionado aos seus favoritos com sucesso!',
              sound: false
            });
            Lead.findById({id: Id}, function (data) {
              $scope.item = data;
              $scope.isfavorite = true;
            });
            var listView = $("#listView").data("kendoListView");
            listView.dataSource.read();   // added line
            listView.refresh();
          });
        }
        else{
          LeadBook.upsert({"userid": user, "leadid": itemId, "favorite": true}, function () {
            toasty.pop.success({
              title: 'Contato Favoritado.',
              msg: 'Contato adicionado aos seus favoritos com sucesso!',
              sound: false
            });
            Lead.findById({id: Id}, function (data) {
              $scope.item = data;
              $scope.isfavorite = true;
            });
            var listView = $("#listView").data("kendoListView");
            listView.dataSource.read();   // added line
            listView.refresh();
          });
        }
      });
    }

    $scope.unfavorite = function (itemId) {
      LeadBook.find({filter: {where: {userid: user, leadid: itemId}}}, function (data) {
        if (data.length > 0) {
          LeadBook.upsert({id: data[0].id, favorite: false}, function () {
            toasty.pop.success({
              title: 'Contato Favoritado.',
              msg: 'Contato adicionado aos seus favoritos com sucesso!',
              sound: false
            });
            Lead.findById({id: itemId}, function (data) {
              $scope.item = data;
              $scope.isfavorite = false;
            });
            var listView = $("#listView").data("kendoListView");
            listView.dataSource.read();   // added line
            listView.refresh();
          });
        }
      });
    }

    $scope.baixar = function(arquivos){
      var urlfile = "/api/containers/unicoop/download/" + arquivos;
      var win = window.open(urlfile, '_blank');
      win.focus();
    }

    $scope.concluir = function(itemId){
      
      if($scope.arquivo != null)
      {
        model.upsert({id: itemId, statusid: '54b9397ebcbf77a824cccb87', file: $scope.arquivo}, function (data, data1) {
            LeadHistory.create({
              "leadid": itemId,
              "statusid": "54b9397ebcbf77a824cccb87",
              "ownerid": user,
              "created": new Date(),
              "comment": $scope.comment
            }, function () {
              //Envia e-mail
              model.leadEmail({leadid: itemId, mensagem: $scope.comment, arquivo: $scope.arquivo});
              
              var listView = $("#listView").data("kendoListView");
              listView.dataSource.read();   // added line
              listView.refresh();
              //$state.go('app.lead.list');
            });
        });
      }
      else
      {
        model.upsert({id: itemId, statusid: '54b9397ebcbf77a824cccb87'}, function () {
            LeadHistory.create({
              "leadid": itemId,
              "statusid": "54b9397ebcbf77a824cccb87",
              "ownerid": user,
              "created": new Date(),
              "comment": $scope.comment
            }, function () {
              var listView = $("#listView").data("kendoListView");
              listView.dataSource.read();   // added line
              listView.refresh();
              //$state.go('app.lead.list');
            });
        });
      }
    }

    $scope.salvar = function(itemId){
      model.upsert({id: itemId, statusid: '54b93970bcbf77a824cccb86'}, function () {
        LeadHistory.create({
          "leadid": itemId,
          "statusid": "54b93970bcbf77a824cccb86",
          "ownerid": user,
          "created": new Date(),
          "comment": "Cotação em andamento"
        }, function () {
          var listView = $("#listView").data("kendoListView");
          listView.dataSource.read();   // added line
          listView.refresh();
          $state.go('app.lead.list');
        });
      });
    }

//Remove
    $scope.ondelete = function (itemId) {
      SweetAlert.swal({
        title: 'Deseja excluir esta indicação?',
        type: 'warning',
        confirmButtonText: "Sim", cancelButtonText: "Não",
        showCancelButton: true,
        confirmButtonColor: '#89cb4e'
      }, function (isConfirm) {
        if (isConfirm) {

          model.upsert({id: itemId, statusid: '54b93988bcbf77a824cccb88'}, function () {

            LeadHistory.create({
              "leadid": itemId,
              "statusid": "54b93988bcbf77a824cccb88",
              "ownerid": user,
              "created": new Date(),
              "comment": 'Lead Cancelado'
            }, function () {
              var listView = $("#listView").data("kendoListView");
              listView.dataSource.read();   // added line
              listView.refresh();
              $state.go('app.lead.list');
            });
          });
        }
      });
    };
  });
