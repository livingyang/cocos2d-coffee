gulp = require('gulp')

console.log 'gulp INIT_CWD: ' + process.env.INIT_CWD

gulp.task 'compile', ->
  console.log 'gulp compile'

gulp.task 'clean', ->
  console.log 'gulp clean'

gulp.task 'publish', ->
  console.log 'gulp publish'

gulp.task 'doctor', ->
  console.log 'gulp doctor'

gulp.task 'default', ->
  console.log 'default task'
