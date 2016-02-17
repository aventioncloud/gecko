angular.module('geckoCliApp').controller('AuthCtrl', function($scope, $state, $rootScope, AccessToken, Rails, User, Permission, $localStorage) {
  var setLoggedIn;
  $scope.loginUrl = "//" + Rails.host + "/oauth/authorize?response_type=token&client_id=" + Rails.application_id + "&redirect_uri=http://" + Rails.host;
  $scope.logout = function() {
    AccessToken["delete"]();
    delete $localStorage.permissionList;
    delete $localStorage.user;
    setLoggedIn(false);
    $rootScope.$broadcast('permissionsChanged');
    return User.logout().then(function() {
      return $state.go('index');
    });
  };
  setLoggedIn = function(isLoggedIn) {
    if(!$scope.loggedIn)
    {
      //window.location = $scope.loginUrl;
    }
    return $scope.loggedIn = !!isLoggedIn;
  };
  setLoggedIn(AccessToken.get());
  return $rootScope.$on('$stateChangeSuccess', function() {
    if($localStorage.permissionList == null || $localStorage.permissionList == undefined)
    {
      User.me().then(function(item){
        $localStorage.user = item.data[0];
        //Recupera as permissões.
        return Permission.me().then(function(data){
          $localStorage.permissionList = data;
          $rootScope.$broadcast('permissionsChanged');
          return setLoggedIn(AccessToken.get());
        });
      });
    }
  });
});