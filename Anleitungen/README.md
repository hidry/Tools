# Anleitungen

Sammlung von Workflow-Dokumentationen und Best Practices für die Entwicklung mit Claude Code.

## Inhalt

### warema-wms-homeassistant.md

Vollständige Installationsanleitung zur Integration von Warema WMS-Geräten (Verdunklungen, Markisen, Raffstores) in Home Assistant über den WMS USB-Stick.

#### Inhalt

- **Hardware-Setup**: USB-Passthrough in Proxmox, Reichweiten-Optimierung
- **MQTT-Konfiguration**: Mosquitto Broker Installation und Einrichtung
- **Addon-Installation**: Warema WMS Addon Setup und Netzwerkparameter-Auslese
- **Automatisierungen**: Beispiele für wetterbasierte und zeitgesteuerte Automatisierungen
- **Troubleshooting**: Lösungen für häufige Probleme

#### Voraussetzungen

- Home Assistant (auf Proxmox, Raspberry Pi, etc.)
- Warema WMS USB-Stick (Standard-Version)
- Warema WMS-Geräte (Verdunklungen, Markisen, etc.)
- USB-Verlängerungskabel (3-5m, USB 2.0 empfohlen)

#### Highlights

- **Schritt-für-Schritt**: Komplette Installation von Null bis fertiges System
- **Proxmox-Integration**: Spezielle Anweisungen für USB-Passthrough
- **Automatisierungsbeispiele**: Regen-, Wind-, Sonnen- und Zeitsteuerung
- **Reichweiten-Optimierung**: Best Practices für optimale Funkabdeckung

---

### prd-to-code-workflow.md

Detaillierte Anleitung für einen strukturierten Entwicklungsworkflow mit Claude Code, der von einem Product Requirements Document (PRD) bis zur fertigen Implementierung führt.

#### Phasen des Workflows

| Phase | Modell | Beschreibung |
|-------|--------|--------------|
| 1 | Opus | PRD erstellen und reviewen |
| 2 | Sonnet | User Stories im INVEST-Format ableiten |
| 3 | Sonnet/Opus | Tasks erstellen und validieren |
| 4 | Sonnet | Sprint-Plan erstellen |
| 5 | Opus | Implementierung nach Sprint-Plan |

#### Voraussetzungen

- Claude Code CLI installiert
- `/create-prd` Command installiert (von buildwithclaude.com)
- `/todo` Template installiert via:
  ```bash
  npm install -g claude-code-templates@latest
  claude-code-templates --command=project-management/todo --yes
  ```

#### Highlights

- **Spec-Driven Development**: Strukturierter Ansatz von Anforderungen bis Code
- **Modell-Optimierung**: Opus für komplexe Aufgaben (PRD, Validierung, Implementierung), Sonnet für strukturierte Aufgaben (Stories, Tasks, Sprint-Plan)
- **Qualitätssicherung**: Integrierte Review- und Validierungsschritte
- **Cheat-Sheet**: Kompakte Kurzreferenz am Ende des Dokuments

## Zielgruppe

Entwickler und Teams, die Claude Code für strukturierte, professionelle Softwareentwicklung nutzen möchten.
