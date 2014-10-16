fs = require 'fs'
program = require 'commander'
path = require 'path'
ncp = require 'ncp'

gulp = require 'gulp'
concat = require 'gulp-concat'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
wrapper = require 'gulp-wrapper'

templatedir = path.join __dirname, '..', 'template'
packagefile = path.join __dirname, '..', 'package.json'

program
  .version (JSON.parse fs.readFileSync packagefile).version

###
coco create
###
program
  .command('create <name>')
  .description('create a coco project.')
  .action (name) ->
    oldDir = path.join templatedir
    newDir = path.join './', name

    ncp oldDir, newDir, (err) ->
      console.error err if err?
      console.log 'To view coco project:'
      console.log "  cd #{name}"

###
coco build
###
compileScripts = (buildDir, isUglify) ->
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
  pipe.pipe gulp.dest path.join buildDir, 'src'

  # res/** to buildDir/res/**
  gulp
    .src 'res/**'
    .pipe gulp.dest path.join buildDir, 'res'

program
  .command 'build <buildDir>'
  .description 'build app/*.coffee to buildDir/src/app.js and copy res/ to buildDir/res/.'
  .option '-u, --uglify', 'uglify buildDir/src/app.js.'
  .action (buildDir, command) ->
    compileScripts buildDir, command.uglify
    console.log "Build at: #{path.resolve buildDir}"

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
    console.log "Publish from: #{path.resolve cocos2dDir} to: #{path.resolve publishDir}"

###
coco doctor
###
program
  .command('doctor')
  .description('check coco project.')
  .action ->
    if not fs.existsSync 'main.coffee'
      console.log 'Error: cannot find main.coffee'
    else
      console.log 'Success: now can build coco project'

program.parse(process.argv);

program.help() if program.args.length is 0
