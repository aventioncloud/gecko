angular.module('geckoCliApp').controller('AuthCtrl', function($scope, $state, $rootScope, AccessToken, Rails, User, Permission, $localStorage) {
  var setLoggedIn;
  $scope.loginUrl = "//" + Rails.host + "/oauth/authorize?response_type=token&client_id=" + Rails.application_id + "&redirect_uri=http://" + Rails.host;
  $scope.logout = function() {
    return User.logout().then(function() {
      AccessToken["delete"]();
      setLoggedIn(false);
      delete $localStorage.permissionList;
      return $state.go('index');
    });
  };
  setLoggedIn = function(isLoggedIn) {
    return $scope.loggedIn = !!isLoggedIn;
  };
  setLoggedIn(AccessToken.get());
  return $rootScope.$on('$stateChangeSuccess', function() {
    return Permission.me().then(function(data){
      $localStorage.permissionList = data;
      return setLoggedIn(AccessToken.get());
    });
  });
});