# Claude Code PRD-to-Code Workflow v2.0
## Spec-Driven Development mit Claude Code Best Practices (2025)

---

## ⚙️ Voraussetzungen & Setup

### 1. Commands & Templates installieren

```bash
# PRD Command
# Quelle: https://www.buildwithclaude.com/command/create-prd

# Story/Task Generator Templates
npm install -g claude-code-templates@latest
claude-code-templates --command=project-management/todo --yes

# Rename für Klarheit (empfohlen)
mv .claude/commands/todo.md .claude/commands/generate-stories.md
mv .claude/commands/todo.md .claude/commands/generate-tasks.md
```

### 2. Claude Settings konfigurieren

```json
// .claude/settings.json
{
  "model": "opusplan",  // Opus für Planning, auto-switch zu Sonnet für Execution
  "planMode": true      // Optional: Plan Mode als Default
}
```

### 3. Project Rules erstellen

```bash
mkdir -p .claude/rules
```

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

---

## 📋 Workflow-Übersicht

| Phase | Modell | TodoWrite | Context | Dauer |
|-------|--------|-----------|---------|-------|
| **0: Setup** | Haiku | ✅ | Fresh | 2-5 min |
| **1: PRD** | OpusPlan + Thinking (8k) | ✅ | Fresh | 15-30 min |
| **2: User Stories** | Sonnet | ✅ | Compact | 10-20 min |
| **3: Tasks & Validation** | OpusPlan + Thinking (16k) | ✅ | Compact | 15-25 min |
| **4: Sprint Plan** | Sonnet | ✅ | Compact | 5-10 min |
| **5: Implementation** | OpusPlan | ✅ per Sprint | Keep! | 1-3h per Sprint |

---

## Phase 0: Setup & Validierung (Haiku)

**Ziel**: Schnelle Umgebungs-Checks und Branch-Setup

```bash
git checkout -b feature/oauth-ms-accounts
claude
```

### In Claude:

```text
/model haiku

Führe Setup-Validierung durch:

TodoWrite:
- Git Branch erstellt (feature/oauth-ms-accounts)
- Dependencies checken (.NET SDK, npm)
- Codebase-Struktur analysieren (Controllers, Services, Tests)
- Claude Settings validieren (.claude/settings.json)

Gib kurzen Setup-Report aus.
```

**Expected TodoWrite Output:**
```javascript
[
  { content: "Git Branch erstellt", status: "completed", activeForm: "Branch erstellen..." },
  { content: "Dependencies prüfen", status: "completed", activeForm: "Dependencies prüfen..." },
  { content: "Codebase-Struktur analysieren", status: "completed", activeForm: "Struktur analysieren..." },
  { content: "Claude Settings validieren", status: "completed", activeForm: "Settings validieren..." }
]
```

**Git Commit:**
```bash
git add claude-progress.txt
git commit -m "chore: setup OAuth MS Accounts feature branch"
```

---

## Phase 1: PRD erstellen und reviewen (OpusPlan + Extended Thinking)

**Ziel**: Qualitativ hochwertiges PRD mit Review-Schleife

### 1. Modell & Thinking konfigurieren

```text
Tab  (Extended Thinking aktivieren, 8k Budget empfohlen)
```

Modell ist bereits auf `opusplan` (aus settings.json)

### 2. Plan Mode aktivieren

```text
Alt + M  (zweimal drücken, bis "Plan" angezeigt wird)
```

### 3. TodoWrite für Phase 1 initialisieren

```text
Erstelle Todo-Liste für PRD-Phase:
- PRD mit /create-prd generieren
- PRD Review durchführen
- Feedback einarbeiten und iterieren
- PRD finalisieren
- Phase 1 committen
```

### 4. PRD generieren

```text
/create-prd "Implementiere oAuth für Microsoft-Konten für User inkl. Refresh etc. Ziel ist es, dass User sich mit Claude Desktop mittels Remote-MCP mit den MCP-Endpunkten der API verbinden können."
```

**→ TodoWrite Update:** `"PRD generieren" → completed`

### 5. PRD Review durchführen

```text
/review @PRD.md: Führe ein detailliertes Review des PRD durch. Prüfe auf:
- Verständlichkeit und Klarheit
- Lücken in Anforderungen
- Widersprüchliche Requirements
- Unklare Akzeptanzkriterien
- Technische Machbarkeit
- Security Considerations

Schlage konkrete, priorisierte Verbesserungen vor.
```

**→ TodoWrite Update:** `"PRD Review" → in_progress` → nach Completion: `completed`

### 6. Feedback einarbeiten

```text
Arbeite folgende Punkte aus dem Review in PRD.md ein:
[Review-Feedback hier einfügen]
```

**→ TodoWrite Update:** `"Feedback einarbeiten" → in_progress`

**Bei Bedarf Schritt 5-6 wiederholen, bis PRD stabil**

**→ TodoWrite Update:** `"Feedback einarbeiten" → completed`

### 7. PRD finalisieren

**→ TodoWrite Update:** `"PRD finalisieren" → in_progress`

Erstelle `claude-progress.txt`:

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

### 8. Plan Mode verlassen (optional)

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
Erstelle Todo-Liste für User Stories Phase:
- PRD.md analysieren
- User Stories im INVEST-Format generieren
- Stories validieren (INVEST-Check)
- user-stories.md speichern
- claude-progress.txt aktualisieren
- Phase 2 committen
```

### 3. User Stories generieren

```text
/generate-stories "Erstelle aus PRD.md detaillierte User Stories im INVEST-Format.

TodoWrite Tracking nutzen für:
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

## Phase 3: Tasks & Validierung (OpusPlan + Extended Thinking 16k)

**Ziel**: Detaillierte Dev-Tasks mit Qualitätssicherung

### 1. Context komprimieren

```text
/compact "Behalte User Stories, Story Points, Dependencies, PRD-Kernfeatures"
```

### 2. Extended Thinking erhöhen

```text
Tab  (Budget auf 16k erhöhen für komplexe Validierung)
```

### 3. TodoWrite für Phase 3

```text
Erstelle Todo-Liste für Tasks & Validierung:
- User Stories analysieren
- Development Tasks ableiten
- Dependencies validieren (keine Zirkularabhängigkeiten)
- Duplikate prüfen
- Story Points validieren (Gesamt-Budget realistisch?)
- PRD-Coverage prüfen (alle Features abgedeckt?)
- INVEST-Kriterien final checken
- Validierungsbericht erstellen
- Feedback in tasks.md einarbeiten
- claude-progress.txt aktualisieren
- Phase 3 committen
```

### 4. Tasks generieren

```text
/generate-tasks "Erstelle aus user-stories.md konkrete Development Tasks für Sprint Planning.

TodoWrite nutzen für jeden Validierungsschritt!

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

TodoWrite für jeden Check:

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
[Findings hier einfügen]
```

**Bei größeren Anpassungen: Validierung wiederholen (Schritt 5)**

### 7. claude-progress.txt aktualisieren

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
Erstelle Todo-Liste für Sprint Planning:
- Tasks nach Priority sortieren
- Dependency-Graph erstellen
- Sprints gruppieren (Top-5 Must-Have Tasks zuerst)
- Story Points pro Sprint balancieren (13-21 SP)
- Sprint-Milestones definieren
- sprint-plan.md erstellen
- claude-progress.txt aktualisieren
- Phase 4 committen
```

### 3. Sprint-Plan erstellen

```text
Gruppiere alle Tasks nach Sprints und erstelle sprint-plan.md:

TodoWrite für jeden Sprint-Gruppierungsschritt nutzen!

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

#### 1. Plan Mode für Sprint aktivieren

```text
Alt + M  (Plan Mode aktivieren)
```

#### 2. TodoWrite für Sprint 1

```text
Erstelle Todo-Liste für Sprint 1 Implementierung:
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
- claude-progress.txt aktualisieren
```

#### 3. Implementierungsplan erstellen (Plan Mode)

```text
Analysiere sprint-plan.md Sprint 1 und erstelle detaillierten Implementierungsplan:

TodoWrite für Planungs-Schritte nutzen!

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
Alt + M  (Plan Mode verlassen)
```

**→ OpusPlan wechselt automatisch zu Sonnet für Execution!**

#### 6. Implementation (Auto-Sonnet via OpusPlan)

```text
Implementiere Sprint 1 basierend auf Plan-File:

TodoWrite für jeden Task (T-001 bis T-005) einzeln!

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

**Für jeden weiteren Sprint:**
1. TodoWrite initialisieren (Tasks aus sprint-plan.md)
2. Plan Mode → Implementierungsplan
3. User Review
4. Execution (Auto-Sonnet)
5. TodoWrite updates pro Task
6. Code Review
7. Tests
8. Commit
9. claude-progress.txt aktualisieren

**WICHTIG**: Context NICHT clearen zwischen Sprints!

---

### Nach allen Sprints: Final Review

```text
TodoWrite für Final Review:
- Alle Sprint-Milestones erreicht?
- End-to-End Test durchführen
- Security Audit
- Performance Check
- Dokumentation aktualisieren (README.md)
- Final Commit & Push
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

### Auto-Formatierung nach Code-Änderungen

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

## 🤖 Subagents (Optional but Recommended)

### PRD Reviewer

```markdown
<!-- .claude/agents/prd-reviewer/AGENT.md -->
# PRD Reviewer Agent

## Purpose
Review Product Requirements Documents for completeness, clarity, and technical feasibility.

## Tools
- Read, Grep, Glob

## Process
1. Read PRD.md
2. Check structure (Problem, Solution, Requirements, Acceptance Criteria)
3. Identify gaps, ambiguities, contradictions
4. Validate technical feasibility
5. Security considerations present?
6. Return structured review report with severity ratings

## Output Format
### Summary
- Overall Rating: [Pass/Needs Work/Fail]

### Findings
1. [Critical] Missing authentication security requirements
2. [High] Ambiguous acceptance criteria for US-003
3. [Medium] Performance targets not specified

### Recommendations
1. Add OAuth security best practices section
2. Clarify "user-friendly" in AC-003 with specific UX metrics
3. Define performance SLAs (response time, throughput)
```

**Usage:**
```text
Spawne prd-reviewer Subagent mit PRD.md
```

### Test Writer

```markdown
<!-- .claude/agents/test-writer/AGENT.md -->
# Test Writer Agent

## Purpose
Generate comprehensive unit and integration tests for C#/.NET code.

## Tools
- Read, Write, Edit, Bash

## Process
1. Read implementation files
2. Identify public APIs, edge cases, error paths
3. Generate xUnit tests with AAA pattern
4. Aim for >80% coverage
5. Run tests and fix failures
6. Return coverage report

## Output Format
- Tests written: [count]
- Coverage: [percentage]
- Tests passing: [count/total]
```

---

## 📊 Cheat-Sheet: Quick Reference v2.0

### Voraussetzungen

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

### Phase 0 – Setup (Haiku, 2-5 min)

```bash
git checkout -b feature/oauth-ms-accounts
claude
```

```text
/model haiku

TodoWrite Setup:
- Branch ✓
- Dependencies ✓
- Codebase-Struktur ✓
- Claude Settings ✓

→ Commit: "chore: setup feature branch"
```

---

### Phase 1 – PRD (OpusPlan + Thinking 8k, 15-30 min)

```text
Tab  (Thinking 8k)
Alt + M  (Plan Mode)

TodoWrite Phase 1:
- PRD generieren
- Review
- Feedback einarbeiten
- Committen

/create-prd "[Beschreibung]"

/review @PRD.md: [Review-Kriterien]

→ Iterieren bis stable

→ Commit: "docs: add PRD (reviewed, validated)"
```

---

### Phase 2 – User Stories (Sonnet, 10-20 min)

```text
/compact "Behalte PRD-Kernfeatures, Requirements, Security"

TodoWrite Phase 2:
- PRD analysieren
- Stories generieren
- INVEST validieren
- Speichern & committen

/generate-stories "INVEST-Format, aus PRD.md → user-stories.md"

→ Commit: "docs: add user stories (X stories, Y SP, INVEST)"
```

---

### Phase 3 – Tasks & Validierung (OpusPlan + Thinking 16k, 15-25 min)

```text
/compact "Behalte User Stories, Story Points, Dependencies"

Tab  (Thinking 16k)

TodoWrite Phase 3:
- Stories analysieren
- Tasks generieren
- 5 Validierungen (Dependencies, Duplikate, Budget, Coverage, INVEST)
- Bericht erstellen
- Fixes einarbeiten
- Committen

/generate-tasks "Tasks aus user-stories.md → tasks.md"

Validierung: Dependencies, Duplikate, Budget, Coverage, INVEST

→ Commit: "docs: add tasks (X tasks, validated)"
```

---

### Phase 4 – Sprint Plan (Sonnet, 5-10 min)

```text
/compact "Behalte Tasks, Dependencies, Story Points, MoSCoW"

TodoWrite Phase 4:
- Tasks sortieren (MoSCoW)
- Dependency-Graph
- Sprints gruppieren (13-21 SP)
- Milestones definieren
- Committen

Erstelle sprint-plan.md: Sprints mit MoSCoW, Dependencies, Budget

→ Commit: "docs: add sprint plan (X sprints, Y SP)"
```

---

### Phase 5 – Implementation (OpusPlan, 1-3h per Sprint)

**Für jeden Sprint:**

```text
KEIN /clear oder /compact! (Context behalten!)

TodoWrite Sprint X:
- Implementierungsplan (Plan Mode)
- T-XXX Tasks implementieren
- Code Review
- Tests (>80%)
- Committen
- Progress aktualisieren

Alt + M  (Plan Mode)
→ Implementierungsplan erstellen
→ User Review
→ Alt + M  (Execution startet, auto-Sonnet)

→ TodoWrite pro Task updaten

→ Commit: "feat(module): implement Sprint X - [Milestone]"
```

**Final:**

```bash
git push -u origin feature/oauth-ms-accounts

# PR erstellen
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
│ Phase 0: Setup (Haiku, TodoWrite)                   │
│ → Branch, Dependencies, Settings                    │
└─────────────────┬───────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────┐
│ Phase 1: PRD (OpusPlan+Think8k, Plan Mode)          │
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
│ Phase 3: Tasks (OpusPlan+Think16k)                  │
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
| **Extended Thinking** | Global aktiviert | ✅ Gezielt (8k/16k je Phase) |
| **Plan Mode** | Nur Phase 1 | ✅ Phase 1 + 5 (per Sprint) |
| **Git Workflow** | Vage "nach großen Blocks" | ✅ Granular, Conventional Commits |
| **Multi-Session** | Kein Tracking | ✅ claude-progress.txt |
| **Standards** | In Prompts wiederholt | ✅ .claude/rules/ (DRY) |
| **Automation** | Keine Hooks | ✅ Hooks (Format, Lint, Protect) |
| **Specialization** | Keine Subagents | ✅ Subagents (Review, Tests) |
| **Setup Phase** | Keine | ✅ Phase 0 (Haiku, schnell) |
| **Command Naming** | `/todo` (verwirrend) | ✅ `/generate-stories` (klar) |

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
