#!/bin/bash
mkdir db
cd db
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
    list-db ) 
        if [ `ls | wc -l` -eq 0 ]
        then
            echo list is empty
        else
            ls
        fi
        ;;
    connect-db ) 
        if [ `ls | wc -l` -eq 0 ]
        then
            echo there is no data base so choise 1 to create your data base
        else
            echo ENTER YOUR NAME OF DATA BASE
            read data
            let flag=0
            for i in `ls`
            do
                if [ $flag -eq 1 ]
                then
                    exit
                fi
                if [ $data = $i ]
                then
                    cd $data
                    echo you now in your $data
                    flag=1
                fi
            done
                if [ $flag -eq 0 ]
                then 
                    echo $data not exist so choise 1 to create your data base
                fi
        fi
        ;;
    delete-db ) 
        if [ `ls | wc -l` -eq 0 ]
        then
            echo there is no data base so choise 1 to create your data base
        else
            echo ENTER YOUR NAME OF DATA BASE
            read data
            let flag=0
        for i in `ls`
        do
            if [ $flag -eq 1 ]
            then
                break
            fi
            if [ $data = $i ]
            then
                rm -ir $data
                echo your $data is deleted
                flag=1
            fi
        done
            if [ $flag -eq 0 ]
            then 
                echo $data not exist 
            fi
        fi
        ;;
    exit ) exit ;;
    *) exit ;;
esac
done