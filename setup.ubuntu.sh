#!/bin/bash
set -Ceu
pwd

echo "apt-get update？ [Y/n]"
read ANSWER
case $ANSWER in
    "" | "Y" | "y" | "yes" | "Yes" | "YES" )sudo apt-get -y update&&sudo apt-get -y upgrade;;
    * ) echo "OK! Continue without apt-get update" ;;
esac
sudo apt-get install -y git vim nautilus-open-terminal openssh-server conky-all python tmux
sudo vim /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart
#PermitRootLogin no
#
env LANGUAGE=C LC_MESSAGES=C xdg-user-dirs-gtk-update

if [ ! -e ~/dotfiles ]; then
    git clone https://github.com/takata150802/dotfiles.git ~/dotfiles
fi
chmod +x ~/dotfiles/create_link.sh
~/dotfiles/create_link.sh
killall conky && true
conky 1>/dev/null 2>&1 &


echo "Do you edit your global git config? [Y/n]"
read ANSWER
case $ANSWER in
    "" | "Y" | "y" | "yes" | "Yes" | "YES" ) \
        echo '$ git config --global user.email "you@example.com". enter use.email:' && \
        read ANSWER && \
        git config --global user.email $ANSWER && \
        echo '$ git config --global user.name "Your Name". enter use.name:' && \
        read ANSWER && \
        git config --global user.name $ANSWER ;;
    * ) echo "OK! Continue without global git config" ;;
esac

sudo apt-get install -y chromium-browser
sudo add-apt-repository -y ppa:webupd8team/atom
sudo apt-get -y update
sudo apt-get install -y atom

if [ ! -e ~/.pyenv ]; then
    git clone https://github.com/yyuu/pyenv.git ~/.pyenv
fi

echo 'export PYENV_ROOT=$HOME/.pyenv' >> ~/.bashrc
echo 'export PATH=$PYENV_ROOT/bin:$PATH' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.bashrc
echo  $PATH
. ~/.bashrc
echo  $PATH
exit
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev
sudo apt-get install -y libfreetype6-dev libblas-dev liblapack-dev gfortran tk-dev libhdf5-dev python-dev
pyenv install 2.7.9
pyenv rehash
pyenv global  2.7.9
#ubuntu 14.0.4の.vhdにはpython 2.7.6が入っているがpipは使えない
#python get-pip.py --user#2.7.9にはpipがデフォルトで入っている
pip install -U pip
pip install --user -U setuptools
pip install --user numpy six
pip install --user scipy
pip install --user ipython
pip install --user scikit-image
pip install --user matplotlib
pip install --user scikit-learn pandas h5py
pip install --user chainer 
pip install --user spyder
echo 'Sus!'
