fs = require 'fs'
program = require 'commander'
path = require 'path'
ncp = require 'ncp'

gulp = require 'gulp'
gutil = require 'gulp-util'
concat = require 'gulp-concat'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
wrapper = require 'gulp-wrapper'
plumber = require 'gulp-plumber'
watch = require 'gulp-watch'

p = require path.join __dirname, '..', 'package.json'

getTemplateDir = (isLite) ->
  path.join __dirname, '..', if isLite then 'template-lite' else 'template'

program
  .version p.version

###
coco create
###
program
  .command('create <name>')
  .description('create a coco project.')
  .option '-l, --lite', 'create cocos2d-js-lite project.'
  .action (name, command) ->
    newDir = path.join './', name

    if fs.existsSync newDir
      console.log "#{name}: Already exists"
    else
      ncp (getTemplateDir command.lite), newDir, (err) ->
        if err?
          console.error err
        else
          console.log "To view coco project:\n  cd #{name}"

###
coco build
###
compileScripts = (buildDir, isUglify) ->
  gutil.log "Build at: #{path.resolve buildDir}"

  # main.coffee to main.js
  pipe = gulp
    .src 'main.coffee'
    .pipe plumber()
    .pipe coffee()
    # .on 'error', (e) ->
    #   gutil.log e.toString()
    .pipe concat 'main.js'
  pipe = pipe.pipe uglify() if isUglify
  pipe.pipe gulp.dest buildDir

  # app/** to src/app.js
  pipe = gulp
    .src 'app/**'
    .pipe plumber()
    .pipe coffee()
    # .on 'error', (e) ->
    #   gutil.log e.toString()
    .pipe wrapper
      header: '// \"---- ${filename}\" ---- begin ----\n'
      footer: '// \"---- ${filename}\" ---- end ----\n'
    .pipe concat 'app.js'

  pipe = pipe.pipe uglify() if isUglify
  pipe.pipe gulp.dest path.join buildDir, 'src'

  # res/** to buildDir/res/**
  gulp
    .src 'res/**'
    .pipe gulp.dest path.join buildDir, 'res'

  # project.json to buildDir/res/project.json
  gulp
    .src 'project.json'
    .pipe gulp.dest buildDir

  # lib/** to buildDir/src/lib/**
  gulp
    .src 'lib/**'
    .pipe gulp.dest path.join buildDir, 'src', 'lib'

program
  .command 'build <buildDir>'
  .description 'build app/*.coffee to buildDir/src/app.js and copy res/ to buildDir/res/.'
  .option '-u, --uglify', 'uglify buildDir/src/app.js.'
  .option '-w, --watch', 'watch coco project.'
  .action (buildDir, command) ->
    compileScripts buildDir, command.uglify

    if command.watch
      watch './**', ->
        compileScripts buildDir, command.uglify

###
coco publish
###
publishCocos2d = (cocos2dDir, publishDir) ->
  gulp
    .src [
      path.join cocos2dDir, 'index.html'
      path.join cocos2dDir, 'main.js'
      path.join cocos2dDir, 'project.json']
    .pipe gulp.dest publishDir

  gulp
    .src path.join cocos2dDir, 'res/**'
    .pipe gulp.dest path.join publishDir, 'res'

  gulp
    .src path.join cocos2dDir, 'src/**'
    .pipe gulp.dest path.join publishDir, 'src'

  gulp
    .src path.join cocos2dDir, 'frameworks/cocos2d-html5/**'
    .pipe gulp.dest path.join publishDir, 'frameworks/cocos2d-html5'

program
  .command('publish <cocos2dDir> <publishDir>')
  .description('publish cocos2d project to publishDir.')
  .action (cocos2dDir, publishDir, command) ->
    publishCocos2d cocos2dDir, publishDir
    gutil.log "Publish from: #{path.resolve cocos2dDir} to: #{path.resolve publishDir}"

###
coco doctor
###
program
  .command('doctor')
  .description('check coco project.')
  .action ->
    if not fs.existsSync 'main.coffee'
      gutil.log 'Error: cannot find main.coffee'
    else
      gutil.log 'Success: now can build coco project'

program.parse(process.argv);

program.help() if program.args.length is 0
