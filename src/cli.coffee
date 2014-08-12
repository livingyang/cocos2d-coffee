fs = require 'fs'
program = require 'commander'
shell = require 'shelljs'
nconf = require 'nconf'
path = require 'path'

nconf.file '.coco'
setConfig = (name, value) ->
  if value?
    if typeof value is 'string'
      nconf.set name, value
    else
      nconf.clear name

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
  .description('compile app/*.coffee to app.js and copy files to cocos project folder.')
  .action ->
    console.log gulpdir
    shell.exec "gulp compile --cwd #{gulpdir} --silent --color", ->
      console.log 'Compile done.'

program
  .command('clean')
  .description('clean cocos project folder.')
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

program
  .command 'config'
  .description 'set config'
  .option '-c, --compile [value]', '*.coffee will compile to cocos2d project folder.'
  .option '-p, --publish [value]', 'cocos2d html5 release folder.'
  .action (command) ->
    setConfig 'compile', command.compile
    setConfig 'publish', command.publish
    nconf.save()
    console.log 'Project config done:'
    console.log nconf.load()

program.parse(process.argv);
