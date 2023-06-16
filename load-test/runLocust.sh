#!/bin/bash
#
# Run locust load test
#
#####################################################################
ARGS="$@"
HOST="${1}"
SCRIPT_NAME=`basename "$0"`
INITIAL_DELAY=1
TARGET_HOST="$HOST"
USERS=2
REQUESTS=10
SPAWN_RATE=1


do_check() {

  # check hostname is not empty
  if [ "${TARGET_HOST}x" == "x" ]; then
    echo "TARGET_HOST is not set; use '-h hostname:port'"
    exit 1
  fi

  # check for locust
  if [ ! `command -v locust` ]; then
    echo "Python 'locust' package is not found!"
    exit 1
  fi

  # check locust file is present
  if [ -n "${LOCUST_FILE:+1}" ]; then
  	echo "Locust file: $LOCUST_FILE"
  else
  	LOCUST_FILE="locustfile.py" 
  	echo "Default Locust file: $LOCUST_FILE" 
  fi
}

do_exec() {
  sleep $INITIAL_DELAY

  # check if host is running
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" ${TARGET_HOST}) 
  if [ $STATUS -ne 200 ]; then
      echo "${TARGET_HOST} is not accessible"
      exit 1
  fi

  echo "
  Will run $LOCUST_FILE against $TARGET_HOST.
  Will spawn $SPAWN_RATE user(s) each second until $USERS users in total are reached.
  The load test will run for $REQUESTS iterations.
  "
  locust --host=http://$TARGET_HOST -f $LOCUST_FILE -u=$USERS -r=$SPAWN_RATE -i=$REQUESTS --headless
  echo "done"
}

do_usage() {
    cat >&2 <<EOF
Usage:
  ${SCRIPT_NAME} [ hostname ] OPTIONS

Options:
  -d  Delay before starting
  -h  Target host url, e.g. http://localhost/
  -u  Peak number of concurrent Locust users (default 2)
  -i  Number of iterations the load test runs for (default 10) - part of Locust plugins
  -r  Indicates how many users are spawned per second until -u users are reached (default 1)

Description:
  Runs a Locust load simulation against specified host.

EOF
  exit 1
}



while getopts ":d:h:u:i:r:" o; do
  case "${o}" in
    d)
        INITIAL_DELAY=${OPTARG}
        #echo $INITIAL_DELAY
        ;;
    h)
        TARGET_HOST=${OPTARG}
        #echo $TARGET_HOST
        ;;
    u)
        USERS=${OPTARG:-2}
        #echo $USERS
        ;;
    i)
        REQUESTS=${OPTARG:-10}
        #echo $REQUESTS
        ;;
    r)
        SPAWN_RATE=${OPTARG:-1}
        #echo $SPAWN_RATE
        ;;
    *)
        do_usage
        ;;
  esac
done


do_check
do_exec
