#!/usr/bin/env bash
# Bouton Prompt-master : double-cliquez ce fichier dans le Finder (ou glissez-le dans le Dock).
# Il demande votre idée, la transforme en prompt optimisé et le copie dans le presse-papiers.
cd "$(dirname "$0")"

if command -v osascript >/dev/null 2>&1; then
  IDEE="$(osascript -e 'text returned of (display dialog "Votre idée, même brute :" default answer "" with title "Prompt-master" buttons {"Annuler", "Améliorer"} default button "Améliorer" cancel button "Annuler")' 2>/dev/null)" || exit 0
else
  read -r -p "Votre idée : " IDEE
fi
[ -z "$IDEE" ] && exit 0

echo "Prompt-master travaille…"
if ! PROMPT="$(.venv/bin/python prompt_master.py "$IDEE" 2>/tmp/prompt-master-erreur.txt)"; then
  ERR="$(cat /tmp/prompt-master-erreur.txt)"
  echo "$ERR"
  command -v osascript >/dev/null 2>&1 && osascript -e "display alert \"Prompt-master\" message \"${ERR//\"/\\\"}\"" >/dev/null
  exit 1
fi

echo; echo "$PROMPT"; echo
if command -v pbcopy >/dev/null 2>&1; then
  printf '%s' "$PROMPT" | pbcopy
  echo "→ Copié dans le presse-papiers (⌘V pour coller)."
  osascript -e 'display notification "Prompt copié : collez-le avec ⌘V" with title "Prompt-master"' >/dev/null 2>&1
fi
