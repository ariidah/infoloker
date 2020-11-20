#!/bin/bash
# Setting interval ada disini (dalam satuan detik) minimal 900 detik, referensi `man termux-notification`
INTERVAL=3600

# ---- jangan modifikasi baris setelah ini ---
if [[ -z $INTERVAL ]];then
	INTERVAL=3600
else
	[[ $INTERVAL -lt 900 ]] && INTERVAL=900
fi

if [[ -z $@ || ! $(type -p termux-job-scheduler) ]];then
	SCRIPTHOME=$HOME/infoloker/
	cd "$SCRIPTHOME"
	\scrapy crawl infoloker
	cd -
	exit
fi
case "$@" in
	start)
		\termux-job-scheduler -s $HOME/infoloker.sh --period-ms $(($INTERVAL * 1000))
		;;
	stop)
		\termux-job-scheduler --cancel-all
		;;
	*)
		echo '---
infoloker.sh [ARGS]
Launcher untuk InfoLoker notification pack, HARUS terintegrasi dengan termux-api.
Jalankan tanpa argument untuk running hanya 1 (satu) kali.

start	untuk mengaktifkan scheduler
stop	untuk menonaktifkan scheduler
'
		exit 1
	;;
esac
