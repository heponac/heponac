# heponac

Installation d'[OpenJarvis](https://github.com/open-jarvis/OpenJarvis) (assistant IA modulaire), configuré pour utiliser Claude (Anthropic).

```bash
./install.sh                          # crée .venv, installe OpenJarvis, copie config/config.toml dans ~/.openjarvis/
export ANTHROPIC_API_KEY="sk-ant-..."  # votre clé : https://console.anthropic.com/settings/keys
source .venv/bin/activate
jarvis ask "Bonjour"                  # question unique
jarvis chat                           # conversation
```

Configuration (`config/config.toml`) :
- moteur `cloud`, modèle `claude-sonnet-4-6` (OpenJarvis 1.0.4 envoie `temperature`, refusé par les modèles Claude 5 ; autre choix : `claude-haiku-4-5`) ;
- télémétrie désactivée.

Ne mettez jamais la clé API dans un fichier du dépôt.

Python 3.10 à 3.13 requis.

## Agenda (calendrier du Mac)

1. Réglages Système → Confidentialité et sécurité → Accès complet au disque → activer **Terminal**, puis relancer le Terminal.
2. Lancer Jarvis avec les outils calendrier :

```bash
jarvis chat --agent react --tools calendar_upcoming,calendar_search
```

Jarvis lit le calendrier de l'app Calendrier du Mac (y compris les comptes Google/iCloud qui y sont ajoutés), en lecture seule.

## Voix (parler à Jarvis et l'entendre répondre)

```bash
./install-voix.sh                 # micro + voix française, en local (Python 3.12 requis)
jarvis chat --voice               # parlez, Jarvis répond à voix haute
```

Au premier lancement, les modèles vocaux sont téléchargés (quelques centaines de Mo). Le Mac demandera l'accès au micro pour le Terminal : acceptez.

## Outils activés par défaut

`config/config.toml` lance l'agent `react` avec les outils `web_search` (météo, actualités…), `calendar_upcoming` et `calendar_search`, et une consigne en français. Après un `git pull`, appliquez la config avec :

```bash
cp config/config.toml ~/.openjarvis/config.toml
```

## Lancement rapide

```bash
read -s "K?Clé Anthropic : " && echo "$K" > ~/.openjarvis/anthropic_key && chmod 600 ~/.openjarvis/anthropic_key   # une seule fois
./jarvis.sh        # mode voix, sans les avertissements techniques
```

## Bouton Prompt-master

Transforme une idée brute (« écris un mail pour relancer un client ») en prompt clair et structuré, prêt à coller dans Claude, ChatGPT, etc.

- **Double-cliquez `Prompt-Master.command`** dans le Finder (ou glissez-le dans le Dock pour en faire un bouton permanent).
- Tapez votre idée dans la fenêtre → le prompt amélioré s'affiche et est **copié dans le presse-papiers** (⌘V pour coller).
- En ligne de commande : `.venv/bin/python prompt_master.py "mon idée"`.

Utilise la même clé que Jarvis (`~/.openjarvis/anthropic_key`) et le modèle `claude-opus-5-5`. Au premier double-clic, si macOS bloque le fichier : clic droit → Ouvrir.
