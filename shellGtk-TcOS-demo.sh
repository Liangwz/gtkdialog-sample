#!/bin/bash
	
#14/09/17 	1 add the fun setting mouse mode left hand or right hand.
#		2 add the label show time dynamic.
#		3 show the imformation about cpu and os.
#09.18		1 using eval to deal with variable instead of button action
#09.19		1 add widget checkbox
#0928		1 add widget imagebut & menubar
#home-pc
#1008		1 add widget vscale.
#		2 finish the volume change for PCM && done the mouse type change.
#1010		1 create temp file instead of time.tx for time record
#		2 add condition requirement
#
#
#mouse change: right==>xmodmap -e "pointer = 3 2 1"   left==>xmodmap -e "pointer = 1 2 3"
GTKDIALOG=gtkdialog 

##amixer get PCM | grep " \[" | head -1|cut -d [ -f 2|cut -d % -f 1   ##get the voluma value
export _RESOLUTION_VALUE=`xrandr | head -1 | cut -d ' ' -f 8-10|sed 's/,//g' | sed 's/ //g'`
export _SCREEN_WIDGH=`echo ${_RESOLUTION_VALUE}|cut -d 'x' -f 1`
export _SCREEN_HEIGHT=`echo ${_RESOLUTION_VALUE}|cut -d 'x' -f 2`
export _RESOLUTION_SET="xrandr -s 1280x768"
export VOLUME_SET="amixer set PCM "
export VOLUME_SET_50="amixer set PCM 50%"
export MOUSE_LEFT="xmodmap -e \"pointer = 1 2 3\""
export MOUSE_RIGHT="xmodmap -e \"pointer = 3 2 1\""
export CPUVAL=`cat /proc/cpuinfo |grep "model name"|cut -f2 -d:`
export _VOLUME_VALUE=`amixer get PCM | grep " \[" | head -1|cut -d [ -f 2|cut -d % -f 1`
#export CPUVAL="intell E5500"
export OS=`uname -s`
export _GTKDIALOG="gtkdialog"
#export _WIFI_NAME=`iwconfig|grep -m 1 'IEEE 802.11'|cut -d ' ' -f 1`
#export _WIFI_IP=`ip addr|grep -A 2 wlan1:|grep 'inet '|cut -d " " -f 6|sed 's/addr://'`
export _WIFI_MODE="managed"
export _WIFI_ENCRYPTION="none"
export _WIFI_ESSID="GUEST"
export _WIFI_KEY="password"


IMAGEFILE="`find /usr/share/pixmaps -maxdepth 1 -type f | head -1`"

export _CONF_MOUSE_TYPE="Left"
export _CONF_HOSTNAME="TC OS"
export _CONF_LANGUAGE_LOCALE="USA"
export _CONF_TIME_ZONE="USA"
export _CONF_UTC_IF_ENABLE="noset"
export _CONF_KEYBOARD_LAYOUT="USA"
export _CONF_NUMLOCK_IF_ENABLE="enable"
export _CONF_RESOLUTION="none"


echo $_VOLUME_VALUE
echo ${_RESOLUTION_VALUE}
echo ${_SCREEN_WIDGH}
echo ${_SCREEN_HEIGHT}

if [ ${_SCREEN_WIDGH} == "0" ];then
	_SCREEN_WIDGH=800
	_SCREEN_HEIGHT=600
fi


## Get major/minor/micro version of an application.
## On entry: $1 = command
##           $2 = index into string to locate version
##  On exit: Initialises major/minor/micro_versionfuncAppVersionGet "$GTKDIALOG -v" 2
funcAppVersionGet() {
	local field
	local index=0

	for field in `$1`; do
		if [ $index -eq $2 ]; then break; fi; index=$((index + 1))
	done
	major_version=${field%%.*}; field=${field#*.}
	minor_version=${field%%.*}
	micro_version=${field#*.}
}


#HOSTNAME            LOCALEVAL        TIMEZONEVAL	UTCABL	KEYBOARLANGUAGEDVAL NUMLOCKVAL

## ----------------------------------------------------------------------------
## Local Functions
## ----------------------------------------------------------------------------

## Enable the embedding of comments within the XML.
Comment() { :; }


##add vscale widget 
funcscaType0Create() {
	echo '<'$2'scale width-request="'$3'" height-request="'$4'" range-value="'${_VOLUME_VALUE}'">
			<variable>_VOLUME_VALUE</variable>
		</'$2'scale>
		<'$2'separator></'$2'separator>'
}
#funcscaType0Create() {
#	echo '<'$2'scale width-request="'$3'" height-request="'$4'" range-value="4">
#			<variable>'$1'</variable>
#			<action>echo "'$1' changed to $'$1'"</action>
#		</'$2'scale>
#		<'$2'separator></'$2'separator>'
#}
##SHELL COMMAND EXECUTE
execute ()
{
	$* >/dev/null
	if [ $? -ne 0 ]; then
		echo
		echo "ERROR: executing $*"
		echo
		exit 1
	fi
}

functimeShow(){			
	echo '<variable>nowtime</variable>
		<action>bash -c funcgetTime</action>	
		<action type="refresh">'${TEMP_FILE_TIME}'</action>							
		</timer>'

	echo '<text>
		<variable export="false">'${TEMP_FILE_TIME}'</variable>
  		<input file>'${TEMP_FILE_TIME}'</input>
  		<input>cat '${TEMP_FILE_TIME}'</input> 
	</text>'
	
}
funcgetTime(){
	NOW=`date +%x-%H:%M:%S`
	echo $NOW > ${TEMP_FILE_TIME}
}; export -f funcgetTime


funcimagebtnCreate() {
	echo '<button image-position="'$1'" homogeneous="'$2'">
					<label>'$3'</label>
					<input file stock="'$3'"></input>
					<action>""</action>
				</button>'
}

funcmenuCreate() {
	echo '<vbox spacing="0">
		<menubar>
			<menu use-underline="true">
				<menuitem stock-id="gtk-quit" accel-key="0x51" accel-mods="4">
					<action>exit:Quit</action>
				</menuitem>
				<label>"_File"</label>
			</menu>
			<menu label="_Other" use-underline="true">
				<menuitem stock-id="gtk-home" label="Stock Icon"></menuitem>
				<menuitemseparator></menuitemseparator>
				<menu image-name="'"${IMAGEFILE}"'" label="Image from File">
					<menu icon-name="gimp" label="Theme Icon">
						<menuitem label="Label Only"></menuitem>
					</menu>
					<height>16</height>
					<width>16</width>
				</menu>
			</menu>
		</menubar>
	</vbox>'
}

funcexpander(){

	echo '		<expander expanded="false" use-underline="true">
			<vbox>
				<hbox>
					<checkbox  active="false">
					<label>Using UTC</label>
					<variable>_CONF_UTC_IF_ENABLE</variable>
					</checkbox>					
				</hbox>
				<hbox>
					<checkbox>
					<label>NumLock</label>
					<variable>_CONF_NUMLOCK_IF_ENABLE</variable>
					</checkbox>
				</hbox>
			</vbox>
			<label>e_xpander</label>
			<variable>exp0</variable>
		</expander>'
}



## ----------------------------------------------------------------------------
## Main
## ----------------------------------------------------------------------------

## Check requirements.
if [ ! `command -v $GTKDIALOG` ]; then
	echo "Couldn't find $GTKDIALOG"
	exit 1
fi
funcAppVersionGet "$GTKDIALOG -v" 2
if [ $minor_version -ge 8 -a $micro_version -ge 3 ]; then
	true
else
	echo "Couldn't find $GTKDIALOG >= 0.8.3"
	exit 1
fi

## Create a temporary file for time.
export TEMP_FILE_TIME=`mktemp  time.XXXXXXXX`
if [ $? -ne 0 ]; then
	echo "Couldn't create temporary directory."
	exit 1
fi


export VIEW_MESSAGE_DIALOG='

<window title="DETAIL MESSAGE" icon-name="gtk-about" resizable="true" width-request="800" height-request="750" > 
	<vbox>
		<hbox space-fill="true" auto-refresh="true">
			<text><label> Aim for Thin OS!  </label></text>
		</hbox>

	</vbox>
</window>
'
echo ${CPUVAL}
##remove the window biger smaller and close optional --> decorated="false"


export MAIN_DIALOG=' 
<window title="Thin Kiosk" icon-name="gtk-about" resizable="true" width-request="'${_SCREEN_WIDGH}'" height-request="'${_SCREEN_HEIGHT}'"> 

<vbox> 
'`Comment ##
##the comment test
`'
		<vbox>
			'"`funcmenuCreate`"'
		</vbox>	
		<vbox>
			'"`funcexpander`"'
		</vbox>	

	<hbox>
<notebook labels="Checkbox|Radiobutton">	
		<frame>
			<frame>
			<hbox> 
				<text><label> '"${CPUVAL}"'</label></text>
			</hbox> 
			<hbox> 
				<text><label> OS:'"${OS}"' </label></text>
			</hbox> 
			</frame>
'`Comment ##
##the comment test	
##
##
`'
			<frame>
			<hbox>
				<text><label> Mouse </label></text>
				<comboboxtext>
					<variable>_CONF_MOUSE_TYPE</variable>
					<item>Left Hand</item>
					<item>Right Hand</item>
					<action>echo "${MOUSETYPE}"</action>
					<action>echo "hello"</action>
				</comboboxtext>
			</hbox>
			</frame>
			<frame>
			<hbox>
				<text><label> HostName </label></text>
				<comboboxtext>
					<default>'"${_CONF_HOSTNAME}"'</default>
					<variable>_CONF_HOSTNAME</variable>		
					<item>Thin OS</item>
					<item>Thin Ubuntu</item>
					
				</comboboxtext>
			</hbox>
			</frame>		
			<hbox>
				<text><label> Language Locale </label></text>
				<comboboxtext>
					<variable>_CONF_LANGUAGE_LOCALE</variable>
					<item>USA</item>
					<item>CHINA</item>
				</comboboxtext>
			</hbox>
		
			<hbox>
				<text><label> Time Zone </label></text>
				<comboboxtext>
					<variable>_CONF_TIME_ZONE</variable>
					<item>Africa/Abidjan</item>
					<item>Africa/Accra</item>
					<item>Africa/Addis_Ababa</item>			
					<item>America/Adak</item>			
					<item>America</item>	
					<item>America/Antigua</item>			
					<item>Asia/Chongqing</item>				
					<item>Asia/shanghai</item>			
					
							
				</comboboxtext>
			</hbox>
		
			<hbox>
				<text><label> Keybord Language </label></text>
				<comboboxtext>
					<variable>_CONF_KEYBOARD_LAYOUT</variable>
					<item>USA</item>
					<item>CHINA</item>
				</comboboxtext>
			</hbox>

			<hbox>
				<text><label> NumLock </label></text>
				<combobox>
					<variable>_CONF_NUMLOCK_IF_ENABLE</variable>
					<item>Enable</item>
					<item>Disable</item>
				</combobox>
			</hbox>
			<hbox>
				<text><label> Resolution '${_RESOLUTION_VALUE}'</label></text>
				<comboboxtext>
					<variable>_CONF_RESOLUTION</variable>
					<item>'${_RESOLUTION_VALUE}'</item>
					<item>800x600</item>
					<item>1024x768</item>
					<item>1152x864</item>			
					<item>1280x600</item>			
					<item>1280x720</item>	
					<item>1280x768</item>			
					<item>1280x800</item>				
					<item>1440X900</item>			
					
							
				</comboboxtext>
			</hbox>
			
			<hbox>
				<text><label> Network </label></text>
			</hbox>
			<hbox>
				<text><label> CRT OR DVI </label></text>
			</hbox>
		
		 
			<hbox> 
		      		<button cancel></button>
				<button ok></button>				
			</hbox> 
		
		
			<hseparator width-request="240"></hseparator> 
		
			<hbox>
				'"`funcimagebtnCreate 0 true gtk-print`"'
			</hbox>
			<hbox>
				<timer interval="1">
				'"`functimeShow`"'	
			</hbox>
		</frame>
		<frame>
			<hbox>
				<text><label> Volume </label></text>
			</hbox>
			<hbox>
				'"`funcscaType0Create vscVScale0 v 50 100`"'
			</hbox>	
			<hbox>
				<text><label> Network </label></text>
			</hbox>
			<hbox>
				<text><label> CRT OR DVI </label></text>
			</hbox>

		</frame>
	</notebook>
	</hbox>

</vbox> 
<action signal="delete-event">bash -c "echo 'delete-event'>'${TEMP_FILE_TIME}'"</action>
</window> 
' 


eval `$GTKDIALOG --program=MAIN_DIALOG --center`
#eval `$GTKDIALOG --program=VIEW_MESSAGE_DIALOG --center`

echo ${_CONF_HOSTNAME}
echo ${_CONF_MOUSE_TYPE}
if [ "${_CONF_MOUSE_TYPE}" == "Left Hand" ]; then
	echo "show left hand"
	echo $MOUSE_LEFT
#	execute $MOUSE_LEFT
	sudo xmodmap -e "pointer = 1 2 3"

elif [ "${_CONF_MOUSE_TYPE}" == "Right Hand" ]; then
	echo "show ${_CONF_MOUSE_TYPE}"
	execute $MOUSE_RIGHT
else
	echo "unknow :${_CONF_MOUSE_TYPE} "
fi

echo ${_CONF_LANGUAGE_LOCALE}
echo ${_CONF_TIME_ZONE}
case ${_CONF_TIME_ZONE} in
	"china"|"CHINA")
	echo "${_CONF_TIME_ZONE}!"
	;;
	"America"|"USA")
	echo "${_CONF_TIME_ZONE}!"
	;;
	*)
	echo "nothing else"
	;;
esac
echo Volume ${_VOLUME_VALUE}	
if [ ${_VOLUME_VALUE} == 101 ];then #if volume is unchange
	echo "volume unchange."	
else
	echo "set volume to be ${_VOLUME_VALUE}"
	sudo amixer set PCM ${_VOLUME_VALUE}%
fi

case ${_CONF_RESOLUTION} in
	"800x600")
	echo "${_CONF_RESOLUTION}!"
	sudo xrandr -s 800x600
	;;
	"1024x768")
	echo "${_CONF_RESOLUTION}!"
	sudo xrandr -s 1024x768
	;;
	"1152x864")
	echo "${_CONF_RESOLUTION}!"
	sudo xrandr -s 1152x864
	;;
	"1280x600")
	echo "${_CONF_RESOLUTION}!"
	sudo xrandr -s 1280x600
	;;
	"1280x720")
	echo "${_CONF_RESOLUTION}!"
	sudo xrandr -s 1280x720
	;;
	"1280x768")
	echo "${_CONF_RESOLUTION}!"
	sudo xrandr -s 1280x768
	;;
	"1280x800")
	echo "${_CONF_RESOLUTION}!"
	sudo xrandr -s 1280x800
	;;
	"1440x900")
	echo "${_CONF_RESOLUTION}!"
	sudo xrandr -s 1440x900
	;;

	*)
	echo "nothing else"
	;;
esac


echo CONF_UTC ${_CONF_UTC_IF_ENABLE}
echo ${_CONF_KEYBOARD_LAYOUT}
echo ${_CONF_NUMLOCK_IF_ENABLE}
rm  $TEMP_FILE_TIME
##############method:button action###########
#			<input file stock="gtk-yes"></input>
#			<label>Application</label> 
#			<action>case "$MOUSETYPE" in "Left Hand") xmodmap -e "pointer = 1 2 3";; *) xmodmap -e "pointer = 3 2 1";; esac</action>
#<action>if [ "$MOUSETYPE"x = "Left Hand"x ];then  xmodmap -e "pointer = 1 2 3";else xmodmap -e "pointer = 3 2 1"; fi</action>
