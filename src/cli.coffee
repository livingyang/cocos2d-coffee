program = require 'commander'

range = (val) ->
  val.split("..").map Number

list = (val) ->
  val.split ","

collect = (val, memo) ->
  memo.push val
  memo

increaseVerbosity = (v, total) ->
  total + 1

program
  .version("0.0.1")
  .usage("[options] <file ...>")
  .option("-i, --integer <n>", "An integer argument", parseInt)
  .option("-f, --float <n>", "A float argument", parseFloat)
  .option("-r, --range <a>..<b>", "A range", range)
  .option("-l, --list <items>", "A list", list)
  .option("-o, --optional [value]", "An optional value")
  .option("-c, --collect [value]", "A repeatable value", collect, [])
  .option("-v, --verbose", "A value that can be increased", increaseVerbosity, 0)
  .parse process.argv

console.log " int: %j", program.integer
console.log " float: %j", program.float
console.log " optional: %j", program.optional
program.range = program.range or []
console.log " range: %j..%j", program.range[0], program.range[1]
console.log " list: %j", program.list
console.log " collect: %j", program.collect
console.log " verbosity: %j", program.verbose
console.log " args: %j", program.args
