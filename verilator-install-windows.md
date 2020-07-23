# Installing Verilator on Windows

Author: Andrew Hanlon

Creation Date: 2020/07/21

**Using MSYS2 is probably the easiest way to get a recent version of Verilator up and running on Windows. However, if you would like greater control of your Verilator installation, you can follow the instructions to install it under Cygwin.**

## Installing with MSYS2

[According to Patrick Stewart](https://www.veripool.org/boards/2/topics/1892-Verilator-Dose-verilator-can-run-in-windows-?r=2118-Verilator-RE-Dose-verilator-can-run-in-windows-#message-2118).

1. Install MSYS2 according to the instructions on [its website](https://www.msys2.org/).

2. Install Verilator with MSYS2 by running ```pacman -S mingw-w64-x86_64-verilator``` in the MSYS2  terminal.

That's it! Verilator should now be ready to use. Note that you may want to add Verilator to your PATH environment variable, if this fits your needs.

### Updating

To update MSYS2 and Verilator, run ```pacman -Syu``` in the MSYS2 terminal. This will update everything under MSYS2. To update just Verilator, the command is the same as installing - ```pacman -S mingw-w64-x86_64-verilator```.

## Installing with Cygwin

Note: These instructions assume Git is set up and installed.

### Part 1 - Install Cygwin and Verilator's Dependencies

1. Download the Cygwin installer "setup-x86_64.exe" from https://www.cygwin.com/. Make sure you keep this program, as it is used to **update** as well as install Cygwin and the programs installed under it.

2. I installed cygwin to ```C:\cygwin64```, with ```C:\cygwin64``` as the "Local Package Directory." Afterwards, I moved "setup-x86_64.exe" to ```C:\cygwin64``` as well, to keep all of Cygwin's stuff in one place.

3. Add ```C:\cygwin64\bin``` to the Windows PATH veriable. The fastest way to get to the PATH settings is by typing "path" into the Windows search tool and selecting "Edit the system environment variables." In the window that comes up, click the "Environament Variables" button near the bottom. From the list in the next popup window, select "PATH" and click "Edit". Here, you can add an entry to the PATH.

The following instructions follow [Verilator's installation instructions](https://www.veripool.org/projects/verilator/wiki/Installing):

4. Having installed base cygwin, run Cygwin's "setup-x86_64.exe" program again to download Verilator's dependencies. That meant ensuring the latest (non-test) version of each of the following programs are installed:
    - perl
    - python3
    - make
    - gcc-g++
    - autoconf
    - flex
    - bison

### Part 2 - Get the Verilator Source

1. Clone verilator into your location of choice with ```git clone https://github.com/verilator/verilator```. I cloned it to ```C:\```, giving me the source in ```C:\verilator\```

2. In the cygwin terminal, run ```cd /cygdrive/c/verilator``` or wherever you cloned the verilator repository

3. Run ```git pull```

4. Checkout the "stable" branch of verilator by running ```git checkout stable```

### Part 3 - Set up Verilator

1. Run ```autoconf```

2. From here, we follow the recommended "Run-in-Place from VERILATOR_ROOT" style of Verilator setup. Run ```export VERILATOR_ROOT=`pwd` ```. Note the use of backticks around ```pwd```, not single quotes!

3. Run ```make -j```. This will compile and link Verilator from source. Verilator is a very large C++ program, so this takes time. Prepare to let your computer chug at full steam for some minutes.

4. Run ```make test``` to ensure there were no problems. If things were successful, ```Tests passed!``` should have been printed near the end of the long train of test output.

5. To make things are set up such Cygwin-based programs can be run from PowerShell, a command prompt, or other programs, open powershell and run ```\verilator\bin\verilator_bin.exe -V```. Something like ```Verilator 4.038 2020-07-11 rev v4.038-8-gdd03d0f3``` should be printed immediately. If the command was unsuccessful, or printed nothing, it's likely that something went astray along the way here.

That's it! Verilator should now be ready to use. Note that you may want to add Verilator to your PATH environment variable, if this fits your needs.

### Updating

To update Verilator compiled from source:

1. Run ```git pull```

2. Go through Part 3 of the installation instructions again to recompile the updated source code.
