#!/usr/bin/bash

function main() {
    apt list --installed > temp.txt
    echo "aptitude" >> temp.txt                             ## Apend aptitude to list
    lineCount=$(wc -l temp.txt | awk '{printf $1}')         ## Get line count minus one to remove first line
    tail -n$((lineCount - 1)) temp.txt > cleanedList.sh     ## Get all lines but the first
    echo "aptitude markauto ~i \\ " > temp.txt
    awk '{ FS = "/"} NF{printf " !~" $1}' cleanedList.sh >> temp.txt
    rm cleanedList.sh
    mv temp.txt cleanedList.sh
}
main;
