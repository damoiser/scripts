#!/bin/sh

# sh hashme.sh
# hash a string input or a file path for the common hash types

read -p "Insert the string or the file path you want to hash: " str
read -p "Is a file path? [y | n]: " is_file 

echo "Select one of the following hash types"
echo "[0] All"
echo "[1] MD5"
echo "[2] SHA-1"
echo "[3] SHA-256"
echo "[4] SHA-512"
read -p "Insert the choice: " hash_nr

if [[ "$hash_nr" = "" ||  $hash_nr -lt 0 || $hash_nr -gt 4 ]]; then
	echo "Hash type not recognized"
	exit 1
fi

if [[ "$is_file" = "y" || "$is_file" = "yes" || "$is_file" = "Y" ]]; then
	is_file=true
else
	is_file=false
fi

HashMd5 () {
	CMD=''
	[ "$CMD" = '' -a -f "`which md5 2>/dev/null`" ]  && CMD=md5

	echo "#### MD5 ####"
	if [ "$CMD" = "" ]; then
		echo "md5 cmd not installed on your system"
	else
		if [ $is_file = true ]; then
			md5 $1
		else 
			printf "%s" $1 | md5
		fi
	fi
}

HashMd5Sum () {
	CMD=''
	[ "$CMD" = '' -a -f "`which md5sum 2>/dev/null`" ]  && CMD=md5

	echo "#### MD5sum ####"
	if [ "$CMD" = "" ]; then
		echo "md5sum cmd not installed on your system!"
	else
		printf "%s" $1 | md5sum
	fi	
}

HashSha1 () {
	CMD=''
	[ "$CMD" = '' -a -f "`which openssl 2>/dev/null`" ]  && CMD=md5

	echo "#### SHA1 ####"
	if [ "$CMD" = "" ]; then
		echo "openssl cmd - required for sha1 - not installed on your system"
	else
		if [ $is_file = true ]; then
			openssl sha1 $1
		else 
			printf "%s" $1 | openssl dgst -sha1
		fi
	fi
}

HashSha256 () {
	CMD=''
	[ "$CMD" = '' -a -f "`which shasum 2>/dev/null`" ]  && CMD=md5

	echo "#### SHA256 ####"
	if [ "$CMD" = "" ]; then
		echo "shasum cmd not installed on your system"
	else
		if [ $is_file = true ]; then
			shasum -a 256 $1
		else 
			printf "%s" $1 | shasum -a 256
		fi
	fi

}

HashSha512 () {
	CMD=''
	[ "$CMD" = '' -a -f "`which shasum 2>/dev/null`" ]  && CMD=md5

	echo "#### SHA512 ####"
	if [ "$CMD" = "" ]; then
		echo "shasum cmd not installed on your system"
	else
		if [ $is_file = true ]; then
			shasum -a 512 $1
		else 
			printf "%s" $1 | shasum -a 512
		fi
	fi
}

case "$hash_nr" in 
	0) 
		HashMd5 $str
		HashSha1 $str
		HashSha256 $str
		HashSha512 $str
	;;
	1) HashMd5 $str
	;;
	2) HashSha1 $str

	;;
	3) HashSha256 $str

	;;
	4) HashSha512 $str

	;;
	*) echo "No option"	
	;;
esac


