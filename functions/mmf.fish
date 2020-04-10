function mmf
    mm --fish | eval (__fzfcmd) | read -lz result
    set result (string trim -- $result)
    if [ $result = "No Makefile found... Exit" ] 
        return 0;
    end
    and commandline -- "make $result"
    commandline -f repaint
end