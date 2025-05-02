#!/bin/bash

# Ghost's Matrix Loader — Kentucky Blue Edition 💙

clear

# Infinite Matrix Code in Blue
while true
do
    echo -e "\e[38;5;33m$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | fold -w 80 | head -n 1)\e[0m"
    sleep 0.03
done
