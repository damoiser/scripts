#!/bin/sh

# sh rename_incremental.sh
# rename all files with an index incremental
# the new files are copied in /rename_incremental dir

read -p "Start the index from (blank for 1): " start_index

if [ "$start_index" = "" ]
	then 
		i=1
		start_index=1
	else i=$start_index
fi

if [[ ! $start_index =~ ^-?[0-9]+$ ]]; then 
		echo "The input is not a number!"
		exit 1
fi

mkdir -p $PWD/rename_incremental

for files in *.*
do
	splitted_name=(${files//./ })
	extension_index=${#splitted_name[@]}
	extension_index=$extension_index-1

	echo "doing $files -> $i.${splitted_name[extension_index]}"

	cp $files rename_incremental/$i.${splitted_name[extension_index]}
	i=$((i+1))
done