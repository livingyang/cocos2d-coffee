nconf = require 'nconf'
path = require 'path'

config =
  set: (key, value) ->
    nconf.set key, value
    nconf.save()

  get: (key) ->
    nconf.get key

  clear: (key) ->
    nconf.clear key
    nconf.save()

  file: (dir) ->
    nconf.file path.join dir, '.coco'

  load: ->
    nconf.load()

config.file '.'
@config = config
