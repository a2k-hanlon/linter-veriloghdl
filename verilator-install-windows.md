# Installing Verilator on Windows with Cygwin

Author: Andrew Hanlon

Date: 2020/07/21

Note: These instructions assume Git is set up and installed.

## 1. Install Cygwin and Verilator's Dependencies

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

## 2. Get the Verilator Source

1. Clone verilator into your location of choice with ```git clone https://github.com/verilator/verilator```. I cloned it to ```C:\```, giving me the source in ```C:\verilator\```

2. In the cygwin terminal, run ```cd /cygdrive/c/verilator``` or wherever you cloned the verilator repository

3. Run ```git pull```

4. Checkout the "stable" branch of verilator by running ```git checkout stable```

## 3. Set up Verilator

1. Run ```autoconf```

2. From here, we follow the recommended "Run-in-Place from VERILATOR_ROOT" style of Verilator setup. Run ```export VERILATOR_ROOT=`pwd` ```. Note the use of backticks around ```pwd```, not single quotes!

3. Run ```make -j```. This will compile and link Verilator from source. Verilator is a very large C++ program, so this takes time. Prepare to let your computer chug at full steam for some minutes.

4. Run ```make test``` to ensure there were no problems. If things were successful, ```Tests passed!``` should have been printed near the end of the long train of test output.

5. To make things are set up such Cygwin-based programs can be run from PowerShell, a command prompt, or other programs, open powershell and run ```\verilator\bin\verilator_bin.exe -V```. Something like ```Verilator 4.038 2020-07-11 rev v4.038-8-gdd03d0f3``` should be printed immediately. If the command was unsuccessful, or printed nothing, it's likely that something went astray along the way here.

That's it! Verilator should now be ready to use.
