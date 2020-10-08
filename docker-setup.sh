#!/bin/bash
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    docker-setup.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: marandre <marandre@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/11/26 17:34:09 by marandre          #+#    #+#              #
#    Updated: 2019/11/26 18:23:25 by marandre         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

grep -qxF 'export DOCKER_TLS_VERIFY=1' ~/.zshrc || echo 'export DOCKER_TLS_VERIFY=1' >> ~/.zshrc
grep -qxF 'export MACHINE_STORAGE_PATH=/Users/$(whoami)/goinfre' ~/.zshrc || echo 'export MACHINE_STORAGE_PATH=/Users/$(whoami)/goinfre' >> ~/.zshrc
grep -qxF 'export DOCKER_CERT_PATH=/Users/$(whoami)/goinfre/certs' ~/.zshrc || echo 'export DOCKER_CERT_PATH=/Users/$(whoami)/goinfre/certs' >> ~/.zshrc
grep -qxF 'export DOCKER_HOST=tcp://$(docker-machine ip default):2376' ~/.zshrc || echo 'export DOCKER_HOST=tcp://$(docker-machine ip default):2376' >> ~/.zshrc
grep -qxF 'eval $(docker-machine env default)' ~/.zshrc || echo 'eval $(docker-machine env default)' >> ~/.zshrc

source ~/.zshrc

mkdir -pv $MACHINE_STORAGE_PATH/cache
if ! [ -f $MACHINE_STORAGE_PATH/cache/boot2docker.iso ]; then
    echo "Downloading the VM system iso..."
    curl -Lo $MACHINE_STORAGE_PATH/cache/boot2docker.iso https://github.com/boot2docker/boot2docker/releases/download/v19.03.5/boot2docker.iso 2> /dev/null 
fi

killall -9 VBoxHeadless
VBoxManage unregistervm --delete default 2> /dev/null 
docker-machine rm default -y

docker-machine create --driver virtualbox default
# Used for first run
eval $(docker-machine env default)
# For testing purpose
docker run hello-world


echo ""

echo -e '\033[0;31m/!\ \033[0mDone, enjoy docker.'
echo -e '\033[0;31m/!\ \033[0mEach time you are going to log out, you will have to run this script again.'
echo -e '\033[0;31m/!\ \033[0mYou \033[0;31mMUST\033[0m close and reopen a new terminal'

for i in 1 2 3 4 5
do
echo "Closing the terminal in $((5-$i+1))s, unless you CTRL-C (not recommended)"
sleep 1
done

kill -9 $PPID