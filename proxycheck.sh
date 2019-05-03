#!/bin/sh
#https://mahtotechnologies.com/blog
#https://facebook.com/devendermahto

if [ $# -lt 1 ];
then
	echo "no arguments supplied"
fi

#scan with nmap
echo "Scanning $1 on port $2 with Nmap.."
nmap $1 -p$2 --open >proxies

#parse the proxies
echo "Parsing proxies"
grep -Eo '[0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}' proxies >list

#check if they work
while read line; do
	echo "Checking socks4: $line"
	res4=$(curl -s -x socks4://$line:$2 https://api.ipify.org/)

	if [ $res4 = "" ];
	then
		echo "Checking socks5: $line"
		res5=$(curl -s -x socks5://$line:$2 https://api.ipify.org/)

        	if [ $res5 ! "" ];
        	then
	                echo "socks5:$res5:$2" >>proxylist
	        fi
	else
		echo "socks4:$res4:$2" >>proxylist
	fi

done <list

cat proxylist

#clean up the directory/files
rm proxies list proxylist
