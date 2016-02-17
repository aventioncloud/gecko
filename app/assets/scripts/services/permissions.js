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
         for(var i =0; i < $localStorage.permissionList.data.length; i++)
         {
            if(typeof $localStorage.permissionList.data[i].action === 'string') {
              if($localStorage.permissionList.data[i].action.trim() === permission)
                return false;
            }
         }
         return true;
      }
      else
      {
          return true;
      }
      
    }
  };
});