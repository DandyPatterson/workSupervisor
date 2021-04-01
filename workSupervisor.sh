
minutes=0
running=false
welcome="
Hi, Welcome to work supervisor.
We will assign a task and work on it for 45 minutes checking posture and breath during then taking a 15 minute break to get up drink and stretch. After repeating 4 times we will take at least an hour break before starting again.

Get water, get coffee, smash one out in the bathroom, put away phone, close all tabs and get ready to focus."

clear
printf "$welcome"
printf "

[Press any key to begin]"
read -n 1
clear
printf "$welcome"
printf "

Assign the first task: "
read
running=true

while $running; do
    userInput=""
    # Increment the minutes and advise how long it has been running
    ((minutes=minutes+1))
    
    
    #end program
    if [ $minutes ==  225 ]
    then 
        printf "
It's been ${minutes} minutes. Great job, take at least an hour break. See you again tomorrow. \n"
running=false
    fi


    # Check the minutes see if they are 15 or 30
    if [ $(($minutes % 60)) ==  15 ] || [ $(($minutes % 60)) == 30 ]
    then 
        # echo -ne '\007'
        printf "
It's been ${minutes} minutes. Fix your posture and check you breathing!"
    fi
    if [ $(($minutes % 60)) ==  45 ]
    then 
        printf "
It's been ${minutes} minutes. Time for a break! Get some Water and Stretch \n"
    fi
    if [ $(($minutes % 60)) ==  0 ] && [ $minutes != 0 ]
    then 
        printf "
Break time is over whats our next task: 
"
        read
    fi
    if [ $(($minutes % 60)) ==  1 ]
    then 
        printf "
Lets do it!"
    fi
    read -t 1
done
