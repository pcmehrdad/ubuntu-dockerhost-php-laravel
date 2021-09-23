#!/bin/sh

# bash dockerhost-portainer-laravel.sh

set -e

# install popular tools
sudo apt --yes install software-properties-common zsh curl make zip unzip git nano aria2 unar htop iotop poppler-utils traceroute nmap net-tools p7zip openssl bzip2 git wget iperf ntp openssh-server fail2ban php-cli

# php-cli full
sudo apt --yes install php-cli php-common php-curl php-json php-opcache php-readline php-fpm php-common php-mysql php-xml php-xmlrpc php-curl php-gd php-imagick php-cli php-dev php-imap php-pdo php-mbstring php-opcache php-soap php-zip php-calendar php-ctype php-exif php-ffi php-fileinfo php-ftp php-iconv php-phar php-posix php-shmop php-sockets php-sysvmsg php-sysvsem php-sysvshm php-tokenizer

# install composer
cd ~
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/bin --filename=composer
rm -f composer-setup.php

# docker + docker-compose
# sudo apt remove docker docker-engine docker.io containerd runc
# sudo apt --yes install apt-transport-https ca-certificates curl gnupg lsb-release
# sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo apt --yes update
# sudo apt --yes install docker-ce docker-ce-cli containerd.io
# sudo groupadd docker
# sudo usermod -aG docker $USER
# sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
# sudo chmod g+rwx "$HOME/.docker" -R
sudo apt --yes install docker.io
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock

#sudo chown $USER:docker ~/.docker
#sudo chown $USER:docker ~/.docker/config.json
#sudo chmod g+rw ~/.docker/config.json

sudo systemctl enable --now docker

COMPOSE_VERSION=$(git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | sort --version-sort | tail -n 1)
sudo curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
# sudo systemctl enable --now docker.service
# sudo systemctl enable --now containerd.service
# portainer
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9999:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce


# ############# Laravel
### global installer
composer global require laravel/installer --update-with-all-dependencies
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
# sudo chown -R $USER:$USER /home/$USER/.config/composer
### sail install alias
echo "alias sail='./vendor/bin/sail'" >> ~/.bash_aliases
source ~/.bash_aliases

rm -f dockerhost-portainer-laravel.sh

# curl -s https://laravel.build/laravel | bash
# cd laravel
# sail up -d

## for problems :
# in .env add these :
# WWWGROUP=1000
# WWWUSER=1000
# OR
# https://tinyurl.com/yzef4gvw
# php artisan storage:link
# sudo chmod -R 777 storage

