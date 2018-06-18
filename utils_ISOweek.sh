#!/bin/bash

p_year(){
    # p function for calculating how many ISO weeks for a given year
    # Ref: https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
    year=$1
    sum=$(( year + year / 4 - year / 100 + year / 400 ))
    mod=$(( sum % 7))
    return $mod
}
calc_num_of_weeks(){
    # calculating how many ISO weeks for a given year
    # Ref: https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
    year=$1
    p_year $year
    p_year_val1=$?
    p_year $(( year - 1))
    p_year_val2=$?
    if [ $p_year_val1 -eq 4 ] || [ $p_year_val2 -eq 3 ]
    then
        return 53
    else
        return 52
    fi
}
week_plus(){
    week=$1
    delta=$2
    if [ $delta -gt 53 ] || [ $delta -lt -53 ]
    then
        echo "currently the function only supports plus/minus within 53 weeks"
        exit
    fi
    IFS='-' read -ra arr <<< "$week"
    yy=${arr[0]}
    ww=${arr[1]}
    calc_num_of_weeks $yy
    week_num=$?
    new_ww=$(( ww + delta ))
    new_yy=$yy
    if [ $new_ww -gt $week_num ]
    then
        new_yy=$(( yy + new_ww / week_num ))
        new_ww=$(( new_ww % week_num ))
    elif [ $new_ww -le 0 ]
    then
        new_yy=$(( yy + new_ww / week_num - 1))
        calc_num_of_weeks $new_yy
        prev_week_num=$?
        prev_ww=$(( new_ww + prev_week_num ))
    fi
    echo $new_yy"-"$new_ww  
}

## testing the number of weeks for each year
for((yy=2000;yy<2050;yy++))
do
    calc_num_of_weeks $yy
    num_week=$?
    if [ $num_week -eq 53 ]
    then 
        echo $yy
    fi
done

## testing week plus/minus
## only supports operations within 53 weeks
wk="2015-48"
for((dt=-53;dt<54;dt++))
do
    next_week=$(week_plus $wk $dt)
    echo $dt, $next_week
done

