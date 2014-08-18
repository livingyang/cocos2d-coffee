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

cocos2dDir = (config.get 'cocos2d') ? '../compile'
getCocos2dPath = (lastPath) ->
  path.join cocos2dDir, lastPath

publishDir = (config.get 'publish') ? '../publish'
getPublishPath = (lastPath) ->
  path.join publishDir, lastPath

compileScripts = (isUglify) ->
  # main.coffee to main.js
  pipe = gulp
    .src 'main.coffee'
    .pipe coffee()
    .pipe concat 'main.js'
  pipe = pipe.pipe uglify() if isUglify
  pipe.pipe gulp.dest cocos2dDir

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

  # res/** to cocos2dDir/res/**
  gulp
    .src 'res/**'
    .pipe gulp.dest getCocos2dPath 'res'

gulp.task 'debug', ->
  compileScripts false

gulp.task 'release', ->
  compileScripts true

gulp.task 'clean', ->
  # TODO: clean
  console.log 'gulp clean'
  return
  gulp
    .src (path.join cocos2dDir, 'res'), read: false
    .pipe rimraf()

gulp.task 'publish', ->
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

gulp.task 'doctor', ->
  console.log 'gulp doctor: '
  console.log config.load()

gulp.task 'default', ->
  console.log 'default task'
