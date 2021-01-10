{ CompositeDisposable } = require 'atom'
fs = require 'fs'
path = require 'path'
helpers = require('atom-linter')

lint = (editor) ->
  file = editor.getPath()
  dirname = path.dirname(file)
  compiler = atom.config.get('linter-veriloghdl.compiler')

  if compiler == 'iverilog'
    regex = /((?:[A-Z]:)?[^:]+):([^:]+):(?: *(error|warning|sorry):)? *(.+)/
    # console.log(dirname)
    afiles = ("#{dir_file}" for dir_file in fs.readdirSync(dirname))
    vfiles = ("#{path.join(dirname,afile) if afile.match(/.*\.s?v$/)}" for afile in afiles).filter (x) ->
      x != 'undefined'
    console.debug(vfiles)

    args = ("#{arg}" for arg in atom.config.get('linter-veriloghdl.iverilogOptions'))
    args = args.concat ['-t', 'null', '-I', dirname]
    args = args.concat vfiles
    command = atom.config.get('linter-veriloghdl.iverilogExecutable')
    console.log(command, args)
    helpers.exec(command, args, {stream: 'both'}).then (output) ->
      lines = output.stderr.split("\n")
      messages = []
      for line in lines
        if line.length == 0
          continue; # Skip the current empty line

        console.log(line)
        parts = line.match(regex)
        if !parts || parts.length != 5
          console.debug("Dropping line:", line)
        else
          severity_ivlog = parts[3] # should be 'error' or 'warning' or 'sorry'
          if severity_ivlog == 'sorry'
            if atom.config.get('linter-veriloghdl.suppressSorry')
              continue # skip this message
            severity_ivlog = 'info'
          else if severity_ivlog != 'warning'
            severity_ivlog = 'error'

          file_ivlog = parts[1].trim()
          line_num = parseInt(parts[2])-1;
          # Don't try to parse line number if error is in another file
          if file_ivlog == file
            message_position = helpers.generateRange(editor, line_num)
          else
            position_ivlog = [[line_num, 0], [line_num+1, 0]]

          message =
            location: {
              file: file_ivlog
              position: message_position
            }
            severity: severity_ivlog
            excerpt: parts[4]

          #console.log(message)
          messages.push(message)

      return messages
  # end if compiler == 'iverilog'

  else if compiler == 'verilator'
    regex = /%(Error|Warning)(?:-([A-Z0-9_]+))?: ((?:[A-Z]:)?(?:[^\s:]+)):(\d+):(?:(\d+):)? *(.+)/
    file = file.replace(/\\/g,"/")
    dirname = dirname.replace(/\\/g,"/")

    args = ("#{arg}" for arg in atom.config.get('linter-veriloghdl.verilatorOptions'))
    args = args.concat ['--lint-only', '-I' + dirname, file]
    command = atom.config.get('linter-veriloghdl.verilatorExecutable')
    console.log(command, args)
    return helpers.exec(command, args, {stream: 'stderr', allowEmptyStderr: true}).then (output) ->
      lines = output.split("\n")
      messages = []
      for line in lines
        if line.length == 0
          continue; # Skip the current empty line

        console.log(line)
        parts = line.match(regex)
        if !parts || parts.length != 7 || (file != parts[3].trim())
          console.debug("Dropping line:", line)
        else
          line_num = Math.min(editor.getLineCount(), parseInt(parts[4]) - 1)
          column_num = if parts[5] then parseInt(parts[5]) - 1 else 0
          message_position = helpers.generateRange(editor, line_num, column_num)
          message =
            location: {
              file: path.normalize(parts[3].trim()),
              position: message_position
            }
            severity: parts[1].toLowerCase()
            excerpt: (if parts[2] then parts[2] + ": " else "") + parts[6]

          #console.log(message)
          messages.push(message)

      return messages
  # end else if compiler == 'verilator'

  else if compiler == 'slang'
    # set up promise-based command execution dependency
    # node's child_process::execFile is needed since slang's output may be
    #   encoded in UTF-16 LE, which atom-linter::exec doesn't support
    util = require('util')
    execFile = util.promisify(require('child_process').execFile)

    regex = /((?:[A-Z]:)?(?:[^\s:]+)):(\d+):(\d+): *(error|warning|note):(.+)/

    args = ("#{arg}" for arg in atom.config.get('linter-veriloghdl.slangOptions'))
    args = args.concat ['--color-diagnostics=false', '-I' + dirname, file]
    command = atom.config.get('linter-veriloghdl.slangExecutable')
    console.log(command, args)

    # slang's Windows binary produces UTF-16 encoded output
    if process.platform == 'win32'
      slang_encoding = 'utf16le'
    else
      slang_encoding = 'utf8'

    return execFile(command, args, {cwd: dirname, encoding: slang_encoding})
    .then () ->
      return [] # slang exited with code 0; no issues detected
    .catch (error) ->
      # slang exited with non-zero exit code since issues were detected;
      # promisified execFile() considers a non-zero exit code to be an
      #   error, so catch() is used

      # console.log(error.stdout)

      if error.code == 'ENOENT' # slang could not be run
        # this has to be implemented here since child_process::execFile() is used;
        # when using atom-linter::exec(), this kind of error is thrown elsewhere
        newError = new Error('Failed to spawn command `' + command + '`. Make
        sure slang is installed and \"Slang Executable\" in linter-veriloghdl\'s
        settings is correct.');
        newError.code = 'ENOENT';
        throw newError;
        return []

      messages = []
      lines = error.stdout.split("\n")
      for line in lines
        if line.length == 0
          continue; # Skip the current empty line

        console.log(line)
        parts = line.match(regex)
        if !parts || parts.length != 6
          console.debug("Dropping line:", line)
        else
          line_num = Math.min(editor.getLineCount(), parseInt(parts[2]) - 1)
          column_num = parseInt(parts[3]) - 1
          message_position = helpers.generateRange(editor, line_num, column_num)
          message =
            location: {
              file: path.join(dirname, parts[1].trim()), # slang gives path relative to working dir
              position: message_position
            }
            severity: if parts[4] == 'note' then 'info' else parts[4]
            excerpt: parts[5].trim()

          # console.log(message)
          messages.push(message)

      return messages
    # end execFile

  else # compiler == 'none'
    atom.notifications.addWarning('[linter-veriloghdl] No compiler selected',
    {detail: 'Please select a compiler in linter-veriloghdl\'s settings.'})
    return []
# end lint

module.exports =
  config:
    compiler:
      type: 'string'
      default: 'none'
      enum: ['iverilog', 'slang', 'verilator', 'none']
      description: 'Verilog/SystemVerilog compiler for this linter provider to use'
      order: 1
    iverilogExecutable:
      title: 'iverilog Executable'
      type: 'string'
      default: 'iverilog'
      description: 'Path to iverilog executable'
      order: 2
    iverilogOptions:
      title: 'iverilog Options'
      type: 'array'
      default: ['-Wall']
      description: 'Comma separated list of iverilog options (note that \"-t null\" will be added)'
      order: 3
    suppressSorry:
      title: 'Suppress iverilog \"sorry\" type info messages'
      type: 'boolean'
      default: false
      description: 'These messages may warn that iverilog does not support all SystemVerilog
      constructs, but this doesn\'t matter for linting'
      order: 4
    slangExecutable:
      type: 'string'
      default: 'slang'
      description: 'Path to slang executable'
      order: 5
    slangOptions:
      type: 'array'
      default: ['-Weverything']
      description: 'Comma separated list of slang options'
      order: 6
    verilatorExecutable:
      type: 'string'
      default: 'verilator'
      description: 'Path to verilator executable'
      order: 7
    verilatorOptions:
      type: 'array'
      default: ['-Wall', '--bbox-sys', '--bbox-unsup']
      description: 'Comma separated list of verilator options (note that \"--lint-only\" will be added)'
      order: 8


  activate: ->
    require('atom-package-deps').install('linter-veriloghdl')

  provideLinter: ->
    provider =
      grammarScopes: ['source.verilog', 'source.systemverilog']
      scope: 'project'
      lintsOnChange: false
      name: 'VerilogHDL'
      lint: (editor) => lint(editor)
