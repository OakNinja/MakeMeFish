function mm --description "MakeMeFish - List all Make targets in the Makefile of the current directory"
   

    function __find_makefile  # Looks for a makefile in the priority order defined by GNU Make

        set makefile
        if test -f 'GNUmakefile'
            set makefile 'GNUmakefile'
        else if test -f 'makefile'
            set makefile 'makefile'
        else if test -f 'Makefile'
            set makefile 'Makefile'
        end
        if test -z $makefile  # Check that makefile variable has a value
            echo "No makefile found" 1>&2 # writes to stdout
            return 1
        end
        if test ! -s $makefile
            echo "No targets found in $makefile" 1>&2 # writes to stdout
            return 1
        end
        echo $makefile
    end

    # Get maketargets
    function __get_targets -a 'makefile'
        set target_pattern '^([a-zA-Z0-9][^\$#\/\t=]+?):[^$#\/\t=]*$'  # This is the pattern for matching make targets
        set targets  # This is where we keep our targets
        for row in (cat $makefile)  # Loop over all rows in the Makefile
            set target (string match -r $target_pattern -- $row)  # Do a regex match for the pattern on the row       
            if test $status -eq 0  # This row contained a target
                set targets $targets (string trim -- $target[2])  # Append the target to targets list, indexes is 1-based, so group 2 is [2]
            end
        end
        for target in $targets  # Loop over all targets and echo them on separate rows
            echo $target
        end
    end

    # Run MakeMeFish
    function run
        set makefile (__find_makefile)
        if test $status -eq 1  # No makefile found, exit
            return 0 
        end
        __get_targets $makefile | eval (__fzfcmd) | read -lz result  # Get targets, pipe them to fzf, put the chosen command in a variable called result
        set result (string trim -- $result)  # Trim newlines and whitespace from the command
        and commandline -- "make $result"  # Prepend the make keyword
        commandline -f repaint  # Repaint command line
    end

    run  # Execute
end
