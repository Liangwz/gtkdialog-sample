#!/bin/bash
 
#aim:check the using of widget such as:combobox entry button and how to get the
#	data from entry. 
#using:user->test pwd->test
#problem:1 how to set the size of widget
#change:
#date :14.09.11
GTKDIALOG=gtkdialog 
export MAIN_DIALOG=' 

<window title="My Second Program" icon-name="gtk-about" resizable="true" width-request="250" height-request="200"> 

<vbox> 
	<hbox space-fill="true"> 
		<combobox>	 
			<variable>myitem</variable> 
			<item>First One</item> 
			<item>Second One</item> 
			<item>Third One</item> 
		</combobox> 
	</hbox> 
	<hbox> 
		<text><label>   USER </label></text>
		<entry><variable>entryID</variable></entry>
	</hbox> 
	<hbox> 
		<text><label> PASSWD </label></text>
		<entry><variable>entryPWD</variable></entry>
	</hbox> 
	<hbox> 
		<button> 
			<label>Login in</label> 
			
			<action>if [ "$entryID"x = "test"x -a "$entryPWD"x = "test"x ]; then zenity --text-info  --width=400 --height=20 --title "loginok" ; fi</action> 		
		</button> 
		<button> 
			<label>Cancel</label> 
			
	
		</button> 
	</hbox> 


<hseparator width-request="240"></hseparator> 


</vbox> 
</window> 
' 

case $1 in 
	-d | --dump) echo "$MAIN_DIALOG" ;; 
	*) $GTKDIALOG --program=MAIN_DIALOG --center ;; 

esac
