#!/bin/bash
SRC=${0%/*}
source "$SRC/echolor.sh"

file_pattern=$1
string=$2
dir=$3

usage(){
  echolor green "Usage: advsearch {{[file_pattern] [string to match] (path to search)}} \n"
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

echo "$files_count files to search"
i=0
matching=0
for file in $files
do
  if [[ -f "$file" ]]
  then
    match=$(cat "$file" | grep "$string")
    if [[ -z $match ]]
  	then
    		echo "Not found" > /dev/null
    	else

        echo "                                          "
    		echolor cyan "$file"
        echo

        match=$(cat "$file" | grep -n "$string" | sed "s/$string/{{$string}}/g")
        echolor orange "$match"
        matching=$(($matching+1))
    fi
    printf "$i/$files_count files processed...\r"
    i=$(($i+1))
  fi
done
echo ""
echo "$matching files found containing '$string' out of $files_count files matching $file_pattern"
