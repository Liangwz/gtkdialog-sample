#!/bin/bash

GTKDIALOG=gtkdialog
export SCREEN_WIDTH=800
export SCREEN_HEIGHT=600


export TMPDIR=/home/git/gtkdialog-sample/
export _SYS_TIME=30

funcpixCreate() {
	for f in 0; do
		echo '<pixmap>
				<variable export="false">pix'$1$f'</variable>
				<input file>'"$TMPDIR"'/pix'$f'.svg</input>
			</pixmap>'
	done
}

funcbtnCreate() {
	echo '<button>
			<input file stock="'$1'"></input>
			<action>'$2':tmr0</action>
			<action>'$2':tmr1</action>
			<action>'$2':tmr2</action>
			<action>'$2':tmr3</action>
		</button>'
}

functmrCreate() {
	echo '<variable>tmr'$1'</variable>
			<action>bash -c funcpixRandomise</action>
			<action>refresh:pix'$1'0</action>
		</timer>'
}

funcimageCreate() {
	local -a colours=("a00000" "00a000" "0000a0" "ffffff")
	echo '
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
	<rect x="0" y="0" height="64" width="64" fill="#'${colours[$1]}'"/>
</svg>' > "$TMPDIR"/image$1.svg
}

funcpixRandomise() {
		
	local rand=
	for f in 0 1 2 3; do
		if [ ${_SYS_TIME} -ge 0 -a ${_SYS_TIME} -lt 20 ];then
			echo "the time bigger then 20" >> time.abc
			ln -sf "$TMPDIR"/image1.svg "$TMPDIR"/pix0.svg
		elif [ ${_SYS_TIME} -ge 20 -a ${_SYS_TIME} -lt 40 ];then
			echo "20 40 time" >> time.abc
			ln -sf "$TMPDIR"/image2.svg "$TMPDIR"/pix0.svg
		elif [ ${_SYS_TIME} -ge 40 -a ${_SYS_TIME} -lt 60 ];then
			echo "40 60 time" >> time.abc
			ln -sf "$TMPDIR"/image3.svg "$TMPDIR"/pix0.svg
		else
			echo "other time" >> time.abc
		fi


#		rand=$(($RANDOM % 4))
#		ln -sf "$TMPDIR"/image$rand.svg "$TMPDIR"/pix0.svg
#		ln -sf "$TMPDIR"/image$rand.svg "$TMPDIR"/pix$f.svg
	done
}; export -f funcpixRandomise

#
#MAIN
#

echo $TMPDIR

export MAIN_DIALOG='

<window title="DETAIL MESSAGE" icon-name="gtk-about" resizable="true" width-request="800" height-request="600" > 
	<vbox>
		<hbox space-fill="true" auto-refresh="true">
			<text><label> Aim for Thin OS!  </label></text>
		</hbox>
	<hbox>
		<timer>
			'"`functmrCreate 0`"'
		'"`funcpixCreate 0`"'
	</hbox>

	<vbox>
		<timer visible="false">
		<action type="refresh">_SYS_TIME</action>
		</timer>
	</vbox>
	</vbox>
</window>
'


eval `$GTKDIALOG --program=MAIN_DIALOG --center`



