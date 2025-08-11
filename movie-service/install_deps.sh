#!/bin/bash
set -e

echo "📦 Installation des dépendances Python pour cast-service..."
cd cast-service
pip3 install --no-cache-dir -r requirements.txt

echo "📦 Installation des dépendances Python pour movie-service..."
cd ../movie-service
pip3 install --no-cache-dir -r requirements.txt

cd ..
echo "✅ Installation terminée."
