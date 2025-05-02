#!/bin/bash
cols=$(tput cols)
rows=$(tput lines)
let "rows = rows / 2"

tput civis
for i in $(seq 1 $rows); do
  echo -e "\033[34m$(cat /dev/urandom | tr -dc '01' | fold -w $cols | head -n 1)\033[0m"
  sleep 0.03
done
tput cnorm
