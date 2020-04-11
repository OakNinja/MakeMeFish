function mm -a 'filename' --description "MakeMeFish - List all Make targets in the Makefile of the current directory"

    # If no filename is provided, Makefile is used
    function __get_filename -a filename  
        if not set -q filename[1]
            set makefile_name 'Makefile' 
        else
            set makefile_name $filename
        end
        echo $makefile_name
    end

    # Get maketargets from provided filename
    function __get_targets -a filename
        set target_pattern '^([a-zA-Z0-9][^\$#\/\t=]+?):[^$#\/\t=]*$'  # This is the pattern for matching make targets
        set targets  # This is where we keep our targets
        for row in (cat $filename)  # Loop over all rows in the Makefile
            set target (string match -r $target_pattern $row)  # Do a regex match for the pattern on the row
            if test $status -eq 0  # This row contained a target
                set targets $targets "$target[2]"  # Append the target to targets list, indexes is 1-based, so group 2 is [2]
            end
        end
        for target in $targets  # Loop over all targets and echo them on separate rows
            echo $target
        end
    end

    # Run MakeMeFish
    function run -a filename
        if test -f $filename
            set targets __get_targets $filename # Get all targets
            $targets | eval (__fzfcmd) | read -lz result  # Get targets, pip them to fzf, put the chosen command in a variable called result
            set result (string trim -- $result)  # Trim newlines and whitespace from the command
            and commandline -- "make $result"  # Append the make keyword
            commandline -f repaint  # Repaint command line
        else 
            echo "No file named $filename found."
        end
    end

    run (__get_filename $filename) # Execute
end
