#!/bin/bash
:'
@name Install SSL android
@author Dwiki Kusuma <twitter: @qlkwej>
@desc: based on https://blog.nviso.eu/2018/01/31/using-a-custom-root-ca-with-burp-for-inspecting-android-n-traffic/
'


: 'Set variables'
YELLOW="\033[1;33m"
GREEN="\033[0;32m"
RESET="\033[0m"
domain="$1"
RESULTDIR="certificates/"
VERSION="1.0"


: 'Starting'
running() {
	clear
	if [[ $EUID -ne 0 ]]; then
		   echo -e "$YELLOW[!] This script must be run as root$RESET" 
		      exit 1
	fi
	echo -e "$GREEN[+] Create new SSL android, stand by ..$RESET"
	mkdir certificates && cd certificates

	echo -e "$GREEN[+] Installing openssl.$RESET"
	sudo apt-get install openssl
	sleep 2
	#'copy openssl.cnf'
	cp /usr/lib/ssl/openssl.cnf .

	#'create a private key'
	printf "ID\nqlkwej-CA\nqlkwej-CA\nqlkwej-CA\nqlkwej-CA\nqlkwej-CA\nqlkwej-CA\n" | openssl req -x509 -days 730 -nodes -newkey rsa:2048 -outform der -keyout server.key -out ca.der -extensions v3_ca -config openssl.cnf
	
	cp ca.der ca.cer

	#'convert to der format'
	openssl rsa -in server.key -inform pem -out server.key.der -outform der

	#'convert to pkcs8 format'
	openssl pkcs8 -topk8 -in server.key.der -inform der -out server.key.pkcs8.der -outform der -nocrypt
	#'checking version 3 and CA:TRUE'
	openssl x509 -in ca.der -inform der -noout -text | grep "Version:" --color
	openssl x509 -in ca.der -inform der -noout -text | grep "CA:" --color
	
	#'Done'
	echo -e "$YELLOW[+]  Done.$RESET"

}

: 'Execute main function'
running
