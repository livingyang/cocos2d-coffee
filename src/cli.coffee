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
  .command('compile')
  .option '-u, --uglify', 'uglify all js files.'
  .description('compile app/*.coffee to app.js and copy files to cocos project folder.')
  .action (command) ->
    shell.exec "gulp #{if command.uglify then 'release' else 'debug'} --cwd #{gulpdir} --silent --color", ->
      console.log 'Compile done.'

program
  .command('clean')
  .description('clean cocos2d res folder.')
  .action ->
    shell.exec "gulp clean --cwd #{gulpdir} --silent --color", ->
      console.log 'Clean done.'

program
  .command('publish')
  .description('publish cocos html5 project to folder.')
  .action ->
    shell.exec "gulp publish --cwd #{gulpdir} --silent --color", ->
      console.log 'Publish done.'

program
  .command('doctor')
  .description('check coco project.')
  .action ->
    shell.exec "gulp doctor --cwd #{gulpdir} --silent --color", ->
      console.log 'Doctor done.'

setConfig = (key, value) ->
  if typeof value is 'string'
    config.set key, value
  else if value?
    config.clear key

program
  .command 'config'
  .description 'set config'
  .option '-c, --cocos2d [value]', 'cocos2d project dir.'
  .option '-p, --publish [value]', 'cocos2d html5 release folder.'
  .action (command) ->
    setConfig 'cocos2d', command.cocos2d
    setConfig 'publish', command.publish

    console.log 'Project config done:'
    console.log config.load()

program.parse(process.argv);

program.help() if program.args.length is 0
