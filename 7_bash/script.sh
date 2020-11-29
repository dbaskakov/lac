#!/bin/bash

#num of IP
X=5

# num of ADDRESSES
Y=5

#SET YOUR EMAIL
EMAIL=test@yandex.ru

LOG_PATH=/vagrant/access.log
MAIL_PATH=/tmp/mail.log
lockfile=/tmp/localfile

period() {
   echo "--Current Period--" >> $MAIL_PATH
   date0=$(date)
   date1=$(date --date '-60 min')
   echo $date1 '-' $date0 >> $MAIL_PATH
}

ip() {
   echo "---Uniq ip---" >> $MAIL_PATH
   cat $LOG_PATH | awk '{ print $1 }' | sort | uniq -c | sort -nr | head -n $X | column -t >> $MAIL_PATH
}

addr() {
   echo "---Uniq ADDR---" >> $MAIL_PATH
   cat $LOG_PATH | grep -E 'http../' | awk '{ print $11 }' | grep -v '^"-' | sort | uniq -c | sort -nr | head -n $Y | column -t >> $MAIL_PATH
}

error() {
   echo "---ERRORS---" >> $MAIL_PATH
   awk '{print $9}' $LOG_PATH | grep -P '^4|^5' | sort | uniq -c | sort -nr | column -t >> $MAIL_PATH

}

send_mail() {
   rm $MAIL_PATH || echo 'NO FILE'
   echo "Send mail!"
   period
   ip
   addr
   error
   > $LOG_PATH
   echo "MAIL_LOG" |  mail -s "Maillog" -a $MAIL_PATH $EMAIL
}

if ( set -o noclobber; echo "$$" > "$lockfile") 1> /dev/null;
  then
    trap 'rm -f "$lockfile"; exit $?' INT  TERM EXIT
    send_mail
    sleep 3
    rm -f "$lockfile"
    trap - INT TERM exit
  else
   echo "program running"
fi
