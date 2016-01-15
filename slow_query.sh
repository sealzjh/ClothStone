#!/bin/bash
DAY=`date +"%Y%m%d"`
ACCESS_LOG=/data/log/mysql/mysql-slow.log-$DAY.gz
MAIL_SEND_PYFILE=/home/ubuntu/potter/mail_send.py
TMP_FILE=/tmp/tmpslow.log
#MYSQLSLA=/home/ubuntu/apps/mysqlsla-2.03/bin/mysqlsla
RECEIVER="tech@alan.cn"

if [ -f "$ACCESS_LOG" ];then
        zcat $ACCESS_LOG > $TMP_FILE
        NUM=`cat $TMP_FILE |awk '{if ($1 == "select" || $1 == "SELECT"){print $0}}'|wc -l`
        LOGC=`mysqldumpslow -s c -t 20 $TMP_FILE|awk '{print $0."<br>"}'`
#        LOGC=`$MYSQLSLA -lt slow -sf "+select" -top 20 $ACCESS_LOG`

    if [ $NUM -gt 0 ];then
        SUBJECT="线上slow query提醒"
        CONTENT=${DAY}" 线上slow query数量: "${NUM}"个<br><br>"${LOGC}
        python $MAIL_SEND_PYFILE "$RECEIVER" "$SUBJECT" "$CONTENT"
    fi
fi
