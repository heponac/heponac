#!/usr/bin/env bash
# Installe OpenJarvis dans un environnement virtuel local (.venv)
# Prérequis : Python 3.10 à 3.13
set -euo pipefail
cd "$(dirname "$0")"
python3 -m venv .venv
.venv/bin/pip install --upgrade pip
.venv/bin/pip install -r requirements.txt
echo "OK : $(.venv/bin/jarvis --version)"
echo "Activez l'environnement avec : source .venv/bin/activate"
