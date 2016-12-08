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
      getconsult: function(_filter) {
          return $http.get(base + '/export',{
              params: _filter
          });
      },
    get: function(id) {
      return $http.get(base + '/' + id);
    },
      audit: function(id) {
          return $http.get(base + '/audit/' + id);
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
    history: function(_lead_id, _status_id) {
      return $http.get(base + '/history', {
        params: { id: _lead_id, status_id: _status_id }
      });
    },
    active: function(id) {
      return $http["post"](base + '/' + id);
    },
    changelead: function(_id, _status, _comment, _file_id, _other) {
      _value = {id: _id, status: _status, comment: _comment, file_id: _file_id, other: _other};
      return $http({
                    method  : 'POST',
                    url     : base + '/changestatus',
                    data    : $.param(_value),  // pass in data as strings
                    headers : { 'Content-Type': 'application/x-www-form-urlencoded' }  // set the headers so angular passing info as form data (not request payload)
             });
    },
    changesconsult: function(_id, _user_id) {
      _value = {id: _id, user_id: _user_id};
      return $http({
                    method  : 'POST',
                    url     : base + '/changesconsult',
                    data    : $.param(_value),  // pass in data as strings
                    headers : { 'Content-Type': 'application/x-www-form-urlencoded' }  // set the headers so angular passing info as form data (not request payload)
             });
    }
  };
});
