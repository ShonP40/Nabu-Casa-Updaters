#!/bin/bash

# Author: https://github.com/ShonP40
# Repository: https://github.com/ShonP40/Nabu-Casa-Updaters
# Date: 2022-02-22

printf "\nWelcome to the ESPHome Core Updater!\n\n"

currentVer=$(esphome version | grep -Po "(\d+\.)+\d+")

newestVer=$(curl --silent "https://api.github.com/repos/esphome/esphome/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')

if [[ $currentVer == $newestVer ]]
then
    printf "You're already running the latest version of ESPHome ($currentVer)\n\n"
    exit
else
    printf "Your current ESPHome version is: $currentVer\n\n"
fi
printf "The latest ESPHome release is: $newestVer\n\n"

printf "Would you like to update ESPHome (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ]
then
    printf "\n\nUpdating ESPHome\n\n"
    python3 -m pip install --upgrade esphome

    printf "\n\nESPHome has been updated successfully!\n\n"
else
    printf "ESPHome won't be updated!\n\n"
fi