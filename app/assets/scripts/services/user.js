var app;

app = angular.module('geckoCliApp');

app.service('User', function($http, Rails) {
  var base;
  base = "//" + Rails.host + "/api/v1/user";
  return {
    all: function() {
      return $http.get(base + '/');
    },
    search: function(_name) {
      return $http.get(base + '/', {
        params: { name: _name }
      });
    },
    me: function() {
      return $http.get(base + '/me');
    },
    get: function(id) {
      return $http.get(base + '/' + id);
    },
    validemail: function(_email, _id) {
      return $http.get(base + '/validemail', {
        params: { email: _email, id: _id }
      });
    },
    post: function(_value) {
      return $http({
                    method  : 'POST',
                    url     : base,
                    data    : $.param(_value),  // pass in data as strings
                    headers : { 'Content-Type': 'application/x-www-form-urlencoded' }  // set the headers so angular passing info as form data (not request payload)
             });
    },
    put: function(_value) {
      return $http({
                    method  : 'PUT',
                    url     : base + '/'+_value.id,
                    data    : $.param(_value),  // pass in data as strings
                    headers : { 'Content-Type': 'application/x-www-form-urlencoded' }  // set the headers so angular passing info as form data (not request payload)
             });
    },
    delete: function(id) {
      return $http["delete"](base + '/' + id);
    },
    logout: function() {
      return $http["delete"](base + '/logout');
    },
    active: function(id) {
      return $http["post"](base + '/' + id);
    }
  };
});