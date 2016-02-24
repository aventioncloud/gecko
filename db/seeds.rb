# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

rolessuperadmin = Role.create({ name: 'Super Admin' })
rolesadmin = Role.create({ name: 'Administrador' })
rolesconsultor = Role.create({ name: 'Supervisor' })
rolesusuario = Role.create({ name: 'Usuario' })

#Users
permission = Permission.new
permission.name = 'Get Users'
permission.subject_class = 'User'
permission.action = 'read'
if permission.save
    permission.roles << Role.where(:name => 'Super Admin')
    permission.roles << Role.where(:name => 'Administrador')
end

permission = Permission.new
permission.name = 'Create Users'
permission.subject_class = 'User'
permission.action = 'create'
if permission.save
    permission.roles << Role.where(:name => 'Super Admin')
    permission.roles << Role.where(:name => 'Administrador')
end

permission = Permission.new
permission.name = 'Delete Users'
permission.subject_class = 'User'
permission.action = 'delete'
if permission.save
    permission.roles << Role.where(:name => 'Super Admin')
    permission.roles << Role.where(:name => 'Administrador')
end

#Group
permission = Permission.new
permission.name = 'Get Group'
permission.subject_class = 'Group'
permission.action = 'read'
if permission.save
    permission.roles << Role.where(:name => 'Super Admin')
    permission.roles << Role.where(:name => 'Administrador')
end

permission = Permission.new
permission.name = 'Create Group'
permission.subject_class = 'Group'
permission.action = 'create'
if permission.save
    permission.roles << Role.where(:name => 'Super Admin')
    permission.roles << Role.where(:name => 'Administrador')
end

permission = Permission.new
permission.name = 'Delete Group'
permission.subject_class = 'Group'
permission.action = 'delete'
if permission.save
    permission.roles << Role.where(:name => 'Super Admin')
    permission.roles << Role.where(:name => 'Administrador')
end

#Lead
permission = Permission.new
permission.name = 'Get Lead'
permission.subject_class = 'Lead'
permission.action = 'read'
if permission.save
    permission.roles << Role.where(:name => 'Super Admin')
    permission.roles << Role.where(:name => 'Administrador')
    permission.roles << Role.where(:name => 'Supervisor')
    permission.roles << Role.where(:name => 'Supervisor')
end

permission = Permission.new
permission.name = 'Create Lead'
permission.subject_class = 'Lead'
permission.action = 'create'
if permission.save
    permission.roles << Role.where(:name => 'Super Admin')
    permission.roles << Role.where(:name => 'Administrador')
    permission.roles << Role.where(:name => 'Supervisor')
    #permission.roles << Role.where(:name => 'Usuario')
end

permission = Permission.new
permission.name = 'Delete Lead'
permission.subject_class = 'Lead'
permission.action = 'delete'
if permission.save
    permission.roles << Role.where(:name => 'Super Admin')
    permission.roles << Role.where(:name => 'Administrador')
    permission.roles << Role.where(:name => 'Supervisor')
    #permission.roles << Role.where(:name => 'Usuario')
end

#menu = PlatformMenu.create([{ name: 'Dashboard', url: '', href: '', short: 1, menudad: nil, icon: ''}])
#PlatformMenuRoles.create(menu_id: menu.first.id, role_id: roles.first.id, principalid: 'read')
