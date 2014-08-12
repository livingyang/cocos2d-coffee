var gulp = require('gulp');

console.log("gulp INIT_CWD: " + process.env.INIT_CWD);

gulp.task('compile', function() {
  console.log('gulp compile');
});

gulp.task('clean', function() {
  console.log('gulp clean');
});

gulp.task('publish', function() {
  console.log('gulp publish');
});

gulp.task('default', function() {
  console.log('default task');
});
