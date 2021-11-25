#!/bin/bash

#custom cd-------
function cd(){
	local processid="$BASHPID"
	local update=true
	local tty=`ps h -p $$ -o tty`
	if [ "$tty" = '?' ]; then
		update=false
	else
		local processname=`ps h -o args -p "$processid"`
		local level=`ps hf -o args,pid |
			sed -r -n "/ +$processid$/p" |
			sed -r "s/ +$processid//" |
			sed -e "s;$processname;;" |
			echo -n "\`cat -\`" |
			wc --chars |
			echo "\`cat -\` / 4" |
			bc`
		[ ! "$level" = 0 ] && update=false
	fi
	if [ ! "$OLDPWD" ] && [ "$1" = "-" ]; then
		OLDPWD=`cat ~/.cd`
	fi

	local destination="$1"
	[ ! "$destination" ] && destination="$HOME"
	builtin cd "$destination" &&
		if "$update"; then
			# 最後の終了コードはできるだけ0にするためifで評価(winscpの仕様)
			pwd > ~/.cd
		fi

}