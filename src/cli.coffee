fs = require 'fs'
program = require 'commander'
path = require 'path'
ncp = require 'ncp'
gaze = require 'gaze'

getTemplateDir = (isLite) ->
  path.join __dirname, '..', if isLite then 'template-lite' else 'template'

program
  .version (require path.join __dirname, '..', 'package.json').version

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
          console.log "To build coco project:\n\tcd #{name}\n\tnpm install\n\tgulp"

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
      console.log 'Success: use gulp to build coco project'

program.parse(process.argv);

program.help() if program.args.length is 0
