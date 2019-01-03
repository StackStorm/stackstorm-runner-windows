#!/usr/bin/env bash

# Write export lines into ~/.buildenv and also source it in ~/.circlerc
write_env() {
  for e in $*; do
    eval "value=\$$e"
    [ -z "$value" ] || echo "export $e=$value" >> ~/.buildenv
  done
  echo ". ~/.buildenv" >> ~/.circlerc
}

if hash greadlink 2>/dev/null; then
    SCRIPT_PATH=$(dirname "$(greadlink -f "$0")")
else
    SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
fi

source ${SCRIPT_PATH}/common.sh

# Set PYTHONPATH to include StackStorm Python packages (components) and write it into ~/.circlerc
ST2_REPO_PATH=${ST2_REPO_PATH:-/tmp/st2}
ST2_COMPONENTS=$(get_st2_components)
PYTHONPATH=$(join ":" ${ST2_COMPONENTS})

write_env PYTHONPATH

# Copy default config file to /etc/st2
sudo mkdir /etc/st2
sudo cp scripts/st2.tests.conf /etc/st2/st2.conf
