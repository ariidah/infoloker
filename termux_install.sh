#!/bin/bash
function loginfo(){
	printf "\e[1;32m[ INFO ] \e[0m$@\n"
}
function logerr(){
	printf "\e[1;31m[ FAIL ] \e[0m$@\n"
}
function logtry(){
	printf "\e[1;34m[  RE  ] \e[0m$@\n"
}
loginfo "active directory '$PWD'"
loginfo "installing dependency..."

THIS=$PWD
TARGET=/sdcard/${PWD/*\/}
TARGETLINK=$HOME/${PWD/*\/}

function is_installed(){
	cd -P $TARGET;x=$PWD
	cd -P $TARGETLINK;y=$PWD
	cd $THIS

	if [[ $x == $y ]];then
		loginfo "Mode perbaikan repositori"
		return 0
	else
		return 1
	fi
}

# pkg install
function pkg_install(){
	loginfo "Checking scrapy dependency"
	if [[ ! $(type -p scrapy) ]];then
		miss_package="python libffi libxml2 clang "
	fi
	loginfo "Checking termux-api packages"
	if [[ ! $(type -p termux-job-scheduler) ]];then
		miss_package=$miss_package"termux-api "
	fi
	loginfo "Checking wget packages"
	if [[ ! $(type -p wget) ]];then
		miss_package=$miss_package"wget "
	fi
	loginfo "Checking w3m packages"
	if [[ ! $(type -p w3m) ]];then
		miss_package=$miss_package"w3m "
	fi

	[[ -z $miss_package ]];while [[ $? -gt 0 ]];do
		logtry "pkg install [refered to README.md]"
		pkg install -y $miss_package
	done
}
pkg_install

# pip install
function pip_install(){
	false;while [[ $? -gt 0 ]];do
		logtry "pip install [refered to README.md]"
		pip install scrapy
	done
}
if [[ ! $(type -p scrapy) ]];then
	pip_install
fi

# setup storage
function setup_storage(){
	ls /sdcard/ >/dev/null 2>&1
	while [[ $? -gt 0 ]];do
		logtry "Izinkan akses ke storage"
		termux-setup-storage
	done
}
setup_storage

# checking termux-api [notification]
function termux_api(){
	logtry "Checking termux-notification [pastikan layar aktif]"
	timeout 5 termux-notification -t "InfoLoker notification pack" -c "T E S T . . ."
	if [[ $? -gt 0 ]];then
		logerr "Termux:API belum terinstall, baca README.md dan install dari Play Store"
		exit 1
	else
		loginfo "termux-notification OK"
	fi
}
termux_api

# prepare infoloker.sh
function prepare_launcher(){ 
	if [[ ! -f "infoloker.sh" ]];then
		 logerr "infoloker.sh tidak ditemukan"
		 exit 2
	fi
	loginfo "Menyalin infoloker.sh ke $HOME"
	cp infoloker.sh "$HOME/"
	[[ ! -x "$HOME/infoloker.sh" ]] && chmod 700 "$HOME/infoloker.sh"
}
prepare_launcher

# pindahan repositori
function to_sdcard(){
	if [[ -d $TARGET ]];then
		loginfo "Folder $TARGET exist!"
	fi
	loginfo "Menyalin repositori ke '$TARGET'"

	cp -r "$THIS" "$TARGET"
	if [[ $? -gt 0 ]];then
		logerr "Gagal menyalin '$THIS' ke '$TARGET'"
		exit 3
	fi
	[[ -d "$TARGETLINK" ]] && rm -rf "$TARGETLINK"

	false;while [[ $? -gt 0 ]];do
		logtry "Membuat symlink $TARGETLINK"
		ln -s "$TARGET" "$TARGETLINK"
		[[ -L "$TARGETLINK" ]]
	done
	cd "$TARGET"
}

is_installed
if [[ $? -gt 0 ]];then
	to_sdcard
fi

# link launcher ke folder bin
function mkbin(){
	[[ ! $(type -p infoloker) ]] && ln -s $HOME/infoloker.sh $HOME/../usr/bin/infoloker
}
mkbin

printf '\e[42m%32s\e[0m\n'
loginfo "INSTALASI SELESAI"
