#!/bin/bash
# $1: filename, $2: bucketname
filename=$(echo $1 | sed 's\./\\')
aws2 s3 cp $1 s3://$2/$filename
rm -f $1
