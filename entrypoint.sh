#!/usr/bin/env bash
set -e

echo "ARGS:      $@"

echo "USER_GID: "${USER_GID:-9001}
echo "USER_UID: "${USER_UID:-9001}

# generate host keys if not present
ssh-keygen -A

# do not detach (-D), log to stderr (-e)
exec /usr/sbin/sshd -D -e &

#cd /sites
#exec openconnect "$@"

function finish {
  echo "Detected SIGTERM, shuting down..."
  if kill -s 0 $IKEC_PID >/dev/null 2>&1; then
    echo "Stopping ikec..."
	kill -TERM $IKEC_PID >/dev/null 2>&1
	wait $IKEC_PID
  fi

  if kill -s 0 $IKED_PID >/dev/null 2>&1; then
    echo "Stopping iked..."
	kill -TERM $IKED_PID >/dev/null 2>&1
	wait $IKED_PID
  fi
}
trap finish TERM INT

SITE=$1
USERNAME=$2
PASSWORD=$3

if [ ! -f /sites/$SITE ]; then
  echo "Error: /sites/$SITE does not exist."
  echo "Did you forget to mount it with -v?"
  exit 1
fi

COMMAND="ikec -r $SITE"

if [ ! "$USERNAME" == "" ]; then
  COMMAND="$COMMAND -u $USERNAME"
fi

if [ ! "$PASSWORD" == "" ]; then
  COMMAND="$COMMAND -p $PASSWORD"
fi

echo ${COMMAND}
COMMAND="${COMMAND} -a"

iked -F &
IKED_PID=$!
echo "IKEd started."

echo "Starting IKEc for $SITE..."
screen -dmS "ikec" $COMMAND &
IKEC_PID=$!

wait $IKED_PID
