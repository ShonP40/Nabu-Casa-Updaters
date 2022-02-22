#!/bin/bash

# Author: https://github.com/ShonP40
# Repository: https://github.com/ShonP40/Nabu-Casa-Updaters
# Date: 2022-02-22

printf "\nWelcome to the Home Assistant Container Updater!\n\n"

if [[ ! -f docker-compose.yml ]]
then
    printf "docker-compose.yml not found!\n\n"
    printf "Please run this updater in the same directory as your docker-compose file!\n\n"
    exit
fi

newestVer=$(curl --silent "https://api.github.com/repos/home-assistant/core/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')

if [[ -f config/.HA_VERSION ]]
then
    currentVer=$(cat config/.HA_VERSION)

    if [[ $currentVer == $newestVer ]]
    then
        printf "You're already running the latest version of Home Assistant ($currentVer)\n\n"
        exit
    else
        printf "Your current Home Assistant version is: $currentVer\n\n"
    fi
else
    printf "Couldn't determine your current Home Assistant version!\n\n"
    printf "Make sure that you're running this updater in the directory before your Home Assistant config directory\n\n"
fi
printf "The latest Home Assistant release is: $newestVer\n\n"

printf "Would you like to update Home Assistant (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ]
then
    printf " "
    docker-compose pull

    printf " "
    docker-compose down

    printf " "
    docker-compose up --detach

    printf "\n\nHome Assistant has been updated and restarted successfully!\n\n"
    printf "You may now delete your old Home Assistant image safely\n\n"
else
    printf "Home Assistant won't be updated!\n\n"
fi