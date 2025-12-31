# Anleitungen

Sammlung von Workflow-Dokumentationen und Best Practices für die Entwicklung mit Claude Code.

## Inhalt

### 📁 Verzeichnisstruktur

```
Anleitungen/
├── README.md
└── prd-to-code-workflow/        # PRD-to-Code Workflow (alle Versionen)
    ├── v1/                      # Original Workflow (Legacy)
    │   └── prd-to-code-workflow.md
    └── v2/                      # Aktueller Workflow mit Best Practices 2025
        ├── prd-to-code-workflow.md
        ├── CHEATSHEET.md
        └── bug-fix-guidelines.md
```

---

## PRD-to-Code Workflow v2.0 (Empfohlen)

**Aktuellste Version mit Anthropic Best Practices (2025)**

- **Workflow**: [prd-to-code-workflow/v2/prd-to-code-workflow.md](./prd-to-code-workflow/v2/prd-to-code-workflow.md)
- **Cheat-Sheet**: [prd-to-code-workflow/v2/CHEATSHEET.md](./prd-to-code-workflow/v2/CHEATSHEET.md)

### Phasen des Workflows

| Phase | Modell | TodoWrite | Context | Dauer |
|-------|--------|-----------|---------|-------|
| **0: Setup** (Optional) | OpusPlan | ✅ | Fresh | 2-5 min |
| **1: PRD** | OpusPlan + Thinking (8k) | ✅ | Fresh | 15-30 min |
| **2: User Stories** | Sonnet (via OpusPlan) | ✅ | Compact | 10-20 min |
| **3: Tasks & Validation** | OpusPlan + Thinking (8k) | ✅ | Compact | 15-25 min |
| **4: Sprint Plan** | Sonnet (via OpusPlan) | ✅ | Compact | 5-10 min |
| **5: Implementation** | OpusPlan | ✅ per Sprint | Keep! | 1-3h per Sprint |

### Voraussetzungen

- Claude Code CLI installiert
- `/create-prd` Command (von [buildwithclaude.com](https://www.buildwithclaude.com/command/create-prd))
- `/todo` Template:
  ```bash
  npm install -g claude-code-templates@latest
  claude-code-templates --command=project-management/todo --yes
  ```
- `.claude/settings.json` konfiguriert (siehe Workflow)

### Neue Features in v2.0

- ✅ **OpusPlan**: Automatisches Model-Switching (Opus für Planning, Sonnet für Execution)
- ✅ **TodoWrite Integration**: Progress-Tracking in allen Phasen
- ✅ **Extended Thinking**: Gezielt in komplexen Phasen (8k/16k Budget)
- ✅ **Context Management**: `/compact` statt `/clear` für Kontext-Erhalt
- ✅ **Plan Mode**: Strukturierte Implementierungsplanung
- ✅ **Multi-Session Support**: `claude-progress.txt` für Session-übergreifendes Tracking
- ✅ **.claude/rules/**: Project-spezifische Coding Standards
- ✅ **Hooks**: Automation (Auto-Format, Pre-Commit-Checks, Protected Files)
- ✅ **Subagents & Skills**: Spezialisierte Agents für Reviews und Tests
- ✅ **Troubleshooting**: Umfangreiche Problemlösungen und FAQs

### Highlights

- **Spec-Driven Development**: Strukturierter Ansatz von PRD bis produktionsreifem Code
- **Best Practices 2025**: Basiert auf aktuellen Anthropic Empfehlungen
- **Produktionsreif**: Validierte Workflows für professionelle Softwareentwicklung
- **Granulare Git-Integration**: Conventional Commits nach jeder Phase
- **Cheat-Sheet**: Schnellreferenz für erfahrene User (separate Datei)

---

## Bug Fix Guidelines v2.0

**Lightweight Process für Bug-Bearbeitung**

- **Guidelines**: [prd-to-code-workflow/v2/bug-fix-guidelines.md](./prd-to-code-workflow/v2/bug-fix-guidelines.md)

### Wann nutzen?

- ✅ **Bug Fixes**: 1-30 Story Points
- ✅ **Hotfixes**: Production-Critical Issues
- ✅ **Performance Issues**: Isolierte Performance-Probleme
- ✅ **Security Vulnerabilities**: Einzelne Sicherheitslücken

### 4 Prozesse nach Bug-Größe

| Prozess | Größe | Dauer | Phasen | Use Case |
|---------|-------|-------|--------|----------|
| **Direkt-Fix** | <5 SP | 1-2h | 1 | Typos, kleine Validierungsfehler |
| **Strukturierter Fix** | 5-15 SP | 0.5-2 Tage | 1 (Plan Mode) | Race Conditions, API Issues |
| **Komplexer Bug** | 15-30 SP | 3-5 Tage | 3 | Architektur-Issues, Data Corruption |
| **Hotfix** | Beliebig | <4h | 1 (Fast-Track) | Production down, Security Breach |

### Key Features

- 🎯 **Entscheidungsbaum**: Automatische Prozess-Auswahl basierend auf Bug-Größe
- 🚨 **Hotfix-Prozess**: Fast-Track für Production-Critical Issues
- 🔍 **Root Cause Analysis**: Strukturierte Analyse bei komplexen Bugs
- ✅ **Test-Strategie**: Fokus auf Regression Tests
- 📝 **Minimal Documentation**: Nur bei komplexen Bugs (15-30 SP)

### Abgrenzung zum PRD-to-Code Workflow

**Nutze Bug Fix Guidelines für**: Bugs (1-30 SP), Hotfixes, einzelne Defects

**Nutze PRD-to-Code Workflow für**: Features (40-120 SP), neue Funktionalität, Produktneuentwicklungen

---

## PRD-to-Code Workflow v1.0 (Legacy)

**Original Version ohne Best Practices**

- **Workflow**: [prd-to-code-workflow/v1/prd-to-code-workflow.md](./prd-to-code-workflow/v1/prd-to-code-workflow.md)

### Einschränkungen vs. v2.0

- ❌ Manuelles Model-Switching (`/model opus` / `/model sonnet`)
- ❌ Kein TodoWrite Progress-Tracking
- ❌ `/clear` führt zu Kontextverlust
- ❌ Kein Multi-Session Support
- ❌ Keine Hooks oder Automation
- ❌ Weniger strukturierte Git-Workflows

**Empfehlung**: Nutze **v2** für neue Projekte.

---

## Zielgruppe

Entwickler und Teams, die Claude Code für strukturierte, professionelle Softwareentwicklung nutzen möchten.

## Feedback & Beiträge

Bei Fragen oder Verbesserungsvorschlägen gerne Issues erstellen oder PRs einreichen.
