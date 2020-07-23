# linter-systemverilog

Atom linter for Verilog/SystemVerilog, using [Icarus Verilog](http://iverilog.icarus.com) or [Verilator](https://www.veripool.org/wiki/verilator).  

![Screenshot](https://raw.githubusercontent.com/a2k-hanlon/linter-systemverilog/master/screenshot.png)


## Compiler Installation

### Icarus Verilog (iverilog)

On Linux, you can install it using your package manager: eg. ```apt install iverilog```

On macOS, you can use homebrew: ```brew install icarus-verilog```

On Windows, the easiest way to install Icarus Verilog is using a pre-built installer, like those available here: https://bleyer.org/icarus/.

### Verilator

On Linux, you can install Verilator using your package manager: eg. ```apt install verilator```

On macOS, you can use homebrew: ```brew install verilator```

On Windows, you can obtain Verilator through [MSYS2](https://www.msys2.org/), or compile it from source using MinGW or Cygwin. See https://www.veripool.org/projects/verilator/wiki/Installing for details. Instructions for compiling Verilator from source with Cygwin are also included with this package in [verilator-install-windows.md](https://github.com/a2k-hanlon/linter-systemverilog/blob/master/verilator-install-windows.md)

Note that GTKWave is not necessary for linting. This applies to both compilers.


## Package Installation and Setup

1. Install this package through the "Install" tab in Atom's settings, or run ```apm install linter-systemverilog```.
2. Open the settings for this package through Atom's settings. Choose which compiler to use, and specify the path to either compiler's executable if necessary. For example, with Verilator on Windows you may need to enter ```C:\verilator\bin\verilator_bin.exe``` for "Verilator Executable".
3. If you wish, you can modify the command arguments to iverilog or verilator by entering options as a comma-separated list.

### Linting SystemVerilog with Icarus Verilog

Icarus Verilog does not completely support SystemVerilog, but for linting this compiler may suffice. Most likely, you will want to add the ```-g2012``` option to iverilog in the package settings if linting SystemVerilog.

### Other Notes

- Be aware that Verilator seems to struggle with spaces in filepaths, at least on Windows.
- See https://iverilog.fandom.com/wiki/Iverilog_Flags for iverilog options
- See https://www.veripool.org/projects/verilator/wiki/Manual-verilator for verilator options


## Acknowledgments

This package is based on the [linter-verilog](https://github.com/manucorporat/linter-verilog) and [linter-verilator](https://github.com/patstew/linter-verilator) packages for Atom, along with a few of their forks. Thanks to the authors of these packages!
