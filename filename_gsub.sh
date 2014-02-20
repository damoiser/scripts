#!/bin/sh

# sh filename_gsub.sh
# substract and/or replace for each filename the given string
# the matched files are copied under /filename_gsub dir

read -p "Enter the string to remove: " rmv_str
read -p "Enter the string to replace (blank for no replace): " repl_str

mkdir -p $PWD/filename_gsub

matched=0

for files in *.* 
do
	final_filename="${files//$rmv_str/$repl_str}"

	if [[ "$files" != "$final_filename" ]]; then
		matched=$((matched+1))
		cp $files filename_gsub/$final_filename
	fi

done

echo "$matched files are renamed!"