#!/bin/bash
MAIL_SEND_PYFILE=/home/ubuntu/potter/mail_send.py
RECEIVER="alan@imdada.cn"

NOWTIME=`date +%s`
HEARTBEAT_TIME=`cat t.log`
t=$[$NOWTIME-$HEARTBEAT_TIME]
if (("$t" > 300));then
    echo $t
    python $MAIL_SEND_PYFILE "$RECEIVER" "job error!" "job error"
fi
