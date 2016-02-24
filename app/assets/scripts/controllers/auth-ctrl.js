angular.module('geckoCliApp').controller('AuthCtrl', function($scope, $state, $rootScope, AccessToken, Rails, User, Permission, $localStorage, $location) {
  var setLoggedIn;
  if($localStorage.user !== undefined && $localStorage.user != null)
    $scope.name = $localStorage.user.name;
  else
    $scope.name = "";
    
    
  $scope.loginUrl = "//" + Rails.host + "/oauth/authorize?response_type=token&client_id=" + Rails.application_id + "&redirect_uri=http://" + Rails.host;
  $scope.logout = function() {
    AccessToken["delete"]();
    $scope.name = "";
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
        $scope.name =  item.data[0].name;
        //Recupera as permissões.
        return Permission.me().then(function(data){
          $localStorage.permissionList = data;
          $location.path('/lead');
          $rootScope.$broadcast('permissionsChanged');
          return setLoggedIn(AccessToken.get());
        });
      });
    }
  });
});