#!/bin/bash

# 1. Définitions
PROJECT_ROOT="/home/siwar/Desktop/Intent_Based_Network/ProjetMonitoring1"
RYU_DIR="$PROJECT_ROOT/ryu"
VENV_DIR="$PROJECT_ROOT/Api/venv"
VENV_RYU="$VENV_DIR/bin/ryu-manager"
VENV_PYTHON="$VENV_DIR/bin/python3"

cd "$RYU_DIR" || exit

echo "🧹 Nettoyage du port 8080..."
sudo fuser -k 8080/tcp > /dev/null 2>&1

echo "🚀 Lancement de Ryu avec les bibliothèques du venv..."

# --- MODIFICATION ICI ---
# On lance Ryu via le PYTHON du venv pour être SÛR qu'il voit la bibliothèque 'ovs'
sudo "$VENV_PYTHON" "$VENV_RYU" --wsapi-port 8080 \
                 --observe-links \
                 simple_switch_13.py \
                 qos_telemetry.py \
                 ryu.app.rest_qos \
                 ryu.app.rest_conf_switch
