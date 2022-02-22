#!/bin/bash

# Author: https://github.com/ShonP40
# Repository: https://github.com/ShonP40/Nabu-Casa-Updaters
# Date: 2022-02-22

printf "\nWelcome to the Home Assistant Core Updater!\n\n"

newestVer=$(curl --silent "https://api.github.com/repos/home-assistant/core/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')

if [[ -f .homeassistant/.HA_VERSION ]]
then
    currentVer=$(cat .homeassistant/.HA_VERSION)

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
    cd "/srv/homeassistant"
    source bin/activate

    printf "\n\nUpdating Home Assistant\n\n"
    python3 -m pip install --upgrade homeassistant

    printf "\n\nRestarting Home Assistant\n\n"
    # Requires a pm2 Home Assistant installation (can be done using: pm2 start /srv/homeassistant/bin/hass --interpreter=/srv/homeassistant/bin/python3.9 -u homeassistant)
    pm2 restart hass

    printf "\n\nHome Assistant has been updated and restarted successfully!\n\n"
else
    printf "Home Assistant won't be updated!\n\n"
fi