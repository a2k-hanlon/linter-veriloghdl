# linter-veriloghdl

Atom linter for Verilog/SystemVerilog, using [Icarus Verilog](http://iverilog.icarus.com), [Slang](https://sv-lang.com/), [Verible](https://google.github.io/verible), or [Verilator](https://www.veripool.org/wiki/verilator).  

![Screenshot showing example of use with Verilator](https://raw.githubusercontent.com/a2k-hanlon/linter-veriloghdl/master/example.png)

## Package Installation and Setup

1. Ensure you have one of the supported Verilog/SystemVerilog compilers installed and working. If you do not yet have one installed, see the information in [Compiler Installation](#compiler-installation).
2. Install this package through the "Install" tab in Atom's settings, or run ```apm install linter-veriloghdl```.
3. Open the settings for this package through Atom's settings. Choose which compiler to use, and specify the path to the compiler's executable if necessary. For example, with Verilator on Windows (obtained through MSYS2) you may need to enter ```C:\msys64\mingw64\bin\verilator_bin.exe``` for "Verilator Executable".
4. If you wish, you can modify the command arguments to any of the compilers by entering options as a comma-separated list.

### Linting SystemVerilog with Icarus Verilog

Icarus Verilog does support as much of SystemVerilog as the other tools, but for linting this compiler may suffice. Most likely, you will want to add the ```-g2012``` option to iverilog in the package settings if linting SystemVerilog.

### Other Notes

- The parent directory of the file being linted is automatically added as an include directory argument to iverilog, slang and verilator.
- Be aware that Verilator seems to struggle with spaces in filepaths, at least on Windows
- See https://iverilog.fandom.com/wiki/Iverilog_Flags for iverilog options
- See https://sv-lang.com/command-line-ref.html for slang options
- See https://google.github.io/verible/verilog_lint.html for verible options
- See https://www.veripool.org/projects/verilator/wiki/Manual-verilator for verilator options

## Compiler Installation

### Icarus Verilog (iverilog)

On Linux, you can install it using your package manager: eg. ```apt install iverilog```

On macOS, you can use homebrew: ```brew install icarus-verilog```

On Windows, the easiest way to install Icarus Verilog is using a pre-built installer, like those available here: https://bleyer.org/icarus/.

### Slang

On Linux, you can download a binary from https://github.com/MikePopoloski/slang/releases/latest

On macOS, compiling from source is necessary. Slang has no provided binary for macOS. Instructions for compiling slang from source can be found at https://sv-lang.com/building.html

On Windows, you can download a binary from https://github.com/MikePopoloski/slang/releases/latest (this is the same place as for Linux binaries).

### Verible

On Linux, you can download a binary from https://github.com/google/verible/releases/latest

On macOS or Windows, you can try compiling from source. See https://github.com/google/verible

### Verilator

On Linux, you can install Verilator using your package manager: eg. ```apt install verilator```

On macOS, you can use homebrew: ```brew install verilator```

On Windows, you can obtain Verilator through [MSYS2](https://www.msys2.org/), or compile it from source using MinGW or Cygwin. Instructions for installing Verilator on Windows are included with this package in [verilator-install-windows.md](https://github.com/a2k-hanlon/linter-veriloghdl/blob/master/verilator-install-windows.md). There are instructions for installation with MSYS2 and for compiling Verilator from source with Cygwin.

Note that GTKWave is not necessary for linting, even though it may be bundled with intstallers or suggested by documentation for the compilers.

## Acknowledgments

This package is based on the [linter-verilog](https://github.com/manucorporat/linter-verilog) and [linter-verilator](https://github.com/patstew/linter-verilator) packages for Atom, along with a few of their forks. Thanks to the authors of these packages!
