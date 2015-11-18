#/usr/bin/env bash
mongoexport --port 5001 --db meteor --collection entries --type csv --fields _id,stamp,text --sort '{stamp:1}' >private/backup/entries_`date -u "+%Y-%m-%dT%H:%M:%SZ"`.csv

