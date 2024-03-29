<img src="https://github.com/OakNinja/MakeMeFish/raw/master/docs/logo.png" width="350" title="MakeMeFish Logo">

[![Demo](https://github.com/OakNinja/MakeMeFish/raw/master/docs/mm.gif)](https://github.com/OakNinja/MakeMeFish/raw/master/docs/mm.gif)

MakeMeFish simplifies the usage of Makefiles by providing quick navigation and searching through make targets.

## Features

- **Type ahead searching** - just write a few characters to filter out the targets you are looking for
- **Preview** - When selecting a target, an excerpt of the target will be shown in the makefile, with match highlighting
- **Snappy** - fzf-ingly fast!

## Prerequisities

- Fish shell 3+
- fzf https://github.com/junegunn/fzf#installation

Don't use fish? Get in touch if you want MakeMe support in your shell.

## Install using omf

`omf install makeme`

## Install using fisher

`fisher install oakninja/MakeMeFish`

or

`fisher install oakninja/MakeMeFish@next-release`

to get the latest version.

it's also possible to get the previous version by running

`fisher install oakninja/MakeMeFish@previous-version`

## Install manually

Download and copy `mm.fish` to `~/.config/fish/functions`

or run

`curl https://raw.githubusercontent.com/OakNinja/MakeMeFish/master/mm.fish?nocache --create-dirs -sLo ~/.config/fish/functions/mm.fish`

## Usage

_Basic usage:_
type `mm`, if there is a Makefile in the current working directory, all targets will be listed. Start typing to filter targets.

_Parameters:_

- `-h` or `--help` to print the help.
- `-f <filename>` to specify a makefile if you have several in the cwd, or if you have a non-standard name.
- `-i` to start MakeMefish in interactive mode. In interactive mode, the selected target will be executed and you will then be returned to the selection prompt. Please note that executed commands won't be added to your command history.
- `<foo>` eg. add an arbitrary keyword to start MakeMeFish with a pre-populated query (editable at runtime)

## Examples

`mm build` will start `MakeMeFish` with an initial query which will filter for targets containing the substring `build`.
Similarly, `mm foo bar` will filter on targets containing both `foo` and `bar`

---

`mm -f MyFancyMakeFile` will start `MakeMeFish` and parse the file `MyFancyMakeFile` instead of trying to find a makefile with a GNU make standard name.

---

`mm -i` will run `MakeMeFish` in interactive mode

---

_All flags and parameters can be combined, and added in any order, eg._

`mm foo -i -f MyFancyMakeFile` is equivalent to `mm -f MyFancyMakeFile foo -i`
