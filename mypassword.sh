#!/bin/bash
passSalt="5d0d9af1449af8d4432ef89da63c5ba6"
passPath="/.mypassword"

#add password
function addPassword(){
    echo "Add a new password."
    read -p "Name:" name
    if [ ! -n "$name" ]; then
        addPassword
        return
    fi

    if [ -f "$passPath/${name}.pwd" ]; then
        echo "Name already exists."
        addPassword
        return
    fi

    read -s -p "Input password of $name:" password
    echo "******"
    echo "$password" | openssl enc -aes-256-cbc -a -k $pwd > "$passPath/${name}.pwd"
    echo "Password added successfully!"
}

#read original password for a password name
function readPasswordWithName(){
    name=$1
    if [ ! -n "$name" ]; then
        read -p "Name:" name
        readPasswordWithName $name
        return
    fi

    #cat "$passPath/$1"
    #echo $pwd
    password=`cat "$passPath/${1}.pwd" | openssl enc -aes-256-cbc -a -d -k $pwd`
    echo "Password of [ $1 ] is [ $password ]"
}

#show password name list
function showPasswordNameList(){
    echo "List of your password:"
    echo "=========================================="
    ls -1 "$passPath" | sed -e 's/.pwd$//g'
    echo "=========================================="
}

#show all passwords
function showAllPassword(){
    echo "All password:"
    currentDir=`pwd`
    cd "${passPath}"
    count=1
    find . -name "*.pwd" | while read i
    do
        name=`echo "${i}" | sed -e 's/^.\///g' | sed -e 's/\.pwd$//g'`
        password=`cat "$passPath/${name}.pwd" | openssl enc -aes-256-cbc -a -d -k $pwd`
        echo "${count}. Password of [ ${name} ] is [ $password ]"
        ((count++))
    done
    cd "${currentDir}"
}

#remove password
function removePassword(){
    read -p "Name:" name
    if [ ! -n "$name" ]; then
        removePassword
        return
    fi

    #check password file exists
    if [ ! -f "${passPath}/${name}.pwd" ]; then
        echo "Password file not exists."
        removePassword
        return
    fi

    read -p "You want to remove password [${name}], [y/n]:" confirm
    if [ "$confirm" = "y" ]; then
        rm "${passPath}/${name}.pwd"
    fi
}

#main handle method
function readWritePassword(){
    checkPWD
    if [ "$?" != "1" ] ; then
        echo "PWD error."
        exit 0
    fi

    #show password name list
    showPasswordNameList

    read -p "Input name or [A]ll or [C]lear or [PWD]changePWD or [Q]uit or [R]emove or [W]rite :" cmd

    if [ "$cmd" == "A" ]; then
        showAllPassword
    elif [ "$cmd" == "C" ]; then
        clear
    elif [ "$cmd" == "PWD" ]; then
        changePWD
    elif [ "$cmd" == "Q" ]; then
        exit 0
    elif [ "$cmd" == "R" ]; then
        removePassword
    elif [ "$cmd" == "W" ]; then
        addPassword
    else
        readPasswordWithName $cmd
    fi

    #next read write password
    readWritePassword
}

#input and encode PWD
function readPWD() {
    read -s -p "PWD:" pwd
    echo "******"
    pwd=`echo "$pwd$passSalt" | openssl enc -base64`
}

#init PWD password
function initCheckPWD() {
    echo "checkPWD password file is not exists, now init it."
    readPWD
    echo "***" | openssl enc -aes-256-cbc -a -k $pwd > "$passPath/checkPWD.pwd"
}

#check PWD is correct
function checkPWD() {
    if [ ! -f "$passPath/checkPWD.pwd" ] ; then
        initCheckPWD
        return 1
    fi
    password=`cat "$passPath/checkPWD.pwd" | openssl enc -aes-256-cbc -a -d -k $pwd`

    if [ "$password" != "***" ]; then
        return 0
    fi
    return 1
}

#change PWD
function changePWD() {
    checkPWD
    if [ "$?" != 1 ] ; then
        echo "PWD error."
        exit 0
    fi
    oldPwd=$pwd
    echo "Now change PWD, please input your new PWD."
    readPWD
    pwd1=$pwd
    echo "Please confirm your new PWD."
    readPWD
    pwd2=$pwd
    if [ "$pwd1" != "$pwd2" ] ; then
        echo "The two passwords you typed did not match."
        pwd=$oldPwd
        changePWD
        return
    fi

    currentDir=`pwd`
    cd "${passPath}"
    count=1
    find . -name "*.pwd" | while read i
    do
        name=`echo "${i}" | sed -e 's/^.\///g' | sed -e 's/\.pwd$//g'`
        password=`cat "$passPath/${name}.pwd" | openssl enc -aes-256-cbc -a -d -k ${oldPwd}`

        #save new password
        echo "$password" | openssl enc -aes-256-cbc -a -k $pwd > "$passPath/${name}.pwd"
    done
    cd "${currentDir}"
}

#init password save dir
if [ ! -d "$passPath" ]; then
    mkdir -p "$passPath"
fi
#read PWD
readPWD
#loop do read write Password
readWritePassword
