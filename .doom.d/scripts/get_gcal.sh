#!/bin/bash
WGET=/usr/bin/wget
ICS2ORG="/home/lucas/.doom.d/scripts/ical2org"
ORGDIR="/home/lucas/Documents/org/agenda/gcal"

FILENAME=$1
URL=$2

ICSFILE="${ORGDIR}/${FILENAME}.ics"
ORGFILE="${ORGDIR}/${FILENAME}.org"

$WGET -O $ICSFILE $URL
$ICS2ORG < $ICSFILE > $ORGFILE

sed -i 's/#+FILETAGS:.*//' $ORGFILE
sed -i "s/unknown/${FILENAME}/" $ORGFILE
