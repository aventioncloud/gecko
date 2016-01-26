var app;

app = angular.module('geckoCliApp');

app.controller('AuthCtrl', function($scope, $state, $rootScope, AccessToken, Rails, User) {
  var setLoggedIn;
  $scope.loginUrl = "//" + Rails.host + "/oauth/authorize?response_type=token&client_id=" + Rails.application_id + "&redirect_uri=http://" + Rails.host;
  $scope.logout = function() {
    return User.logout().then(function() {
      AccessToken["delete"]();
      setLoggedIn(false);
      return $state.go('index');
    });
  };
  setLoggedIn = function(isLoggedIn) {
    return $scope.loggedIn = !!isLoggedIn;
  };
  setLoggedIn(AccessToken.get());
  return $rootScope.$on('$stateChangeSuccess', function() {
    return setLoggedIn(AccessToken.get());
  });
});