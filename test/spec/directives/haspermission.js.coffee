'use strict'

describe 'Directive: hasPermission.js', ->

  # load the directive's module
  beforeEach module 'geckoCliApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<has-permission.js></has-permission.js>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the hasPermission.js directive'
