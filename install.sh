#!/usr/bin/env bash
# Installe OpenJarvis dans un environnement virtuel local (.venv), configuré pour Claude (Anthropic).
# Prérequis : Python 3.10 à 3.13
set -euo pipefail
cd "$(dirname "$0")"
python3 -m venv .venv
.venv/bin/pip install --upgrade pip
.venv/bin/pip install -r requirements.txt
mkdir -p ~/.openjarvis
if [ -f ~/.openjarvis/config.toml ]; then
  echo "~/.openjarvis/config.toml existe déjà : non remplacé (voir config/config.toml)."
else
  cp config/config.toml ~/.openjarvis/config.toml
fi
echo "OK : $(.venv/bin/jarvis --version)"
echo "Ensuite : export ANTHROPIC_API_KEY=... ; source .venv/bin/activate ; jarvis chat"
