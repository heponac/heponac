"""Prompt-master : transforme une idée brute en prompt clair et efficace pour une IA.

Usage : .venv/bin/python prompt_master.py "mon idée"   (ou l'idée sur l'entrée standard)
La clé est lue dans ANTHROPIC_API_KEY ou dans ~/.openjarvis/anthropic_key.
"""
import os
import sys
from pathlib import Path

import anthropic

MODEL = "claude-opus-5-5"

SYSTEM = """Tu es Prompt-master, expert en rédaction de prompts pour les assistants IA (Claude, ChatGPT, etc.).
On te donne une demande brute, parfois vague ou mal formulée. Réécris-la en un prompt prêt à copier-coller qui obtiendra la meilleure réponse possible.

Le prompt que tu écris :
- dit à l'IA qui elle doit être (rôle ou expertise utile) ;
- donne le contexte et l'objectif réel de la demande ;
- décrit précisément la tâche, avec les contraintes (ton, longueur, public, langue) ;
- précise le format de réponse attendu ;
- laisse entre [crochets] les informations que seul l'utilisateur peut fournir, au lieu de les inventer.

Écris le prompt dans la langue de la demande. Réponds uniquement par le prompt, sans introduction ni commentaire."""


def load_key() -> None:
    if os.environ.get("ANTHROPIC_API_KEY"):
        return
    key_file = Path.home() / ".openjarvis" / "anthropic_key"
    if key_file.is_file():
        os.environ["ANTHROPIC_API_KEY"] = key_file.read_text().strip()


def improve(idea: str) -> str:
    client = anthropic.Anthropic()
    response = client.messages.create(
        model=MODEL,
        max_tokens=16000,
        system=SYSTEM,
        messages=[{"role": "user", "content": idea}],
    )
    if response.stop_reason == "refusal":
        raise RuntimeError("Claude a refusé cette demande.")
    return "".join(b.text for b in response.content if b.type == "text").strip()


def main() -> int:
    idea = " ".join(sys.argv[1:]).strip() or sys.stdin.read().strip()
    if not idea:
        print("Donnez une idée à transformer en prompt.", file=sys.stderr)
        return 1
    load_key()
    if not os.environ.get("ANTHROPIC_API_KEY"):
        print("Clé Anthropic absente (voir README, « Lancement rapide »).", file=sys.stderr)
        return 1
    try:
        print(improve(idea))
    except anthropic.AuthenticationError:
        print("Clé Anthropic invalide.", file=sys.stderr)
        return 1
    except anthropic.APIConnectionError:
        print("Pas de connexion à Internet.", file=sys.stderr)
        return 1
    except (anthropic.APIStatusError, RuntimeError) as e:
        print(f"Erreur : {e}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
