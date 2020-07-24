# v1.0.0

First release! The following changes were made to the source material from [linter-verilog](https://github.com/manucorporat/linter-verilog) and [linter-verilator](https://github.com/patstew/linter-verilator):

- Functionality from both source packages combined into one, for support of Icarus Verilog AND Verilator
- Dependencies brought up to date:
    - Code from linter-verilog updated for the [linter v2 API](https://github.com/steelbrain/linter/blob/v2.3.0/docs/guides/upgrading-to-standard-linter-v2.md)
    - [atom-linter](https://github.com/steelbrain/atom-linter) bumped to v10.0.0
    - [atom-package-deps](https://github.com/steelbrain/package-deps/blob/master/package.json) bumped to v6.0.0
- The parent directory of the file being linted is now added as an include path to iverilog, with proper support for errors in files besides the one being edited. This comes in part from [feilongfl's fork](https://github.com/feilongfl/linter-verilog) of linter-verilog
- Improved message positioning, particularly with verilator (which somtimes provides a column number that previously went unused)
- Added "source.systemverilog" grammar scope for compatibility with [language-systemverilog](https://atom.io/packages/language-systemverilog)
- Added a settings option for path to iverilog, like the setting for verilator's path in linter-verilator
- Added functionality for dealing with iverilog "sorry"-type messages:
    - These are now presented with "info" severity
    - Added an option to suppress "sorry" messages, since these aren't really helpful for linting
- Improved documentation, particularly for installing Verilator/Icarus Verilog
- Clarified the arguments that are added to ```iverilog``` or ```verilator``` commands to put either compiler in a mode for linting
