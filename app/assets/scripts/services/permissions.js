//permissions.js
angular.module('geckoCliApp')  
.factory('permissions', function ($rootScope, $localStorage) {
  var permissionList;
  return {
    setPermissions: function(permissions) {
      permissionList = permissions;
      $rootScope.$broadcast('permissionsChanged');
    },
    hasPermission: function (permission) {
      permission = permission.trim();
      if($localStorage.permissionList != undefined && $localStorage.permissionList.data != undefined && $localStorage.permissionList.data.length > 0)
      {
          return $.each(JSON.stringify($localStorage.permissionList.Data), function(item) {
            if(typeof item.action === 'string') {
              return item.action.trim() === permission
            }
          });
      }
      else
      {
          return true;
      }
      
    }
  };
});