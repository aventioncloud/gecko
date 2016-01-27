var app;

app = angular.module('geckoCliApp');

app.service('Permission', function($http, Rails) {
  var base;
  base = "//" + Rails.host + "/api/v1/role";
  return {
    all: function() {
      return $http.get(base + '/');
    },
    me: function() {
      return $http.get(base + '/me');
    }
  };
});