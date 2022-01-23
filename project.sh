#!/bin/bash
# if the db dir already exist don't show an error
# if it isn't exist
# create it
mkdir DB 2>> /dev/null
# enter to the db dir
cd DB
clear
echo "Welcome To our database :)"
# will be use to check for the list is empty or not
let q=0
# first menu work in the db main dir
# you can create / list / connect to / delete spacifice db
function list1() {
    echo CHOOSE FROM DB MENU
    select choice in "create-db" "list-db" "connect-db" "delete-db" "exit"; do
        case $choice in
        create-db)
            clear
            # take db name from user
            echo -e "Enter your database name : \c"
            read dbName
            # db name shouldn't start with numbers
            while ! [[ $dbName =~ ^[a-zA-Z][a-zA-Z0-9]*$ ]]; do
                echo -e "invalid db name !!"
                echo -e "Enter your database name : \c"
                read dbName
            done
            # db flag
            let flag=0
            # list all existed dbs
            # no need to check if it is empty because it won't enter
            # the loop and will create the db
            for i in $(ls); do
                # check if your db exist
                if [ $dbName = $i ]; then
                    # it exists
                    clear
                    echo -e "$dbName table is already exist\n"
                    # make flag = 1
                    # so the db is exist
                    flag=1
                    # so break the 'if' condition
                    break
                fi
            done
            # if flag = 0 so it dosn't exist
            # so you can create it
            if [ $flag -eq 0 ]; then
                clear
                mkdir $dbName
                echo -e "$dbName table is created\n"
            fi
            list1
            ;;
        list-db)
            clear
            showlist
            q=0
            list1
            ;;
        connect-db)
            clear
            showlist
            if [ $q -eq 1 ]; then
                # if the list isn't empty
                echo ENTER YOUR NAME OF DATA BASE
                read dbName
                let flag=0
                for i in $(ls); do
                    # if the db is exist
                    # so enter to your db dir
                    if [ $dbName = $i ]; then
                        clear
                        cd $dbName
                        echo -e "you now in your $dbName\n"
                        list2
                    fi
                done
                # if data base is not exist
                if [ $flag -eq 0 ]; then
                    clear
                    echo -e "$dbName not exist so choise 1 to create your data base\n"
                fi
                q=0
            fi
            list1
            ;;
        delete-db)
            clear
            showlist
            if [ $q -eq 1 ]; then
                echo ENTER YOUR NAME OF DATA BASE
                read dbName
                let flag=0
                # i=items
                for i in $(ls); do
                    if [ $dbName = $i ]; then
                        # if data base is exist remove it
                        rm -ir $dbName
                        clear
                        if [ -d "$dbName" ]; then
                            echo -e "\ndb didn't delete\n"
                        else
                            # The db Deleted Successfully
                            echo -e "your $dbName is Deleted Successfully\n"
                        fi
                        flag=1
                        break
                    fi
                done
                if [ $flag -eq 0 ]; then
                    clear
                    echo -e "$dbName db not exist\n"
                fi
                q=0
            fi
            list1
            ;;
        exit)
            clear
            exit
            ;;
        *)
            clear
            echo WRONG CHOICE !!
            list1
            ;;
        esac
    done
}
function showlist() {
    # list the items in dir then count them
    # if the list is empty
    x=$(ls | wc -l)
    if [ $x -eq 0 ]; then
        # so list is empty
        echo -e "\nthere is no items so choise 1 to create your own\n"
        q=0
    else
        # if the list isn't empty
        # show the list
        echo -e "\n###################"
        echo there is $x item in your list
        echo THE LIST OF YOUR DIR :
        ls
        echo -e "###################\n"
        q=1
    fi
}
# second menu work in your db dir (that you choise)
# you can create / list / drop /  insert into / select from / delete from spacefice table , back to db menu
function list2() {
    echo CHOOSE FROM TABLE MENU
    select choice in "create-table" "list-table" "drop-table" "insert-in-table" "select-from-table" "delete-from-table" "back-to-db-menu" "exit"; do
        case $choice in
        create-table)
            clear
            # take table name from user
            echo -e "Enter your table name : \c"
            read tablename
            # table name shouldn't start with numbers
            while ! [[ $tablename =~ ^[a-zA-Z][a-zA-Z0-9]*$ ]]; do
                echo -e "invalid table name !!"
                echo -e "Enter your table name : \c"
                read tablename
            done
            # table flag
            let flag=0
            # list all existed tables
            # no need to check if it is empty because it won't enter
            # the loop and will create the table
            for i in $(ls); do
                # check if your table exist
                if [ $tablename = $i ]; then
                    # it exists
                    clear
                    echo -e "$tablename table is already exist\n"
                    # make flag = 1
                    # so the table is exist
                    flag=1
                    # so break the 'if' condition
                    break
                fi
            done
            # if table is not exist
            if [ $flag -eq 0 ]; then
                # enter the number of columns in the table
                echo -e "Number of Columns: \c"
                read colsNum
                # check if the user enter a number or something else
                while  [[ ! ( $colsNum =~ ^[0-9]*$ ) || $colsNum = "" ]]; do
                    echo -e "invalid Number !!"
                    echo -e "Number of Columns: \c"
                    read colsNum
                done
                # columns counter
                count=1
                # field seperator
                sep="|"
                # record seperator
                rSep="\n"
                # meta data string
                metaData="Field"$sep"Type"$sep"key"
                #while the counter is less than number of column  that you entered
                while [ $count -le $colsNum ]; do
                    if [[ $count -eq 1 ]]; then
                        echo -e "Enter Name of Your Primary Key Column : \c"
                        read colName
                        # column name shouldn't contain any ting except characters
                        while [[ ! ( $colName =~ ^[a-zA-Z]*$ ) || $colName = "" ]]; do
                            echo -e "invalid column name !!"
                            echo -e "Enter Name of Your Primary Key Column : \c"
                            read colName
                        done
                    else
                        # enter the column name
                        echo -e "Name of Column No.$count: \c"
                        read colName
                        while [[ ! ( $colName =~ ^[a-zA-Z]*$ ) || $colName = "" ]]; do
                            echo -e "invalid column name !!"
                            echo -e "Name of Column No.$count: \c"
                            read colName
                        done
                    fi
                    # choice the column type
                    echo -e "Type of Column $colName: "
                    select var in "int" "varchar"; do
                        case $var in
                        int)
                            colType="int"
                            break
                            ;;
                        varchar)
                            colType="varchar"
                            break
                            ;;
                        *)
                            echo WRONG CHOICE !!
                            ;;
                        esac
                    done
                    # choice if it is a primary key or not
                    if [[ $count -eq 1 ]]; then
                        metaData+=$rSep$colName$sep$colType$sep"PK"
                    else
                        metaData+=$rSep$colName$sep$colType$sep""
                    fi
                    # columns names
                    if [[ $count == $colsNum ]]; then
                        temp=$temp$colName
                    else
                        # when count < colsNum
                        temp=$temp$colName$sep
                    fi
                    ((count++))
                done
                clear
                # create meta data hidden file
                touch .$tablename
                # insert meta data string in meta data file
                echo -e $metaData >>.$tablename
                # create table file
                touch $tablename
                # insert columns names in table file
                echo -e $temp >>$tablename
                if [[ $? == 0 ]]; then
                    # the Table Created Successfully
                    echo -e "Table Created Successfully\n"
                else
                    echo -e "Error Creating Table $tablename\n"
                fi
            fi
            metaData=""
            temp=""
            list2
            ;;
        list-table)
            clear
            showlist
            q=0
            list2
            ;;
        drop-table)
            clear
            showlist
            if [ $q -eq 1 ]; then
                echo ENTER YOUR NAME OF Table
                read data
                #let flag =0 to check if the table is exist
                let flag=0
                for i in $(ls); do
                    if [ $data = $i ]; then
                        # remove table data file
                        rm $data
                        # remove table meta data file
                        rm .$data
                        clear
                        if [ -f "$data" ]; then
                            echo -e "\ntable didn't delete\n"
                        else
                            # The table Deleted Successfully
                            echo -e "your $data is Deleted Successfully\n"
                        fi
                        #the table is exist so let flag=1
                        flag=1
                        break
                    fi
                done
                # if flage=0 (table not exist)
                if [ $flag -eq 0 ]; then
                    clear
                    echo -e "$data table not exist\n"
                fi
                q=0
            fi
            list2
            ;;
        insert-in-table)
            clear
            showlist
            if [ $q -eq 1 ]; then
                echo -e "Table Name: \c"
                read tableName
                # check if your table  not exist by !-f
                if ! [[ -f $tableName ]]; then
                    # it dosn't exist
                    clear
                    echo -e "Table $tableName isn't existed ,choose another Table\n"
                    # back to the menu 2
                    list2
                fi
                # it exists so
                # get the number of columns
                colsNum=$(awk 'END{print NR}' .$tableName)
                sep="|"
                rSep="\n"
                row=""
                for ((i = 2; i <= $colsNum; i++)); do
                    # trace on each record in metadata hidden file
                    colName=$(awk 'BEGIN{FS="|"}{ if(NR=='$i') print $1}' .$tableName)
                    colType=$(awk 'BEGIN{FS="|"}{if(NR=='$i') print $2}' .$tableName)
                    # get record values from user
                    echo -e "$colName ($colType) = \c"
                    read data
                    # is it a primary key ?
                    if [[ $i -eq 2 ]]; then
                        while [[ true ]]; do
                            # if it is a primary key so
                            # check if it is available
                            if [[ $colType == "int" ]]; then
                                while [[ !( $data =~ ^[0-9]*$ ) && $data != "" ]]; do
                                    echo -e "Primary Key can't be empty !!"
                                    echo -e "invalid DataType !!"
                                    echo -e "$colName ($colType) = \c"
                                    read data
                                done
                            fi
                            if [[ $colType == "varchar" ]]; then
                                while [[ !( $data =~ ^[a-zA-Z]*$ ) && $data != "" ]]; do
                                    echo -e "Primary Key can't be empty !!"
                                    echo -e "invalid DataType !!"
                                    echo -e "$colName ($colType) = \c"
                                    read data
                                done
                            fi
                            if [ "$data" = "`awk -F "|" '{ print $1 }' $tableName | grep "^$data$"`" ]; then
                                echo -e "invalid input for Primary Key !!"
                                echo -e "$colName ($colType) = \c"
                                read data
                            else
                                break
                            fi
                        done
                    fi
                    # Validate datatype
                    # is it an integer ?
                    if [[ $i -ne 2 ]]; then
                        if [[ $colType == "int" ]]; then
                            while ! [[ $data =~ ^[0-9]*$ ]]; do
                                echo -e "invalid DataType !!"
                                echo -e "$colName ($colType) = \c"
                                read data
                            done
                        fi
                        # is it a varchar ?
                        if [[ $colType == "varchar" ]]; then
                            while ! [[ $data =~ ^[a-zA-Z]*$ ]]; do
                                echo -e "invalid DataType !!"
                                echo -e "$colName ($colType) = \c"
                                read data
                            done
                        fi
                    fi
                    #Set value in record
                    if [[ $i == $colsNum ]]; then
                        row=$row$data$rSep
                    else
                        row=$row$data$sep
                    fi
                done
                # if all done set full record in the table
                echo -e $row"\c" >>$tableName
                # check if Data Inserted Successfully
                clear
                if [[ $? == 0 ]]; then
                    echo -e "\nData Inserted Successfully\n"
                else
                    echo -e "\nError Inserting Data into Table $tableName\n"
                fi
                q=0
            fi
            row=""
            list2
            ;;
        select-from-table)
            clear
            selectTable
            ;;
        delete-from-table)
            clear
            showlist
            if [ $q -eq 1 ]; then
                echo -e "Enter Table Name: \c"
                read tableName
                # check if your table exist
                if ! [[ -f $tableName ]]; then
                    # it dosn't exist
                    clear
                    echo -e "Table $tableName isn't existed ,choose another Table\n"
                    list2
                fi
                # it exists so
                # which Value do you want to search with
                echo -e "Enter Condition Value: \c"
                read value
                # check if your Value exist
                result=$(awk 'BEGIN{FS="|"}{if ( $1 == "'$value'" ) print $1 }' $tableName 2>>/dev/null)
                # echo $result
                if [[ $result == "" ]]; then
                    # it dosn't exist
                    echo "Value Not Found"
                else
                    # it exists so
                    # get the line number of the value to delete it
                    NR=$(awk 'BEGIN{FS="|"}{if ( $1 == "'$value'" ) print NR}' $tableName 2>>/dev/null)
                    # edit the table and delete the record
                    sed -i ''$NR'd' $tableName 2>>/dev/null
                    # clear
                    if [[ $? == 0 ]]; then
                        # The Row Deleted Successfully
                        echo -e "\nRow Deleted Successfully\n"
                    else
                        echo -e "\nRow didn't delete\n"
                    fi
                fi
                q=0
            fi
            list2
            ;;
        back-to-db-menu)
            clear
            cd ..
            list1
            ;;
        exit)
            clear
            exit
            ;;
        *)
            clear
            echo WRONG CHOICE !!
            list2
            ;;
        esac
    done
}
function selectTable() {
    echo CHOOSE FROM SELECT MENU
    select choice in "select-all" "select-specific-record" "back-to-db-menu" "back-to-table-menu" "exit"; do
        case $choice in
        select-all)
            showlist
            if [ $q -eq 1 ]; then
                echo -e "Enter Table Name: \c"
                read tableName
                if ! [[ -f $tableName ]]; then
                    # it dosn't exist
                    clear
                    echo -e "Table $tableName isn't existed\n"
                    # back to the menu 2
                    selectTable
                fi
                clear
                # display each column in table
                column -t -s '|' $tableName 2>>/dev/null
                if [[ $? != 0 ]]; then
                    echo "Error Displaying Table $tableName"
                fi
                echo -e "\n"
                q=0
            fi
            selectTable
            ;;
        select-specific-record)
            showlist
            if [ $q -eq 1 ]; then
                echo -e "Enter Table Name: \c"
                read tableName
                if ! [[ -f $tableName ]]; then
                    # it dosn't exist
                    clear
                    echo -e "Table $tableName isn't existed\n"
                    # back to the menu 2
                    selectTable
                fi
                echo -e "Enter Condition Value: \c"
                read value
                # check if your Value exist
                result=$(awk 'BEGIN{FS="|"}{if ( $1 == "'$value'" ) print $1 }' $tableName 2>>/dev/null)
                # echo $result
                if [[ $result == "" ]]; then
                    # it dosn't exist
                    clear
                    echo -e "Value Not Found\n"
                else
                    # it exists so
                    # get the line number of the value to select it
                    NR=$(awk 'BEGIN{FS="|"}{if ( $1 == "'$value'" ) print NR}' $tableName 2>>/dev/null)
                    clear
                    echo $(awk 'BEGIN{FS="|";}{if ( NR == 1 ) print $0 }' $tableName 2>>/dev/null)
                    echo $(awk 'BEGIN{FS="|";}{if ( NR == '$NR' ) print $0 }' $tableName 2>>/dev/null)
                    if [[ $? != 0 ]]; then
                        echo -e "\nError selecting Data from Table $tableName\n"
                    fi
                    echo -e "\n"
                fi
                q=0
            fi
            selectTable
            ;;
        back-to-db-menu)
            clear
            cd ..
            list1
            ;;
        back-to-table-menu)
            clear
            list2
            ;;
        exit)
            clear
            exit
            ;;
        *)
            clear
            echo WRONG CHOICE !!
            selectTable
            ;;
        esac
    done
}
list1
