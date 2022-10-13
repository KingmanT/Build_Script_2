
#!/bin/bash

# This script created by Kingman Tam for Build Script Exercise 2.  Script started on 08/06/22.
# This script will:
# 1. Check for system processes.
# 2. Ask the user to terminate a process if the process exceeds a certain amount of memory.
# 3. You may use firefox (open some tabs) to test out your script
# 4. You must have have a header in your script.
# 5. You must document anything that will break your script.

## cat /proc/meminfo | grep MemA | awk -F ":" '{print $2}'
## ps -eo user,pid,%cpu,%mem,comm --sort=-%mem | head -n 10
## ps -eo %mem --sort=-%mem | head -n 11 | tail -n10 | awk '{if($1>10)print$1}'


echo "--------------------------------"
echo "This tool will check your system processes and"
echo "give you the option to terminate memory hungry ones"
echo "--------------------------------"
echo "enter 'yes' to procede, 'no' to exit"
echo "--------------------------------"

read ans1
echo "--------------------------------"


ans1c=$(echo $ans1 | cut -c 1 | tr [:upper:] [:lower:] )

if [[ $ans1c = "y" ]];

then
echo "These are currently the top 10 processes that are consuming the most memory on your system:"
echo "--------------------------------"
ps -eo user,pid,%cpu,%mem,comm --sort=-%mem | head -n 11
echo "--------------------------------"
read -p "Press enter to continue"
echo "--------------------------------"
ps -eo user,pid,%cpu,%mem,comm --sort=-%mem | head -n 11 |  echo "$(awk '{if($4>5)print$2,$5}')" 
echo "--------------------------------"

else

echo "Exiting command"
echo "--------------------------------"

exit 0

fi

process=`ps -eo user,pid,%cpu,%mem,comm --sort=-%mem | head -n 11 | tail -n 10 | echo "$(awk '{if($4>5)print$5}')"`

if [[ -z $process ]];

then

echo "There are no processes consuming more than 5% memory"
echo "Exiting command"
echo "--------------------------------"

exit 0

else

echo "above process(es) is/are consuming more than 5% of memory.  Would you like to terminate any processes? (yes/no)" 
echo "--------------------------------"

read ans2
echo "--------------------------------"
fi

ans2c=`echo $ans2 | cut -c 1 | tr [:upper:] [:lower:]`

if [[ $ans2c = "y" ]];

then

echo "Please enter PID of the process you would like to terminate" 
echo "--------------------------------"
read pid
echo "--------------------------------"
echo "Are you sure you want to terminate Process" $pid"? (yes/no)"
echo "--------------------------------"
read ans3
echo "--------------------------------"

fi

ans3c=`echo $ans3 |cut -c 1 | tr [:upper:] [:lower:]`

if [[ $ans3c = "y" ]];

then 

kill $pid
echo "Process" $pid "terminated.  Exiting command."
echo "--------------------------------"
else

echo "Exiting command"

exit 0

fi
 
if [[ $ans2c != "y" ]];
then
echo "Exiting command"
echo "--------------------------------"

exit 0

fi


