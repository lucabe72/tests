#!/bin/bash
. ../utils.sh

TNAME=$(echo $0 | tr '/' ' ' | tr '.' ' ' | awk '{ print $1 }')
TINFO="Check for the (In)famous SCHED_DEADLINE migration bug"
BENCHMARK="rt-app"
TRACE=$1
EVENTS="sched_wakeup* sched_switch sched_migrate*"

cleanup() {
  trace_stop
  enable_ac
  turn_on_cpu 1
  turn_on_cpu 2
  turn_on_cpu 3
  turn_on_cpu 4
  turn_on_cpu 5
  turn_on_cpu 6
  turn_on_cpu 7

  for c in ${ALL_MASK}; do
    set_cpufreq ${c} ondemand
  done

  exit 0
}

trap cleanup SIGINT SIGTERM

print_test_info

trace_start
turn_off_cpu 2
turn_off_cpu 3
turn_off_cpu 4
turn_off_cpu 5
turn_off_cpu 6
turn_off_cpu 7

TASKSET="${TNAME}.json"

#for c in ${A15_MASK}; do
#  # this corresponds to 1024 cap on A15
#  set_cpufreq ${c} userspace 1200000
#done
set_cpufreq 0 userspace 1200000

log "waiting 5 seconds..."
sleep 5
log "running taskset ${TASKSET} (at 1024 cap)"
mkdir -p ./log
${BENCHMARK} ${TASKSET} >> ${TNAME}.out 2>&1

log "${TNAME} execution finished"

trace_stop
trace_extract

cleanup

