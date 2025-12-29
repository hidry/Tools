# Claude Code PRD-to-Code Workflow v2.0
## Spec-Driven Development mit Claude Code Best Practices (2025)

---

## ⚙️ Voraussetzungen & Setup

### 1. Commands & Templates installieren

```bash
# PRD Command installieren
# Option 1: Via buildwithclaude.com (empfohlen)
# 1. Besuche https://www.buildwithclaude.com/command/create-prd
# 2. Klicke "Add to Claude Code" oder kopiere den Command-Inhalt
# 3. Command wird zu ~/.claude/commands/ oder .claude/commands/ hinzugefügt

# Option 2: Prüfen ob bereits installiert
ls ~/.claude/commands/create-prd.md 2>/dev/null || \
ls .claude/commands/create-prd.md 2>/dev/null || \
echo "⚠️  /create-prd nicht gefunden - bitte über buildwithclaude.com installieren"

# Story/Task Generator Templates
npm install -g claude-code-templates@latest
claude-code-templates --command=project-management/todo --yes

# Optional: Weitere Templates für Stories und Tasks
# (Falls verfügbar - ansonsten /todo für beides nutzen)
# claude-code-templates --command=project-management/user-stories --yes
# claude-code-templates --command=project-management/tasks --yes

# Hinweis: Im Workflow wird /todo für Story/Task-Generierung genutzt
# Der Name ist OK, da TodoWrite ein separates Tool (kein Command) ist
```

### 2. Claude Settings konfigurieren

**Location**:
- **Projekt-spezifisch**: `<projekt-root>/.claude/settings.json` (empfohlen für Team-Projekte)
- **Global**: `~/.claude/settings.json` (für alle Projekte)
- Projekt-Settings überschreiben Global-Settings

```bash
# Projekt-Settings erstellen (empfohlen)
mkdir -p .claude
cat > .claude/settings.json <<'EOF'
{
  "model": "opusplan",
  "planMode": false,
  "extendedThinking": {
    "enabled": false,
    "budgetTokens": 8192
  }
}
EOF
```

```json
// .claude/settings.json - Finale Konfiguration
{
  "model": "opusplan",  // Opus für Planning, auto-switch zu Sonnet für Execution
  "planMode": false,     // Optional: true = Plan Mode als Default (nicht empfohlen)
  "extendedThinking": {
    "enabled": false,    // false = Tab aktiviert Extended Thinking / true = immer aktiv
    "budgetTokens": 8192  // 8k für Phase 1 & 3 (nicht interaktiv änderbar!)
  }
}
```

**Wichtig zu Extended Thinking:**
- `"enabled": false` → **Tab aktiviert** Extended Thinking (empfohlen!)
- `"enabled": true` → Extended Thinking **immer aktiv** (nicht empfohlen, hohe Kosten)
- Budget (8192 Tokens) wird in settings.json gesetzt und gilt für die gesamte Session
- Tab-Taste togglet Extended Thinking nur AN/AUS, ändert **nicht** das Budget
- Status-Check: Claude Code UI zeigt ob Extended Thinking aktiv ist
- Für verschiedene Budgets: Settings vor Session anpassen

### 3. Project Rules erstellen

```bash
mkdir -p .claude/rules
```

**Beispiele (passe für deinen Tech-Stack an):**

<details>
<summary>C#/.NET Projekt</summary>

```markdown
<!-- .claude/rules/coding-standards.md -->
# C#/.NET Coding Standards

- Clean Code Principles
- SOLID Principles
- Dependency Injection
- Async/Await best practices
```

```markdown
<!-- .claude/rules/testing.md -->
# Testing Standards

- Minimum 80% Code Coverage
- xUnit Framework
- Arrange-Act-Assert Pattern
- Mock external dependencies
```

```markdown
<!-- .claude/rules/documentation.md -->
# Documentation Standards

- XML Comments für public APIs
- README.md für jedes Modul
- Inline Comments nur für komplexe Logik
```
</details>

<details>
<summary>Python Projekt</summary>

```markdown
<!-- .claude/rules/coding-standards.md -->
# Python Coding Standards

- PEP 8 Style Guide
- Type Hints für alle Public Functions
- Dataclasses für Data Models
- Context Managers für Resource Handling
```

```markdown
<!-- .claude/rules/testing.md -->
# Testing Standards

- Minimum 80% Code Coverage
- pytest Framework
- Arrange-Act-Assert Pattern
- Mock external dependencies (pytest-mock)
```

```markdown
<!-- .claude/rules/documentation.md -->
# Documentation Standards

- Docstrings (Google Style) für public APIs
- README.md für jedes Modul
- Type annotations statt Comments
```
</details>

<details>
<summary>TypeScript/Node.js Projekt</summary>

```markdown
<!-- .claude/rules/coding-standards.md -->
# TypeScript Coding Standards

- ESLint + Prettier
- Strict TypeScript Mode
- Functional Programming Patterns
- Async/Await (keine Callbacks)
```

```markdown
<!-- .claude/rules/testing.md -->
# Testing Standards

- Minimum 80% Code Coverage
- Jest Framework
- Arrange-Act-Assert Pattern
- Mock dependencies (jest.mock)
```

```markdown
<!-- .claude/rules/documentation.md -->
# Documentation Standards

- JSDoc für public APIs
- README.md pro Package
- TypeScript Types statt Comments
```
</details>

---

## 📋 Workflow-Übersicht

| Phase | Modell | TodoWrite | Context | Dauer (Minimum)* |
|-------|--------|-----------|---------|------------------|
| **0: Setup** (Optional) | OpusPlan | ✅ | Fresh | 2-5 min |
| **1: PRD** | OpusPlan + Thinking (8k) | ✅ | Fresh | 15-30 min* |
| **2: User Stories** | Sonnet (via OpusPlan) | ✅ | Compact | 10-20 min |
| **3: Tasks & Validation** | OpusPlan + Thinking (8k) | ✅ | Compact | 15-25 min* |
| **4: Sprint Plan** | Sonnet (via OpusPlan) | ✅ | Compact | 5-10 min |
| **5: Implementation** | OpusPlan | ✅ per Sprint | Keep! | 1-3h per Sprint* |

**\*Zeitangaben-Hinweis:**
- Angaben sind **Minimum** für einfache Features ohne Iterationen
- **Realistische Zeiten** mit Reviews/Feedback-Schleifen:
  - Phase 1: **40-70 min** (PRD + 2-3 Review-Runden)
  - Phase 3: **25-40 min** (mit Validierungs-Fixes)
  - Phase 5: **2-5h pro Sprint** (realistisch für Implementierung + Tests)
- Komplexität variiert stark je nach Feature

---

## Phase 0: Setup & Validierung (Optional)

**Ziel**: Schnelle Umgebungs-Checks und Branch-Setup

**Hinweis**: Diese Phase ist optional. Für erfahrene User: Direkt zu Phase 1 springen.

```bash
git checkout -b feature/oauth-ms-accounts
claude
```

### In Claude:

```text
Führe Setup-Validierung durch und tracke den Fortschritt:

Erstelle eine Todo-Liste (du nutzt intern das TodoWrite-Tool) und arbeite folgende Punkte ab:
- Git Branch erstellt (feature/oauth-ms-accounts)
- Dependencies checken (.NET SDK, npm)
- Codebase-Struktur analysieren (Controllers, Services, Tests)
- Claude Settings validieren (.claude/settings.json)

Gib kurzen Setup-Report aus.
```

**Hinweis zu TodoWrite:**
- TodoWrite ist ein internes Tool, das Claude automatisch nutzt
- Du als User siehst die Todo-Liste und den Fortschritt in Echtzeit
- Du musst TodoWrite nicht manuell aufrufen

**Expected TodoWrite Output:**
```javascript
[
  { content: "Git Branch erstellt", status: "completed", activeForm: "Branch erstellen..." },
  { content: "Dependencies prüfen", status: "completed", activeForm: "Dependencies prüfen..." },
  { content: "Codebase-Struktur analysieren", status: "completed", activeForm: "Struktur analysieren..." },
  { content: "Claude Settings validieren", status: "completed", activeForm: "Settings validieren..." }
]
```

**Optional: Git Commit für Setup**
```bash
# Optional - nur wenn du Setup-Änderungen tracken möchtest
git commit --allow-empty -m "chore: setup OAuth MS Accounts feature branch"

# Hinweis: claude-progress.txt wird erst in Phase 1 erstellt!
```

---

## Phase 1: PRD erstellen und reviewen (OpusPlan + Extended Thinking)

**Ziel**: Qualitativ hochwertiges PRD mit Review-Schleife

**Warum Plan Mode in Phase 1?**
- Tiefe Analyse für PRD-Qualität erforderlich
- Opus-Modell (via OpusPlan) für komplexes Reasoning
- Extended Thinking für durchdachte Architektur-Entscheidungen

### 1. Extended Thinking + Plan Mode aktivieren

**Schritt-für-Schritt:**

```text
1. Tab drücken (Extended Thinking aktivieren)
   → Budget: 8k (bereits in settings.json konfiguriert)

2. Plan Mode aktivieren:
   - Windows/Linux: Alt + M
   - macOS: Option + M
   - Alternative: Command-Palette (Ctrl/Cmd + Shift + P) → "Toggle Plan Mode"

3. Status prüfen:
   - UI zeigt "Plan" → Plan Mode aktiv ✅
   - UI zeigt "Extended Thinking" → Extended Thinking aktiv ✅
```

**Hinweise:**
- Modell ist bereits auf `opusplan` (aus settings.json)
- Extended Thinking Budget (8k) wurde in settings.json gesetzt
- Tab-Taste togglet Extended Thinking AN/AUS, ändert **nicht** das Budget
- Alt/Option + M togglet Plan Mode AN/AUS

### 2. TodoWrite für Phase 1 initialisieren

```text
Erstelle eine Todo-Liste für die PRD-Phase und arbeite diese Schritte ab:
- PRD mit /create-prd generieren
- PRD Review durchführen
- Feedback einarbeiten und iterieren
- PRD finalisieren
- Phase 1 committen

(Claude wird automatisch TodoWrite nutzen, um den Fortschritt zu tracken)
```

### 3. PRD generieren

```text
/create-prd "Implementiere oAuth für Microsoft-Konten für User inkl. Refresh etc. Ziel ist es, dass User sich mit Claude Desktop mittels Remote-MCP mit den MCP-Endpunkten der API verbinden können."
```

**→ TodoWrite Update:** `"PRD generieren" → completed`

### 4. PRD Review durchführen

```text
Führe ein detailliertes Review von PRD.md durch. Lies das Dokument und prüfe auf:

- Verständlichkeit und Klarheit
- Lücken in Anforderungen
- Widersprüchliche Requirements
- Unklare Akzeptanzkriterien
- Technische Machbarkeit
- Security Considerations

Erstelle einen strukturierten Review-Report:
- Summary (Pass/Needs Work/Fail)
- Findings (Critical/High/Medium/Low)
  - Issue-Beschreibung
  - Location in PRD
  - Impact
- Recommendations (konkret, priorisiert)

Schlage konkrete, priorisierte Verbesserungen vor.
```

**→ TodoWrite Update:** `"PRD Review" → in_progress` → nach Completion: `completed`

### 5. Feedback einarbeiten

```text
Arbeite folgende Punkte aus dem Review in PRD.md ein:

⚠️ PLATZHALTER: [Review-Feedback aus Schritt 4 hier einfügen]

Beispiel:
- [HIGH] Zeile 45: OAuth Scopes unvollständig → ergänze 'offline_access' und 'User.Read'
- [MEDIUM] Zeile 78: Refresh Token Rotation nicht dokumentiert → Security-Section erweitern
- [LOW] Zeile 120: Akzeptanzkriterium "funktioniert" zu vage → konkretisieren
```

**→ TodoWrite Update:** `"Feedback einarbeiten" → in_progress`

**Bei Bedarf Schritt 4-5 wiederholen, bis PRD stabil**

**→ TodoWrite Update:** `"Feedback einarbeiten" → completed`

### 6. PRD finalisieren

**→ TodoWrite Update:** `"PRD finalisieren" → in_progress`

**Wichtig**: Du (Claude) erstellst diese Datei jetzt automatisch - der User macht das nicht manuell!

**Erstelle `claude-progress.txt` mit folgendem Inhalt:**

```markdown
# PRD-to-Code Progress: OAuth MS Accounts

## Phase 1: PRD ✅ COMPLETED
- PRD.md erstellt und reviewt (2 Review-Iterationen)
- Security Considerations ergänzt
- Akzeptanzkriterien präzisiert
- Commit: [wird ergänzt]

## Phase 2: User Stories ⏸️ PENDING
## Phase 3: Tasks & Validation ⏸️ PENDING
## Phase 4: Sprint Plan ⏸️ PENDING
## Phase 5: Implementation ⏸️ PENDING
```

**Git Commit:**
```bash
git add PRD.md claude-progress.txt
git commit -m "docs: add OAuth MS Accounts PRD (reviewed, security validated)"
```

**→ TodoWrite Update:** `"Phase 1 committen" → completed`

### 7. Plan Mode verlassen (optional)

```text
Alt + M  (wenn du für nächste Phase keinen Plan Mode brauchst)
```

---

## Phase 2: User Stories aus PRD ableiten (Sonnet)

**Ziel**: INVEST-konforme User Stories

### 1. Context komprimieren

```text
/compact "Behalte PRD-Kernfeatures, wichtigste Requirements, Security Considerations, technische Constraints"
```

**Wichtig**: NICHT `/clear` → PRD-Kontext bleibt erhalten!

### 2. TodoWrite für Phase 2

```text
Erstelle eine Todo-Liste für die User Stories Phase und arbeite diese Schritte ab:
- PRD.md analysieren
- User Stories im INVEST-Format generieren
- Stories validieren (INVEST-Check)
- user-stories.md speichern
- claude-progress.txt aktualisieren (du schreibst das automatisch)
- Phase 2 committen

(Claude nutzt intern TodoWrite für Progress-Tracking)
```

### 3. User Stories generieren

```text
/todo "Erstelle aus PRD.md detaillierte User Stories im INVEST-Format.

Tracke den Fortschritt mit einer Todo-Liste für:
- PRD analysieren
- Stories schreiben
- INVEST validieren
- Dokument speichern

Format pro Story:
- ID: US-XXX
- Title: [Kurzbeschreibung]
- Description: Als [Role] möchte ich [Feature] damit [Business Value]
- Acceptance Criteria: (mindestens 3 konkrete, testbare Bedingungen)
- Story Points: [Schätzung nach Fibonacci]
- Priority: [MoSCoW: Must/Should/Could/Won't]
- Dependencies: [US-IDs falls abhängig]

Ausgabe: user-stories.md"
```

**TodoWrite läuft automatisch während Generierung**

### 4. claude-progress.txt aktualisieren

**Wichtig**: Du (Claude) aktualisierst diese Datei automatisch - der User macht das nicht manuell!

**Schreibe folgenden Inhalt in claude-progress.txt:**

```markdown
## Phase 2: User Stories ✅ COMPLETED
- user-stories.md erstellt (8 Stories, INVEST-konform)
- Story Points: 56 SP gesamt
- Priority: 5 Must, 2 Should, 1 Could
- Commit: [wird ergänzt]
```

**Git Commit:**
```bash
git add user-stories.md claude-progress.txt
git commit -m "docs: add user stories for OAuth feature (8 stories, 56 SP, INVEST)"
```

**→ TodoWrite Update:** `"Phase 2 committen" → completed`

---

## Phase 3: Tasks & Validierung (OpusPlan + Extended Thinking 8k)

**Ziel**: Detaillierte Dev-Tasks mit Qualitätssicherung

### 1. Context komprimieren

```text
/compact "Behalte User Stories, Story Points, Dependencies, PRD-Kernfeatures"
```

### 2. Extended Thinking nutzen

```text
Tab  (Extended Thinking aktivieren - nutzt 8k Budget aus settings.json)
```

**Hinweis:** Extended Thinking ist bereits mit 8k konfiguriert, ausreichend für die Validierung

### 3. TodoWrite für Phase 3

```text
Erstelle eine Todo-Liste für Tasks & Validierung und arbeite diese Schritte systematisch ab:
- User Stories analysieren
- Development Tasks ableiten
- Dependencies validieren (keine Zirkularabhängigkeiten)
- Duplikate prüfen
- Story Points validieren (Gesamt-Budget realistisch?)
- PRD-Coverage prüfen (alle Features abgedeckt?)
- INVEST-Kriterien final checken
- Validierungsbericht erstellen
- Feedback in tasks.md einarbeiten
- claude-progress.txt aktualisieren (du schreibst das automatisch)
- Phase 3 committen

(TodoWrite trackt automatisch den Fortschritt durch alle Validierungsschritte)
```

### 4. Tasks generieren

```text
/todo "Erstelle aus user-stories.md konkrete Development Tasks für Sprint Planning.

Tracke jeden Validierungsschritt mit einer Todo-Liste!

Format pro Task:
- Task-ID: T-XXX
- Titel: [Kurzbeschreibung]
- User Story Link: US-XXX
- Beschreibung: [Technische Schritte, Code-Locations]
- Acceptance Criteria:
  ✓ Code implementiert
  ✓ Unit Tests >80% Coverage
  ✓ Integration Tests
  ✓ Code Review passed
  ✓ Merged to main
- Story Points: [1-5 nach Fibonacci]
- Dependencies: [T-IDs, chronologisch]
- Priority: [Must/Should/Could]
- Estimated Files: [Controller, Service, Tests, etc.]

Ausgabe: tasks.md"
```

### 5. Validierung durchführen

```text
Validiere user-stories.md + tasks.md systematisch:

Erstelle eine Todo-Liste und arbeite jeden Check ab:

✓ Dependencies: Keine Zirkularabhängigkeiten?
  - Erstelle Dependency Graph
  - Prüfe auf Zyklen
  - Identifiziere kritischen Pfad

✓ Duplikate: Keine doppelten Stories/Tasks?
  - Vergleiche Titles
  - Prüfe Descriptions auf Overlap

✓ Schätzung: Gesamtbudget realistisch?
  - User Stories: 56 SP
  - Tasks: Summe = 56 SP?
  - Velocity Check (13-21 SP pro Sprint üblich)

✓ Coverage: Alle PRD-Features abgedeckt?
  - PRD Requirements Liste
  - Mapping zu Stories
  - Mapping zu Tasks
  - Gap Analysis

✓ INVEST: Stories erfüllen Kriterien?
  - Independent, Negotiable, Valuable, Estimable, Small, Testable

Gib strukturierten Validierungsbericht aus:
- Summary (Pass/Fail pro Kategorie)
- Findings (Issues mit Severity)
- Recommendations (konkrete Fixes)
```

**TodoWrite läuft für alle 5 Checks**

### 6. Validierungsbericht Review & Fixes

```text
Arbeite Findings aus Validierungsbericht in tasks.md ein:

⚠️ PLATZHALTER: [Findings aus Schritt 5 hier einfügen]

Beispiel:
- [HIGH] T-005 hat zirkuläre Dependency zu T-003 → Reihenfolge korrigieren
- [MEDIUM] Story Points Summe: Tasks = 58 SP vs Stories = 56 SP → 2 SP zu viel, T-012 reduzieren
- [LOW] T-007 und T-009 haben identische Beschreibung → zusammenführen oder präzisieren
```

**Bei größeren Anpassungen: Validierung wiederholen (Schritt 5)**

### 7. claude-progress.txt aktualisieren

**Wichtig**: Du (Claude) aktualisierst diese Datei automatisch - der User macht das nicht manuell!

**Schreibe folgenden Inhalt in claude-progress.txt:**

```markdown
## Phase 3: Tasks & Validation ✅ COMPLETED
- tasks.md erstellt (23 Tasks)
- Validierung: ✅ Alle Checks passed
  - Dependencies: Keine Zyklen, kritischer Pfad identifiziert
  - Duplikate: Keine
  - Story Points: 56 SP (= User Stories ✓)
  - Coverage: 100% PRD Features mapped
  - INVEST: Alle Stories konform
- Commit: [wird ergänzt]
```

**Git Commit:**
```bash
git add tasks.md claude-progress.txt
git commit -m "docs: add development tasks (23 tasks, validated, dependency-free)"
```

**→ TodoWrite Update:** `"Phase 3 committen" → completed`

---

## Phase 4: Sprint-Plan erstellen (Sonnet)

**Ziel**: Machbare Sprints mit MoSCoW-Priorisierung

### 1. Context komprimieren

```text
/compact "Behalte Tasks, Dependencies, Story Points, Priorities (MoSCoW)"
```

### 2. TodoWrite für Phase 4

```text
Erstelle eine Todo-Liste für Sprint Planning und arbeite diese Schritte ab:
- Tasks nach Priority sortieren
- Dependency-Graph erstellen
- Sprints gruppieren (Top-5 Must-Have Tasks zuerst)
- Story Points pro Sprint balancieren (13-21 SP)
- Sprint-Milestones definieren
- sprint-plan.md erstellen
- claude-progress.txt aktualisieren (du schreibst das automatisch)
- Phase 4 committen

(Claude trackt den Fortschritt automatisch mit TodoWrite)
```

### 3. Sprint-Plan erstellen

```text
Gruppiere alle Tasks nach Sprints und erstelle sprint-plan.md:

Tracke jeden Sprint-Gruppierungsschritt mit einer Todo-Liste!

Regeln:
- MoSCoW-Priorisierung (Must-Have zuerst)
- Dependencies berücksichtigen (chronologisch)
- Story Points Budget: 13-21 SP pro Sprint
- Sprints: 3-5 Sprints (abhängig von Gesamtbudget)

Format:

# Sprint Plan: OAuth MS Accounts

## Sprint 1: Core OAuth Flow (Must-Have)
**Goal**: Funktionierende OAuth-Authentifizierung

Tasks:
- T-001: OAuth Controller Skeleton (SP: 3, Dependencies: -)
- T-002: Microsoft Identity Integration (SP: 5, Dependencies: T-001)
- T-003: Token Storage Service (SP: 3, Dependencies: T-002)
- T-004: Basic Unit Tests (SP: 2, Dependencies: T-001,T-002,T-003)
- T-005: Integration Test Setup (SP: 3, Dependencies: T-004)

**Total SP**: 16
**Milestone**: Manuelle OAuth-Anmeldung funktioniert

## Sprint 2: Token Management (Must-Have)
[weitere Tasks...]

**Total SP**: 18
**Milestone**: Refresh Tokens funktionieren

## Sprint 3: MCP Integration (Should-Have)
[weitere Tasks...]

**Total SP**: 15
**Milestone**: Remote MCP Connection funktioniert

## Sprint 4: Security & Hardening (Should-Have)
[weitere Tasks...]

**Total SP**: 7
**Milestone**: Production-ready

Ausgabe: sprint-plan.md
```

### 4. claude-progress.txt aktualisieren

**Wichtig**: Du (Claude) aktualisierst diese Datei automatisch - der User macht das nicht manuell!

**Schreibe folgenden Inhalt in claude-progress.txt:**

```markdown
## Phase 4: Sprint Plan ✅ COMPLETED
- sprint-plan.md erstellt
- 4 Sprints definiert (56 SP total)
  - Sprint 1: 16 SP (Core Flow)
  - Sprint 2: 18 SP (Token Mgmt)
  - Sprint 3: 15 SP (MCP)
  - Sprint 4: 7 SP (Security)
- Dependencies berücksichtigt, kritischer Pfad optimiert
- Commit: [wird ergänzt]
```

**Git Commit:**
```bash
git add sprint-plan.md claude-progress.txt
git commit -m "docs: add sprint plan (4 sprints, 56 SP, dependency-optimized)"
```

**→ TodoWrite Update:** `"Phase 4 committen" → completed`

---

## Phase 5: Implementierung nach Sprint-Plan (OpusPlan)

**Ziel**: Produktionsreifer Code mit Tests & Reviews

### ⚠️ WICHTIG: Context Management

```text
KEIN /clear oder /compact zwischen Sprints!
→ Code-Patterns, Architektur-Decisions bleiben erhalten
→ Konsistenz über alle Sprints
```

---

### Sprint 1: Core OAuth Flow

**Warum Plan Mode in Phase 5?**
- Architektur-Planung vor Code-Schreiben
- Opus für detaillierte Implementierungspläne
- Code-Konsistenz über alle Sprint-Tasks

#### 1. Plan Mode für Sprint aktivieren

```text
Plan Mode aktivieren:
- Windows/Linux: Alt + M
- macOS: Option + M
- Alternative: Command-Palette (Ctrl/Cmd + Shift + P) → "Toggle Plan Mode"
```

#### 2. TodoWrite für Sprint 1

```text
Erstelle eine Todo-Liste für Sprint 1 Implementierung und arbeite diese Schritte ab:
- sprint-plan.md Sprint 1 Tasks analysieren
- Implementierungsplan erstellen (welche Files, welche Änderungen)
- Plan reviewen lassen (User)
- T-001: OAuth Controller implementieren
- T-002: Microsoft Identity Integration implementieren
- T-003: Token Storage Service implementieren
- T-004: Unit Tests schreiben (>80% Coverage)
- T-005: Integration Tests schreiben
- Code Review durchführen
- Tests ausführen & validieren
- Sprint 1 committen
- claude-progress.txt aktualisieren (du schreibst das automatisch)

(TodoWrite trackt automatisch jeden Task-Fortschritt)
```

#### 3. Implementierungsplan erstellen (Plan Mode)

```text
Analysiere sprint-plan.md Sprint 1 und erstelle detaillierten Implementierungsplan:

Tracke die Planungs-Schritte mit einer Todo-Liste!

Für jeden Task (T-001 bis T-005):
- Welche Files neu erstellen? (z.B. Controllers/OAuthController.cs)
- Welche Files editieren? (z.B. Startup.cs, appsettings.json)
- Welche Dependencies hinzufügen? (NuGet: Microsoft.Identity.Web)
- Welche Interfaces/Services erstellen?
- Welche Tests schreiben?
- Architektur-Pattern: Clean Architecture, Dependency Injection

Erstelle detaillierten Plan in Plan-File.
```

#### 4. Plan Review & User Approval

**→ User reviewt Plan, gibt Go oder Feedback**

#### 5. Plan Mode verlassen → Execution startet

```text
Plan Mode verlassen:
- Windows/Linux: Alt + M
- macOS: Option + M
- UI zeigt "Plan" nicht mehr → Normal Mode aktiv
```

**→ OpusPlan-Behavior:**
- **Plan Mode aktiv**: Nutzt Claude Opus (starkes Reasoning)
- **Plan Mode verlassen**: Wechselt automatisch zu Claude Sonnet (effiziente Execution)
- **Status prüfen**: Claude Code UI zeigt aktuelles Modell (z.B. "Claude Opus 4" oder "Claude Sonnet 3.5")
- **Manuell wechseln**: `/model opus` oder `/model sonnet` (überschreibt OpusPlan temporär)

#### 6. Implementation (Auto-Sonnet via OpusPlan)

```text
Implementiere Sprint 1 basierend auf Plan-File:

Erstelle eine Todo-Liste für jeden Task (T-001 bis T-005) und arbeite sie einzeln ab!

Qualitätskriterien (aus .claude/rules/):
• Clean Code, SOLID Principles
• Dependency Injection
• Async/Await best practices
• XML Comments für public APIs
• Inline Comments nur für komplexe Logik
• Tests: >80% Coverage, xUnit, AAA-Pattern

Wichtig:
- Nach jedem Task TodoWrite updaten (completed)
- Security-Checks für OAuth (PKCE, State-Parameter, HTTPS-only)
```

**TodoWrite Updates während Implementierung:**
```javascript
// T-001 fertig:
{ content: "T-001: OAuth Controller", status: "completed", ... }

// T-002 in progress:
{ content: "T-002: Microsoft Identity Integration", status: "in_progress", ... }

// etc.
```

#### 7. Code Review (Optional: Subagent)

```text
Führe Code-Review für Sprint 1 durch:

Prüfe:
✓ SOLID Principles eingehalten?
✓ Security Best Practices (OAuth)?
✓ Test Coverage >80%?
✓ Async/Await korrekt?
✓ Error Handling vollständig?
✓ XML Comments vorhanden?

[Optional: Spawne code-reviewer Subagent für automatisiertes Review]
```

**→ TodoWrite:** `"Code Review" → completed`

#### 8. Tests ausführen

```bash
dotnet test --collect:"XPlat Code Coverage"
```

**Validierung:**
- Alle Tests grün ✅
- Coverage >80% ✅

**→ TodoWrite:** `"Tests validieren" → completed`

#### 9. Sprint 1 Commit

```bash
git add src/ tests/
git commit -m "feat(oauth): implement Sprint 1 - Core OAuth Flow

- T-001: OAuth Controller with Microsoft Identity endpoints
- T-002: Microsoft.Identity.Web integration with PKCE
- T-003: Token Storage Service (IDistributedCache)
- T-004: Unit Tests (87% coverage)
- T-005: Integration Tests (E2E OAuth flow)

Milestone: Manual OAuth login functional"
```

**→ TodoWrite:** `"Sprint 1 committen" → completed`

#### 10. claude-progress.txt aktualisieren

**Wichtig**: Du (Claude) aktualisierst diese Datei automatisch - der User macht das nicht manuell!

**Schreibe folgenden Inhalt in claude-progress.txt:**

```markdown
## Phase 5: Implementation 🔄 IN PROGRESS

### Sprint 1: Core OAuth Flow ✅ COMPLETED
- T-001 ✅ OAuth Controller (Controllers/OAuthController.cs)
- T-002 ✅ Microsoft Identity Integration (Startup.cs, appsettings.json)
- T-003 ✅ Token Storage Service (Services/TokenStorageService.cs)
- T-004 ✅ Unit Tests (87% coverage)
- T-005 ✅ Integration Tests (OAuth E2E)
- Commit: feat(oauth): implement Sprint 1 [abc1234]
- Milestone: ✅ Manual OAuth login functional

### Sprint 2: Token Management ⏸️ PENDING
### Sprint 3: MCP Integration ⏸️ PENDING
### Sprint 4: Security & Hardening ⏸️ PENDING
```

---

### Sprint 2-4: Analog zu Sprint 1

**Für jeden weiteren Sprint wiederholen:**

#### Übersicht (Details siehe Sprint 1 oben)

1. **TodoWrite initialisieren**
   - Tasks aus sprint-plan.md für aktuellen Sprint
   - Alle Sprint-Schritte in Todo-Liste aufnehmen

2. **Plan Mode aktivieren** (Alt/Option + M)
   - Implementierungsplan erstellen
   - Siehe → [Sprint 1, Schritt 3](#3-implementierungsplan-erstellen-plan-mode)

3. **User Review**
   - Plan reviewen lassen
   - Feedback einarbeiten

4. **Plan Mode verlassen** → Execution startet (Auto-Sonnet)

5. **Implementation**
   - Tasks einzeln abarbeiten
   - TodoWrite nach jedem Task updaten (completed)
   - Siehe → [Sprint 1, Schritt 6](#6-implementation-auto-sonnet-via-opusplan)

6. **Code Review**
   - SOLID, Security, Test Coverage prüfen
   - Siehe → [Sprint 1, Schritt 7](#7-code-review-optional-subagent)

7. **Tests ausführen**
   - Alle Tests grün?
   - Coverage >80%?

8. **Sprint Commit**
   - Conventional Commit Message
   - Siehe → [Sprint 1, Schritt 9](#9-sprint-1-commit)

9. **claude-progress.txt aktualisieren** (automatisch durch Claude)

**⚠️ WICHTIG**: Context NICHT clearen zwischen Sprints!
→ Code-Patterns & Architektur-Decisions bleiben erhalten
→ Konsistenz über alle Sprints

---

### Nach allen Sprints: Final Review

```text
Erstelle eine Todo-Liste für Final Review und arbeite alle Punkte ab:
- Alle Sprint-Milestones erreicht?
- End-to-End Test durchführen
- Security Audit
- Performance Check
- Dokumentation aktualisieren (README.md)
- Final Commit & Push

(Claude nutzt TodoWrite für das finale Tracking)
```

**Final Commit:**
```bash
git add .
git commit -m "feat(oauth): complete OAuth MS Accounts implementation

All 4 sprints completed:
- Sprint 1: Core OAuth Flow ✅
- Sprint 2: Token Management ✅
- Sprint 3: MCP Integration ✅
- Sprint 4: Security & Hardening ✅

Total: 23 Tasks, 56 SP, 87% Test Coverage
Milestone: Production-ready OAuth for Remote MCP"

git push -u origin feature/oauth-ms-accounts
```

**claude-progress.txt Final:**
```markdown
## Phase 5: Implementation ✅ COMPLETED

All Sprints: ✅ COMPLETED
- Total: 23 Tasks, 56 SP
- Test Coverage: 87%
- Security Audit: ✅ Passed
- Performance: ✅ <200ms OAuth flow
- Documentation: ✅ Updated

Final Commit: feat(oauth): complete implementation [xyz9876]
Branch: feature/oauth-ms-accounts
Status: Ready for PR
```

---

## 🔧 Hooks (Optional but Recommended)

**Hooks** ermöglichen deterministische Automation (z.B. Auto-Format, Pre-Commit-Checks).

### Setup (Einmalig)

**1. Node.js Projekt initialisieren:**
```bash
# Im Projekt-Root
cd /path/to/your/project
npm init -y
```

**2. Claude Agent SDK installieren:**
```bash
npm install --save-dev @anthropic-ai/agent-sdk typescript @types/node
```

**3. TypeScript konfigurieren:**
```bash
npx tsc --init
```

**Minimal-Konfiguration für Hooks:**
```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "esModuleInterop": true,
    "skipLibCheck": true,
    "strict": false,
    "resolveJsonModule": true
  },
  "include": [".claude/hooks/**/*"]
}
```

**4. Hooks-Verzeichnis erstellen:**
```bash
mkdir -p .claude/hooks
```

**5. Settings konfigurieren:**
```json
// .claude/settings.json (erweitert mit Hooks)
{
  "model": "opusplan",
  "extendedThinking": {
    "enabled": false,    // false = Tab aktiviert Extended Thinking
    "budgetTokens": 8192
  },
  "hooks": {
    "postToolUse": ".claude/hooks/post-tool-use.ts",
    "preToolUse": ".claude/hooks/pre-tool-use.ts"
  }
}
```

---

### Hook-Beispiele

#### Auto-Formatierung nach Code-Änderungen

```typescript
// .claude/hooks/post-tool-use.ts
export async function postToolUse(tool, result, context) {
  if ((tool === "Edit" || tool === "Write") && result.filePath?.endsWith(".cs")) {
    await context.bash(`dotnet format "${result.filePath}"`);
    console.log(`✓ Auto-formatted: ${result.filePath}`);
  }
}
```

### Pre-Commit Linting

```typescript
// .claude/hooks/pre-tool-use.ts
export async function preToolUse(tool, params, context) {
  if (tool === "Bash" && params.command?.includes("git commit")) {
    const lintResult = await context.bash("dotnet build --no-restore");
    if (lintResult.exitCode !== 0) {
      return {
        allowed: false,
        reason: "Build errors detected. Fix before committing."
      };
    }
  }
  return { allowed: true };
}
```

### Protect Production Config

```typescript
// .claude/hooks/pre-tool-use.ts
export async function preToolUse(tool, params, context) {
  const protectedFiles = ["appsettings.Production.json", ".env.production"];

  if ((tool === "Edit" || tool === "Write") &&
      protectedFiles.some(f => params.filePath?.includes(f))) {
    return {
      allowed: false,
      reason: "Production configuration files are protected"
    };
  }
  return { allowed: true };
}
```

---

## 🤖 Subagents & Skills (Optional but Recommended)

**Wichtig**: Es gibt zwei Arten spezialisierter Agents:

1. **Subagents (via Task Tool)**: Inline, keine Files, für einmalige Tasks
2. **Skills**: File-basiert, wiederverwendbar, für wiederkehrende Workflows

### Option 1: Inline Subagents (via Task Tool)

Für einmalige, spezialisierte Reviews ohne File-Overhead:

**Usage in Phase 1:**
```text
Spawne einen Subagent mit folgendem Prompt:

"Du bist ein PRD-Review-Spezialist. Analysiere PRD.md auf:
- Verständlichkeit und Vollständigkeit
- Lücken in Requirements
- Widersprüche
- Unklare Akzeptanzkriterien
- Technische Machbarkeit
- Security Considerations

Gib einen strukturierten Review-Report mit:
- Summary (Pass/Needs Work/Fail)
- Findings (Critical/High/Medium/Low)
- Konkrete Recommendations

Tools: Read, Grep"
```

**Vorteil**: Kein Setup, sofort nutzbar

**Nachteil**: Nicht wiederverwendbar zwischen Sessions

---

### Option 2: Skills (File-basiert, wiederverwendbar)

Für wiederkehrende Tasks, die du öfter brauchst:

```bash
# Setup
mkdir -p .claude/skills/prd-reviewer
```

```markdown
<!-- .claude/skills/prd-reviewer/SKILL.md -->
# PRD Reviewer Skill

## Purpose
Review Product Requirements Documents for quality and completeness.

## When to Use
- After /create-prd command
- Before moving to User Stories phase
- When PRD needs validation

## Process
1. Read PRD.md with Read tool
2. Check structure: Problem, Solution, Requirements, Acceptance Criteria
3. Identify gaps, ambiguities, contradictions
4. Validate technical feasibility
5. Security considerations present?
6. Generate structured review report

## Output Format
### Summary
- Overall Rating: [Pass/Needs Work/Fail]
- Reviewed: [Date]

### Findings
1. [Severity] Description
   - Location: Line X
   - Impact: ...
   - Recommendation: ...

### Action Items
- [ ] Fix Critical issues
- [ ] Address High priority items
- [ ] Consider Medium suggestions

## Tools
- Read (for PRD.md)
- Grep (for keyword searches)
```

```json
// .claude/skills/prd-reviewer/skill.json
{
  "name": "prd-reviewer",
  "description": "Reviews PRD documents for quality and completeness",
  "version": "1.0.0"
}
```

**Usage:**
```text
# In Claude
/skills prd-reviewer

# Oder inline
Nutze das prd-reviewer Skill um PRD.md zu reviewen
```

**Vorteil**: Wiederverwendbar, versionierbar, team-shareable

**Nachteil**: Setup-Overhead

---

### Empfehlung für PRD-to-Code Workflow

**Phase 1 (PRD Review)**: Inline Subagent (einmalig, schnell)
**Phase 5 (Code Review)**: Skill erstellen falls wiederholt gebraucht

**Alternative**: Einfach Claude direkt fragen statt Subagents/Skills zu nutzen

---

**Für das komplette Cheat-Sheet siehe:** [CHEATSHEET.md](./CHEATSHEET.md)

---

## 🛠️ Troubleshooting

### Command not found: `/create-prd`
**Problem**: `/create-prd` existiert nicht

**Lösung**:
```bash
# Check ob installiert
ls ~/.claude/commands/create-prd.md || ls .claude/commands/create-prd.md

# Falls nicht: Installation
# Besuche https://www.buildwithclaude.com/command/create-prd
# Klicke "Add to Claude Code"
```

---

### Extended Thinking funktioniert nicht
**Problem**: Tab-Taste macht nichts

**Lösung**:
1. Check settings.json: `"enabled": false` (nicht true!)
2. Tab-Taste drücken zum Aktivieren
3. Status in Claude Code UI prüfen (sollte "Extended Thinking" zeigen)
4. Falls immer noch nicht: Neustart von Claude Code

**Toggle-Verhalten:**
- `enabled: false` → Tab aktiviert / Tab wieder deaktiviert ✅ Empfohlen
- `enabled: true` → Immer aktiv, Tab macht nichts

---

### Plan Mode lässt sich nicht aktivieren
**Problem**: Alt/Option + M funktioniert nicht

**Lösung**:
- **Windows/Linux**: Alt + M zweimal drücken
- **macOS**: Option + M zweimal drücken (nicht Cmd!)
- **Alternative (alle)**:
  - Ctrl/Cmd + Shift + P → Command-Palette
  - Suche "Toggle Plan Mode"
  - Enter
- **Check**: UI sollte "Plan" anzeigen wenn aktiv
- **Terminal-Issue**: Manche Terminals blockieren Alt-Shortcuts → nutze Command-Palette

---

### OpusPlan nutzt immer Sonnet, nie Opus
**Problem**: Sehe nur "Claude Sonnet" in UI, nie "Claude Opus"

**Lösung**:
1. **Plan Mode aktivieren**: Alt/Option + M (zweimal!)
2. **UI checken**: Sollte "Plan" UND "Claude Opus" zeigen
3. **Opus wird nur in Plan Mode genutzt!**
4. Falls immer noch Sonnet:
   - Check settings.json: `"model": "opusplan"`
   - Manuell: `/model opusplan` eingeben
   - Restart Claude Code

**Erwartetes Verhalten:**
- Plan Mode ON → Claude Opus 4
- Plan Mode OFF → Claude Sonnet 3.5

---

### Session abgestürzt - wie weitermachen?
**Problem**: Claude Code abgestürzt mitten in Phase X

**Lösung**:
```bash
# 1. Letzten Stand identifizieren
git log --oneline | head -5
cat claude-progress.txt  # Falls vorhanden

# 2. Neue Session starten
claude

# 3. Context wiederherstellen
cat PRD.md
cat user-stories.md
cat tasks.md
cat sprint-plan.md

# 4. Claude informieren
"Ich arbeite am PRD-to-Code Workflow für [Feature].

Letzer Stand laut Git:
[commit message]

Letzter Stand laut claude-progress.txt:
- Phase 1: ✅ PRD
- Phase 2: ✅ User Stories
- Phase 3: 🔄 Tasks erstellt, Validierung offen

Nächster Schritt: Validierung in Phase 3 abschließen"
```

---

### Hooks funktionieren nicht
**Problem**: Code wird nicht formatiert, Pre-Commit-Checks laufen nicht

**Lösung**:
```bash
# 1. Node.js installiert?
node --version  # Sollte v18+ sein

# 2. Agent SDK installiert?
npm list @anthropic-ai/agent-sdk

# 3. TypeScript kompiliert?
npx tsc --noEmit  # Check für Errors

# 4. Settings korrekt?
cat .claude/settings.json | grep hooks

# 5. Hook-Files existieren?
ls .claude/hooks/post-tool-use.ts
ls .claude/hooks/pre-tool-use.ts

# 6. Claude Code Logs checken
# Im Claude Code Terminal sollten Hook-Errors sichtbar sein
```

**Häufiger Fehler:**
```json
// ❌ Falsch
"hooks": {
  "postToolUse": "post-tool-use.ts"  // Pfad fehlt!
}

// ✅ Korrekt
"hooks": {
  "postToolUse": ".claude/hooks/post-tool-use.ts"
}
```

---

### `/todo` Command generiert falsche Ausgabe
**Problem**: `/todo` erstellt nicht das erwartete Format

**Lösung**:
- `/todo` ist **generisch** - Prompt-Qualität entscheidet über Ausgabe
- **Gib detailliertes Format im Prompt vor:**
  ```text
  /todo "Erstelle aus PRD.md detaillierte User Stories im INVEST-Format.

  Format pro Story:
  - ID: US-XXX
  - Title: ...
  - Description: Als [Role]...

  Ausgabe: user-stories.md"
  ```
- **Falls verfügbar**: Nutze spezialisierte Commands wie `/generate-stories` falls installiert

---

### `/compact` macht Context kaputt
**Problem**: Nach `/compact` fehlen wichtige Infos

**Lösung**:
- `/compact` mit **klaren Anweisungen** nutzen:
  ```text
  /compact "Behalte PRD-Kernfeatures, wichtigste Requirements, Security Considerations, User Stories Summary, technische Constraints"
  ```
- **Wichtiges explizit benennen** was behalten werden soll
- **Falls zu viel verloren**: `/clear` und neu starten
- **Alternative**: Komplett ohne `/compact` arbeiten (Claude hat großen Context)

---

### Zeitangaben passen nicht
**Problem**: Phase 1 dauert 60 min statt 15-30 min

**Antwort**: Das ist **normal!**
- Zeitangaben in Tabelle sind **Minimum** für einfache Features
- **Realistische Zeiten** mit Reviews/Iterationen:
  - Phase 1: 40-70 min (PRD + 2-3 Review-Runden)
  - Phase 2: 15-30 min
  - Phase 3: 25-40 min (mit Validierungs-Fixes)
  - Phase 4: 5-10 min
  - Phase 5: 2-5h pro Sprint (realistisch)
- **Komplexität variiert** stark je nach Feature

---

## 🎓 Weiterführende Ressourcen

- [Claude Code Docs](https://code.claude.com/docs/)
- [Extended Thinking Guide](https://platform.claude.com/docs/en/build-with-claude/extended-thinking)
- [Claude Agent SDK](https://platform.claude.com/docs/en/agent-sdk/overview)
- [OpusPlan Best Practices](https://code.claude.com/docs/en/model-config.md)
- [Hooks Guide](https://code.claude.com/docs/en/hooks-guide.md)
- [Subagents Guide](https://code.claude.com/docs/en/sub-agents.md)

---

**Version**: 2.0
**Last Updated**: 2025-01-XX
**Author**: Based on Anthropic Best Practices 2025
