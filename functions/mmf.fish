function mmf
    mm --fish | eval (__fzfcmd) | read -lz result
    set result (string trim -- $result)
    and commandline -- "make $result"
    commandline -f repaint
end