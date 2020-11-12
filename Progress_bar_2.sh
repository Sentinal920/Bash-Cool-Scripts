#!/bin/bash

# go to last line and print the empty progress bar
tput sc #save the current cursor position
tput cup $((`tput lines`-1)) 3 # go to last line
echo -n "[" # the next 5 lines just print the required stuff to make the bar
for i in $(seq 1 $((`tput cols`-10))); do
    echo -n "-"
done
echo -n "]"
tput rc # bring the cursor back to the last saved position


# the actual loop which does the script's main job
for i in $(seq 0 10 100); do
    # print the filled progress bar
    tput sc  #save the current cursor position
    doned=${i}  #example value for completed amount
    total=100   #example value for total amount

    doned=`echo $doned $total | awk '{print ($1/$2)}'` # the next three lines calculate how many characters to print for the completed amount
    total=`tput cols | awk '{print $1-10}'`
    doned=`echo $doned $total | awk '{print int(($1*$2))}'`


    tput cup $((`tput lines`-1)) 4 #go to the last line
    for l in $(seq 1 $doned); do #this loop prints the required no. of "="s to fill the bar
        echo -n "="
    done
    tput rc #bring the cursor back to the last saved position

    # the next 7 lines are to find the row on which the cursor is currently on to check if it 
    # is at the last line 
    # (based on the accepted answer of this question: https://stackoverflow.com/questions/2575037/)
    exec < /dev/tty
    oldstty=$(stty -g)
    stty raw -echo min 0
    tput u7 > /dev/tty
    IFS=';' read -r -d R -a pos
    stty $oldstty
    row=$((${pos[0]:2} - 1))


    # check if the cursor is on the line before the last line, if yes, clear the terminal, 
    # and make the empty bar again and fill it with the required amount of "="s
    if [ $row -gt $((`tput lines`-2)) ]; then
        clear
        tput sc
        tput cup $((`tput lines`-1)) 3
        echo -n "["

        for j in $(seq 1 $((`tput cols`-10))); do
            echo -n "-"
        done
        echo -n "]"
        tput cup $((`tput lines`-1)) 4
        for k in $(seq 1 $doned); do
            echo -n "="
        done
        tput rc
    fi

    # this is just to show that the cursor is behaving correctly
    read -p "Do you want to continue? (y/n)" yn;  

done

 # the next few lines remove the progress bar after the program is over   
tput sc # save the current cursor position
tput cup $((`tput lines`-1)) 3 # go to the line with the progress bar
tput el # clear the current line
tput rc # go back to the saved cursor position
