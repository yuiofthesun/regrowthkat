#! /bin/bash

#set -x

WORKDIR=$(pwd)
OUTSIDEDIR=$WORKDIR/world


#server.properties check
#testing whether server.properties exist and generating default one with whitelist and difficulty set to normal

if test -f "$OUTSIDEDIR/server.properties";

then

	ln -s $OUTSIDEDIR/server.properties $WORKDIR/server.properties ;


else

        cat > $OUTSIDEDIR/server.properties <<-LIMITSTRING
		#Minecraft server properties
	        #$(date)	
		generator-settings=
		op-permission-level=4
		allow-nether=true
		level-name=world
		enable-query=false
		allow-flight=false
		announce-player-achievements=true
		server-port=25565
		level-type=DEFAULT
		enable-rcon=false
		level-seed=
		force-gamemode=false
		server-ip=
		max-build-height=256
		spawn-npcs=true
		white-list=true
		spawn-animals=true
		hardcore=false
		snooper-enabled=true
		online-mode=true
		resource-pack=
		pvp=true
		difficulty=2
		enable-command-block=false
		gamemode=0
		player-idle-timeout=0
		max-players=20
		spawn-monsters=true
		view-distance=10
		motd=A Regrowth Server

LIMITSTRING

	ln -s $OUTSIDEDIR/server.properties $WORKDIR/server.properties ;

fi


# whitelist.json check

#checks if whitelist.json exists and if  parameters are given creates one. In both cases links the accessible files to be used correctly inside the container. Else exits.

if test -f "$OUTSIDEDIR/whitelist.json";

then 

	echo
	echo  "Whitelist exists and will be used."
	ln -s $OUTSIDEDIR/whitelist.json $WORKDIR/whitelist.json

elif test -n "$UUID" -a -n "$NAME";

then

	echo
	echo "whitelist doesn't exist and will now be generated with the parameters given."
	cat > $OUTSIDEDIR/whitelist.json <<-LIMITSTRING
		[
		  {
    			"uuid": "$UUID",
    			"name": "$NAME"
  		  }
		]
LIMITSTRING

	ln -s $OUTSIDEDIR/whitelist.json $WORKDIR/whitelist.json 

else

	echo
	echo "Please enter you Minecraft name and UUID by using \"docker run -e NAME=yourminecraftname -e UUID=yourminecraftUUID .... \""
	exit 1

fi



# ops.json check

#checks if ops.json exists and if parameters are given creates one. In both cases links the accessible files to be used correctly inside the container. Else exits. 


if test -f "$OUTSIDEDIR/ops.json";

then

	echo
	echo "Ops list exists and will be used."
	ln -s $OUTSIDEDIR/ops.json $WORKDIR/ops.json ;

elif test -n "$UUID" -a -n "$NAME";

then

	echo
	echo "Ops list doesn't exist and will now be generated with the parameters given."

	cat > $OUTSIDEDIR/ops.json <<-LIMITSTRING
                [
                  {
                        "uuid": "$UUID",
                        "name": "$NAME",
			"level": "4"
                  }
                ]
LIMITSTRING

	ln -s $OUTSIDEDIR/ops.json $WORKDIR/ops.json ;

else
 
         echo
         echo "Please enter you Minecraft name and UUID by using \"docker run -e NAME=yourminecraftname -e UUID=yourminecraftUUID .... \""
         exit 1

fi


# banned-ips.json check

#checks if banned-ips.json exists. If not creates an example file. In any case links accessible and inside files.

if test -f "$OUTSIDEDIR/banned-ips.json";

then

	echo
        echo "The ips banned will still be banned as per the banned-ips.json supplied."
        ln -s $OUTSIDEDIR/banned-ips.json $WORKDIR/banned-ips.json;

else

	echo
	echo "An example and future link file will now be generated."

	cat > $OUTSIDEDIR/banned-ips.json <<-LIMITSTRING
	       #[
  	       #   {
    	       #	"ip": "xxx.xxx.xxx.xxx",
    	       #	"created": "year-MM-DD HH:MM:SS +0000",
    	       #	"source": "opswhobanned",
    	       #	"expires": "howlong",
 	       #	"reason": "Banned by an operator or sumthin."
	       #  }
	       #] 

LIMITSTRING

	ln -s $OUTSIDEDIR/banned-ips.json $WORKDIR/banned-ips.json;

fi


# banned-players.json check

#checks if banned-players.json exists. If not creates an example file. In any case links accessible and inside files.

if test -f "$OUTSIDEDIR/banned-players.json";

then

	echo
        echo "The players banned will still be banned as per the banned-players.json supplied."
        ln -s $OUTSIDEDIR/banned-players.json $WORKDIR/banned-players.json;

else

	echo
        echo "An example and future link file will now be generated."

        cat > $OUTSIDEDIR/banned-players.json <<-LIMITSTRING
               #[
               #   {
               #        "uuid": "UUIDofbannedplayer",
	       #        "name": "nameofbannedplayer",	
               #        "created": "year-MM-DD HH:MM:SS +0000",
               #        "source": "opswhobanned",
               #        "expires": "howlong",
               #       "reason": "Banned by an operator or sumthin."
               #   }
               #] 
LIMITSTRING

	ln -s $OUTSIDEDIR/banned-players.json $WORKDIR/banned-players.json;

fi


exec java -Xms2048m -Xmx4096m -XX:PermSize=256m -jar forge-1.7.10-10.13.4.1558-1.7.10-universal.jar nogui
