#!/bin/bash
if [[ -z $@ ]];then
	printf "need url ARGS";
	return 1
fi
\timeout 1 sleep 10;
while [[ $? -gt 8 ]];do
	\timeout -s SIGTERM 60 \wget -q -o - --adjust-extension --no-check-certificate -P 'cache/' "$@";
done
