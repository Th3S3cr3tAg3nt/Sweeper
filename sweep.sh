function advancedMenu() {
    ADVSEL=$(whiptail --title "NMap Scan" --fb --menu "Choose an option" 15 60 4 \
        "1" "eth0" \
        "2" "wlan0" \
        "3" "wlan1" 3>&1 1>&2 2>&3)
    case $ADVSEL in
        1)
            echo "Fast Scanning Ethernet"
            INTERFACE="eth0"
        ;;
        2)
            echo "Fast Scanning WiFi"
            INTERFACE="wlan0"
        ;;
        3)
            echo "Fast Scanning WiFi"
            INTERFACE="wlan1"
        ;;
    esac
}

if [[ -z "$1" ]]; then
    advancedMenu
else
    INTERFACE=$1
fi

echo -n "Checking interface ${INTERFACE} exists ..."

if ip addr show | grep -q ${INTERFACE}; then
	echo " found"
else
	echo " NOT found."
	echo "Please use on the of these interfaces"
	ip link show
	echo "Exiting"
	echo -ne '\007'
	exit
fi

echo -n "Waiting for interface to have IP "

while ! ip addr show dev ${INTERFACE} | grep -q inet;
do
	echo -n "."
	sleep 1
done
echo ". done"

echo "Running nmap ..."

# NMAP options here.
# Remember to run as SUDO/root if the nmap options require it
nmap -F -v0 `ip -o -f inet addr show dev ${INTERFACE} | awk '/scope global/ {print $4}'` -oA `date '+%Y%m%d%H%M%S'`

status=$?

if [ $status -eq 0 ]
then
	echo "Nmap Completed Successfully"
	for i in {0..1}
	do
		echo -ne '\007'
		sleep 1
	done
	echo -ne '\007'
else
	echo "Nmap Failed"
	for i in {0..2}
	do
		for j in {0..2}
		do
			echo -ne '\007'
			sleep 0.1
		done
		sleep 0.5
	done
fi

