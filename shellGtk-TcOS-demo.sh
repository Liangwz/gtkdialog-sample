#!/bin/bash
	
#14/09/17 	1 add the fun setting mouse mode left hand or right hand.
#		2 add the label show time dynamic.
#		3 show the imformation about cpu and os.
#09.18		1 using eval to deal with variable instead of button action
#09.19		1 add widget checkbox
#0928		1 add widget imagebut & menubar

#mouse change: right==>xmodmap -e "pointer = 3 2 1"   left==>xmodmap -e "pointer = 1 2 3"
GTKDIALOG=gtkdialog 

export MOUSE_LEFT="xmodmap -e \"pointer = 1 2 3\""
export MOUSE_RIGHT="xmodmap -e \"pointer = 3 2 1\""
export CPUVAL=`cat /proc/cpuinfo |grep "model name"|cut -f2 -d:`
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

#HOSTNAME            LOCALEVAL        TIMEZONEVAL	UTCABL	KEYBOARLANGUAGEDVAL NUMLOCKVAL



functimeShow(){			
	echo '<variable>nowtime</variable>
		<action>bash -c funcgetTime</action>	
		<action type="refresh">time.tx</action>							
		</timer>'

	echo '<text>
		<variable export="false">time.tx</variable>
  		<input file>time.tx</input>
  		<input>cat time.tx</input> 
	</text>'
	
}
funcgetTime(){
	NOW=`date +%x-%H:%M:%S`
	echo $NOW > time.tx
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
				<menu image-name="'"$IMAGEFILE"'" label="Image from File">
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


export VIEW_MESSAGE_DIALOG='

<window title="DETAIL MESSAGE" icon-name="gtk-about" resizable="true" width-request="600" height-request="550" > 
	<vbox>
		<hbox space-fill="true" auto-refresh="true">
			<text><label> Aim for Thin OS!  </label></text>
		</hbox>

	</vbox>
</window>
'
echo ${CPUVAL}
export MAIN_DIALOG=' 

<window title="Thin Kiosk" icon-name="gtk-about" resizable="true" width-request="600" height-request="550"> 

<vbox> 
	<hbox>
		<vbox>
			'"`funcmenuCreate`"'
		</vbox>		
		<frame>

			<hbox> 
				<text><label> '"${CPUVAL}"'</label></text>
			</hbox> 
			<hbox> 
				<text><label> OS:'"${OS}"' </label></text>
			</hbox> 			
		
			<hbox>
				<text><label> Mouse </label></text>
				<comboboxtext>
					<variable>_CONF_MOUSE_TYPE</variable>
					<item>Left Hand</item>
					<item>Right Hand</item>
					<action>echo "$MOUSETYPE"</action>
					<action>echo hello</action>
				</comboboxtext>
			</hbox>
			
			<hbox>
				<text><label> HostName </label></text>
				<comboboxtext>
					<default>'"${_CONF_HOSTNAME}"'</default>
					<variable>_CONF_HOSTNAME</variable>		
					<item>Thin OS</item>
					<item>Thin Ubuntu</item>
					
				</comboboxtext>
			</hbox>
		
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
			<checkbox>
			<label>Using UTC</label>
			<variable>_CONF_UTC_IF_ENABLE</variable>
			</checkbox>
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
			<checkbox>
				<label>NumLock</label>
				<variable>_CONF_NUMLOCK_IF_ENABLE</variable>
				</checkbox>
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
				<text><label> Volume </label></text>
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
				<text><label> Network </label></text>
			</hbox>
			<hbox>
				<text><label> CRT OR DVI </label></text>
			</hbox>

		</frame>
	
	</hbox>

</vbox> 
</window> 
' 


eval `$GTKDIALOG --program=MAIN_DIALOG --center`
#eval `$GTKDIALOG --program=VIEW_MESSAGE_DIALOG --center`

echo ${_CONF_HOSTNAME}
echo ${_CONF_MOUSE_TYPE}
echo ${_CONF_LANGUAGE_LOCALE}
echo ${_CONF_TIME_ZONE}
echo CONF_UTC ${_CONF_UTC_IF_ENABLE}
echo ${_CONF_KEYBOARD_LAYOUT}
echo ${_CONF_NUMLOCK_IF_ENABLE}

##############method:button action###########
#			<input file stock="gtk-yes"></input>
#			<label>Application</label> 
#			<action>case "$MOUSETYPE" in "Left Hand") xmodmap -e "pointer = 1 2 3";; *) xmodmap -e "pointer = 3 2 1";; esac</action>
#<action>if [ "$MOUSETYPE"x = "Left Hand"x ];then  xmodmap -e "pointer = 1 2 3";else xmodmap -e "pointer = 3 2 1"; fi</action>
