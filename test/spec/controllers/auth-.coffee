'use strict'

describe 'Controller: AuthCtrlCtrl', ->

  # load the controller's module
  beforeEach module 'geckoCliApp'

  AuthCtrlCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AuthCtrlCtrl = $controller 'AuthCtrlCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(AuthCtrlCtrl.awesomeThings.length).toBe 3
