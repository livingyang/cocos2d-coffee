# gulp = require 'gulp'
gulp = require('gulp-param') require('gulp'), process.argv
gutil = require 'gulp-util'
concat = require 'gulp-concat'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
wrapper = require 'gulp-wrapper'
buster = require 'gulp-buster'
path = require 'path'
crypto = require 'crypto'

gulp.task 'default', ['watch']

gulp.task 'build-main', (dist = 'dist') ->
  gulp
    .src 'main.coffee'
    .pipe coffee()
    .pipe gulp.dest dist

gulp.task 'build-app', (dist = 'dist') ->
  gulp
    .src 'app/**'
    .pipe coffee()
    .pipe wrapper
      header: '// \"---- ${filename}\" ---- begin ----\n'
      footer: '// \"---- ${filename}\" ---- end ----\n'
    .pipe concat 'app.js'
    .pipe gulp.dest path.join dist, 'src'

gulp.task 'copy-lib', (dist = 'dist') ->
  gulp
    .src 'lib/**'
    .pipe gulp.dest path.join dist, 'src', 'lib'

gulp.task 'copy-res', (dist = 'dist') ->
  gulp
    .src 'res/**'
    .pipe gulp.dest path.join dist, 'res'

gulp.task 'buster', ['build-main', 'build-app', 'copy-lib', 'copy-res'], (dist = 'dist') ->
  bustersJson = 'res/busters.json'

  getObjectMd5 = (obj) ->
    crypto.createHash('md5').update(JSON.stringify obj).digest('Hex')

  gulp
    .src ["#{dist}/**", "!#{dist}/#{bustersJson}"]
    .pipe buster
      length: 8
      transform: (hashes) ->
        result = {}
        for filePath, hash of hashes
          result[path.relative dist, filePath] = hash

        result[bustersJson] = getObjectMd5 result

        result
    .pipe gulp.dest "#{dist}/res"

gulp.task 'watch', ->
  gulp.start 'buster'
  gulp.watch ['app/**', 'lib/**', 'res/**', 'main.coffee', 'project.json'], ->
    gulp.start 'buster'
