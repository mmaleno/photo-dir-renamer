#!/bin/bash

# Usage: transfer.sh <photo_directory>
# Example: bash transfer.sh /home/me/Pictures/

# command to copy folders (without contents) of photos drive to an experimental folder
# rsync -a --include='*/' --exclude='*' Pictures/Photo-Drive/Photo-Library/ Repos/photo-dir-rename/Photo-Library/

years=($(seq 2000 1 2023)) # create array of possible years
months=(January February March April May June July August September October November December)
parent_dir=$2
parent_dir+="*/"

for dir in $parent_dir
do
    orig_dir=$dir
    name_year=""
    name_month=""
    name_day=""
    name_moment=""
    dir=${dir%*/}    # remove trailing /
    dir="${dir##*/}" # get everything after first /

    # searches dir for year
    for year in "${years[@]}"; do
        if [[ $dir = *$year* ]]
        then
            name_year=$year
        fi
    done

    # searches dir for month
    for i in "${!months[@]}"; do
        if [[ $dir = *${months[$i]}* ]]
        then
            name_month_word=${months[$i]}
            name_month=$(printf "%02d" $((i+1)))
        fi
    done

    # gets substring after month, then extracts number between space and comma
    name_day=${dir#*$name_month_word}
    name_day=$(temp=${name_day:1};echo ${temp%%,*})

    # convert day into two-digit number
    name_day=$(printf "%02d" $name_day)

    # determine if there is a moment name or not. moment name would occur before month, separated by comma
    # if theres a moment, there would be three commas in directory name. If no moment name, there'd be only two
    commas="${dir//[^,]}"
    if [ ${#commas} -eq 2 ]; then
        name_moment=${dir%%,*}
        #echo "name_moment = $name_moment"
        #name_moment="$(echo $name_moment | tr " " -)"
        #echo "name_moment = $name_moment"
        new_dir=$name_year-$name_month-$name_day" "$name_moment
    else
        new_dir=$name_year-$name_month-$name_day
    fi

    dest_dir=$2
    dest_dir+=$new_dir"/"
    
    mv "$orig_dir" "$dest_dir" 
done

echo "finished script"

