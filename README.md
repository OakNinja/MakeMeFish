# MakeMeFish
## Easing the usage of makefiles
[![Demo](https://github.com/OakNinja/MakeMeFish/raw/master/docs/mmf.gif)](https://github.com/OakNinja/MakeMeFish/raw/master/docs/mmf.gif)

MakeMeFish simplifies the usage of Makefiles by providing quick navigation and searching through make targets.

If you don't use fish, MakeMeFish is available as a python package. 
See [MakeMe](https://github.com/OakNinja/MakeMe/)

## Prerequisities
* Fish shell
* fzf https://github.com/junegunn/fzf#installation
* fisher https://github.com/jorgebucaran/fisher

## Install using fisher
`fisher add oakninja/MakeMeFish`

## Install manually 
Clone this repo `git clone https://github.com/OakNinja/MakeMeFish`
and then copy `mm.fish` to `~/.config/fish/functions` or create a symlink
`ln -s mm.fish ~/.config/fish/functions/mm.fish`

## Usage
type `mm`, if there is a Makefile in the current working directory, all targets will be listed. Start typing to filter targets.

type `mm <filename>` to specify a makefile if you have several in the cwd, or if you have a non-standard name. 

