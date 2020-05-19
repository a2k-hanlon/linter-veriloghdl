# linter-verilog

Atom linter for Verilog, using [Icarus Verilog](http://iverilog.icarus.com).  

![Screenshot](https://raw.githubusercontent.com/manucorporat/linter-verilog/master/screenshot.png)


## Installation

1. [Install icarus verilog](https://bleyer.org/icarus/). 
On OSX you can just use **brew**:  

 ```
$ brew install icarus-verilog
```

2. Install atom package:  

 ```
$ apm install linter-verilog
```

## Notes on installation

- GTKWave is not necessary for linting. 
- I did install MinGW dependencies
- I did not create a desktop shortcut.

If cloning this fork of the original package instead of using the atom package manager ```apm``` to get the original as above, do the following:

1. Clone this repository into the ~/.atom/packages/ directory
2. In a terminal, navigate to the  ~/.atom/packages/linter-verilog directory and run ```apm install``` to install some of the dependencies
3. Restart Atom