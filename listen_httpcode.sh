#!/bin/bash

HTTP_CODE_LOG=/home/ubuntu/potter/code.log
DADA_ACCESS_LOG=/var/log/nginx/dada_access_log
LAST_LINE_LOG=/home/ubuntu/potter/linenum
MAIL_SEND_PYFILE=/home/ubuntu/potter/mail_send.py
ONE_SECOND_LOG=/home/ubuntu/potter/one_second.log
RECEIVER="tech@imdada.cn"

CURRENT_TIME=`date "+%Y-%m-%d %H:%M:%S"` 

if [ -f "$DADA_ACCESS_LOG" ];then

    LAST_LINENUM=$(cat $LAST_LINE_LOG)
    CURRENT_LINENUM=`wc -l $DADA_ACCESS_LOG | awk '{print $1}'`
    echo $CURRENT_LINENUM > $LAST_LINE_LOG
    TAIL_OFFSET=$(( CURRENT_LINENUM - LAST_LINENUM ))
    echo $TAIL_OFFSET

    # new version
    tail $DADA_ACCESS_LOG -n$TAIL_OFFSET > $ONE_SECOND_LOG
    cat $ONE_SECOND_LOG | awk '{print $9}' > $HTTP_CODE_LOG

    SEC_502_LOG=`cat $ONE_SECOND_LOG | awk '{if ($9 == 502) {print $0}}'`
    SEC_500_LOG=`cat $ONE_SECOND_LOG | awk '{if ($9 == 500) {print $0}}'`

    CODE_502_NUM=`cat $ONE_SECOND_LOG | awk '{if ($9 == 502) {print $0}}' | wc -l`
    CODE_500_NUM=`cat $ONE_SECOND_LOG | awk '{if ($9 == 500) {print $0}}' | wc -l`

    if [ $CODE_502_NUM -gt 0 ];then
        SUBJECT="线上502警告"
        CONTENT=${CURRENT_TIME}" 线上502数量 : "${CODE_502_NUM}"个<br>"${SEC_502_LOG}
        python $MAIL_SEND_PYFILE "$RECEIVER" "$SUBJECT" "$CONTENT"
    fi
    echo ${CURRENT_TIME}" 线上502数量 : "${CODE_502_NUM}"个"

    if [ $CODE_500_NUM -gt 0 ];then
        SUBJECT="线上500警告"
        CONTENT=${CURRENT_TIME}" 线上500数量 : "${CODE_500_NUM}"个<br>"${SEC_500_LOG}
        python $MAIL_SEND_PYFILE "$RECEIVER" "$SUBJECT" "$CONTENT"
    fi
    echo ${CURRENT_TIME}" 线上500数量 : "${CODE_500_NUM}"个"
    # new version

    # tail $DADA_ACCESS_LOG -n$TAIL_OFFSET | awk '{print $9}' > $HTTP_CODE_LOG

    # CODE_502_NUM=`awk '{if ($0 == 502) {print $0}}' $HTTP_CODE_LOG | wc -l`
    # if [ $CODE_502_NUM -gt 0 ];then
    #     SUBJECT="线上502警告"
    #     CONTENT=${CURRENT_TIME}" 线上502数量 : "${CODE_502_NUM}"个"
    #     python $MAIL_SEND_PYFILE "$RECEIVER" "$SUBJECT" "$CONTENT"
    # fi
    # echo ${CURRENT_TIME}" 线上502数量 : "${CODE_502_NUM}"个"

    # CODE_500_NUM=`awk '{if ($0 == 500) {print $0}}' $HTTP_CODE_LOG | wc -l`
    # if [ $CODE_500_NUM -gt 0 ];then
    #     SUBJECT="线上500警告"
    #     CONTENT=${CURRENT_TIME}" 线上500数量 : "${CODE_500_NUM}"个"
    #     python $MAIL_SEND_PYFILE "$RECEIVER" "$SUBJECT" "$CONTENT"
    # fi
    # echo ${CURRENT_TIME}" 线上500数量 : "${CODE_500_NUM}"个"
else
    CURRENT_LINENUM=0
    echo $CURRENT_LINENUM > $LAST_LINE_LOG
    echo ${CURRENT_TIME}" 线上502数量 : 0个"
    echo ${CURRENT_TIME}" 线上500数量 : 0个"
fi

