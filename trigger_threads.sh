#!/bin/bash

# DB connection variables
ORACLE_USER="dbuser"
ORACLE_PASS="dbpass"
ORACLE_SID="ORCL"
ORACLE_HOME="/path/to/oracle"
export ORACLE_HOME
export PATH=$ORACLE_HOME/bin:$PATH

LOG_FILE="/var/log/scalexecutor/trigger_threads.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "$TIMESTAMP - Triggering dynamic threads" >> $LOG_FILE

# Call PL/SQL to generate threads
sqlplus -s $ORACLE_USER/$ORACLE_PASS@$ORACLE_SID <<EOF >> $LOG_FILE
SET SERVEROUTPUT ON
BEGIN
  thread_processor_pkg.dynamic_thread_creation;
END;
/
EXIT;
EOF
