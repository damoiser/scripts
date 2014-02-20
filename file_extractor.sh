#!/bin/sh

# you need perl to execute this script
# sh file_extractor.sh path_to_the_file/file.txt
# extract from a text file the matched strings

echo "What are you looking for?"
echo "[0] Custom regexp"
echo "[1] Custom string"
echo "[2] Emails"
echo "[3] Phone numbers (not so accurate)"
echo "[4] Hex value"
echo "[5] Url"
echo "[6] IP address"
read -p "Please select: " choice

if [[ "$choice" = "" ||  $choice -lt 0 || $choice -gt 6 ]]; then
	echo "Bad choice"
	exit 1
fi

if [[ "$1" = "" ]]; then
	echo "Please give a path for a file"
	exit 1
fi

CMD=''
[ "$CMD" = '' -a -f "`which perl 2>/dev/null`" ]  && CMD=perl

if [ "$CMD" = "" ]; then
	echo "perl cmd not installed on your system"
	exit 1
fi


SearchAndPrint () {
	current_line=1
	while read -r line
	do
		if [ $3 = "string" ]; then # a simple string
			result=$(echo "$line" | grep -io "$2")
		else
			result=$(echo "$line" | perl -nle "/$2/ and print $&")
		fi

		if [ "$result" != "" ]; then
			# uncomment next line if you want to print the number of the line
			# printf "Line $current_line: "
			echo $result
		fi
		current_line=$((current_line+1))
	done < $1

}


case "$choice" in 
	0)
		read -p "Please insert the regexp (without the open-close slash /..//): " regexp
		SearchAndPrint $1 $regexp "regexp"
	;;
	1)
		read -p "Please insert the string: " string
		SearchAndPrint $1 $string "string"
	;;
	2)
		# email regexp
		regexp="([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})"
		SearchAndPrint $1 $regexp "email"
	;;
	3) 
		# phone numbers 
		# international regexp, the standard international access code identifier + is mandatory to match
		regexp="\+(9[976]\d|8[987530]\d|6[987]\d|5[90]\d|42\d|3[875]\d|2[98654321]\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\d{1,14}"
		SearchAndPrint $1 $regexp "phone"
	;;
	4)
		# hex value
		regexp='#?([a-f0-9]{6}|[a-f0-9]{3})'
		SearchAndPrint $1 $regexp "hex"
	;;
	5)
		# url
		regexp="((https?|ftp):\/\/|(www|ftp)\.)[a-z0-9-]+(\.[a-z0-9-]+)+([\/?].*)?"
		SearchAndPrint $1 $regexp "url"
	;;
	6)
		# IP
		regexp="(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"
		SearchAndPrint $1 $regexp "ip"
	;;
	*)
		echo "Is not an integer"
	;;
esac
