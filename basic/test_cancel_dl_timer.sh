#!/bin/bash
. ../utils.sh
TDESC="
##############################################
#
#    Stress cancel_dl_timer()
#
##############################################

"
TNAME="test_cancel_dl_timer"
TRACE=${1-0}
SWITCHES=${2-100}
EVENTS="sched_wakeup* sched_switch sched_migrate*"

print_test_info

dump_on_oops
trace_start

./cpuhog &
PID=$!

echo "Going to perform $SWITCHES sched_setscheduler on task $PID"
for i in `seq 0 $SWITCHES`; do
  if [[ $((i % 2)) == 0 ]]; then
    usec=$(random 1 10)
    trace_write "setting $PID to (${usec},100)"
    schedtool -E -t ${usec}000000:100000000 $PID
  else
    trace_write "setting $PID to normal"
    schedtool -N $PID
  fi

  sleep_for=$(random 1 99)
  sleep 0.${sleep_for}
  echo -n "Numbers of switches: $i"
  echo -ne "\r"

done

echo

kill -9 $PID

trace_stop
trace_extract

exit 0
