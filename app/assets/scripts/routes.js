var app;

app = angular.module('geckoCliApp');

app.config(function($stateProvider, $urlRouterProvider) {
  $urlRouterProvider.otherwise(function() {
    return '/';
  });
  $stateProvider.state('index', {
    url: '/',
    templateUrl: 'assets/main.html',
    controllerAs: 'main'
  });
  $stateProvider.state('about', {
    url: '/about',
    templateUrl: 'assets/about.html',
    controllerAs: 'about'
  });
  $stateProvider.state('accessToken', {
    url: '/access_token=:response',
    controller: function($window, $state, $stateParams, AccessToken) {
      var token;
      token = $stateParams.response.match(/^(.*?)&/)[1];
      AccessToken.set(token);
      return $state.go('index');
    }
  });
  return $stateProvider.state('401', {
    url: '/unauthorized',
    controller: function($state, AccessToken) {
      if (AccessToken.get()) {
        return $state.go('index');
      }
    },
    templateUrl: '401.html'
  });
});