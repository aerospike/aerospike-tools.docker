#!/bin/bash 
#set -x
#set -e

# Sets locale to utf-8 instead of posix. 
# This allows asadm to display the mu symbol when micro-benchmarks are enabled
export LC_CTYPE=C.UTF-8 

CMD="$1"
shift

if [ -z "$CMD" ]; then
  echo "error: Please provide a command to execute." >&2
  exit 1
fi

which "$CMD" >/dev/null
if [ $? -ne 0 ]; then 
  echo "error: Command not found: $CMD" >&2
  exit 1
fi

case "$CMD" in
"aql" | "asadm" | "asbackup" | "asrestore" | "asloglatency" | "asinfo" | "asbench" | "uda" | "asconfig" ) 
  ;;
* )
  echo "error: Unknown command: $CMD" >&2
  exit 1
esac

if [[ $AEROSPIKE_PORT_3000_TCP_ADDR ]]; then
$CMD -h $AEROSPIKE_PORT_3000_TCP_ADDR -p $AEROSPIKE_PORT_3000_TCP_PORT "$@"
exit $?
else
$CMD "$@"
exit $?
fi  
