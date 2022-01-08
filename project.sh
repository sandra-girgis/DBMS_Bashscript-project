#!/bin/bash

select choice in "create-db" "list-db" "connect-db" "delete-db" "exit"
do
case $choice in
    create-db )
        read namedb
        let flag=0
        for i in `ls`
        do
            if [ $flag -eq 1 ]
            then
                break
            fi
            if [ $namedb = $i ]
            then
                echo $namedb is already exist
                flag=1
            fi
        done
        if [ $flag -eq 0 ]
        then
            mkdir $namedb
            echo $namedb is created
        fi
        ;;
    list-db ) ;;
    connect-db ) ;;
    delete-db )  ;;
    exit ) exit ;;
    *) exit ;;
esac
done