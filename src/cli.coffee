program = require 'commander'
shell = require 'shelljs'

program
  .version('0.0.1')

program
  .command('create <name>')
  .description('create a coco project.')
  .action (name) ->
    console.log "create: #{name}"

program
  .command('compile')
  .description('compile app/*.coffee to app.js and copy files to cocos project folder.')
  .action ->
    shell.exec("gulp compile --cwd #{__dirname}/.. --silent --color");

program
  .command('clean')
  .description('clean cocos project folder.')
  .action ->
    shell.exec("gulp clean --cwd #{__dirname}/.. --silent --color");

program
  .command('publish')
  .description('publish cocos html5 project to folder.')
  .action ->
    shell.exec("gulp publish --cwd #{__dirname}/.. --silent --color");

program
  .command('doctor')
  .description('check coco project.')
  .action ->
    console.log 'doctor'

program.parse(process.argv);
