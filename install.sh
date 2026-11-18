#!/usr/bin/env bash
# Installe OpenJarvis dans un environnement virtuel local (.venv), configuré pour Claude (Anthropic).
# Prérequis : Python 3.10 à 3.13 (sur Mac : brew install python@3.12)
set -euo pipefail
cd "$(dirname "$0")"

PY=""
for c in python3.12 python3.11 python3.10 python3.13 python3; do  # 3.12 en premier : la voix (kokoro) ne marche pas en 3.13
  if command -v "$c" >/dev/null 2>&1 && "$c" -c 'import sys; sys.exit(0 if (3,10) <= sys.version_info[:2] <= (3,13) else 1)'; then
    PY="$c"; break
  fi
done
if [ -z "$PY" ]; then
  echo "ERREUR : il faut Python 3.10 à 3.13 (trouvé : $(python3 --version 2>&1))."
  echo "Sur Mac, installez-le avec : brew install python@3.12   puis relancez ./install.sh"
  exit 1
fi
echo "Python utilisé : $($PY --version)"

"$PY" -m venv --clear .venv
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
