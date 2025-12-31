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

## Phase 1: PRD erstellen und reviewen (OpusPlan + Extended Thinking)

**Ziel**: Qualitativ hochwertiges PRD mit Review-Schleife

**Warum Plan Mode in Phase 1?**
- Tiefe Analyse für PRD-Qualität erforderlich
- Opus-Modell (via OpusPlan) für komplexes Reasoning
- Extended Thinking für durchdachte Architektur-Entscheidungen

### 1. Git-Setup

```bash
git checkout -b feature/oauth-ms-accounts
claude
```

### 2. Extended Thinking + Plan Mode aktivieren

**Schritt-für-Schritt:**

```text
1. Tab drücken (Extended Thinking aktivieren)
   → Budget: 8k (bereits in settings.json konfiguriert)

2. Plan Mode aktivieren:
   - Windows/Linux: Alt + M (zweimal drücken bis "Plan" angezeigt wird)
   - macOS: Option + M (zweimal drücken bis "Plan" angezeigt wird)
   - Alternative: Command-Palette (Ctrl/Cmd + Shift + P) → "Toggle Plan Mode"

3. Status prüfen:
   - UI zeigt "Plan" → Plan Mode aktiv ✅
   - UI zeigt "Extended Thinking" → Extended Thinking aktiv ✅
```

**Hinweise:**
- Modell ist bereits auf `opusplan` (aus settings.json)
- Extended Thinking Budget (8k) wurde in settings.json gesetzt
- Tab-Taste togglet Extended Thinking AN/AUS, ändert **nicht** das Budget
- Alt/Option + M togglet Plan Mode AN/AUS (zweimal drücken für Aktivierung)

### 3. PRD generieren

```text
/create-prd "Implementiere oAuth für Microsoft-Konten für User inkl. Refresh etc. Ziel ist es, dass User sich mit Claude Desktop mittels Remote-MCP mit den MCP-Endpunkten der API verbinden können."
```

**→ TodoWrite Update:** `"PRD generieren" → completed`

### 4. PRD Review durchführen

```text
/review @PRD.md: Führe ein Review des PRD durch. Prüfe auf Verständlichkeit, Lücken, widersprüchliche Anforderungen und unklare Akzeptanzkriterien. Schlage konkrete Änderungen vor.
```

**Claude erstellt automatisch:**
- Strukturierten Review-Report mit Findings
- Konkrete, priorisierte Verbesserungsvorschläge
- TodoWrite Update: `"PRD Review" → completed`

### 5. Feedback einarbeiten

**User gibt Feedback oder Anweisung:**
```text
Arbeite die Verbesserungen aus dem Review in PRD.md ein
```

**Claude arbeitet die Änderungen ein und updated TodoWrite automatisch**

**Bei Bedarf Schritt 4-5 wiederholen:**
```text
/review @PRD.md
```
Bis PRD stabil ist.

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

### User-Eingaben

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

### Workflow

1. Claude analysiert PRD und generiert User Stories
2. Claude validiert gegen INVEST-Kriterien
3. Claude speichert user-stories.md
4. Claude updated claude-progress.txt automatisch
5. User reviewt Stories, gibt Feedback bei Bedarf
6. User: "Committe die User Stories"

### Commit-Message

```bash
git add user-stories.md claude-progress.txt
git commit -m "docs: add user stories (X stories, Y SP, INVEST)"
```

**Hinweis:** Claude nutzt automatisch TodoWrite für Progress-Tracking. Du siehst den Fortschritt in Echtzeit.

---

## Phase 3: Tasks & Validierung (OpusPlan + Extended Thinking 8k)

**Ziel**: Detaillierte Dev-Tasks mit Qualitätssicherung

### User-Eingaben

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

### Workflow

1. Claude generiert Tasks aus User Stories
2. Claude führt 5 Validierungen durch und erstellt Bericht
3. User reviewt Validierungsbericht
4. Bei Issues: User gibt Anweisung → Claude arbeitet Fixes ein
5. Optional: Validierung wiederholen bei größeren Anpassungen
6. Claude updated claude-progress.txt automatisch
7. User: "Committe die Tasks"

### Commit-Message

```bash
git add tasks.md user-stories.md claude-progress.txt
git commit -m "docs: add tasks (X tasks, validated)"
```

**Hinweis:** Claude nutzt automatisch TodoWrite für Progress-Tracking durch alle Validierungsschritte.

---

## Phase 4: Sprint-Plan erstellen (Sonnet)

**Ziel**: Machbare Sprints mit MoSCoW-Priorisierung

### User-Eingaben

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

### Workflow

1. Claude sortiert Tasks nach MoSCoW-Priorisierung
2. Claude erstellt Dependency-Graph
3. Claude gruppiert in Sprints (13-21 SP pro Sprint)
4. Claude definiert Milestones
5. Claude speichert sprint-plan.md
6. Claude updated claude-progress.txt automatisch
7. User reviewt Sprint-Plan, gibt Feedback bei Bedarf
8. User: "Committe den Sprint-Plan"

### Commit-Message

```bash
git add sprint-plan.md claude-progress.txt
git commit -m "docs: add sprint plan (X sprints, Y SP)"
```

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

### Für jeden Sprint (z.B. Sprint 1)

**Warum Plan Mode?**
- Architektur-Planung vor Code-Schreiben
- Opus für detaillierte Implementierungspläne
- Code-Konsistenz über alle Sprint-Tasks

#### User-Eingaben

```text
Alt + M                          # Plan Mode (zweimal drücken bis "Plan" angezeigt wird)

Implementiere ALLE Tasks aus Sprint 1 basierend auf sprint-plan.md

Schreibe produktiven, produktionsreifen Code:
• Standard: Clean Code, SOLID Principles
• Tests: Mindestens 80% Coverage
• Dokumentation: Inline Comments für komplexe Logik
```

_(Nach User Review auf den Plan)_

```text
Alt + M                          # Start Execution (auto-Sonnet)
```

#### Workflow

1. Claude erstellt Implementierungsplan in Plan Mode
   - Analysiert Sprint Tasks (T-001 bis T-XXX)
   - Plant Files (neu/editieren), Dependencies, Interfaces
   - Definiert Architektur-Pattern (z.B. Clean Architecture, DI)

2. User reviewt Plan, gibt Feedback/Approval

3. User startet Execution mit Alt + M
   - OpusPlan wechselt automatisch zu Sonnet (effizient für Coding)

4. Claude implementiert Tasks aus Sprint
   - Nutzt TodoWrite pro Task (T-001 → in_progress → completed)
   - Wendet Qualitätskriterien an (aus .claude/rules/)
   - Security-Checks bei sensitivem Code

5. Claude führt Code Review durch
   - SOLID Principles, Security, Test Coverage, Error Handling

6. Claude erstellt Tests (>80% Coverage)
   - Unit Tests, Integration Tests

7. Claude updated claude-progress.txt automatisch

8. User: "Committe Sprint 1"

#### Commit-Message

```bash
git add src/ tests/ claude-progress.txt
git commit -m "feat(oauth): implement Sprint X - [Milestone]"
```

**Hinweis:** Claude updated claude-progress.txt automatisch und nutzt TodoWrite für jeden Task.

---

### Weitere Sprints (Sprint 2-N)

**Für jeden weiteren Sprint:**
- Wiederhol den gleichen Prozess (User-Eingaben → Workflow → Commit)
- **WICHTIG:** KEIN `/clear` oder `/compact` zwischen Sprints!
- Context bleibt erhalten für Code-Konsistenz

---

### Nach allen Sprints: Final

```bash
git push -u origin feature/oauth-ms-accounts
gh pr create --title "OAuth MS Accounts" --body "$(cat sprint-plan.md)"
```

---

## 📏 Feature Sizing & Scope Guidelines

### Optimale Feature-Größe (Sweet Spot)

**Empfohlene Größe:** 40-120 Story Points (~3-8 Sprints)

**Warum dieser Bereich?**
- PRD bleibt überschaubar (3-6 Seiten)
- User Stories: 10-25 Stories
- Tasks: 20-50 Tasks
- Context-Management mit `/compact` funktioniert gut
- Dependencies bleiben handhabbar
- Validierung bleibt durchführbar

**Beispiele für passende Features:**
- ✅ "OAuth-Integration für Microsoft Accounts mit Refresh Token und Remote-MCP Support" (~5 Sprints)
- ✅ "File Upload System mit S3, Preview-Generation, Virus-Scan und Versionierung" (~4 Sprints)
- ✅ "Reporting Dashboard mit 5 Chart-Typen, Filterung, Export (PDF/CSV/Excel)" (~6 Sprints)
- ✅ "Payment-Integration mit Stripe (Setup, Checkout, Webhooks, Refunds)" (~5 Sprints)
- ✅ "Notification-System (Email, Push, In-App, Preferences, Templates)" (~4 Sprints)

---

### Warnsignale: Feature zu groß

**Erkennungsmerkmale:**
- ❌ PRD >8 Seiten
- ❌ >30 User Stories
- ❌ >60 Development Tasks
- ❌ >10 Sprints geplant
- ❌ Validierungsbericht wird unlesbar
- ❌ Dependency-Graph unübersichtlich
- ❌ Context trotz `/compact` schwer handhabbar

**Beispiele für zu große Features:**
- ⚠️ "Komplettes Ticketing-System (Users, Tickets, Comments, Assignments, SLA, Reporting, Analytics)"
- ⚠️ "E-Commerce Platform komplett (Catalog, Cart, Checkout, Payment, Orders, Shipping, Returns)"
- ⚠️ "Social Media Feed (Posts, Comments, Likes, Shares, Notifications, Friends, Messages)"

**Lösung:** Feature in 2-3 unabhängige Sub-Features aufteilen, jeweils Workflow anwenden

---

### Grenzwertige Features (10-15 Sprints)

**Feature-Größe:** 200-300 Story Points

**Beispiele:**
- ⚠️ "Multi-Tenant System mit Isolation, Billing, Admin Panel" (~12 Sprints)
- ⚠️ "Real-time Collaboration System (WebSockets, State Sync, Conflict Resolution)" (~13 Sprints)
- ⚠️ "Advanced Search mit Elasticsearch (Indexing, Facets, Suggestions, Analytics)" (~11 Sprints)

**Herausforderungen:**
- PRD wird sehr lang (>8 Seiten)
- 50+ User Stories → Validierung komplex
- 100+ Tasks → Dependency-Tracking schwierig
- Context-Management trotz `/compact` herausfordernd
- Sprint-Planung: Schwer alle Dependencies zu erfassen

**Empfehlung:** Wenn möglich, in kleinere Features aufteilen. Falls nicht möglich, Feature-Batching verwenden (siehe unten).

---

### Strategien für große Projekte

#### **Strategie 1: Feature-Batching** (Empfohlen)

Zerlege komplettes Produkt in **unabhängige Feature-Batches**:

**Beispiel: CRM-System**

```
Produkt: CRM-System (komplett)

→ Batch 1: Lead-Management
   PRD: Lead CRUD, Import (CSV/API), Status Tracking, Assignment
   Workflow anwenden → 4-6 Sprints

→ Batch 2: Contact-Management
   PRD: Contact CRUD, Company Relations, Deduplication
   Workflow anwenden → 3-5 Sprints

→ Batch 3: Deal-Pipeline
   PRD: Deal Stages, Forecasting, Win/Loss Tracking
   Workflow anwenden → 5-7 Sprints

→ Batch 4: Reporting & Analytics
   PRD: Dashboards, Charts, Custom Reports, Export
   Workflow anwenden → 4-6 Sprints

→ Batch 5: Email-Integration
   PRD: Email Sync, Templates, Tracking, Automation
   Workflow anwenden → 4-5 Sprints
```

**Vorteile:**
- ✅ Jeder Batch bleibt in Sweet Spot (3-8 Sprints)
- ✅ Klare, fokussierte PRDs
- ✅ Überschaubare Dependencies pro Batch
- ✅ Iteratives User-Feedback möglich
- ✅ Frühe Deliverables (Lead-Mgmt nach 6 Wochen statt nach 6 Monaten)
- ✅ Weniger Risiko (kleinere Einheiten)

**Ablauf:**
1. High-Level Produkt-Roadmap erstellen (manuell, ~2 Seiten)
2. Priorisierung der Feature-Batches (MoSCoW)
3. Für jeden Batch: Kompletter Workflow (Phase 1-5)
4. Nach jedem Batch: Review, Deploy, Feedback
5. Nächster Batch basierend auf Learnings

---

#### **Strategie 2: MVP-First Approach**

**Phase 1: Core MVP** (Workflow anwenden)
- Minimale Features für Launch
- 8-12 Sprints
- Beispiel: "User Auth + Basic CRUD + Core Feature #1"

**Phase 2-N: Feature-Increments** (Workflow jeweils anwenden)
- Jede neue Feature-Gruppe als separater Workflow
- 3-6 Sprints pro Increment
- Beispiel: "Advanced Search" → Workflow
- Beispiel: "Reporting" → Workflow
- Beispiel: "API v2" → Workflow

**Vorteile:**
- ✅ Schnelles Time-to-Market
- ✅ Frühes User-Feedback
- ✅ Inkrementelles Wachstum
- ✅ Jede Phase = verwertbares Produkt

---

#### **Strategie 3: Architektur-PRD + Feature-PRDs** (Hybrid)

**Schritt 1: High-Level Architektur-PRD** (mit Claude Review, aber **nicht** kompletter Workflow)
- System-Architektur & Tech Stack
- Core-Module & Schnittstellen
- Datenmodell & Entities
- Security & Performance Requirements
- 1-2 Wochen, nur PRD-Phase (kein Sprint Planning)

**Schritt 2: Für jedes Core-Modul → Workflow anwenden**
```
→ Auth-Modul
   PRD → Stories → Tasks → Sprints (4-5 Sprints)

→ Data-Access-Layer
   PRD → Stories → Tasks → Sprints (3-4 Sprints)

→ API-Layer
   PRD → Stories → Tasks → Sprints (5-6 Sprints)

→ Frontend-Core
   PRD → Stories → Tasks → Sprints (6-8 Sprints)
```

**Vorteile:**
- ✅ Architektur-Konsistenz durch initiales Design
- ✅ Modules bleiben im Sweet Spot
- ✅ Parallele Entwicklung möglich (Teams)

---

### Praktische Entscheidungshilfe

**Frage:** Wie groß sollte mein Feature sein?

```
START
  │
  ├─ PRD passt auf <6 Seiten?
  │   ├─ JA → ✅ Workflow direkt anwenden
  │   └─ NEIN → Feature zu groß, weitermachen
  │
  ├─ <25 User Stories schätzbar?
  │   ├─ JA → ✅ Workflow direkt anwenden
  │   └─ NEIN → Feature zu groß, weitermachen
  │
  ├─ <50 Development Tasks?
  │   ├─ JA → ✅ Workflow direkt anwenden
  │   └─ NEIN → Feature zu groß, weitermachen
  │
  ├─ <8 Sprints schätzbar?
  │   ├─ JA → ⚠️  Grenzwertig, evtl. splitten
  │   └─ NEIN → Feature zu groß, weitermachen
  │
  └─ Feature splitten:
      ├─ Vertikal (nach User Journey): z.B. "Checkout" → "Cart" + "Payment" + "Order Processing"
      ├─ Horizontal (nach Layer): z.B. "API" + "Frontend" + "Admin Panel"
      └─ Nach Priorität (MVP): z.B. "Core Features" + "Nice-to-Have Features"
```

---

### Konkrete Größen-Beispiele

#### ✅ **Optimal (Sweet Spot)**

**Example 1: OAuth Microsoft Integration**
- PRD: 4 Seiten
- User Stories: 12 Stories, 48 SP
- Tasks: 28 Tasks
- Sprints: 5 Sprints
- ✅ Passt perfekt

**Example 2: File Management System**
- PRD: 5 Seiten (Upload, Storage, Preview, Versioning, Sharing)
- User Stories: 18 Stories, 62 SP
- Tasks: 35 Tasks
- Sprints: 6 Sprints
- ✅ Passt perfekt

---

#### ⚠️ **Grenzwertig → Besser splitten**

**Example: E-Commerce Checkout Flow**
- PRD: 9 Seiten (Cart, Addresses, Shipping, Payment, Tax, Order, Email, Tracking)
- User Stories: 35 Stories, 120 SP
- Tasks: 68 Tasks
- Sprints: 10 Sprints
- ⚠️ Zu groß!

**Lösung - Split in 3 Features:**
1. "Shopping Cart & Wishlist" → 3 Sprints (12 Stories, 35 SP)
2. "Checkout & Payment Integration" → 4 Sprints (15 Stories, 52 SP)
3. "Order Processing & Notifications" → 3 Sprints (8 Stories, 33 SP)
- ✅ Jedes Feature im Sweet Spot!

---

#### ❌ **Zu groß → Feature-Batching nötig**

**Example: Social Media Platform**
- PRD: 25+ Seiten (Users, Posts, Comments, Likes, Shares, Messages, Friends, Notifications, Feed Algorithm, Search, etc.)
- User Stories: 120+ Stories
- Tasks: 250+ Tasks
- Sprints: 30+ Sprints
- ❌ NICHT als ein Feature machbar!

**Lösung - Feature-Batching:**
```
Batch 1: User Management & Profiles (5 Sprints)
Batch 2: Posts & Basic Feed (4 Sprints)
Batch 3: Social Interactions (Comments, Likes, Shares) (5 Sprints)
Batch 4: Messaging System (6 Sprints)
Batch 5: Friend System & Discovery (4 Sprints)
Batch 6: Notifications (3 Sprints)
Batch 7: Advanced Feed Algorithm (5 Sprints)
Batch 8: Search & Explore (4 Sprints)
```
- ✅ Jeder Batch im Sweet Spot!
- ✅ Inkrementelle Releases möglich

---

### Zusammenfassung

| Kriterium | Sweet Spot | Grenzwertig | Zu groß |
|-----------|-----------|-------------|---------|
| **Story Points** | 40-120 SP | 120-200 SP | >200 SP |
| **Sprints** | 3-8 Sprints | 8-15 Sprints | >15 Sprints |
| **PRD Länge** | 3-6 Seiten | 6-10 Seiten | >10 Seiten |
| **User Stories** | 10-25 | 25-40 | >40 |
| **Tasks** | 20-50 | 50-80 | >80 |
| **Empfehlung** | ✅ Workflow direkt | ⚠️ Evtl. splitten | ❌ Feature-Batching |

**Faustregel:**
Wenn du beim Schreiben des PRD merkst, dass du >6 Seiten brauchst → Feature ist zu groß → Splitten!

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
