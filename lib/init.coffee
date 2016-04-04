{ CompositeDisposable } = require 'atom'

lint = (editor) ->
  helpers = require('atom-linter')
  regex = /([^:]+):([^:]+):(.+)/
  file = editor.getPath()
  path = file.substring(0, file.lastIndexOf("/"))

  helpers.exec('iverilog', ['-t', 'null', '-I', path,  file], {stream: 'both'}).then (output) ->
    lines = output.stderr.split("\n")
    messages = []
    for line in lines
      if line.length == 0
        continue;

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
  activate: ->
    require('atom-package-deps').install('linter-verilog')

  provideLinter: ->
    provider =
      grammarScopes: ['source.verilog']
      scope: 'project'
      lintOnFly: false
      name: 'Verilog'
      lint: (editor) => lint(editor)
