#!/bin/bash
ticks=("✖" "✔")
printf ticks[true]
supervisorLogString=""
stretch=0
water=0
brain=0
stretchTotal=0
waterTotal=0
brainTotal=0
bold=$(tput bold)
normal=$(tput sgr0)
minutes=0
userInput=""
running=true
welcome="\nWelcome to work supervisor you can ${bold}[P]${normal}ause or ${bold}[F]${normal}inish at anytime.\n"

# Pause the supervisor
function pauseSupervisor {
    printf "\nWe are paused type any key to continue work supervisor"
    read -n 1
}

# End the supervisor
function endSupervisor {
    attempts=$(($minutes / 60))

    if [ $((100*$stretchTotal/$attempts)) -gt 80  ]
    then
        printf "\nStretch: ${stretchTotal}/$attempts times. Pass!"
    else
        printf "\nStretch: ${stretchTotal}/$attempts times. Fail!"
    fi

    if [ $((100*$brainTotal/$attempts)) -gt 80  ]
    then
        printf "\nBrain: ${brainTotal}/$attempts times. Pass!"
    else
        printf "\nBrain: ${brainTotal}/$attempts times. Fail!"
    fi

    if [ $((100*$waterTotal/$attempts)) -gt 80  ]
    then
        printf "\nWater: ${waterTotal}/$attempts times. Pass!"
    else
        printf "\nWater: ${waterTotal}/$attempts times. Fail!"
    fi
    running=false
}


while $running; do
    clear
    printf "$welcome"
    printf "$supervisorLogString"
    userInput=""

    # Increment the minutes and advise how long it has been running
    ((minutes=minutes+1))
    if [ $(($minutes / 60)) -gt 0 ] 
    then
        printf "It's been $(($minutes / 60)) Hours: "
        if [ "$brain" = 0 ]
        then 
            printf " Work your [B]rain; "
        fi
        if [ "$stretch" = 0 ]
        then 
            printf " [S]tretch; "
        fi
        if [ "$water" = 0 ]
        then 
            printf " Drink [W]ater; "
        fi
        printf "\n"
    fi

    # Check if its been 60 minutes of running
    if [ $(($minutes % 60)) == 0 ] && [ $(($minutes / 60)) -gt 1 ]
    then
        echo -ne '\007'
        supervisorLogString="${supervisorLogString} You completed $((($minutes / 60) - 1)) Hours: \t[${ticks[$water]}]Water \t[${ticks[$stretch]}]Stretch \t[${ticks[$brain]}]Brain \n"
        # Store the previous hour into file and add to string 
        if [ "$brain" = 1 ]
        then 
            ((brainTotal++))
        fi
        if [ "$stretch" = 1 ]
        then 
            ((stretchTotal++))
        fi
        if [ "$water" = 1 ]
        then 
            ((waterTotal++))
        fi
        # Reset the tasks at hand!
        stretch=0   
        water=0
        brain=0
    fi

    # Minute logging
    printf "You have been working for a total of $minutes Minutes.\n"
    # Check if its been 15 minutes of running
    if [ $(($minutes % 15)) == 0 ]
    then 
        echo -ne '\007'
        printf "Fix your posture and check you breathing!"
    fi

    # Alert if we are still fucking around with 15 minutes remaining
    if [ $(($minutes % 60)) == 45 ] 
    then 
        if [ $water == 0 ] || [ $brain == 0 ] || [ $stretch == 0 ]
        then 
            echo -ne '\007'
            echo -ne '\007'
            echo -ne '\007'
            printf "Only 15 minutes left to get stuff done!"
            printf "The more you do it the easier it gets!"
        fi
    fi

    # Listen for userinput 
    read -t 60 -n 1 userInput
    if [ ! -z $userInput ]
    then
        ((minutes=minutes-1))
        # tell supervisor we drank water stretched or worked our brain
        if [ $userInput == 'w' ] 
        then 
            water=1
        elif [ $userInput == 's' ] 
        then 
            stretch=1
        elif [ $userInput == 'b' ] 
        then 
            brain=1
        fi

        # BLOCKING RESPONSES
        # Pause the supervisor when clicking p
        if [ $userInput == 'p' ] 
        then 
            pauseSupervisor
        fi
        # End the supervisor when clicking f 
        if [ $userInput == 'f' ] 
        then 
            if [ "$brain" = 1 ]
            then 
                ((brainTotal++))
            fi
            if [ "$stretch" = 1 ]
            then 
                ((stretchTotal++))
            fi
            if [ "$water" = 1 ]
            then 
                ((waterTotal++))
            fi
            endSupervisor
        fi
    fi
done
