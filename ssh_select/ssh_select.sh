#!/bin/bash

CSV_FILE="path"

if [ ! -f "$CSV_FILE" ]; then
    echo "Error: '$CSV_FILE' not found!"
    exit 1
fi

echo "Select a server to connect to:"
servers=()
i=1
while IFS=, read -r name ip port user id_file; do
    if [ "$name" != "name" ]; then
        echo "$i) $name ($user@$ip:$port)"
        servers+=("$name,$ip,$port,$user,$id_file")
        i=$((i+1))
    fi
done < "$CSV_FILE"

read -p "Enter the number of the server you want to connect to: " choice
choice=$((choice-1))

if [ "$choice" -lt 0 ] || [ "$choice" -ge "${#servers[@]}" ]; then
    echo "Error: Invalid choice!"
    exit 1
fi

IFS=, read -r name ip port user id_file <<< "${servers[$choice]}"

if [ -n "$id_file" ]; then
    id_file_option="-i $id_file"
else
    id_file_option=""
fi

echo "Connecting to $name ($user@$ip:$port)..."
ssh -p "$port" $id_file_option "$user@$ip"

exit 0

