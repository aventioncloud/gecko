'use strict'

describe 'Service: tokenInterceptor', ->

  # load the service's module
  beforeEach module 'geckoCliApp'

  # instantiate service
  tokenInterceptor = {}
  beforeEach inject (_tokenInterceptor_) ->
    tokenInterceptor = _tokenInterceptor_

  it 'should do something', ->
    expect(!!tokenInterceptor).toBe true
