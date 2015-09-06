#!/bin/bash

# This file is part of FUI.
# FUI is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3
# as published by the Free Software Foundation.
#
# FUI is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.  <http://www.gnu.org/licenses/>
#
# Author(s):
# © 2015 Kasra Madadipouya <kasra@madadipouya.com>


# $1 should be the path to compare images
counter='0';
fixname='dup'
filename0=$fixname$counter
echo 'Searching to find similar pictures'
findimagedupes $1 > $filename0
counter=`expr $counter + 1`
filename1=$fixname$counter
#spliting lines by space
echo 'Spliting filenames by space'
cat $filename0| tr " " "\n" > $filename1

counter=`expr $counter + 1`
filename2=$fixname$counter
echo 'Removing unnecessery lines'
#removing even line
awk 'NR%2==0' $filename1 > $filename2

echo 'Retrieving filename out of the path'
#spliting the filename from path and pushing to new file
counter=`expr $counter + 1`
filename3=$fixname$counter
while read -r line
do
   name=$line
   two= basename $name >> $filename3
   #echo $two >> $filename3
done < $filename2
counter=`expr $counter + 1`
filename4=$fixname$counter
echo 'Removing whitespace'
#removing blank line (no need)
grep -v "^$" $filename3 > $filename4

cat $filename3 > $filename4	
echo 'Sorting file'
#sorting file
counter=`expr $counter + 1`
filename5=$fixname$counter
sort -V $filename4 > $filename5

#reading last line of file and use it as counter
var=`tail -1 $filename5`
#separating extension
extension="${var##*.}"
var="${var%.*}"
echo "Counting image number in $1 folder"
echo "There are $var images"
counter=`expr $counter + 1`
filename6=$fixname$counter
#loop through the file and find those unique image names
echo "Finding unique images"
for (( c=1; c <= $var; c++ ))
do
   if [ "$var" == "$extension" ]
   then
   var1=`grep -Fx $c $filename5`
   else
   var1=`grep -Fx $c.$extension $filename5`
   fi
   if [ -z "$var1" ]
   then
	echo "Image [$c] is unqiue"    
	echo $c >> $filename6
   fi
done
rm -rvf $filename0 $filename1 $filename2 $filename3 $filename4 $filename5
echo "Finished!, please check $filename6 for list of unique image names!"
var3=`wc -l $filename6`
echo "Overall there are $var3 unique images found"
