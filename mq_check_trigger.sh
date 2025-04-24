bash
CopyEdit
#!/bin/bash

MQ_QUEUE="TRANSACTION.IN.Q"
MQMGR="MYQMGR"
MSG_THRESHOLD=10000

CURRENT_MSGS=$(echo "display qlocal($MQ_QUEUE) curdepth" | runmqsc $MQMGR | grep CURDEPTH | awk '{print $2}' | cut -d'(' -f2 | cut -d')' -f1)

if [ "$CURRENT_MSGS" -ge "$MSG_THRESHOLD" ]; then
  echo "[$(date)] MQ depth high ($CURRENT_MSGS). Triggering load scale." >> /var/log/scalexecutor/mq_monitor.log
  /path/to/trigger_threads.sh
fi
