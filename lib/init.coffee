{ CompositeDisposable } = require 'atom'
fs = require 'fs'
path = require 'path'

lint = (editor) ->
  helpers = require('atom-linter')
  regex = /((?:[A-Z]:)?[^:]+):([^:]+):(?: *(error|warning):)? *(.+)/
  file = editor.getPath()
  dirname = path.dirname(file)
  # fileParient = path.join(dirname,'..')
  console.log(dirname)
  # vfiles = []
  lock = true
  afiles = ("#{file}" for file in fs.readdirSync(dirname))
  vfiles = ("#{path.join(dirname,afile) if afile.match(/.*\.s?v$/)}" for afile in afiles).filter (x) -> x != 'undefined'
  console.debug(vfiles)

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
      if !parts || parts.length != 5
        console.debug("Dropping line:", line)
      else
        severity_tmp = parts[3] # should be 'error' or 'warning'
        if severity_tmp != 'warning'
          severity_tmp = 'error'
        message =
          location: {
            file: parts[1].trim()
            position: helpers.rangeFromLineNumber(editor, parseInt(parts[2])-1, 0)
          }
          severity: severity_tmp
          excerpt: parts[4]
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
      lintsOnChange: false
      name: 'Verilog'
      lint: (editor) => lint(editor)
