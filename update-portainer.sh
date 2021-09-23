#!/bin/sh
clear
main_ip=$(hostname -I | cut -d' ' -f1)
docker rm $(docker stop $(docker ps -a -q --filter="name=portainer" --format="{{.ID}}"))
docker pull portainer/portainer-ce:latest
docker run -d -p 9999:9000 -p 8000:8000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
clear
echo -e "\n=============================================\n====== \e[32mPortainer Successfully Updated!\033[0m ======\n"
echo -e "http://${main_ip}:9999"
echo -e "\n=============================================\n"