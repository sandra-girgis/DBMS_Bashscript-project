#!/bin/bash
mkdir DB 2>> ./.wornning.log
cd DB
echo "Welcome To our database :)"
let flag2=0
select choice in "create-db" "list-db" "connect-db" "delete-db" "exit"
do
case $choice in
    create-db )
        echo enter your database name
        read namedb
        let flag=0
        for i in `ls`
        do
            if [ $namedb = $i ]
            then
                echo $namedb is already exist
                flag=1
            fi
            if [ $flag -eq 1 ]
            then
                break
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
                if [ $data = $i ]
                then
                    cd $data
                    echo you now in your $data
                    flag=1
                fi
                if [ $flag -eq 1 ]
                then
                    flag2=1
                    break
                    # exit
                fi
            done
            if [ $flag -eq 0 ]
            then 
                echo $data not exist so choise 1 to create your data base
            fi
            if [ $flag2 -eq 1 ]
            then
                break
                #exit
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
            if [ $data = $i ]
            then
                rm -ir $data
                echo your $data is deleted
                flag=1
            fi
            if [ $flag -eq 1 ]
            then
                break
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
if [ $flag2 -eq 1 ]
then
    select choice in "create-table" "list-table" "drop-table" "select-from-table" "insert-in-table" "delete-from-table"
    do
    case $choice in
        create-table )
            echo ENTER your table name 
            read tablename
            let flag=0
            for i in `ls`
            do
                if [ $tablename = $i ]
                then
                    echo $tablename is already exist
                    flag=1
                fi
                if [ $flag -eq 1 ]
                then
                    break
                fi
            done
            if [ $flag -eq 0 ]
            then
                echo -e "Number of Columns: \c"
                read colsNum
                counter=1
                sep="|"
                rSep="\n"
                pKey=""
                metaData="Field"$sep"Type"$sep
                while [ $counter -le $colsNum ]
                do
                    if [ $counter -eq 1 ]
                    then
                        echo -e "Enter your primary key Name: \c"
                        read colName
                    else
                        echo -e "Name of Column No.$counter: \c"
                        read colName
                    fi
                    echo -e "Type of Column $colName: "
                    select var in "int" "varchar"
                    do
                    case $var in
                        int )
                            colType="int";break;;
                        varchar )
                            colType="varchar";break;;
                        * )
                            echo "Wrong Choice" ;;
                    esac
                    done
                    metaData+=$rSep$colName$sep$colType$sep""
                    if [[ $counter == $colsNum ]]; then
                    temp=$temp$colName
                    else
                    temp=$temp$colName$sep
                    fi
                    ((counter++))
                done
                touch .$tablename
                echo -e $metaData  >> .$tablename
                touch $tablename
                echo -e $temp >> $tablename
                if [[ $? == 0 ]]
                then
                    echo "Table Created Successfully"
                else
                    echo "Error Creating Table $tablename"
                fi
            fi
            ;;
        list-table )
            if [ `ls | wc -l` -eq 0 ]
            then
                echo list is empty
            else
                ls
            fi
        ;;
        drop-table )
            if [ `ls | wc -l` -eq 0 ]
            then
                echo there is no data base so choise 1 to create your Table
            else
                echo ENTER YOUR NAME OF Table
                read data
                let flag=0
            for i in `ls`
            do
                if [ $data = $i ]
                then
                    rm $data
                    rm .$data
                    echo your $data Table is deleted
                    flag=1
                fi
                if [ $flag -eq 1 ]
                then
                    break
                fi
            done
                if [ $flag -eq 0 ]
                then 
                    echo $data not exist 
                fi
            fi
        ;;
        select-from-table ) ;;
        insert-in-table ) ;;
        delete-from-table ) ;;
        exit ) exit ;;
        *) exit ;;
    esac
    done
fi