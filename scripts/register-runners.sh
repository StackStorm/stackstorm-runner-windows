#!/usr/bin/env bash
# Licensed to the StackStorm, Inc ('StackStorm') under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Script which tries to register all the resources from a particular pack and
# fails (exits with non-zero) if registering a particular resource fails.
#

if hash greadlink 2>/dev/null; then
    SCRIPT_PATH=$(dirname "$(greadlink -f "$0")")
else
    SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
fi

PYTHON_BINARY=virtualenv/bin/python

source ${SCRIPT_PATH}/common.sh

ST2_CONFIG_FILE=${ST2_CONFIG_FILE:-${SCRIPT_PATH}/st2.tests.conf}

ST2_REPO_PATH=${ST2_REPO_PATH:-/tmp/st2}

REGISTER_SCRIPT_PATH="${ST2_REPO_PATH}/st2common/bin/st2-register-content"
REGISTER_SCRIPT_FLAGS="--register-fail-on-failure --config-file=${ST2_CONFIG_FILE} -v --register-runners"

echo "Registering runners"
echo "PYTHONPATH=${PYTHONPATH}"
echo "Running script: ${PYTHON_BINARY} ${REGISTER_SCRIPT_PATH} ${REGISTER_SCRIPT_FLAGS}"
${PYTHON_BINARY} ${REGISTER_SCRIPT_PATH} ${REGISTER_SCRIPT_FLAGS}
EXIT_CODE=$?

if [ ${EXIT_CODE} -ne 0 ]; then
    echo "Registering runners failed"
fi

exit ${EXIT_CODE}
