'use strict';

/**
 * @ngdoc function
 * @name geckoCliApp.controller:ProntCtrl
 * @description
 * # ProntCtrl
 * Controller of the geckoCliApp
 */
angular.module('geckoCliApp')
  .config(function($stateProvider) {
    $stateProvider.state('pront', {
      url: '/pront',
      templateUrl: 'assets/pront/index.html',
      controller: 'ProntCtrl'
    })
  }).controller('ProntCtrl', function () {
    $rootScope.$broadcast('disablefilterChanged');


    var pusher = new Pusher('thapymar', {
      wsHost: 'localhost',
      wsPort: 8080,
      wssPort: 4433,    // Required if encrypted is true
      encrypted: false, // Optional. the application must use only SSL connections
      enabledTransports: ["ws", "flash"],
      disabledTransports: ["flash"]
    });

    //var pusher = new Pusher('63230285f168f50e6200', {
    //  encrypted: true
    //});
    var channel = pusher.subscribe('lead_channel');
    channel.bind('created', function(data) {
      if($scope.usuario.accounts == data.account_id && ($scope.notify && (data.user == $scope.usuario.id ||
        permissions.hasPermission('{"action": "changelead", "subject_class": "Lead"}'))) && $scope.leadnotify != data.lead)
      {
        $scope.leadnotify = data.lead;
        toaster.success({title: 'Lead', body: data.message, sound: true});
        $scope.refresh();
      }
    });


  });
