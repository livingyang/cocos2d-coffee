gulp = require 'gulp'
concat = require 'gulp-concat'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
wrapper = require 'gulp-wrapper'
rimraf = require 'gulp-rimraf'

config = (require '../src/config').config
path = require 'path'

# set current working directory to coco project directory
process.chdir process.env.INIT_CWD
config.file '.'

buildDir = (config.get 'build') ? './build'
getCocos2dPath = (lastPath = '.') ->
  path.join buildDir, lastPath

publishDir = (config.get 'publish') ? './publish'
getPublishPath = (lastPath = '.') ->
  path.join publishDir, lastPath

compileScripts = (isUglify) ->
  console.log "Building to: #{path.resolve buildDir}"

  # main.coffee to main.js
  pipe = gulp
    .src 'main.coffee'
    .pipe coffee()
    .pipe concat 'main.js'
  pipe = pipe.pipe uglify() if isUglify
  pipe.pipe gulp.dest buildDir

  # app/** to src/app.js
  pipe = gulp
    .src 'app/**'
    .pipe coffee()
    .pipe wrapper
      header: '// \"---- ${filename}\" ---- begin ----\n'
      footer: '// \"---- ${filename}\" ---- end ----\n'
    .pipe concat 'app.js'

  pipe = pipe.pipe uglify() if isUglify
  pipe.pipe gulp.dest getCocos2dPath 'src'

  # res/** to buildDir/res/**
  gulp
    .src 'res/**'
    .pipe gulp.dest getCocos2dPath 'res'

gulp.task 'debug', ->
  compileScripts false

gulp.task 'release', ->
  compileScripts true

gulp.task 'publish', ->
  console.log "Publish from: #{path.resolve getCocos2dPath()}\nto: #{path.resolve getPublishPath()}"

  gulp
    .src [
      getCocos2dPath 'index.html'
      getCocos2dPath 'main.js'
      getCocos2dPath 'project.json']
    .pipe gulp.dest publishDir

  gulp
    .src getCocos2dPath 'res/**'
    .pipe gulp.dest getPublishPath 'res'

  gulp
    .src getCocos2dPath 'src/**'
    .pipe gulp.dest getPublishPath 'src'

  gulp
    .src getCocos2dPath 'frameworks/cocos2d-html5/**'
    .pipe gulp.dest getPublishPath 'frameworks/cocos2d-html5'

gulp.task 'default', ->
  console.log 'Please use coco common line tool.'
