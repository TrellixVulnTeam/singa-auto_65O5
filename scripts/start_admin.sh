#!/usr/bin/env bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

LOG_FILE_PATH=$PWD/$LOGS_DIR_PATH/start_admin.log

PROD_MOUNT_DATA=$HOST_WORKDIR_PATH/$DATA_DIR_PATH:$DOCKER_WORKDIR_PATH/$DATA_DIR_PATH
PROD_MOUNT_PARAMS=$HOST_WORKDIR_PATH/$PARAMS_DIR_PATH:$DOCKER_WORKDIR_PATH/$PARAMS_DIR_PATH
PROD_MOUNT_LOGS=$HOST_WORKDIR_PATH/$LOGS_DIR_PATH:$DOCKER_WORKDIR_PATH/$LOGS_DIR_PATH

# Mount whole project folder with code for dev for shorter iterations
if [ $APP_MODE = "DEV" ]; then
  VOLUME_MOUNTS="-v $PWD:$DOCKER_WORKDIR_PATH"
else
  VOLUME_MOUNTS="-v $PROD_MOUNT_DATA -v $PROD_MOUNT_PARAMS -v $PROD_MOUNT_LOGS"
fi

source ./scripts/utils.sh

title "Starting Rafiki's Admin..."

# docker container run flags info:
# --rm: container is removed when it exits
# (--rm will also remove anonymous volumes)
# -v == --volume: shared filesystems
# -e == --env: environment variable
# --name: name used to identify the container
# --network: default is docker bridge
# -p: expose and map port(s)

(docker run --rm --name $ADMIN_HOST \
  --network $DOCKER_NETWORK \
  -e POSTGRES_HOST=$POSTGRES_HOST \
  -e POSTGRES_PORT=$POSTGRES_PORT \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_DB=$POSTGRES_DB \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e SUPERADMIN_PASSWORD=$SUPERADMIN_PASSWORD \
  -e ADMIN_HOST=$ADMIN_HOST \
  -e ADMIN_PORT=$ADMIN_PORT \
  -e REDIS_HOST=$REDIS_HOST \
  -e REDIS_PORT=$REDIS_PORT \
  -e KAFKA_HOST=$KAFKA_HOST \
  -e KAFKA_PORT=$KAFKA_PORT \
  -e PREDICTOR_PORT=$PREDICTOR_PORT \
  -e RAFIKI_ADDR=$RAFIKI_ADDR \
  -e RAFIKI_IMAGE_WORKER=$RAFIKI_IMAGE_WORKER \
  -e RAFIKI_IMAGE_PREDICTOR=$RAFIKI_IMAGE_PREDICTOR \
  -e RAFIKI_VERSION=$RAFIKI_VERSION \
  -e DOCKER_WORKDIR_PATH=$DOCKER_WORKDIR_PATH \
  -e WORKDIR_PATH=$DOCKER_WORKDIR_PATH \
  -e HOST_WORKDIR_PATH=$HOST_WORKDIR_PATH \
  -e DATA_DIR_PATH=$DATA_DIR_PATH \
  -e PARAMS_DIR_PATH=$PARAMS_DIR_PATH \
  -e LOGS_DIR_PATH=$LOGS_DIR_PATH \
  -e APP_MODE=$APP_MODE \
  -v /var/run/docker.sock:/var/run/docker.sock \
  $VOLUME_MOUNTS \
  -p $ADMIN_EXT_PORT:$ADMIN_PORT \
  $RAFIKI_IMAGE_ADMIN:$RAFIKI_VERSION \
  &> $LOG_FILE_PATH) &

ensure_stable "Rafiki's Admin" $LOG_FILE_PATH 5
