fs = require 'fs'
program = require 'commander'
shell = require 'shelljs'
path = require 'path'

config = (require './config').config

gulpdir = path.join __dirname, '..', 'gulp'
templatedir = path.join __dirname, '..', 'template'
packagefile = path.join __dirname, '..', 'package.json'

program
  .version (JSON.parse fs.readFileSync packagefile).version

program
  .command('create <name>')
  .description('create a coco project.')
  .action (name) ->
    oldDir = path.join templatedir
    newDir = path.join './', name
    shell.exec "cp -R #{oldDir} #{newDir}", ->
      console.log 'To view coco project:'
      console.log "  cd #{name}"
      
program
  .command 'build [DIR]'
  .description 'build app/*.coffee to DIR/src/app.js and copy res/ to DIR/res/.'
  .option '-u, --uglify', 'uglify DIR/src/app.js.'
  .action (buildDir, command) ->
    config.set 'build', buildDir if buildDir?

    if (config.get 'build')?
      shell.exec "gulp #{if command.uglify then 'release' else 'debug'} --cwd #{gulpdir} --silent --color", ->
        console.log 'Build done.'
    else
      console.log 'please input build dir.'

program
  .command('publish [DIR]')
  .description('publish cocos html5 project to DIR.')
  .option '-s, --save', 'save DIR to .coco config file.'
  .action (publishDir, command) ->
    config.set 'publish', publishDir if publishDir?

    if (config.get 'publish')?
      shell.exec "gulp publish --cwd #{gulpdir} --silent --color", ->
        console.log 'Publish done.'
    else
      console.log 'please input publish dir.'

program
  .command('doctor')
  .description('check coco project.')
  .action ->
    console.log config.load()

program.parse(process.argv);

program.help() if program.args.length is 0
