{ CompositeDisposable } = require 'atom'
fs = require 'fs'
path = require 'path'

lint = (editor) ->
  helpers = require('atom-linter')
  file = editor.getPath()
  dirname = path.dirname(file)
  compiler = atom.config.get('linter-verilog.compiler')
  
  if compiler == 'iverilog'
    regex = /((?:[A-Z]:)?[^:]+):([^:]+):(?: *(error|warning|sorry):)? *(.+)/
    console.log(dirname)
    lock = true
    afiles = ("#{file}" for file in fs.readdirSync(dirname))
    vfiles = ("#{path.join(dirname,afile) if afile.match(/.*\.s?v$/)}" for afile in afiles).filter (x) -> x != 'undefined'
    console.debug(vfiles)

    args = ("#{arg}" for arg in atom.config.get('linter-verilog.iverilogOptions'))
    args = args.concat ['-t', 'null', '-I', dirname]
    args = args.concat vfiles
    command = atom.config.get('linter-verilog.iverilogExecutable')
    console.log(command, args)
    helpers.exec(command, args, {stream: 'both'}).then (output) ->
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
          severity_tmp = parts[3] # should be 'error' or 'warning' or 'sorry'
          file_tmp = parts[1].trim()
          if severity_tmp == 'sorry'
            if atom.config.get('linter-verilog.suppressSorry')
              continue # skip this message
            severity_tmp = 'info'
          else if severity_tmp != 'warning'
            severity_tmp = 'error'
          line_num = parseInt(parts[2])-1;
          # Don't try to parse line number if error is in another file
          if file_tmp == editor.getPath()
            position_tmp = helpers.generateRange(editor, line_num)
          else
            position_tmp = [[line_num, 0], [line_num+1, 0]]

          message =
            location: {
              file: file_tmp
              position: position_tmp
            }
            severity: severity_tmp
            excerpt: parts[4]
          messages.push(message)

      return messages

  else # compiler == 'verilator'
    regex = /%(Error|Warning)(?:-([A-Z0-9_]+))?: ((?:[A-Z]:)?(?:[^\s:]+)):(\d+):(?:(\d+):)?(.+)/
    file = file.replace(/\\/g,"/")

    args = ("#{arg}" for arg in atom.config.get('linter-verilog.verilatorOptions'))
    args = args.concat ['--lint-only', '-I' + dirname, file]
    command = atom.config.get('linter-verilator.executable')
    console.log(command, args)
    return helpers.exec(command, args, {stream: 'stderr', allowEmptyStderr: true}).then (output) ->
      lines = output.split("\n")
      messages = []
      for line in lines
        if line.length == 0
          continue;

        console.log(line)
        parts = line.match(regex)
        if !parts || parts.length != 7 || (file != parts[3].trim())
          console.debug("Dropping line:", line)
        else
          column_num = if parts[5] then column_num = parseInt(parts[5]) - 1 else 0
          message_position = helpers.generateRange(editor, Math.min(editor.getLineCount(), parseInt(parts[4]))-1, column_num)
          message =
            location: {
              file: path.normalize(parts[3].trim()),
              position: message_position
            }
            severity: parts[1].toLowerCase()
            excerpt: (if parts[2] then parts[2] + ": " else "") + parts[6].trim()

          #console.log(message)
          messages.push(message)

      return messages
# end lint

module.exports =
  config:
    compiler:
      type: 'string'
      default:'verilator'
      enum: ['verilator', 'iverilog']
      description: 'Verilog/SystemVerilog compiler for this linter provider to use'
      order: 1
    verilatorExecutable:
      type: 'string'
      default: 'verilator'
      description: 'Path to verilator executable'
      order: 2
    verilatorOptions:
      type: 'array'
      default: ['-Wall', '--bbox-sys', '--bbox-unsup']
      description: 'Comma separated list of verilator options (note that \"--lint-only\" will be added)'
      order: 3
    iverilogExecutable:
      title: 'iverilog Executable'
      type: 'string'
      default: 'iverilog'
      description: 'Path to iverilog executable'
      order: 4
    iverilogOptions:
      title: 'iverilog Options'
      type: 'array'
      default: ['-Wall']
      description: 'Comma separated list of iverilog options (note that \"-t null\" will be added)'
      order: 5
    suppressSorry:
      title: 'Suppress iverilog \"sorry\" type info messages'
      type: 'boolean'
      default: false
      description: 'These messages may warn that iverilog does not support all SystemVerilog 
      constructs, but this doesn\'t matter for linting'
      order: 6

  activate: ->
    require('atom-package-deps').install('linter-verilog')

  provideLinter: ->
    provider =
      grammarScopes: ['source.verilog', 'source.systemverilog']
      scope: 'project'
      lintsOnChange: false
      name: 'Verilog/SystemVerilog'
      lint: (editor) => lint(editor)
