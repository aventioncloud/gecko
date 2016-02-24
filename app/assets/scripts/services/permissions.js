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
      permission = JSON.parse(JSONize(permission));
      if(permission.action === "delete")
        var teste = "";
      if($localStorage.permissionList != undefined && $localStorage.permissionList.data != undefined && $localStorage.permissionList.data.length > 0)
      {
         for(var i =0; i < $localStorage.permissionList.data.length; i++)
         {
            if(typeof $localStorage.permissionList.data[i].action === 'string') {
              if($localStorage.permissionList.data[i].action.trim() === permission.action && $localStorage.permissionList.data[i].subject_class.trim() === permission.subject_class)
                return true;
            }
         }
         return false;
      }
      else
      {
          return false;
      }
      
    }
  };
});