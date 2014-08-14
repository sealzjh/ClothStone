#!/bin/bash

HTTP_CODE_LOG=/home/dada/potter/code.log
DADA_ACCESS_LOG=/var/log/nginx/dada_dada_access_log
LAST_LINE_LOG=/home/dada/potter/linenum

while true
do
    CURRENT_TIME=`date "+%Y-%m-%d %H:%M:%S"` 
    CURRENT_SECOND=`date "+%S"`
    echo $CURRENT_SECOND
    if [ 00 -eq $CURRENT_SECOND ];then

        if [ -f "$DADA_ACCESS_LOG" ];then

            LAST_LINENUM=$(cat $LAST_LINE_LOG)
            CURRENT_LINENUM=`wc -l $DADA_ACCESS_LOG | awk '{print $1}'`
            echo $CURRENT_LINENUM > $LAST_LINE_LOG
            TAIL_OFFSET=$(( CURRENT_LINENUM - LAST_LINENUM ))
            echo $TAIL_OFFSET
            tail $DADA_ACCESS_LOG -n$TAIL_OFFSET | awk '{print $9}' > $HTTP_CODE_LOG

            CODE_502_NUM=`awk '{if ($0 == 502) {print $0}}' $HTTP_CODE_LOG | wc -l`
            if [ $CODE_502_NUM -gt 0 ];then
                echo ${CURRENT_TIME}" 线上502数量 : "${CODE_502_NUM}"个" | mail -s "线上502警告" -r "dada@imdada.cn" "782922086@qq.com"
            fi
            echo ${CURRENT_TIME}" 线上502数量 : "${CODE_502_NUM}"个"

            CODE_500_NUM=`awk '{if ($0 == 500) {print $0}}' $HTTP_CODE_LOG | wc -l`
            if [ $CODE_500_NUM -gt 0 ];then
                echo ${CURRENT_TIME}" 线上500数量 : "${CODE_500_NUM}"个" | mail -s "线上500警告" -r "dada@imdada.cn" "782922086@qq.com"
            fi
            echo ${CURRENT_TIME}" 线上500数量 : "${CODE_500_NUM}"个"
        else
            CURRENT_LINENUM=0
            echo $CURRENT_LINENUM > $LAST_LINE_LOG
            echo ${CURRENT_TIME}" 线上502数量 : 0个"
            echo ${CURRENT_TIME}" 线上500数量 : 0个"
        fi

    fi
    sleep 1
done

