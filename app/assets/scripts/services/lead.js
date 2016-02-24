var app;

app = angular.module('geckoCliApp');

app.service('Lead', function($http, Rails) {
  var base;
  base = "//" + Rails.host + "/api/v1/lead";
  return {
    all: function(_filter) {
      return $http.get(base + '/',{
        params: _filter
      });
    },
    get: function(id) {
      return $http.get(base + '/' + id);
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
    active: function(id) {
      return $http["post"](base + '/' + id);
    }
  };
});