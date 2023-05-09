#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]; then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]; then
  echo "Invalid directory path provided"
  exit
fi

# [TASK 1]
targetDirectory=$1
destinationDirectory=$2

# [TASK 2]
echo "Target directory is $targetDirectory"
echo "Destination directory is $destinationDirectory"

# [TASK 3]
currentTS=$(date +%s)

# [TASK 4]
backupFileName="backup-[$currentTS].tar.gz"

# Debug : Print the backup filename
# echo "Backup filename is $backupFileName"

# We're going to:
# 1: Go into the target directory
# 2: Create the backup file
# 3: Move the backup file to the destination directory

# To make things easier, we will define some useful variables...

# [TASK 5]
origAbsPath=$(pwd)

# [TASK 6]
cd "$destinationDirectory" # <-
destDirAbsPath=$(pwd)

# Debug : Print destination directory absolute path
echo "Destination directory path is : $destDirAbsPath"

# [TASK 7]
cd "$origAbsPath" # <-
cd "$targetDirectory" # <-
targetDirAbsPath=$(pwd)

# Debug : Target absolute path
echo "Target directory absolute path path is : $targetDirAbsPath"

# [TASK 8]
# Query the yesterday timestamp by computing the difference in seconds
# relative to to day
yesterdayTS=$(($currentTS - 24 * 60 * 60))

# Debug : Yesterday date
# echo "Yesterday: $(date -r "$yesterdayTS")"

# Declared a variable (array) which will hold list of files to backup using tar
declare -a toBackup

# Navigate back to original path before creating backup files
cd "$origAbsPath"

for file in $(ls "$targetDirAbsPath") # [TASK 9]
do
  # [TASK 10]
  fullpath="$targetDirAbsPath/$file"
  # Use && [[ -f $fullpath ]] to test if is file to exclude directories
  if [[ $(date -r $fullpath +%s) > $yesterdayTS ]]; then
    # [TASK 11]
    toBackup+=("./$targetDirectory/$file")
  fi
done

# [TASK 12]
# # Compress an array of files
# # We use [@] to access all element of the array
tar -czvf $backupFileName ${toBackup[@]}

# [TASK 13]
mv -f $backupFileName "$destDirAbsPath"