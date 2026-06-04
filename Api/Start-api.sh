# 1. Définition des variables pour ton environnement
PROJECT_ROOT="/home/siwar/Desktop/Intent_Based_Network/ProjetMonitoring1/Api"
API_SCRIPT="network-manager.py"
PYTHON_VENV="/home/siwar/ai-py310/bin/python3"

# 2. Tue l'ancienne instance si elle existe pour libérer le port 5000
# Utiliser fuser est plus précis que pkill pour libérer un port
echo "🚀 Libération du port 5000..."
sudo fuser -k 5000/tcp > /dev/null 2>&1

# 3. Lancement du Network Manager avec ton venv (Python 3.9)
echo "📡 Lancement du Network Manager..."
cd $PROJECT_ROOT
sudo $PYTHON_VENV $API_SCRIPT
