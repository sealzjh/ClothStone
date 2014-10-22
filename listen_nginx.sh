#!/bin/bash
DADA_ERROR_LOG=/var/log/nginx/dada_error_log
LAST_LINE_LOG=/tmp/nginxerrorlinenum.log
ONE_SECOND_LOG=/tmp/tmpnginxerror.log
MAIL_SEND_PYFILE=/home/ubuntu/potter/mail_send.py
RECEIVER="tech@imdada.cn"

CURRENT_TIME=`date "+%Y-%m-%d %H:%M:%S"`

if [ -f "$DADA_ERROR_LOG" ];then
    LAST_LINENUM=`cat $LAST_LINE_LOG`
    CURRENT_LINENUM=`wc -l $DADA_ERROR_LOG|awk '{print $1}'`
    echo $CURRENT_LINENUM > $LAST_LINE_LOG
    TAIL_OFFSET=$((CURRENT_LINENUM - LAST_LINENUM))

    if [ $TAIL_OFFSET -gt 0 ];then
        echo $TAIL_OFFSET
        tail $DADA_ERROR_LOG -n$TAIL_OFFSET > $ONE_SECOND_LOG

        ERROR_NUM=`cat $ONE_SECOND_LOG |wc -l`
        ERROR_LOG=`cat $ONE_SECOND_LOG |awk 'gsub(/"/ , "\"" , $0) {print $0}'`

        if [ $ERROR_NUM -gt 0 ];then
            SUBJECT="Nginx error警告"
            CONTENT=${CURRENT_TIME}" Nginx error : "${ERROR_NUM}"<br><br>"${ERROR_LOG}
            python $MAIL_SEND_PYFILE "$RECEIVER" "$SUBJECT" "$CONTENT"

        fi
    fi
fi
