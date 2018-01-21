#!/bin/bash
set -o errexit
pwd

echo "apt-get update？ [Y/n]"
read ANSWER
case $ANSWER in
    "" | "Y" | "y" | "yes" | "Yes" | "YES" )sudo apt-get update&&sudo apt-get upgrade;;
    * ) echo "OK! Continue without apt-get update" ;;
esac
sudo apt-get install git vim nautilus-open-terminal openssh-server conky-all python tmux
sudo apt-get install python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose
sudo vim /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart
#PermitRootLogin no
#
env LANGUAGE=C LC_MESSAGES=C xdg-user-dirs-gtk-update

git clone https://github.com/takata150802/dotfiles.git ~/dotfiles
chmod +x ~/dotfiles/create_link.sh
~/dotfiles/create_link.sh
killall conky; conky 1>/dev/null 2>&1 &

git clone git://github.com/yyuu/pyenv.git ~/.pyenv
git clone git://github.com/yyuu/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT=$HOME/.pyenv' >> ~/.bashrc
echo 'export PATH=$PYENV_ROOT/bin:$PATH' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.bashrc
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
pip install --user scikit-learn pandas h5py pylab
pip install --user chainer 
pip install --user spyder
echo 'Sus!'
