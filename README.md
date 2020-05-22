# MakeMeFish

## Easing the usage of makefiles

[![Demo](https://github.com/OakNinja/MakeMeFish/raw/master/docs/mm.gif)](https://github.com/OakNinja/MakeMeFish/raw/master/docs/mm.gif)

MakeMeFish simplifies the usage of Makefiles by providing quick navigation and searching through make targets.

## Features

- **Type ahead searching** - just write a few characters to filter out the targets you are looking for
- **Preview** - When selecting a target, an excerpt of the target will be shown in the makefile, with match highlighting
- **Snappy** - fzf-ingly fast!

If you don't use fish, MakeMeFish is available as a python package.
See [MakeMe](https://github.com/OakNinja/MakeMe/)

## Prerequisities

- Fish shell
- fzf https://github.com/junegunn/fzf#installation

## Install using fisher

`fisher add oakninja/MakeMeFish`

or

`fisher add oakninja/MakeMeFish@next-release`

to get the latest version.

it's also possible to get the previous version by running

`fisher add oakninja/MakeMeFish@previous-version`

## Install manually

Clone this repo `git clone https://github.com/OakNinja/MakeMeFish`

and then copy `mm.fish` to `~/.config/fish/functions`

or create a symlink `ln -s mm.fish ~/.config/fish/functions/mm.fish`

## Usage

_Basic usage:_
type `mm`, if there is a Makefile in the current working directory, all targets will be listed. Start typing to filter targets.

_Parameters:_

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
