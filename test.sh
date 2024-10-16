#!/bin/bash

FILE=OpenAudible_x86_64.deb

[ ! -f $FILE ] && wget https://openaudible.org/latest/OpenAudible_x86_64.deb

# Hard coded version for now.. 
./build_flatpak.sh $FILE




