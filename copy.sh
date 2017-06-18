ls -a | egrep --exclude="git" '^\.[a-z]' |  while read -r line ; do
     echo "Processing $line"
     # cp $line  ~/
done
