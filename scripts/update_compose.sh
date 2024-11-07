#!/bin/bash
DCV=$(docker compose version)

echo  ""
echo  -e "\e[32;1m Current: $DCV \e[0m"

FILE=docker-compose.yml
if [ -f "$FILE" ]; then
    echo  -e "\e[33;1m   Stopping all containers\e[0m"
    docker compose stop
else 
    echo -e "\e[33;1m   No runing containers detected - $FILE does not exist yet.\e[0m"
fi

echo  -e "\e[33;1m   Removing Docker compose plugin\e[0m"
sudo apt-get remove docker-compose-plugin -y &> /dev/null

echo  -e "\e[33;1m   Installing new Docker compose plugin\e[0m"
sudo apt-get install docker-compose-plugin -y &> /dev/null

FILE=docker-compose.yml
if [ -f "$FILE" ]; then
    echo  -e "\e[33;1m   Starting all container up again\e[0m"
    docker compose up -d
else 
     echo -e "\e[33;1m   No containers to start $FILE does not exist yet.\e[0m"
fi

DCV=$(docker compose version)
echo  -e "\e[32;1m Current: $DCV\e[0m"
echo  ""