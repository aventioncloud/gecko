angular.module('starter.controllers', [])

.controller('DashCtrl', function($scope) {})

.controller('ChatsCtrl', function($scope, Chats, Lead) {
  // With the new view caching in Ionic, Controllers are only called
  // when they are recreated or on app start, instead of every page change.
  // To listen for when this page is active (for example, to refresh data),
  // listen for the $ionicView.enter event:
  //
  //$scope.$on('$ionicView.enter', function(e) {
  //});
  

  $scope.chats = Chats.all();
  $scope.modelsearch = {orderby: 'leads.updated_at desc', awesome: false};
  $scope.leads = [];
  $scope.modelsearch.page = 0;
  
  $scope.doRefresh = function(){
    $scope.modelsearch.page = 1;
    Lead.all($scope.modelsearch).then(function(data){
      for(i = 0; i < data.data.length; i++)
      {
        $scope.leads.push(data.data[i]);        
      }
      $scope.$broadcast('scroll.refreshComplete');
    });
  }
  
  $scope.loadMore = function() {
    $scope.modelsearch.page += 1;
    Lead.all($scope.modelsearch).then(function(data){
      for(i = 0; i < data.data.length; i++)
      {
        $scope.leads.push(data.data[i]);        
      }
      $scope.$broadcast('scroll.infiniteScrollComplete');
    });
  };
  
  $scope.remove = function(chat) {
    Chats.remove(chat);
  };
})

.controller('ChatDetailCtrl', function($scope, $stateParams, Chats, Lead) {
  Lead.get($stateParams.chatId).then(function(data){
      $scope.chat = data.data[0];
  });
})

.controller('AccountCtrl', function($scope, User, $state, Rails) {
    $scope.sair = function() {
      User.logout().then(function(){
        window.localStorage.removeItem('ngStorage-token');
        var loginUrl = "//" + Rails.host + "/oauth/authorize?response_type=token&client_id=" + Rails.application_id + "&redirect_uri=http://" + Rails.host;
        window.location = loginUrl;
      });
    }
});
