#!/bin/bash
file_pattern=$1
string=$2
dir=$3

usage(){
  echo "Usage: advsearch [file_pattern] [string to match] (path to search)"
  exit
}

if [[ -z $file_pattern ]]
then
  usage
fi


if [[ -z $dir ]]
then
  dir=$(pwd)
fi
files=$(locate "$dir/$file_pattern")

files_count=$(echo "$files" | wc -l)
files_count=$(($files_count-1))
echo "Updating database..."
updatedb
echo "$files_count files to search"
i=0
matching=0
for file in $files
do
  if [[ -f "$file" ]]
  then
    if [[ -z $(cat "$file" | grep "$string") ]]
  	then
    		echo "Not found" > /dev/null
    	else
        echo "                                          "
    		echo $file
        echo
        cat "$file" | grep "$string"
        matching=$(($matching+1))
    fi
    i=$(($i+1))
    printf "$i/$files_count files processed...\r"
  fi
done

echo "$matching files found containing '$string' out of $files_count files matching $file_pattern"
