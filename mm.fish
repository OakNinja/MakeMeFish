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

    # Based on: 
    # https://github.com/fish-shell/fish-shell/blob/8e418f5205106b11f83fa1956076a9b20c56f0f9/share/completions/make.fish 
    # and 
    # https://stackoverflow.com/a/26339924
    function __parse_makefile -a 'filename'
        # Since we filter based on localized text, we need to ensure the
        # text will be using the correct locale.
        set -lx LC_ALL C

        set makeflags -f $filename
        
        if make --version 2>/dev/null | string match -q 'GNU*'
            make $makeflags -pRrq : 2>/dev/null |
            awk -F: '/^# Files/,/^# Finished Make data base/ {
                    if ($1 == "# Not a target") skip = 1;
                    if ($1 !~ "^[#.\t]") { if (!skip) print $1; skip=0 }
                }' 2>/dev/null
        else
            # BSD make
            make $makeflags -d g1 -rn >/dev/null 2>| awk -F, '/^#\*\*\* Input graph:/,/^$/ {if ($1 !~ "^#... ") {gsub(/# /,"",$1); print $1}}' 2>/dev/null
        end
    end

    function __get_targets -a 'filename'
        set targets 
        set parsed_makefile (__parse_makefile $filename) 
        for row in $parsed_makefile  # Loop over all rows in the Makefile
            if test -n "$row"
                set targets $targets (string trim -- $row)  # Append the target to targets list, indexes is 1-based, so group 2 is [2]
            end
        end
        echo $targets
    end

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
            if test -n "$targets"
                if test -n "$custom_filename"
                    set make_command "make -f $filename"
                else
                    set make_command "make"
                end
                printf "%s\n" $targets | eval (__fzf_command $filename) | read -lz result  # print targets as a list, pipe them to fzf, put the chosen command in $result
                set result (string trim -- $result)  # Trim newlines and whitespace from the command
                and commandline -- "$make_command $result"  # Prepend the make command
                commandline -f repaint  # Repaint command line
            else
                echo "No targets found in $filename"
            end
        end
    end

    run $filename
end
