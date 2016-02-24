var app;

app = angular.module('geckoCliApp');

app.service('Product', function($http, Rails) {
  var base;
  base = "//" + Rails.host + "/api/v1/product";
  return {
    all: function() {
      return $http.get(base + '/');
    }
  };
});