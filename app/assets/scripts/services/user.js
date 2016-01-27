var app;

app = angular.module('geckoCliApp');

app.service('User', function($http, Rails) {
  var base;
  base = "//" + Rails.host + "/api/v1/user";
  return {
    all: function() {
      return $http.get(base + '/');
    },
    me: function() {
      return $http.get(base + '/me');
    },
    logout: function() {
      return $http["delete"](base + '/logout');
    }
  };
});