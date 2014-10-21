#!/bin/bash
DAY=`date +"%Y%m%d" -d "-1 day"`
ACCESS_LOG=/data/log/mysql/mysql-slow.log
MAIL_SEND_PYFILE=/home/ubuntu/potter/mail_send.py
#MYSQLSLA=/home/ubuntu/apps/mysqlsla-2.03/bin/mysqlsla
RECEIVER="tech@imdada.cn"

if [ -f "$ACCESS_LOG" ];then

        NUM=`cat $ACCESS_LOG |awk '{if ($1 == "select" || $1 == "SELECT"){print $0}}'|wc -l`
        LOGC=`mysqldumpslow -s c -t 20 $ACCESS_LOG|awk '{print $0."<br>"}'`
#        LOGC=`$MYSQLSLA -lt slow -sf "+select" -top 20 $ACCESS_LOG`

    if [ $NUM -gt 0 ];then
        SUBJECT="线上slow query提醒"
        CONTENT=${DAY}"线上slow query数量: "${NUM}"个<br><br>"${LOGC}
        python $MAIL_SEND_PYFILE "$RECEIVER" "$SUBJECT" "$CONTENT"
    fi
fi
