#!/bin/bash
DAY=`date +"%Y%m%d" -d "-1 day"`
ACCESS_LOG=/var/log/nginx/dada_access_log-$DAY.gz
MAIL_SEND_PYFILE=/home/ubuntu/potter/mail_send.py
RECEIVER="tech@alan.cn"

if [ -f "$ACCESS_LOG" ];then
    NUM301=`zcat $ACCESS_LOG |awk '{if ($9 == 301){print $0}}' |wc -l`
    URLLIST=`zcat $ACCESS_LOG |awk '{if ($9 == 301){split($7,b,"?"); count[b[1]]++;}}END{{ for(i in     count){print i "  " count[i] "<br>";}}}'`

    if [ $NUM301 -gt 0 ];then
        SUBJECT="线上301提醒"
        CONTENT=${DAY}"线上301数量: "${NUM301}"个<br><br>"${URLLIST}
        python $MAIL_SEND_PYFILE "$RECEIVER" "$SUBJECT" "$CONTENT"
    fi

    echo ${DAY}" 线上301数量"${NUM301}
fi
