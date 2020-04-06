#!/bin/sh
#
# https://www.youtube.com/watch?v=hnT4WTz9dR8
# 
# FNR - File Number (which resets on new file, NR doesn't)
#
#
# this script is to update new customer information. I was not given associated emails in 
# updated csv, only customer names. In Mailchimp for all customers with that 
# company name the property had to be updated. 
#
# ideally it would update a
#
#
# (File 1 - fresh data) 
#
# Column Headers are required (first data row otherwise will not work properly)
#
#    Column 1          Column 2
#
# | (PK) Customer Name |     Status (new)    |
#
# (File 2 - old data that needs to be refreshed from File 1) 
#
# | Email Address      |     Status (old)    |   (PK) Customer Name  | 
#
#
echo "Enter the file name of updated csv provided by client to be imported: "
read file1
echo "Enter the file name of client's mailchimp csv than needs to be updated: "
read file2
#
# The first part reads in file 1 into an array while FNR=NR, which means
# which returns false when awk starts reading the second file because FNR
# equals 1 at that point. Now we can start comparing column x pointer
# (Customer Name or Status - fresh data) with (Customer Name - old data)
#
# # a[$3] represents column 2 of file 1
#
# so... look at a given column x, does $3 exist in that column?
# if so we have match on customer name... print email address, new status, customer name,
# and prepend 1337 to differentiate the match in the overall output
# 
# then output to csv (delimited by commas)
awk ' 
	FS = ","
	FNR == NR {
	  a[$1] = a[$1]$2
	  next
	}
	OFS = ","
	{ for (column in a) {
	        if (column=$3) {
	       	print "1337", $1, a[$3], $3
                break	}}}
' $file1 $file2 | awk -F "," '$1~/1337/ {print $2,$3,$4}' OFS=","  > updatedlist.csv
#awk '{split($0,a)}'
#awk '{print $1, $2, $3}'
