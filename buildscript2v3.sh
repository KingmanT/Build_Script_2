#!/bin/bash

# This script created by Kingman Tam for Build Script Exercise 2.  Script started on 08/06/22. Submitted on 08/11/22
#
# This script will check for system processes and ask the user to terminate a process if it excedes
# a certain amount of memory.
#
# UPDATE V2 08/10/22- user given the option to set own %memory consumption threshold
# bug fix: fixed issue where %mem threshold ($ans1) caused error if integer was not entered (e.g.- a word was entered)
#
# UPDATE V3 08/11/22- While loop implemented to allow user to terminate multiple processes as long as there are still processes above the set threshold
# 
# pending issues: - error where if anything other than a valid PID is entered, script will still try to kill $pid - Might make $process into array that user must select from
#		  - Want to omit gnome shell from list so that user will not be asked to kill Ubuntu.
#		  - Issues to be addressed in V4

echo "--------------------------------"
echo "This tool will check your system processes and"
echo "give you the option to terminate memory hungry ones"
echo "--------------------------------"
echo "Please enter threshold of % memory consumption (0-100) to continue or 'exit' to quit"
echo "--------------------------------"
read ans1
echo "--------------------------------"

if [[ $ans1 = "exit" ]]; then

echo "Exiting command"
exit 0

## =~ for regular expression; 0-9 for containing digits; ^ for beginning with; $ for ends with; + for everything in between 
elif [[ $ans1 =~ ^[0-9]+$ ]]; then

echo "These are currently the top 10 processes that are consuming the most memory on your system:"
echo "--------------------------------"
ps -eo user,pid,%cpu,%mem,comm --sort=-%mem | head -n 11
echo "--------------------------------"
read -p "Press enter to continue"
echo "--------------------------------"

else 
echo "Invalid option. Exiting command"
exit 1

fi

process=`ps -eo user,pid,%cpu,%mem,comm --sort=-%mem | head -n 11 | tail -n 10 | echo "$(awk '{if($4>'$ans1')print$5}')"`

if [[ -z $process ]]; then

echo "There are no processes consuming more than" $ans1"% memory"
echo "Exiting command"
echo "--------------------------------"

exit 0
fi

while [[ -n $process ]]; do

ps -eo user,pid,%cpu,%mem,comm --sort=-%mem | head -n 11 |  echo "$(awk '{if($4>'$ans1')print$2,$5}')" 
echo "--------------------------------"
echo "above process(es) is/are consuming more than" $ans1"% of memory.  Would you like to terminate any processes? (yes/no)" 
echo "--------------------------------"
read ans2
echo "--------------------------------"

ans2c=`echo $ans2 | cut -c 1 | tr [:upper:] [:lower:]`

if [[ $ans2c = "y" ]]; then

echo "Please enter PID of the process you would like to terminate" 
echo "--------------------------------"
read pid
echo "--------------------------------"
echo "Are you sure you want to terminate Process" $pid"? (yes/no)"
echo "--------------------------------"
read ans3
echo "--------------------------------"

else

echo "Exiting command"
echo "--------------------------------"

exit 0
fi

ans3c=`echo $ans3 |cut -c 1 | tr [:upper:] [:lower:]`

if [[ $ans3c = "y" ]]; then 

kill $pid
sleep 2
echo "Process" $pid "terminated"
echo "--------------------------------"
process=`ps -eo user,pid,%cpu,%mem,comm --sort=-%mem | head -n 11 | tail -n 10 | echo "$(awk '{if($4>'$ans1')print$5}')"`
sleep 2

else
echo "Exiting command"
exit 0
fi
 
done

echo "There are no more processes consuming more than" $ans1"% memory.  Exiting command"
echo "--------------------------------"

