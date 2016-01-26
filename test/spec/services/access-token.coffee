'use strict'

describe 'Service: accessToken', ->

  # load the service's module
  beforeEach module 'geckoCliApp'

  # instantiate service
  accessToken = {}
  beforeEach inject (_accessToken_) ->
    accessToken = _accessToken_

  it 'should do something', ->
    expect(!!accessToken).toBe true
