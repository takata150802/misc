#!/bin/bash
set -Ceux
pwd

: 'flush stderr' ; stdbuf --error=0 printf '' >&2
echo "apt update？ [Y/n]"
read ANSWER
case $ANSWER in
    "" | "Y" | "y" | "yes" | "Yes" | "YES" )sudo apt -y update&&sudo apt -y upgrade;;
    * ) echo "OK! Continue without apt update" ;;
esac
sudo apt install -y git vim openssh-server conky-all python tmux
sudo vim /etc/ssh/sshd_config
sudo systemctl start ssh 
#PermitRootLogin no
#
env LANGUAGE=C LC_MESSAGES=C xdg-user-dirs-gtk-update

if [ ! -e ~/dotfiles ]; then
    git clone https://github.com/takata150802/dotfiles.git ~/dotfiles
fi
chmod +x ~/dotfiles/create_link.sh
~/dotfiles/create_link.sh

: 'flush stderr' ; stdbuf --error=0 printf '' >&2
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

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb

wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo apt-get -y update
sudo apt-get install -y typora

if [ ! -e ~/.pyenv ]; then
    git clone https://github.com/yyuu/pyenv.git ~/.pyenv
fi

echo 'export PYENV_ROOT=$HOME/.pyenv' >> ~/.bashrc
echo 'export PATH=$PYENV_ROOT/bin:$PATH' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev
sudo apt install -y libfreetype6-dev libblas-dev liblapack-dev gfortran tk-dev libhdf5-dev python-dev
pyenv install 3.9.0
pyenv rehash
pyenv global  3.9.0
pip install -U pip
# pip install --user -U setuptools
# pip install --user numpy six
# pip install --user scipy
# pip install --user ipython
# pip install --user scikit-image
# pip install --user matplotlib
# pip install --user scikit-learn pandas h5py
# pip install --user chainer 
# pip install --user spyder

# Docker
sudo apt-get -y install \
         apt-transport-https \
         ca-certificates \
         curl \
         gnupg \
         lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
         "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
         $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/nullecho \
         "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
         $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
sudo docker run hello-world
