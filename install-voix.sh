#!/usr/bin/env bash
# Ajoute la voix à OpenJarvis (micro + réponses parlées en français), 100 % local.
# À lancer après ./install.sh, sur Mac.
set -euo pipefail
cd "$(dirname "$0")"

if ! .venv/bin/python -c 'import sys; sys.exit(0 if sys.version_info[:2] <= (3,12) else 1)'; then
  echo "ERREUR : la voix (kokoro) demande Python 3.12 au maximum ; .venv utilise $(.venv/bin/python --version)."
  echo "Faites : brew install python@3.12 && ./install.sh   puis relancez ./install-voix.sh"
  exit 1
fi

if command -v brew >/dev/null 2>&1; then
  brew list espeak-ng >/dev/null 2>&1 || brew install espeak-ng   # prononciation du français
else
  echo "Homebrew absent : installez espeak-ng manuellement."
fi

# av < 19 : PyAV 19 a supprimé l'option metadata_errors utilisée par faster-whisper 1.2.1
.venv/bin/pip install "kokoro>=0.9.4" sounddevice soundfile faster-whisper "av<19"

CFG=~/.openjarvis/config.toml
if grep -q '^\[speech\]' "$CFG" 2>/dev/null; then
  echo "$CFG contient déjà une section [speech] : non modifiée (modèle dans config/config.toml)."
else
  sed -n '/^\[speech\]/,$p' config/config.toml >> "$CFG"
  echo "Section [speech] (voix française) ajoutée à $CFG"
fi
echo "OK. Lancez : jarvis chat --voice"
