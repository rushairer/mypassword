#!/bin/bash
passSalt="5d0d9af1449af8d4432ef89da63c5ba6"
passPath="/Users/abendas/Library/Mobile Documents/com~apple~CloudDocs/.mypassword"
read -s -p "PWD:" pwd
echo "******"

function base64Encode(){
    echo "$1$passSalt" | openssl enc -base64
}

pwd=`base64Encode $pwd`

function addPassword(){
    echo "Add a new password."
    read -p "Name:" name
    if [ ! -n "$name" ]; then
        addPassword
        exit 0
    fi

    if [ -f "$passPath/$name" ]; then
        echo "Name already exists."
        addPassword
        exit 0
    fi

    read -s -p "Input password of $name:" password
    echo "******"
    echo "$password" | openssl enc -aes-256-cbc -a -k $pwd > "$passPath/$name"
    echo "Password added successfully!"
}

function readPassword(){
    read -p "Name:" name
    if [ ! -n "$name" ]; then
        readPassword
        exit 0
    fi
    password=`cat "$passPath/$name" | openssl enc -aes-256-cbc -a -d -k $pwd`
    echo "Password of $name is [$password]"
}

function readPasswordWithName(){
    if [ ! -n "$1" ]; then
        readPassword
        exit 0
    fi
    #cat "$passPath/$1"
    #echo $pwd
    password=`cat "$passPath/$1" | openssl enc -aes-256-cbc -a -d -k $pwd`
    echo "Password of $1 is [$password]"
}

function showPasswordList(){
    echo "List of your password:"
    echo "=========================================="
    ls -1 "$passPath"
    echo "=========================================="
}


if [ ! -d "$passPath" ]; then
    mkdir -p "$passPath"
    addPassword
    exit 0
else
    showPasswordList
    read -p "Input name or [W]rite:" cmd

    if [ "$cmd" == "W" ]; then
        addPassword
        exit 0
    else
        readPasswordWithName $cmd
        exit 0
    fi
fi



