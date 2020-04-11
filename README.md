# MakeMeFish
## Easing the usage of makefiles
MakeMeFish simplifies the usage of Makefiles by providing quick navigation and searching.

If you don't use fish, MakeMeFish is available as a python package. See [MakeMe](https://github.com/OakNinja/MakeMe/)

## Prerequisities
* Fish shell
* fzf https://github.com/junegunn/fzf#installation
* fisher https://github.com/jorgebucaran/fisher

## Install 
**Note: This will also install jethrokuan/fzf if not already installed**

`fisher add oakninja/MakeMeFish`

## Usage
type `mm`, if there is a Makefile in the current working directory, all targets will be listed. Start typing to filter targets.
If you want to specify a Makefile name:
type `mm <filename>`

