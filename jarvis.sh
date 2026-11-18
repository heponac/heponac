#!/usr/bin/env bash
# Lance Jarvis en mode voix, sans les avertissements techniques.
# La clé est lue dans ANTHROPIC_API_KEY ou dans ~/.openjarvis/anthropic_key (fichier privé, hors du dépôt).
cd "$(dirname "$0")"
if [ -z "${ANTHROPIC_API_KEY:-}" ] && [ -f ~/.openjarvis/anthropic_key ]; then
  ANTHROPIC_API_KEY="$(cat ~/.openjarvis/anthropic_key)"; export ANTHROPIC_API_KEY
fi
if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
  echo "Clé absente. Enregistrez-la une fois avec :"
  echo "  read -s -p 'Clé Anthropic : ' K && echo \"\$K\" > ~/.openjarvis/anthropic_key && chmod 600 ~/.openjarvis/anthropic_key"
  exit 1
fi
export PYTHONWARNINGS=ignore HF_HUB_VERBOSITY=error TRANSFORMERS_VERBOSITY=error HF_HUB_DISABLE_PROGRESS_BARS=1
exec .venv/bin/jarvis chat --voice "$@" 2> >(grep -v -E 'redirects.py|Defaulting repo_id|HF_TOKEN|UserWarning|FutureWarning|warnings.warn|super\(\).__init__|WeightNorm.apply|MPS backend' >&2)
