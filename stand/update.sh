#!/bin/bash

FILE=~/fun/stand/stand.txt

if [ "$1" == "start" ]; then
    echo >> $FILE
    echo -n "$(date +%D),$(date +%s)," >> $FILE
elif [ "$1" == "end" ]; then
    tail -1 $FILE | grep '/' > /dev/null
    RET=$?
    if [ "$RET" != 0 ]; then
        echo "missing start!"
        exit 1
    fi 

    echo -n "$(date +%s)," >> $FILE
    t1=$(tail -1 $FILE | awk -F, '{print $2}')
    t2=$(tail -1 $FILE | awk -F, '{print $3}')
    diff=$((t2-t1))
    echo "$diff" >> $FILE
    echo >> $FILE
elif [ "$1" == "process" ]; then
    cur_d=
    diff_t=
    for row in $(cat $FILE); do
        d=$(echo $row | awk -F, '{print $1}')
        diff=$(echo $row  | awk -F, '{print $4}')

        if [ "$cur_d" == "$d" ]; then
            diff_t=$((diff_t+diff))
        else
            if [ "$cur_d" ]; then
                echo "$cur_d   -    $diff_t"
                cur_d=
            fi
            cur_d=$d 
            diff_t=$diff
        fi
    done
    if [ "$cur_d" ]; then
        echo "$cur_d   :    $(($diff_t/60))"
    fi
fi
