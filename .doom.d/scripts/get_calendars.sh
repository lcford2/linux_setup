#!/bin/bash

echo "$(date): Calendars Retrieved" >> /home/lucas/.doom.d/scripts/get_calendars.log

GETGCAL=/home/lucas/.doom.d/scripts/get_gcal.sh

FILENAME="work"
URL="https://calendar.google.com/calendar/ical/lcford2%40ncsu.edu/private-d5e99ba8a2495ea7be4d026224c84579/basic.ics"

$GETGCAL $FILENAME $URL

FILENAME="finances"
URL="https://calendar.google.com/calendar/ical/as6njklct2jcku4fs3meqeli9c%40group.calendar.google.com/private-eb8cb035d2a6d24aed54749114d08db7/basic.ics"

$GETGCAL $FILENAME $URL

FILENAME="joint"
URL="https://calendar.google.com/calendar/ical/foreverford2020%40gmail.com/private-272090c901dc34b5a262b390007d6886/basic.ics"

$GETGCAL $FILENAME $URL

FILENAME="personal"
URL="https://calendar.google.com/calendar/ical/lcford185%40gmail.com/private-f7fd803b152d4c351b5946e5a4e1ff94/basic.ics"

$GETGCAL $FILENAME $URL
