#!/bin/bash

main()
{
readarray -t pids < ./pids
programGuiID=${pids[0]}
serverID=${pids[1]}

    kill $programGuiID $serverID ;
    echo "" > ./pids
}
main
