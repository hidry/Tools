# Claude Code PRD-to-Code Workflow - Cheat-Sheet v2.0

**Quick Reference für erfahrene User**

---

## Voraussetzungen

```bash
# Settings
echo '{"model": "opusplan", "planMode": true}' > .claude/settings.json

# Rules
mkdir -p .claude/rules
# Create coding-standards.md, testing.md, documentation.md

# Commands
npm install -g claude-code-templates@latest
claude-code-templates --command=project-management/todo --yes
```

---

## Phase 1 – PRD (OpusPlan + Thinking 8k, 15-30 min)

**Setup:**
```bash
git checkout -b feature/oauth-ms-accounts
claude
```

**User-Eingaben:**
```text
Tab                              # Extended Thinking (8k)
Alt + M                          # Plan Mode
/create-prd "[Beschreibung]"
```

**Claude führt automatisch aus:**
- Erstellt Todo-Liste für Phase 1 (PRD generieren, Review, Feedback einarbeiten, Committen)
- Nutzt TodoWrite für Progress-Tracking
- Führt PRD Review durch (Schritt 4 im Main Workflow)
- Iteriert bis stable

**Commit-Message:**
```
docs: add PRD (reviewed, validated)
```

---

## Phase 2 – User Stories (Sonnet, 10-20 min)

**User-Eingaben:**
```text
/compact "Behalte PRD-Kernfeatures, Requirements, Security"
/todo "Erstelle aus PRD.md detaillierte User Stories im INVEST-Format → user-stories.md"
```

**Claude führt automatisch aus:**
- Erstellt Todo-Liste für Phase 2 (PRD analysieren, Stories generieren, INVEST validieren, Speichern & committen)
- Nutzt TodoWrite für Progress-Tracking

**Commit-Message:**
```
docs: add user stories (X stories, Y SP, INVEST)
```

---

## Phase 3 – Tasks & Validierung (OpusPlan + Thinking 8k, 15-25 min)

**User-Eingaben:**
```text
/compact "Behalte User Stories, Story Points, Dependencies"
Tab                              # Extended Thinking (8k)
/todo "Erstelle aus user-stories.md konkrete Development Tasks für Sprint Planning → tasks.md"
```

**Claude führt automatisch aus:**
- Erstellt Todo-Liste für Phase 3 (Stories analysieren, Tasks generieren, 5 Validierungen, Bericht erstellen, Fixes einarbeiten, Committen)
- Nutzt TodoWrite für Progress-Tracking
- Führt 5 Validierungen durch (Dependencies, Duplikate, Budget, Coverage, INVEST)
- Erstellt Validierungsbericht und arbeitet Fixes ein

**Commit-Message:**
```
docs: add tasks (X tasks, validated)
```

---

## Phase 4 – Sprint Plan (Sonnet (via OpusPlan), 5-10 min)

**User-Eingaben:**
```text
/compact "Behalte Tasks, Dependencies, Story Points, MoSCoW"
```

**User gibt Claude Anweisung (kein Command):**
```text
Erstelle sprint-plan.md: Sprints mit MoSCoW, Dependencies, Budget
```

**Claude führt automatisch aus:**
- Erstellt Todo-Liste für Phase 4 (Tasks sortieren, Dependency-Graph, Sprints gruppieren, Milestones definieren, Committen)
- Sortiert Tasks nach MoSCoW
- Erstellt Dependency-Graph
- Gruppiert in Sprints (13-21 SP)
- Definiert Milestones
- Nutzt TodoWrite für Progress-Tracking

**Commit-Message:**
```
docs: add sprint plan (X sprints, Y SP)
```

---

## Phase 5 – Implementation (OpusPlan, 1-3h per Sprint)

⚠️ **WICHTIG:** KEIN `/clear` oder `/compact` zwischen Sprints! (Sprint-Context behalten!)

**Für jeden Sprint:**

**User-Eingaben:**
```text
Alt + M                          # Plan Mode → Implementierungsplan
```
_(Nach User Review auf den Plan)_
```text
Alt + M                          # Start Execution (auto-Sonnet)
```

**Claude führt automatisch aus:**
- Erstellt Todo-Liste für Sprint X (Implementierungsplan, T-XXX Tasks implementieren, Code Review, Tests, Committen, Progress aktualisieren)
- Erstellt Implementierungsplan (in Plan Mode)
- Wartet auf User Review
- Implementiert T-XXX Tasks (nach 2. Alt + M)
- Führt Code Review durch
- Erstellt Tests (>80% Coverage)
- Updated TodoWrite pro Task
- Updated claude-progress.txt

**Commit-Message:**
```
feat(module): implement Sprint X - [Milestone]
```

---

**Final:**

**User-Eingaben:**
```bash
git push -u origin feature/oauth-ms-accounts
gh pr create --title "OAuth MS Accounts" --body "$(cat sprint-plan.md)"
```

---

## 💡 Best Practices

### Context Management
- ✅ `/compact` mit klaren Anweisungen statt `/clear`
- ✅ Context NUR zwischen Phasen komprimieren, NICHT zwischen Sprints
- ✅ `/context` nutzen, um Context-Usage zu visualisieren

### TodoWrite
- ✅ In jeder Phase für Multi-Step-Tasks
- ✅ Tasks sofort als `completed` markieren nach Fertigstellung
- ✅ Max. 1 Task als `in_progress` gleichzeitig

### Model Selection
- ✅ OpusPlan als Default (Auto-Switching)
- ✅ Haiku für Setup/Validierung (speed-critical)
- ✅ Extended Thinking nur für Complex Reasoning (Phase 1, 3)

### Git Workflow
- ✅ Conventional Commits (`docs:`, `feat:`, `test:`, `refactor:`)
- ✅ Granulare Commits nach jeder Phase + jedem Sprint
- ✅ `claude-progress.txt` bei jedem Commit aktualisieren

### Hooks
- ✅ Post-Tool-Use: Auto-Formatierung
- ✅ Pre-Tool-Use: Linting, Protected Files
- ✅ Spezifische Matchers (nicht `*`)

### Subagents
- ✅ Fokussierte Agents (Single Responsibility)
- ✅ Minimal Tools (nur notwendige)
- ✅ Wiederverwendbar über Projekte

---

## 🔄 Workflow-Diagramm

```
┌─────────────────────────────────────────────────────┐
│ Phase 1: PRD (OpusPlan+Think8k, Plan Mode)          │
│ → Git Setup: Branch erstellen                       │
│ → TodoWrite: Generate → Review → Iterate → Commit   │
│ → claude-progress.txt initialisieren                │
└─────────────────┬───────────────────────────────────┘
                  │ /compact (keep PRD)
┌─────────────────▼───────────────────────────────────┐
│ Phase 2: User Stories (Sonnet)                      │
│ → TodoWrite: Analyze → Generate → Validate → Commit │
└─────────────────┬───────────────────────────────────┘
                  │ /compact (keep Stories)
┌─────────────────▼───────────────────────────────────┐
│ Phase 3: Tasks (OpusPlan+Think8k)                   │
│ → TodoWrite: Generate → 5x Validate → Fix → Commit  │
└─────────────────┬───────────────────────────────────┘
                  │ /compact (keep Tasks)
┌─────────────────▼───────────────────────────────────┐
│ Phase 4: Sprint Plan (Sonnet)                       │
│ → TodoWrite: Group → Balance → Milestones → Commit  │
└─────────────────┬───────────────────────────────────┘
                  │ NO /clear! (keep context)
┌─────────────────▼───────────────────────────────────┐
│ Phase 5: Implementation (OpusPlan)                  │
│ ┌──────────────────────────────────────────────┐    │
│ │ Per Sprint:                                   │    │
│ │ 1. TodoWrite Sprint Tasks                     │    │
│ │ 2. Plan Mode → Implementation Plan            │    │
│ │ 3. Execution (auto-Sonnet)                    │    │
│ │ 4. TodoWrite Updates per Task                 │    │
│ │ 5. Code Review                                │    │
│ │ 6. Tests (>80%)                               │    │
│ │ 7. Commit Sprint                              │    │
│ │ 8. Update claude-progress.txt                 │    │
│ │ 9. NO /clear → Next Sprint                    │    │
│ └──────────────────────────────────────────────┘    │
└─────────────────┬───────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────┐
│ Final: Review, E2E Tests, Documentation, Push       │
│ → PR erstellen mit sprint-plan.md als Body          │
└─────────────────────────────────────────────────────┘
```

---

## 📈 Verbesserungen vs. v1.0

| Aspekt | v1.0 | v2.0 (New) |
|--------|------|------------|
| **Model Config** | Manuelles `/model` switching | ✅ OpusPlan (auto-switching) |
| **Context Mgmt** | `/clear` → Kontextverlust | ✅ `/compact` mit Kontext-Erhalt |
| **Progress Tracking** | Keine TodoWrite | ✅ TodoWrite in allen Phasen |
| **Extended Thinking** | Global aktiviert | ✅ Gezielt (8k je Phase 1 & 3) |
| **Plan Mode** | Nur Phase 1 | ✅ Phase 1 + 5 (per Sprint) |
| **Git Workflow** | Vage "nach großen Blocks" | ✅ Granular, Conventional Commits |
| **Multi-Session** | Kein Tracking | ✅ claude-progress.txt |
| **Standards** | In Prompts wiederholt | ✅ .claude/rules/ (DRY) |
| **Automation** | Keine Hooks | ✅ Hooks (Format, Lint, Protect) |
| **Specialization** | Keine Subagents | ✅ Subagents (Review, Tests) |
| **Command Naming** | `/todo` (verwirrend) | ✅ `/todo` mit klarem Context (geklärt) |

---

**Version**: 2.0
**Last Updated**: 2025-01-XX
**Author**: Based on Anthropic Best Practices 2025
