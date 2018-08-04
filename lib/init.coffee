{ CompositeDisposable } = require 'atom'
fs = require 'fs'
path = require 'path'

lint = (editor) ->
  helpers = require('atom-linter')
  regex = /((?:[A-Z]:)?[^:]+):([^:]+):(.+)/
  file = editor.getPath()
  dirname = path.dirname(file)
  # fileParient = path.join(dirname,'..')
  console.log(dirname)
  # vfiles = []
  lock = true
  afiles = ("#{file}" for file in fs.readdirSync(dirname))
  vfiles = ("#{path.join(dirname,afile) if afile.match(/.*\.v$/)}" for afile in afiles).filter (x) -> x != 'undefined'
  # console.log(vfiles)

  args = ("#{arg}" for arg in atom.config.get('linter-verilog.extraOptions'))
  args = args.concat ['-t', 'null', '-I', dirname]
  args = args.concat vfiles
  console.log(args)
  helpers.exec('iverilog', args, {stream: 'both'}).then (output) ->
    lines = output.stderr.split("\n")
    messages = []
    for line in lines
      if line.length == 0
        continue;

      console.log(line)
      parts = line.match(regex)
      if !parts || parts.length != 4
        console.debug("Droping line:", line)
      else
        message =
          filePath: parts[1].trim()
          range: helpers.rangeFromLineNumber(editor, parseInt(parts[2])-1, 0)
          type: 'Error'
          text: parts[3].trim()

        messages.push(message)

    return messages

module.exports =
  config:
    extraOptions:
      type: 'array'
      default: []
      description: 'Comma separated list of iverilog options'
  activate: ->
    require('atom-package-deps').install('linter-verilog')

  provideLinter: ->
    provider =
      grammarScopes: ['source.verilog']
      scope: 'project'
      lintOnFly: false
      name: 'Verilog'
      lint: (editor) => lint(editor)
