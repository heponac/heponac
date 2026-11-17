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
- moteur `cloud`, modèle `claude-sonnet-5-5` (changer `default_model` ou utiliser `jarvis ask -m claude-haiku-4-5 ...`) ;
- télémétrie désactivée.

Ne mettez jamais la clé API dans un fichier du dépôt.

Python 3.10 à 3.13 requis.
