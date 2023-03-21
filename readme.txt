
windows:
    clone to ~/vimfiles/billl-f
    edit $MYVIMRC
        set runtimepath^=C:\users\bfraney\vimfiles\billl-f
        runtime vimrc
    getplug.sh
    :PlugInstall
    manual install executables and add to path
    optionally add personal access token for github push

linux:
    clone to ~/.vim/
    getplug.sh
