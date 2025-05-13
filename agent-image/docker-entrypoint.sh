#!/bin/bash
set -e

echo "==> Starting Docker Daemon..."
nohup dockerd > /tmp/dockerd.log 2>&1 &
sleep 10

echo "==> Checking if Docker is running..."
if ! docker info > /dev/null 2>&1; then
  echo "❌ Docker daemon failed to start. Log:"
  cat /tmp/dockerd.log
  exit 1
fi
echo "✅ Docker is up"

echo "==> Environment Variables:"
echo "AZP_URL: $AZP_URL"
echo "AZP_POOL: $AZP_POOL"
echo "AZP_AGENT_NAME: $AZP_AGENT_NAME"

echo "==> Registering Azure Pipelines Agent..."
cd /azagent

if [ ! -f .agent ]; then
  echo "==> First time registration"
  su mikaadmin -c "./config.sh --unattended \
    --url \"$AZP_URL\" \
    --auth pat \
    --token \"$AZP_TOKEN\" \
    --pool \"$AZP_POOL\" \
    --acceptTeeEula \
    --replace"
else
  echo "==> Agent already configured, skipping config"
fi

echo "==> Starting Azure Pipelines Agent"
su mikaadmin -c "./run.sh"
