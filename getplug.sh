curl -fLo ./autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 

YUM='command -v yum'
APT='command -v apt-get'

if [[ -z $YUM ]]; then
    sudo yum install universal-ctags	
    sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
    sudo yum install ripgrep 
    sudo yum install global
    sudo yum install tmux-plugin-manager
elif [[ -z $APT ]]; then
    sudo apt-get install universal-ctags
    sudo apt-get install ripgrep
    sudo apt-get install global
    sudo apt-get install tmux-plugin-manager
fi


