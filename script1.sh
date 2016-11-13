echo "   PID      USER   RSS COMMAND"
PIDS=($(ls /proc | grep [0-9] | sort -n))
NUM_PIDS=${#PIDS[@]}
for((i = 0; i < NUM_PIDS; i++)); do
   if [ -d "/proc/${PIDS[i]}" ]; then
	printf "% 6d" ${PIDS[i]}
	UID_LINE=$(grep "Uid:" /proc/${PIDS[i]}/status | cut -f 5)
	USER=$(grep "x:$UID_LINE" /etc/passwd | cut -d ":" -f -1)
	printf "% 10s" $USER 
   	RSS=$(cat /proc/${PIDS[i]}/status | grep VmRSS | sed 's/[^0-9]*//g')
   	printf "% 6d " $RSS
	COMMAND=$(cat /proc/${PIDS[i]}/cmdline)
	if (test -z "$COMMAND"); then
		COMMAND=$(cat /proc/${PIDS[i]}/status | grep "Name" | sed 's/.*\t//g')
		COMMAND=[$COMMAND]
	fi
   	echo $COMMAND | tr '\0' ' '
   fi
done
