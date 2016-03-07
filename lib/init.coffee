{ CompositeDisposable } = require 'atom'


lint = (editor) ->
  console.log("HEYYYYYYY!!!")
  helpers = require('atom-linter')
  regex = /([^:]+):([^:]+):(.+)/

  file = editor.getPath()

  helpers.exec('iverilog', ['-t', 'null', file], {stream: 'both'}).then (output) ->
    lines = output.stderr.split("\n")
    warnings = []
    for line in lines
      parts = line.match(regex)
      if !parts || parts.length != 4
        console.log(line)
      else
        message =
          filePath: parts[1].trim()
          range: helpers.rangeFromLineNumber(editor, parseInt(parts[2])-1, 0)
          type: 'Error'
          text: parts[3].trim()

        warnings.push(message)

    return warnings

module.exports =
  activate: ->
    require('atom-package-deps').install('linter-verilog')

  provideLinter: ->
    provider =
      grammarScopes: ['source.verilog']
      scope: 'project'
      lintOnFly: true
      name: 'Verilog'
      lint: (editor) => lint editor
