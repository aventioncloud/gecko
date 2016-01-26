# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

roles = PlatformRoles.create([{ name: 'Administrador' }, { name: 'Consultor' }, { name: 'Cliente' }])
menu = PlatformMenu.create([{ name: 'Dashboard', url: '', href: '', short: 1, menudad: nil, icon: ''}])
PlatformMenuRoles.create(menu_id: menu.first.id, role_id: roles.first.id, principalid: 'read')
