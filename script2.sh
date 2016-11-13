#!/bin/bash

SCRIPT_PATH=$1

rm -f /tmp/lab4_main.txt
rm -f /tmp/lab4_modules.txt
rm -f /tmp/lab4_other.txt

for file in $(find $SCRIPT_PATH -name '*.c'); do
	if grep -q "\(int\|void\) main" "$file"; then 
		PRINTFS=($(cat $file | grep -e "[^f]printf"))
		FPRINTFS=($(cat $file | grep -e "fprintf"))
		echo "$PWD/$file:${#PRINTFS[@]},${#FPRINTFS[@]}" >> /tmp/lab4_main.txt
	elif grep -q "\(int\|void\) init_module" "$file"; then
		LINES=""
		while read -r printk; do
			NEWLINE=($(echo "$printk" | sed 's/[^0-9]*//g'))
			if [ "$LINES" == "" ]; then 
				LINES=$NEWLINE
			else
				LINES="$LINES,$NEWLINE"
			fi
		done < <(cat $file | grep -n printk)
		echo "$PWD/$file:$LINES" >> /tmp/lab4_modules.txt
	else 
		echo "$PWD/$file" >> /tmp/lab4_other.txt
	fi
done

echo "Main Files:"
if [ -s /tmp/lab4_main.txt ]; then
	cat /tmp/lab4_main.txt
else
	echo 'No main file'
fi
echo "Modules Files:"
if [ -s /tmp/lab4_modules.txt ]; then
	cat /tmp/lab4_modules.txt
else
	echo 'No module file'
fi
echo "Other Files:"
if [ -s /tmp/lab4_other.txt ]; then
	cat /tmp/lab4_other.txt
else
	echo 'No other file'
fi
