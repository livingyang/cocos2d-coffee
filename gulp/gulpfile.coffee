gulp = require 'gulp'
config = (require '../src/config').config

config.file process.env.INIT_CWD

console.log 'gulp INIT_CWD: ' + process.env.INIT_CWD

gulp.task 'compile', ->
  console.log 'gulp compile'

gulp.task 'clean', ->
  console.log 'gulp clean'

gulp.task 'publish', ->
  console.log 'gulp publish'

gulp.task 'doctor', ->
  console.log 'gulp doctor: '
  console.log config.load()

gulp.task 'default', ->
  console.log 'default task'
