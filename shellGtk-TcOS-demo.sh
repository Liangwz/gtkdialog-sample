#!/bin/bash 
	
#14/09/17 	1 add the fun setting mouse mode left hand or right hand.
#		2 add the label show time dynamic.
#		3 show the imformation about cpu and os.
#
#

#mouse change: right==>xmodmap -e "pointer = 3 2 1"   left==>xmodmap -e "pointer = 1 2 3"
GTKDIALOG=gtkdialog 

export MOUSE_LEFT="xmodmap -e \"pointer = 1 2 3\""
export MOUSE_RIGHT="xmodmap -e \"pointer = 3 2 1\""
export CPUVAL=`cat /proc/cpuinfo |grep "model name"|cut -f2 -d:`
export OS=`uname -s`

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
		<text><label> Detail: </label></text>
		<text><label> '"${CPUVAL}"'</label></text>
		<text><label> OS:'"${OS}"' </label></text>
	</hbox> 

	<hbox>
		<text><label> Mouse </label></text>
		<combobox>
			<variable>MOUSETYPE</variable>
			<item>Left Hand</item>
			<item>Right Hand</item>
			<action>echo "$MOUSETYPE"</action>
			<action>echo hello</action>
		</combobox>
	</hbox>
	
	<hbox>
		<text><label> HostName </label></text>
		<combobox>
			<variable>HOSTNAME</variable>
			<item>Thin OS</item>
		</combobox>
	</hbox>

	<hbox>
		<text><label> Language Locale </label></text>
		<combobox>
			<variable>LOCALEVAL</variable>
			<item>USA</item>
			<item>CHINA</item>
		</combobox>
	</hbox>

	<hbox>
		<text><label> Time Zone </label></text>
		<combobox>
			<variable>TIMEZONEVAL</variable>
			<item>Africa/Abidjan</item>
			<item>Africa/Accra</item>
			<item>Africa/Addis_Ababa</item>			
			<item>America/Adak</item>			
			<item>America</item>	
			<item>America/Antigua</item>			
			<item>Asia/Chongqing</item>				
			<item>Asia/shanghai</item>			
			
					
		</combobox>
	</hbox>
	<hbox>
		<text><label> UTC </label></text>
		<combobox>
			<variable>UTCABL</variable>
			<item>Enable</item>
			<item>Disable</item>
		</combobox>
	</hbox>

	<hbox>
		<text><label> Keybord Language </label></text>
		<combobox>
			<variable>KEYBOARLANGUAGEDVAL</variable>
			<item>usa</item>
			<item>cHINA</item>
		</combobox>
	</hbox>

	<hbox>
		<text><label> NumLock </label></text>
		<combobox>
			<variable>NUMLOCKVAL</variable>
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
		<button> 
			<input file stock="gtk-yes"></input>
			<label>Application</label> 
			<action>case "$MOUSETYPE" in "Left Hand") xmodmap -e "pointer = 1 2 3";; *) xmodmap -e "pointer = 3 2 1";; esac</action>
		</button> 
		<button> 
			<input file stock="gtk-no"></input>
			<label>Cancel</label> 
			
	
		</button> 
	</hbox> 


<hseparator width-request="240"></hseparator> 

	<hbox>
		<timer interval="1">
		'"`functimeShow`"'	
	</hbox>

</vbox> 
</window> 
' 

case $1 in 
	-d | --dump) echo "$MAIN_DIALOG" ;; 
	*) $GTKDIALOG --program=MAIN_DIALOG --center ;; 

esac
#<action>if [ "$MOUSETYPE"x = "Left Hand"x ];then  xmodmap -e "pointer = 1 2 3";else xmodmap -e "pointer = 3 2 1"; fi</action>
$GTKDIALOG --program=VIEW_MESSAGE_DIALOG --center 
echo Now show me $MOUSETYPE

