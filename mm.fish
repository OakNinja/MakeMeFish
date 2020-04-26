function mm -a 'filename' --description "MakeMeFish - List all Make targets in the Makefile of the current directory"
    
    function __get_makefile_name -a 'filename'
        if test -n "$filename"
            set makefile_filenames $filename
        else 
            set makefile_filenames 'GNUmakefile' 'makefile' 'Makefile'
        end
        for filename in $makefile_filenames 
            if test -f $filename
                echo $filename
                break
            end
        end
    end
    function __get_targets -a 'filename'
        set target_pattern '^([a-zA-Z0-9][^\$#\/\t=]+?):[^$#\/\t=]*$'  # This is the pattern for matching make targets
        set targets  # This is where we keep our targets
        for row in (cat $filename)  # Loop over all rows in the Makefile
            set target (string match -r -- $target_pattern $row)  # Do a regex match for the pattern on the row
            if test $status -eq 0  # This row contained a target
                set targets $targets (string trim -- $target[2])  # Append the target to targets list, indexes is 1-based, so group 2 is [2]
            end
        end
        echo $targets
    end

    # Copied from https://github.com/jethrokuan/fzf/blob/master/functions/__fzfcmd.fish
    function __fzf_command -a 'filename'
        set -q FZF_TMUX; or set FZF_TMUX 0
        set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 60%
        if [ $FZF_TMUX -eq 1 ]
            echo "fzf-tmux -d$FZF_TMUX_HEIGHT --layout=reverse --border --preview='grep -A 10 -B 1 \^{}: $filename'"
        else
            echo "fzf --height 60% --layout=reverse --border --preview='grep --color=always -A 10 -B 1 \^{}: $filename'"
        end
    end

    function run -a 'filename'
        set custom_filename $filename
        set filename (__get_makefile_name $filename)
        if test -z "$filename"
            echo 'No makefile found in the current working directory'
        else
            set targets (string split " " -- (__get_targets $filename))
            if test -n "$targets[1]"
                if test -n "$custom_filename"
                    set make_command "make -f $filename"
                else
                    set make_command "make"
                end
                printf "%s\n" $targets | eval (__fzf_command $filename) | read -lz result  # print targets as a list, pipe them to fzf, put the chosen command in a variable called result
                set result (string trim -- $result)  # Trim newlines and whitespace from the command
                and commandline -- "$make_command $result"  # Prepend the make keyword
                commandline -f repaint  # Repaint command line
            else
                echo "No targets found in $filename"
            end
        end
    end
    run $filename
end
