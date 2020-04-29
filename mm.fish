function mm -a 'filename' --description "MakeMeFish - List all Make targets in the Makefile of the current directory"
    
    function __mm_get_makefile_name -a 'filename'
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
    function __mm_parse_makefile -a 'filename'
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

    function __mm_get_targets -a 'filename'
        set static_targets
        set generated_targets 
        set parsed_makefile (__mm_parse_makefile $filename | sort -f) 
        for row in $parsed_makefile  # Loop over all rows in the Makefile
            if test -n "$row"
                set found_in_file (grep "$row:" $filename)
                if test -n "$found_in_file"
                    if test -n "$static_targets"
                        set static_targets "$static_targets\0$row"  # Append the target to targets list
                    else
                        set static_targets "$row"
                    end
                else
                    if test -n "$generated_targets"
                        set generated_targets "$generated_targets\0$row"  # Append the target to targets list
                    else
                        set generated_targets "$row"
                    end
                end
            end
        end
        set output
        if test -n "$static_targets"
            set output "$static_targets"
        end
        if test -n "$generated_targets"
            if test -n "$output"
                set output "$output\0$generated_targets"
            else
                set output "$generated_targets"
            end
        end
        echo "$output"
    end

    function __mm_fzf_command -a 'filename'
        set -q FZF_TMUX; or set FZF_TMUX 0
        set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 60%
        if [ $FZF_TMUX -eq 1 ]
            echo "fzf-tmux --read0 -d$FZF_TMUX_HEIGHT --layout=reverse --border --preview='grep -A 10 -B 1 \^{}: $filename'"
        else
            echo "fzf --read0 --height 60% --layout=reverse --border --preview='grep --color=always -A 10 -B 1 \^{}: $filename; or echo -GENERATED TARGET-'"
        end
    end

    function __mm_run -a 'filename'
        set custom_filename $filename
        set filename (__mm_get_makefile_name $filename)
        if test -z "$filename"
            echo 'No makefile found in the current working directory'
        else
            set targets (string split " " -- (__mm_get_targets $filename))
            if test -n "$targets"
                if test -n "$custom_filename"
                    set make_command "make -f $filename"
                else
                    set make_command "make"
                end
                printf $targets | eval (__mm_fzf_command $filename) | read -lz result  # print targets as a list, pipe them to fzf, put the chosen command in $result
                set result (string trim -- $result)  # Trim newlines and whitespace from the command
                and commandline -- "$make_command $result"  # Prepend the make command
                commandline -f repaint  # Repaint command line
            else
                echo "No targets found in $filename"
            end
        end
    end

    __mm_run $filename
end
