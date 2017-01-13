#!/usr/bin/env bash
sudo rm .bash_history
sudo apt-get update
sudo apt-get upgrade

sudo apt install bc
sudo apt-get install unzip
pip install kaggle-cli

cd ~
git clone https://github.com/TomLous/fastai-courses.git
ln -s ~/fastai-courses/deeplearning1/nbs/ nbs/deeplearning1
mkdir ~/nbs/data
cd ~/nbs/data
wget http://www.platform.ai/data/dogscats.zip
unzip -q dogscats.zip

read -p "Kaggle Username? " -n 1 -r
echo    # (optional) move to a new line
KGU=$REPLY


read -p "Kaggle Pass? " -n 1 -r
echo    # (optional) move to a new line
KGP=$REPLY

kg config -g -u $KGU -p $KGP -c dogs-vs-cats-redux-kernels-edition

read -p "Reboot? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo reboot now
    exit 1 || return 1
fi






#Checks
nvidia-smi
jupyter notebook