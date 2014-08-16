nconf = require 'nconf'
path = require 'path'

config =
  setCompile: (value) ->
    nconf.set 'compile', value
    nconf.save()
  getCompile: ->
    nconf.get 'compile'
  clearCompile: ->
    nconf.clear 'compile'
    nconf.save()

  setPublish: (value) ->
    nconf.set 'publish', value
    nconf.save()
  getPublish: ->
    nconf.get 'publish'
  clearPublish: ->
    nconf.clear 'publish'
    nconf.save()

  file: (dir) ->
    nconf.file path.join dir, '.coco'

  load: ->
    nconf.load()

config.file '.'
@config = config
