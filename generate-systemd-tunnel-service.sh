#!/bin/bash
  
# Überprüfung der Anzahl der Argumente
if [ "$#" -lt 6 ]; then
    echo "Usage: $0 <SERVICE_NAME> <USER> <GROUP> <SSH_REMOTE_PORT> <TARGET_ENDPOINT> <SSH_USER@SSH_HOST>"
    exit 1
fi

SERVICE_NAME=$1
USER=$2
GROUP=$3
SSH_REMOTE_PORT=$4
TARGET_ENDPOINT=$5
SSH_USER_HOST=$6
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

# Erstellen der Service-Datei

cat <<EOF > $SERVICE_FILE
[Unit]
Description=AutoSSH tunnel to public server
After=network.target

[Service]
User=${USER}
Group=${GROUP}
Environment="AUTOSSH_GATETIME=0"
ExecStart=/usr/bin/autossh -M 0 -N -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -R ${SSH_REMOTE_PORT}:${TARGET_ENDPOINT} ${SSH_USER_HOST}
ExecStop=/usr/bin/pkill -3 autossh
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

# Service Datei laden und aktivieren
systemctl daemon-reload
systemctl enable ${SERVICE_NAME}
systemctl start ${SERVICE_NAME}

echo "Service ${SERVICE_NAME} wurde erstellt, aktiviert und gestartet."
