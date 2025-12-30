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

/review @PRD.md: Führe ein Review des PRD durch. Prüfe auf Verständlichkeit, Lücken, widersprüchliche Anforderungen und unklare Akzeptanzkriterien. Schlage konkrete Änderungen vor.
```

**Workflow:**
1. Claude generiert PRD (nutzt TodoWrite für Tracking)
2. Claude führt Review durch, schlägt Verbesserungen vor
3. User gibt Feedback
4. Claude arbeitet Änderungen ein
5. Bei Bedarf `/review @PRD.md` wiederholen bis stabil
6. User: "Committe das PRD"

**Commit-Message:**
```
docs: add PRD (reviewed, validated)
```

---

## Phase 2 – User Stories (Sonnet, 10-20 min)

**User-Eingaben:**
```text
/compact "Behalte PRD-Kernfeatures, Requirements, Security"
/todo "Erstelle aus PRD.md detaillierte User Stories im INVEST-Format.

Format:
- ID: US-XXX
- Title: [Kurzbeschreibung]
- Description: Als [Role] möchte ich [Feature] damit [Business Value]
- Acceptance Criteria: (3+ konkrete Bedingungen)
- Story Points: [Schätzung]
- Priority: [MoSCoW]

Ausgabe: user-stories.md"
```

**Workflow:**
1. Claude analysiert PRD und generiert User Stories
2. Claude validiert gegen INVEST-Kriterien
3. Claude speichert user-stories.md
4. User reviewt Stories, gibt Feedback bei Bedarf
5. User: "Committe die User Stories"

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
/todo "Erstelle aus user-stories.md konkrete Development Tasks für Sprint Planning.

Format:
- Task-ID: T-XXX
- Titel: [Kurzbeschreibung]
- User Story Link: US-XXX
- Beschreibung: [Technische Schritte]
- Acceptance Criteria: (Code, Tests >80%, Review, Merged)
- Story Points: [1-5]
- Dependencies: [Task-IDs]
- Priority: [Must/Should/Could]

Ausgabe: tasks.md"

Validiere user-stories.md + tasks.md auf:
✓ Dependencies: Keine Zirkularabhängigkeiten?
✓ Duplikate: Keine doppelten Stories/Tasks?
✓ Budget: Gesamtschätzung realistisch?
✓ Coverage: Alle PRD-Features abgedeckt?
✓ INVEST: Stories erfüllen INVEST-Kriterien?

Gib strukturierten Validierungsbericht aus.
```

**Workflow:**
1. Claude generiert Tasks aus User Stories
2. Claude führt Validierung durch und erstellt Bericht
3. User reviewt Validierungsbericht
4. Bei Issues: User gibt Anweisung → Claude arbeitet Fixes ein
5. Optional: Validierung wiederholen bei größeren Anpassungen
6. User: "Committe die Tasks"

**Commit-Message:**
```
docs: add tasks (X tasks, validated)
```

---

## Phase 4 – Sprint Plan (Sonnet (via OpusPlan), 5-10 min)

**User-Eingaben:**
```text
/compact "Behalte Tasks, Dependencies, Story Points, MoSCoW"

Gruppiere alle Tasks nach Sprints und erstelle sprint-plan.md:

Sprint 1 (Top-5 Tasks):
- T-XXX: [Task] (SP: 3)
- T-XXX: [Task] (SP: 2)

Sprint 2:
- [weitere Tasks]

Sprint 3 (optional):
- [weitere Tasks]

MoSCoW-Priorisierung (Must-Have zuerst).
Gesamtbudget: ~13-21 Story Points pro Sprint.
Output: sprint-plan.md
```

**Workflow:**
1. Claude sortiert Tasks nach MoSCoW-Priorisierung
2. Claude erstellt Dependency-Graph
3. Claude gruppiert in Sprints (13-21 SP pro Sprint)
4. Claude definiert Milestones
5. Claude speichert sprint-plan.md
6. User reviewt Sprint-Plan, gibt Feedback bei Bedarf
7. User: "Committe den Sprint-Plan"

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
Alt + M                          # Plan Mode
Implementiere Sprint 1 aus sprint-plan.md

Schreibe produktiven, produktionsreifen Code:
• Standard: Clean Code, SOLID Principles
• Tests: Mindestens 80% Coverage
• Dokumentation: Inline Comments für komplexe Logik
```
_(Nach User Review auf den Plan)_
```text
Alt + M                          # Start Execution (auto-Sonnet)
```

**Workflow:**
1. Claude erstellt Implementierungsplan in Plan Mode
2. User reviewt Plan, gibt Feedback/Approval
3. User startet Execution mit Alt + M
4. Claude implementiert Tasks aus Sprint (nutzt TodoWrite pro Task)
5. Claude führt Code Review durch
6. Claude erstellt Tests (>80% Coverage)
7. Claude updated claude-progress.txt
8. User: "Committe Sprint X"

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
