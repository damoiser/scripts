#!/bin/sh

# sh rename.sh
# prepend/append string to filename in current dir
# the name can contains even multiples dot, but must have an extension
# (the last dot is the extension of the file)
# the new files are copied to rename/ dir


read -p "Enter the prepended string (blank for nothing): " prepend
read -p "Enter the appended string (blank for nothing): " append
read -p "Prompt each file? [yes | no]: " prompt

mkdir -p $PWD/rename

for files in *.* 
do
	splitted_name=(${files//./ })

	length=${#splitted_name[@]}

	if [ $length = 2 ]
		then final_name=$prepend${splitted_name[0]}$append.${splitted_name[1]}
		else 
			final_name=$prepend
			for (( i=0; i< ($length - 1); i++ ));
			do
				if [ $i = 0 ]
					then final_name=$final_name${splitted_name[$i]}
					else final_name=$final_name.${splitted_name[$i]}
				fi
			done
			final_name=$final_name$append.${splitted_name[length - 1]}
	fi

	echo converting $files to $final_name

	if [ "$prompt" = "yes" ] || [ "$prompt" = "y" ] || [ "$prompt" = "Y" ]
		then cp -i $files rename/$final_name
		else cp $files rename/$final_name
	fi

done