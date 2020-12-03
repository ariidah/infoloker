#!/bin/bash
if [[ -z $@ ]];then
	echo 'Penggunaan : makecache.sh [url]'
	exit 1
fi
# reference https://stackoverflow.com/a/37840948
function urldecode(){
	: "${*//+/ }";echo -e "${_//%/\\x}"
}
output=`urldecode "${@/*\/}"`
\timeout 1 sleep 10;
while [[ $? -gt 0 ]];do
	\timeout -s SIGTERM 60 \wget -q -o - --adjust-extension --no-check-certificate -P 'cache/' "$@";
done
\w3m -dump "cache/$output.html" > "cache/$output.txt"
