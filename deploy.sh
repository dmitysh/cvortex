#!/usr/bin/env bash

# Использование:
# ./deploy-full-local.sh /path/to/project user@remote_host:/remote/path [SSH_KEY]

LOCAL_PATH=$1
REMOTE_PATH=$2
SSH_KEY=$3

if [ -z "$LOCAL_PATH" ] || [ -z "$REMOTE_PATH" ]; then
  echo "Использование: $0 <local_path> <user@remote_host:/remote_path> [ssh_key]"
  exit 1
fi

REMOTE_HOST=$(echo "$REMOTE_PATH" | cut -d: -f1)
REMOTE_TARGET_PATH=$(echo "$REMOTE_PATH" | cut -d: -f2-)

# Путь для ControlMaster сокета (во временной папке, уникальное имя)
CONTROL_PATH="/tmp/ssh-%r@%h:%p"

# Общие ssh опции для multiplexing
SSH_OPTIONS="-o ControlMaster=auto -o ControlPersist=5m -o ControlPath=$CONTROL_PATH"

RSYNC_CMD="rsync -avz --delete --exclude={'.git','.idea'}"

if [ -n "$SSH_KEY" ]; then
  RSYNC_CMD="$RSYNC_CMD -e \"ssh -i $SSH_KEY $SSH_OPTIONS\""
  SSH_CMD="ssh -i $SSH_KEY $SSH_OPTIONS"
else
  RSYNC_CMD="$RSYNC_CMD -e \"ssh $SSH_OPTIONS\""
  SSH_CMD="ssh $SSH_OPTIONS"
fi

echo "Синхронизация $LOCAL_PATH → $REMOTE_PATH ..."
eval "$RSYNC_CMD $LOCAL_PATH/ $REMOTE_PATH"

if [ $? -eq 0 ]; then
  echo "✅ Копирование завершено успешно."
else
  echo "❌ Ошибка при копировании."
  exit 1
fi

echo "Подключение к $REMOTE_HOST и запуск docker-compose"
$SSH_CMD "$REMOTE_HOST" "cd $REMOTE_TARGET_PATH && docker-compose stop && docker-compose up --build -d && docker compose -f docker-compose.yml exec -T nginx nginx -s reload"

if [ $? -eq 0 ]; then
  echo "✅ Docker-compose запущен успешно."
else
  echo "❌ Ошибка при запуске docker-compose."
  exit 1
fi
