#!/bin/bash
# if the db dir already exist don't show an error
# if it isn't exist
# create it
mkdir DB 2>>./.wornning.log
# enter to the db dir
cd DB
echo "Welcome To our database :)"
let q=0
# first menu work in the db main dir
# you can create / list / connect to / delete spacifice db
function list1() {
    echo CHOOSE FROM DB MENU
    select choice in "create-db" "list-db" "connect-db" "delete-db" "exit"; do
        case $choice in
        create-db)
            # take db name from user
            echo enter your database name
            read dbName
            # db flag
            let flag=0
            # list all existed dbs
            # no need to check if it is empty because it won't enter
            # the loop and will create the db
            for i in $(ls); do
                # check if your db exist
                if [ $dbName = $i ]; then
                    # it exists
                    echo $dbName is already exist
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
                mkdir $dbName
                echo $dbName is created
            fi
            ;;
        list-db)
            showlist
            q=0
            list1
            ;;
        connect-db)
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
                        cd $dbName
                        echo you now in your $dbName
                        list2
                    fi
                done
                # if data base is not exist
                if [ $flag -eq 0 ]; then
                    echo $dbName not exist so choise 1 to create your data base
                fi
                q=0
            fi
            ;;
        delete-db)
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
                        echo your $dbName is deleted
                        flag=1
                    fi
                    if [ $flag -eq 1 ]; then
                        break
                    fi
                done
                if [ $flag -eq 0 ]; then
                    echo $dbName not exist
                fi
                q=0
            fi
            list1
            ;;
        exit)
            exit
            ;;
        *)
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
            # take table name from user
            echo ENTER your table name
            read tablename
            # table flag
            let flag=0
            # list all existed tables
            # no need to check if it is empty because it won't enter
            # the loop and will create the table
            for i in $(ls); do
                # check if your table exist
                if [ $tablename = $i ]; then
                    # it exists
                    echo $tablename is already exist
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
                while ! [[ $colsNum =~ ^[0-9]*$ ]]; do
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
                # primary key string
                pKey=""
                # meta data string
                metaData="Field"$sep"Type"$sep"key"
                #while the counter is less than number of column  that you entered
                while [ $count -le $colsNum ]; do
                    # enter the column name
                    echo -e "Name of Column No.$count: \c"
                    read colName
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
                    if [[ $pKey == "" ]]; then
                        echo -e "Make it as a PrimaryKey ? "
                        select var in "yes" "no"; do
                            case $var in
                            yes)
                                pKey="PK"
                                metaData+=$rSep$colName$sep$colType$sep$pKey
                                break
                                ;;
                            no)
                                metaData+=$rSep$colName$sep$colType$sep""
                                break
                                ;;
                            *)
                                echo WRONG CHOICE !!
                                ;;
                            esac
                        done
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
                    echo "Table Created Successfully"
                else
                    echo "Error Creating Table $tablename"
                fi
            fi
            list2
            ;;
        list-table)
            showlist
            q=0
            list2
            ;;
        drop-table)
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
                        echo your $data Table is deleted
                        #the table is exist so let flag=1
                        flag=1
                        break
                    fi
                done
                # if flage=0 (table not exist)
                if [ $flag -eq 0 ]; then
                    echo $data not exist
                fi
                q=0
            fi
            ;;
        insert-in-table)
            showlist
            if [ $q -eq 1 ]; then
                echo -e "Table Name: \c"
                read tableName
                # check if your table  not exist by !-f
                if ! [[ -f $tableName ]]; then
                    # it dosn't exist
                    echo "Table $tableName isn't existed ,choose another Table"
                    # back to the menu 2
                    break
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
                    colKey=$(awk 'BEGIN{FS="|"}{if(NR=='$i') print $3}' .$tableName)
                    # get record values from user
                    echo -e "$colName ($colType) = \c"
                    read data
                    # Validate datatype
                    # is it an integer ?
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
                    # is it a primary key ?
                    if [[ $colKey == "PK" ]]; then
                        while [[ true ]]; do
                            # if it is a primary key so
                            # check if it is available
                            if [[ $data =~ ^[$(awk 'BEGIN{FS="|" ; ORS=" "}{if(NR != 1)print $(('$i'-1))}' $tableName)]$ ]]; then
                                echo -e "invalid input for Primary Key !!"
                                echo -e "$colName ($colType) = \c"
                                read data
                            else
                                break
                            fi
                        done
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
                if [[ $? == 0 ]]; then
                    echo -e "\nData Inserted Successfully\n"
                else
                    echo -e "\nError Inserting Data into Table $tableName\n"
                fi
                q=0
            fi
            list2
            ;;
        select-from-table)
            selectTable
            ;;
        delete-from-table)
            showlist
            if [ $q -eq 1 ]; then
                echo -e "Enter Table Name: \c"
                read tableName
                # check if your table exist
                if ! [[ -f $tableName ]]; then
                    # it dosn't exist
                    echo "Table $tableName isn't existed ,choose another Table"
                    break
                fi
                # it exists so
                # which column do you want to search with
                echo -e "Enter Condition Column name: \c"
                read field
                # check if your column exist
                fid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $tableName)
                if [[ $fid == "" ]]; then
                    # it dosn't exist
                    echo "Not Found"
                else
                    ((x = $fid + 1))
                    test=$(awk 'BEGIN{FS="|"}{if(NR=='$x'){if($3=="PK") print 0}}' .$tableName)
                    if [[ $test != "0" ]]; then
                        # it dosn't exist
                        echo " you shoud enter your primarykey column name "
                        exit
                    else
                        # it exists so
                        # which Value do you want to search with
                        echo -e "Enter Condition Value: \c"
                        read value
                        # check if your Value exist
                        result=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$value'") print $'$fid'}' $tableName 2>>./.wornning.log)
                        if [[ $result == "" ]]; then
                            # it dosn't exist
                            echo "Value Not Found"
                        else
                            # it exists so
                            # get the line number of the value to delete it
                            NR=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$value'") print NR}' $tableName 2>>./.wornning.log)
                            # edit the table and delete the record
                            sed -i ''$NR'd' $tableName 2>>./.wornning.log
                            # The Row Deleted Successfully
                            echo "Row Deleted Successfully"
                        fi
                    fi
                fi
                q=0
            fi
            ;;
        back-to-db-menu)
            cd ..
            list1
            ;;
        exit)
            exit
            ;;
        *)
            echo WRONG CHOICE !!
            list2
            ;;
        esac
    done
}
function selectTable() {
    echo CHOOSE FROM SELECT MENU
    select choice in "select-all" "select-specific-column" "back-to-db-menu" "back-to-table-menu" "exit"; do
        case $choice in
        select-all)
            showlist
            if [ $q -eq 1 ]; then
                echo -e "Enter Table Name: \c"
                read tableName
                if ! [[ -f $tableName ]]; then
                    # it dosn't exist
                    echo "Table $tableName isn't existed"
                    # back to the menu 2
                    selectTable
                fi
                column -t -s '|' $tableName 2>>./.wornning.log
                if [[ $? != 0 ]]; then
                    echo "Error Displaying Table $tableName"
                    echo "You may choiced an empty table"
                fi
                q=0
            fi
            selectTable
            ;;
        select-specific-column)
            showlist
            if [ $q -eq 1 ]; then
                echo -e "Enter Table Name: \c"
                read tableName
                if ! [[ -f $tableName ]]; then
                    # it dosn't exist
                    echo "Table $tableName isn't existed"
                    # back to the menu 2
                    selectTable
                fi
                echo -e "Enter Column Name: \c"
                read field
                # check if your column exist
                fid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $tableName)
                if [[ $fid == "" ]]; then
                    # it dosn't exist
                    echo "Not Found"
                else
                    echo -e "\n#################"
                    awk 'BEGIN{FS="|"}{print $'$fid'}' $tableName
                    echo -e "#################\n"
                fi
                q=0
            fi
            selectTable
            ;;
        back-to-db-menu)
            cd ..
            list1
            ;;
        back-to-table-menu)
            list2
            ;;
        exit)
            exit
            ;;
        *)
            echo WRONG CHOICE !!
            selectTable
            ;;
        esac
    done
}
list1