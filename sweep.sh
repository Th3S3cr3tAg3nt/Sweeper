#INTERFACE="wlp2s0"
#INTERFACE="enp0s31f6"
INTERFACE=$1

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

