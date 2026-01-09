# Sprint-Release-Workflow Enhancements (v2.1)

**Version:** 2.1
**Datum:** 2026-01-09
**Autor:** Claude
**Ziel:** Jeden Sprint releasebar machen ("Potentially Shippable Increment")

---

## 🎯 Problem-Statement

Der aktuelle PRD-to-Code-Workflow (v2.0) ist exzellent für strukturierte Feature-Entwicklung, hat aber eine Lücke:

**Sprints sind oft erst spät releasebar**, weil:
- Tasks horizontal gruppiert werden (z.B. "alle Backend-Tasks zuerst")
- Keine explizite Definition of Done für Releasebarkeit
- Fehlende End-to-End-Tests pro Sprint
- Keine Deployment-Strategie pro Sprint
- Sprint-Ziele nicht immer End-to-End nutzbar

**Konsequenz:** Erst nach mehreren Sprints gibt es ein nutzbares Inkrement.

---

## ✅ Lösung: 7 Prinzipien für Sprint-Releasebarkeit

Diese Enhancements erweitern v2.0 **evolutionär** (keine Breaking Changes).

---

### 1. Vertikales Slicing (Kritisch!)

**Wo:** Phase 4 - Sprint Planning
**Änderung:** Sprint-Zusammenstellung nach End-to-End-Features, nicht nach Komponenten

#### Alte Methode (v2.0)
```
Sprint-Planung basierend auf:
✓ Story Points (13-21 SP)
✓ Dependencies
✓ MoSCoW-Priorität
```

#### Neue Methode (v2.1)
```
Sprint-Planung basierend auf:
✓ Story Points (13-21 SP)
✓ Dependencies
✓ MoSCoW-Priorität
✓ Vertikale Slices (NEU!)
✓ Sprint-Goal (NEU!)
```

#### Vertikales Slicing - Checkliste

Ein Sprint enthält für jedes Feature ALLE Layer:

```
□ Backend-Komponente
  - Database Schema/Migration
  - Business Logic
  - API Endpoints

□ Frontend-Komponente
  - UI Components
  - State Management
  - API Integration

□ Tests
  - Unit Tests (Backend + Frontend)
  - Integration Tests (API + DB)
  - E2E Tests (User Flow)

□ Dokumentation
  - API Documentation (Swagger/OpenAPI)
  - User Documentation
  - Code Comments (komplexe Logik)

□ Deployment
  - Database Migrations
  - Environment Variables
  - Deployment Script
  - Rollback-Plan
```

#### Beispiel: User Management Feature

**❌ FALSCH (Horizontal)**
```
Sprint 1: User Database Models (Backend)
  - T-001: User Model erstellen (3 SP)
  - T-002: Role Model erstellen (2 SP)
  - T-003: Migrations schreiben (2 SP)
  Total: 7 SP → Nicht releasebar (kein Frontend!)

Sprint 2: User API Endpoints (Backend)
  - T-004: POST /users (3 SP)
  - T-005: GET /users/:id (2 SP)
  - T-006: PUT /users/:id (3 SP)
  Total: 8 SP → Nicht releasebar (kein Frontend!)

Sprint 3: User UI Components (Frontend)
  - T-007: UserList Component (5 SP)
  - T-008: UserForm Component (5 SP)
  Total: 10 SP → ERST JETZT releasebar!
```

**✅ RICHTIG (Vertikal)**
```
Sprint 1: User Registration (End-to-End)
  - T-001: User Model + Migration (3 SP)
  - T-002: POST /users Endpoint (3 SP)
  - T-003: Registration Form UI (4 SP)
  - T-004: Integration Tests (2 SP)
  - T-005: E2E Test: User kann sich registrieren (2 SP)
  - T-006: Docs: API + User Guide (1 SP)
  Total: 15 SP → Releasebar! User können sich registrieren.

Sprint 2: User Login (End-to-End)
  - T-007: Session Model + Migration (2 SP)
  - T-008: POST /login Endpoint + JWT (4 SP)
  - T-009: Login Form UI (3 SP)
  - T-010: Protected Route Guards (2 SP)
  - T-011: Integration + E2E Tests (3 SP)
  - T-012: Docs Update (1 SP)
  Total: 15 SP → Releasebar! User können sich einloggen.

Sprint 3: User Profile Management (End-to-End)
  - T-013: PUT /users/:id Endpoint (3 SP)
  - T-014: Profile Edit Form UI (4 SP)
  - T-015: Avatar Upload (S3 Integration) (5 SP)
  - T-016: Tests (2 SP)
  - T-017: Docs (1 SP)
  Total: 15 SP → Releasebar! User können Profil bearbeiten.
```

**Vorteil:** Nach jedem Sprint ist ein nutzbares Feature deployed!

---

### 2. Sprint-Goal Definition

**Wo:** Phase 4 - Sprint Planning
**Neu:** Jeder Sprint bekommt ein konkretes, testbares Ziel

#### Format

```markdown
## Sprint [X] Goal

**Als [Benutzer-Typ] kann ich [Aktion durchführen], um [Nutzen] zu erzielen.**

**Akzeptanzkriterium:** [Konkrete, testbare Bedingung]

**Demo-Szenario:** [Schritt-für-Schritt User Flow für Sprint-Demo]
```

#### Beispiele

```markdown
## Sprint 1 Goal

**Als neuer Nutzer kann ich mich registrieren und einloggen, um Zugang zur Plattform zu erhalten.**

**Akzeptanzkriterium:**
Ein Nutzer kann ein Konto mit Email und Passwort erstellen, erhält eine Bestätigungsmail,
und kann sich danach einloggen.

**Demo-Szenario:**
1. Öffne /register
2. Fülle Formular aus (Email, Passwort, Name)
3. Klicke "Registrieren"
4. Prüfe Email-Posteingang → Bestätigungsmail erhalten
5. Klicke Bestätigungslink
6. Öffne /login
7. Logge dich ein → Dashboard wird angezeigt

---

## Sprint 2 Goal

**Als eingeloggter Nutzer kann ich mein Profil bearbeiten und ein Profilbild hochladen,
um meine Identität zu personalisieren.**

**Akzeptanzkriterium:**
Nutzer können Name, Bio, und Profilbild ändern. Änderungen werden sofort sichtbar.

**Demo-Szenario:**
1. Logge dich ein
2. Gehe zu /profile/edit
3. Ändere Namen und Bio
4. Lade Profilbild hoch (max 5MB, JPG/PNG)
5. Klicke "Speichern"
6. Zurück zu /profile → Änderungen sind sichtbar
7. Andere Nutzer sehen ebenfalls das neue Profil
```

#### Validierung eines guten Sprint-Goals

Stelle sicher:
- ✅ **Nutzbar ohne nachfolgende Sprints** (inkremententell wertvoll)
- ✅ **Testbar** (klare Akzeptanzkriterien)
- ✅ **Wertstiftend** (liefert echten User-Value)
- ✅ **Demo-fähig** (kann Stakeholdern gezeigt werden)

---

### 3. Definition of Done (DoD)

**Wo:** Phase 5 - Implementation (pro Sprint)
**Neu:** Checklist für Releasebarkeit

#### Sprint Definition of Done Checklist

Kopiere diese Checklist in jedes `sprint-X-plan.md`:

```markdown
## Sprint [X] - Definition of Done

Ein Sprint ist NUR releasebar, wenn ALLE Kriterien erfüllt sind:

### ✅ Funktionale Kriterien
- [ ] Alle Acceptance Criteria der User Stories erfüllt
- [ ] Feature funktioniert End-to-End (Backend → Frontend → User)
- [ ] Sprint-Goal erreicht (Demo-Szenario erfolgreich durchführbar)
- [ ] Keine Known Bugs (Critical/High Priority)
- [ ] Edge Cases getestet (z.B. leere Felder, lange Inputs, Sonderzeichen)

### ✅ Technische Kriterien
- [ ] Code Review abgeschlossen (mindestens 1 Reviewer, alle Kommentare addressed)
- [ ] Unit Tests: ≥80% Coverage für neuen Code
- [ ] Integration Tests: Alle kritischen API-Pfade getestet
- [ ] E2E Tests: Mindestens 1 Happy-Path-Test pro User Story
- [ ] CI/CD Pipeline: Alle Checks bestanden (grün)
- [ ] Keine Compiler Warnings (kritische)
- [ ] Linter-Checks bestanden (ESLint/PSScriptAnalyzer)
- [ ] Performance-Tests (wenn relevant): Antwortzeiten <2s

### ✅ Deployment-Kriterien
- [ ] Database Migrations getestet (Up + Down)
- [ ] Deployment-Script vorhanden (`deploy-sprint-X.sh/.ps1`)
- [ ] Rollback-Plan dokumentiert (`ROLLBACK.md`)
- [ ] Environment Variables dokumentiert (`.env.example` aktualisiert)
- [ ] Secrets sicher hinterlegt (nicht im Code!)
- [ ] Health-Check-Endpoint funktioniert (`/health`)

### ✅ Dokumentations-Kriterien
- [ ] API Documentation aktualisiert (Swagger/OpenAPI)
- [ ] User-facing Dokumentation aktualisiert (README.md, Wiki, Docs-Seite)
- [ ] CHANGELOG.md aktualisiert (Conventional Commits Format)
- [ ] Architecture Decision Records (ADRs) erstellt (bei Architektur-Änderungen)
- [ ] Code Comments für komplexe Logik (mind. 1 Comment pro 50 Zeilen)
- [ ] Deployment-Instructions für DevOps (`DEPLOYMENT.md`)

### ✅ Sicherheits-Kriterien
- [ ] OWASP Top 10 Checklist durchgegangen
- [ ] Input Validation implementiert (Frontend + Backend)
- [ ] Authentication korrekt (z.B. JWT-Tokens, Sessions)
- [ ] Authorization korrekt (RBAC, Permissions)
- [ ] SQL Injection-Schutz (Prepared Statements/ORM)
- [ ] XSS-Schutz (Output Escaping)
- [ ] CSRF-Schutz (Tokens bei State-Changing Operations)
- [ ] Rate Limiting (API Endpoints)
- [ ] Keine Secrets im Code (`.env` check)

### ✅ Rückwärts-Kompatibilität
- [ ] Breaking Changes dokumentiert (BREAKING.md, wenn unvermeidbar)
- [ ] Migration-Guide für User (bei Breaking Changes)
- [ ] Alte API-Versionen unterstützt (deprecated, aber funktional)
- [ ] Database Migrations rückwärts-kompatibel (oder explizit dokumentiert)

### ✅ Qualitätssicherung
- [ ] Smoke-Tests auf Staging erfolgreich
- [ ] Browser-Kompatibilität getestet (Chrome, Firefox, Safari, Edge)
- [ ] Responsive Design getestet (Mobile, Tablet, Desktop)
- [ ] Accessibility (a11y) Basics geprüft (Keyboard-Navigation, Screen-Reader)
- [ ] Keine Console Errors im Browser
```

#### Verwendung

```bash
# Am Ende von Sprint-Implementation (Phase 5)
# BEVOR du committest:

1. Öffne sprint-X-plan.md
2. Gehe durch DoD-Checklist
3. Hake ALLE Punkte ab (oder dokumentiere, warum nicht)
4. Bei fehlenden Punkten: NICHT committen, erst fixen
5. Erst wenn 100% abgehakt: Sprint committen
```

---

### 4. Feature-Flags für Sprint-Übergreifende Features

**Wo:** Phase 3 (Task-Erstellung) + Phase 5 (Implementation)
**Wann:** Wenn ein Feature mehrere Sprints benötigt, aber trotzdem jeder Sprint deployed werden soll

#### Strategie

```markdown
Wenn ein Feature >2 Sprints benötigt:

1. Verstecke das Feature hinter einem Feature-Flag
2. Deploye jeden Sprint (Code ist da, aber Flag = OFF)
3. Im letzten Sprint: Flag aktivieren (Feature geht live)

Vorteil:
- Jeder Sprint kann deployed werden
- Kein Dead Code in Production
- Einfaches Rollback (Flag wieder OFF)
```

#### Implementation-Beispiel (TypeScript/Node.js)

**config/features.ts**
```typescript
export const FEATURE_FLAGS = {
  // Sprint 1-3: Advanced Search Implementation
  ADVANCED_SEARCH: process.env.ENABLE_ADVANCED_SEARCH === 'true',

  // Sprint 4-5: Payment Integration
  PAYMENT_INTEGRATION: process.env.ENABLE_PAYMENTS === 'true',

  // Sprint 6: Real-time Notifications
  REALTIME_NOTIFICATIONS: process.env.ENABLE_REALTIME === 'true',
}

export function isFeatureEnabled(feature: keyof typeof FEATURE_FLAGS): boolean {
  return FEATURE_FLAGS[feature] ?? false
}
```

**.env.example**
```bash
# Feature Flags
ENABLE_ADVANCED_SEARCH=false
ENABLE_PAYMENTS=false
ENABLE_REALTIME=false
```

**.env.production** (Initially)
```bash
# Sprint 1-2 deployed, but feature not ready
ENABLE_ADVANCED_SEARCH=false

# Sprint 3 deployed → Feature ready → Activate!
ENABLE_ADVANCED_SEARCH=true
```

**Usage in Code**
```typescript
// Backend API
import { isFeatureEnabled } from './config/features'

app.get('/api/search', async (req, res) => {
  if (isFeatureEnabled('ADVANCED_SEARCH')) {
    // Sprint 1-3: New advanced search logic
    return await advancedSearch(req.query)
  } else {
    // Old simple search (fallback)
    return await simpleSearch(req.query)
  }
})

// Frontend Component
import { FEATURE_FLAGS } from '@/config/features'

function SearchBar() {
  return (
    <div>
      {FEATURE_FLAGS.ADVANCED_SEARCH ? (
        <AdvancedSearchForm />
      ) : (
        <SimpleSearchForm />
      )}
    </div>
  )
}
```

#### Sprint-Plan mit Feature-Flags

```markdown
## Sprint 1: Advanced Search - Backend (Part 1/3)

**Feature-Flag:** `ENABLE_ADVANCED_SEARCH=false` (disabled in production)

Tasks:
- T-050: Implement search index (Elasticsearch/Algolia) (8 SP)
- T-051: Add search API endpoint `/api/search/advanced` (5 SP)
- T-052: Unit + Integration Tests (3 SP)

**DoD:**
- [ ] Code deployed to production (but flag OFF)
- [ ] Feature-Flag in .env.example documented
- [ ] README: How to enable feature locally for testing

---

## Sprint 2: Advanced Search - Frontend (Part 2/3)

**Feature-Flag:** `ENABLE_ADVANCED_SEARCH=false` (still disabled)

Tasks:
- T-053: Build AdvancedSearchForm component (5 SP)
- T-054: Integrate with backend API (3 SP)
- T-055: E2E Tests (4 SP)

**DoD:**
- [ ] Code deployed to production (flag still OFF)
- [ ] E2E Tests pass when flag=true locally

---

## Sprint 3: Advanced Search - Activation (Part 3/3)

**Feature-Flag:** `ENABLE_ADVANCED_SEARCH=true` (enable in production!)

Tasks:
- T-056: Performance Tuning (2 SP)
- T-057: Final QA Testing (2 SP)
- T-058: Update Docs (1 SP)
- T-059: Monitor Rollout (1 SP)

**DoD:**
- [ ] Feature-Flag activated in production
- [ ] Monitoring Dashboard zeigt keine Errors
- [ ] User Feedback collected (first 24h)
```

---

### 5. Erweiterte CI/CD Pipeline

**Wo:** `.github/workflows/`
**Neu:** Automated Sprint-Releases

#### Neue Workflow-Datei: `sprint-release.yml`

Erstelle `.github/workflows/sprint-release.yml`:

```yaml
name: Sprint Release Pipeline

on:
  push:
    branches:
      - 'claude/sprint-*'  # Trigger on sprint branches
      - main
  pull_request:
    types: [opened, synchronize, reopened]
  workflow_dispatch:  # Manual trigger

jobs:
  # Job 1: Code Quality
  code-quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install Dependencies
        run: npm ci

      - name: Lint
        run: npm run lint

      - name: Type Check
        run: npm run type-check

      - name: Security Audit
        run: npm audit --audit-level=high

  # Job 2: Unit Tests
  unit-tests:
    runs-on: ubuntu-latest
    needs: code-quality
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Dependencies
        run: npm ci

      - name: Run Unit Tests
        run: npm run test:unit -- --coverage

      - name: Check Coverage Threshold
        run: |
          COVERAGE=$(cat coverage/coverage-summary.json | jq '.total.lines.pct')
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "Coverage $COVERAGE% is below 80% threshold"
            exit 1
          fi

      - name: Upload Coverage
        uses: codecov/codecov-action@v3

  # Job 3: Integration Tests
  integration-tests:
    runs-on: ubuntu-latest
    needs: unit-tests
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: test
          POSTGRES_DB: testdb
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Dependencies
        run: npm ci

      - name: Run Migrations
        run: npm run db:migrate
        env:
          DATABASE_URL: postgresql://postgres:test@localhost:5432/testdb

      - name: Run Integration Tests
        run: npm run test:integration
        env:
          DATABASE_URL: postgresql://postgres:test@localhost:5432/testdb

  # Job 4: E2E Tests
  e2e-tests:
    runs-on: ubuntu-latest
    needs: integration-tests
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Dependencies
        run: npm ci

      - name: Install Playwright
        run: npx playwright install --with-deps

      - name: Build Application
        run: npm run build

      - name: Start Application
        run: npm run start &

      - name: Wait for Application
        run: npx wait-on http://localhost:3000

      - name: Run E2E Tests
        run: npm run test:e2e

      - name: Upload Playwright Report
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: playwright-report
          path: playwright-report/

  # Job 5: Build & Deploy to Staging
  deploy-staging:
    runs-on: ubuntu-latest
    needs: [code-quality, unit-tests, integration-tests, e2e-tests]
    if: github.ref == 'refs/heads/main' || startsWith(github.ref, 'refs/heads/claude/sprint-')
    environment:
      name: staging
      url: https://staging.example.com
    steps:
      - uses: actions/checkout@v4

      - name: Deploy to Staging
        run: |
          echo "Deploying to staging..."
          # Your deployment script here
          # e.g., ./scripts/deploy.sh staging

      - name: Run Smoke Tests
        run: npm run test:smoke -- --base-url=https://staging.example.com

      - name: Notify Slack
        if: success()
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "✅ Sprint deployed to staging: ${{ github.ref_name }}",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "*Deployment successful!*\n\n*Branch:* ${{ github.ref_name }}\n*URL:* https://staging.example.com"
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}

  # Job 6: Production Deployment (Manual Approval)
  deploy-production:
    runs-on: ubuntu-latest
    needs: deploy-staging
    if: github.ref == 'refs/heads/main'
    environment:
      name: production
      url: https://example.com
    steps:
      - uses: actions/checkout@v4

      - name: Deploy to Production
        run: |
          echo "Deploying to production..."
          # Your production deployment script

      - name: Create Release Tag
        run: |
          VERSION=$(cat package.json | jq -r '.version')
          git tag "v$VERSION"
          git push origin "v$VERSION"

      - name: Generate Release Notes
        uses: actions/github-script@v7
        with:
          script: |
            const commits = await github.rest.repos.listCommits({
              owner: context.repo.owner,
              repo: context.repo.repo,
              sha: context.sha,
              per_page: 10
            })
            const releaseNotes = commits.data
              .map(c => `- ${c.commit.message.split('\n')[0]}`)
              .join('\n')
            console.log(releaseNotes)

      - name: Notify Slack - Production
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "🚀 Deployed to PRODUCTION: v${{ github.ref_name }}",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "*🎉 Production Deployment*\n\n*Version:* ${{ github.ref_name }}\n*URL:* https://example.com"
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}

  # Job 7: Rollback (Manual Workflow)
  rollback:
    runs-on: ubuntu-latest
    if: github.event_name == 'workflow_dispatch'
    environment:
      name: production
    steps:
      - uses: actions/checkout@v4

      - name: Rollback to Previous Version
        run: |
          PREVIOUS_TAG=$(git describe --tags --abbrev=0 HEAD^)
          echo "Rolling back to $PREVIOUS_TAG"
          git checkout $PREVIOUS_TAG
          # Your rollback script
          ./scripts/deploy.sh production
```

#### Package.json Scripts

Add to `package.json`:

```json
{
  "scripts": {
    "test:unit": "jest --testPathPattern='.*.test.ts$'",
    "test:integration": "jest --testPathPattern='.*.integration.test.ts$'",
    "test:e2e": "playwright test",
    "test:smoke": "playwright test --grep @smoke",
    "db:migrate": "prisma migrate deploy",
    "type-check": "tsc --noEmit",
    "lint": "eslint . --ext .ts,.tsx"
  }
}
```

---

### 6. Sprint-Demo-Prozess

**Wo:** Ende von Phase 5 (nach jedem Sprint)
**Neu:** Strukturierter Demo-Prozess mit Stakeholder-Feedback

#### Sprint-Demo-Template

Erstelle nach jedem Sprint: `sprint-X-demo-notes.md`

```markdown
# Sprint [X] Demo Notes

**Datum:** [YYYY-MM-DD]
**Sprint-Goal:** [Copy from sprint-plan.md]
**Teilnehmer:** [Namen der Stakeholder]
**Demo-Dauer:** [z.B. 25 Minuten]

---

## 1. Sprint-Zusammenfassung

**Geplant:**
- [X] User Stories geplant
- [Y] Story Points geplant

**Erreicht:**
- [X] User Stories abgeschlossen
- [Y] Story Points abgeschlossen
- [Z]% Story Points erreicht

**Highlights:**
- ✅ [Größte Errungenschaft]
- ✅ [Zweite wichtige Errungenschaft]

**Herausforderungen:**
- ⚠️ [Größte Herausforderung + wie gelöst]

---

## 2. Demo-Szenario (Live-Demonstration)

**URL:** https://staging.example.com

### Schritt 1: [Feature-Teil 1]
**Aktion:** [Was wird gezeigt]
**Erwartetes Ergebnis:** [Was passieren sollte]
**Screenshot:** ![](./screenshots/sprint-X-step-1.png)

### Schritt 2: [Feature-Teil 2]
**Aktion:** [Was wird gezeigt]
**Erwartetes Ergebnis:** [Was passieren sollte]
**Screenshot:** ![](./screenshots/sprint-X-step-2.png)

[Weitere Schritte...]

---

## 3. Technische Highlights

**Architektur-Entscheidungen:**
- [ADR-Link oder kurze Beschreibung]

**Performance-Metriken:**
- API Response Time: [Xms]
- Page Load Time: [Xs]
- Test Coverage: [X%]

**Security-Maßnahmen:**
- [Implementierte Security-Features]

---

## 4. Stakeholder-Feedback

### Positive Rückmeldungen
- 👍 [Feedback 1]
- 👍 [Feedback 2]

### Verbesserungsvorschläge
- 💡 [Vorschlag 1] → **Aktion:** [Was tun wir damit?]
- 💡 [Vorschlag 2] → **Aktion:** [Backlog / Next Sprint / Won't Do]

### Kritische Probleme
- 🔴 [Problem 1] → **Aktion:** [Sofort fixen in diesem Sprint]
- 🟡 [Problem 2] → **Aktion:** [Nächster Sprint]

---

## 5. Release-Entscheidung

**Frage:** Soll dieser Sprint in Production deployed werden?

**Entscheidung:** ✅ JA / ❌ NEIN / ⏸️ WARTEN

**Begründung:**
[Warum ja/nein/warten]

**Wenn NEIN/WARTEN - Was fehlt noch?**
- [ ] [Blocker 1]
- [ ] [Blocker 2]

**Deployment-Termin:** [Datum + Uhrzeit]

---

## 6. Nächste Schritte

**Sofort (innerhalb 24h):**
- [ ] [Kritische Bugs aus Feedback fixen]

**Nächster Sprint:**
- [ ] [Features/Improvements aus Feedback]

**Backlog:**
- [ ] [Nice-to-haves für später]

---

## Anhang

**Video-Aufzeichnung:** [Link zur Demo-Aufzeichnung]
**Screenshots:** [./screenshots/sprint-X/]
**Code-Changes:** [GitHub Commit Range]
```

#### Demo-Prozess (Schritt-für-Schritt)

```markdown
## Sprint-Demo-Ablauf (25-30 Minuten)

### Vorbereitung (1 Tag vorher)
- [ ] Sprint auf Staging deployed
- [ ] Demo-Szenario getestet (Dry-Run)
- [ ] Screenshots erstellt
- [ ] Video-Aufzeichnung vorbereitet (falls asynchrone Demo)
- [ ] Demo-Notes-Dokument erstellt
- [ ] Stakeholder eingeladen (Kalender-Einladung)

### Demo-Meeting
**1. Intro (3 Min)**
- Sprint-Goal wiederholen
- Geplante vs. erreichte Story Points
- Kurzer Kontext

**2. Live-Demo (15 Min)**
- Schritt-für-Schritt durch Demo-Szenario
- Auf Staging-Umgebung zeigen
- Highlights erklären

**3. Technische Insights (5 Min)**
- Kurze Architektur-Erläuterung (wenn relevant)
- Performance/Security-Highlights

**4. Feedback-Sammlung (5 Min)**
- Offene Diskussion
- Notizen direkt in demo-notes.md

**5. Release-Entscheidung (2 Min)**
- Go/No-Go Decision
- Deployment-Termin festlegen

### Nachbereitung (direkt nach Demo)
- [ ] Demo-Notes finalisieren
- [ ] Feedback-Items in Backlog/TodoWrite übertragen
- [ ] Bei Go-Decision: Production-Deployment triggern
- [ ] Bei No-Go: Blocker als neue Tasks erstellen
```

---

### 7. Inkrementelle Architektur ("Walking Skeleton")

**Wo:** Phase 3 (Task-Erstellung)
**Prinzip:** Erst minimale End-to-End-Implementierung, dann iterative Verbesserung

#### Das "Walking Skeleton" Prinzip

```
Sprint 1: Dünn, aber komplett (End-to-End)
  ↓
Sprint 2+: Iterativ verbreitern und verbessern
```

**Ziel:** Nach Sprint 1 ist das Feature bereits nutzbar (wenn auch minimalistisch).

#### Beispiel: "File Upload Feature"

**❌ FALSCH (Zu viel in Sprint 1)**
```
Sprint 1: Vollständiges Upload-System (40 SP)
- Drag & Drop UI
- Multi-File-Upload
- Progress Bar
- Image Thumbnails
- Video Preview
- PDF Viewer
- S3 Storage mit CDN
- Virus-Scanning
- File-Type-Validation
- Size-Limits
→ Zu komplex, wahrscheinlich nicht in 1 Sprint fertig!
```

**✅ RICHTIG (Walking Skeleton)**
```
Sprint 1: Minimales Upload-System (15 SP) - WALKING SKELETON
- Einfaches File-Input (<input type="file">)
- Single-File-Upload
- Basic Size Validation (max 10MB)
- Local Storage (erst mal, nicht S3)
- File-Liste anzeigen
→ FUNKTIONIERT End-to-End! User können Dateien hochladen.

Sprint 2: Verbesserte UI (15 SP)
- Drag & Drop UI
- Multi-File-Upload
- Progress Bar
→ Besseres UX, aber Sprint 1 war schon nutzbar!

Sprint 3: Cloud Storage (15 SP)
- Migration zu S3
- CDN Integration
- Thumbnail-Generation
→ Skaliert jetzt besser, aber Sprint 1+2 waren schon im Einsatz!

Sprint 4: Security & Previews (15 SP)
- Virus-Scanning
- File-Type-Validation (tiefere Checks)
- Image/PDF Previews
→ Sicherer und komfortabler, aber Sprint 1-3 waren bereits produktiv!
```

#### Walking-Skeleton-Checkliste

Für jede User Story in Phase 3:

```markdown
## User Story: [Titel]

### Sprint 1: Walking Skeleton (Minimum Viable Feature)

**Frage:** Was ist das ABSOLUTE Minimum, damit das Feature End-to-End funktioniert?

Checklist:
- [ ] Einfachste UI (kein fancy Design, nur funktional)
- [ ] Einfachste Datenstruktur (kann später erweitert werden)
- [ ] Minimale Validierung (nur kritisch notwendig)
- [ ] Kein Error-Handling für Edge Cases (nur Main-Path)
- [ ] Kein Performance-Tuning (erst bei Bedarf)
- [ ] Keine Third-Party-Integrations (außer absolut notwendig)

**Akzeptanzkriterium:**
"Ein User kann [Hauptaktion] durchführen und sieht [Hauptergebnis]."

### Sprint 2+: Iterative Verbesserungen

**Was kann später kommen?**
- Besseres UI/UX
- Mehr Validierung
- Error-Handling
- Performance-Optimierungen
- Third-Party-Integrations
- Edge-Case-Behandlung
```

#### Beispiel-Aufgliederung: "User Registration"

```markdown
## User Story: US-003 - User Registration

### Sprint 1: Walking Skeleton (10 SP)

**Scope:**
- Email + Password Input (kein OAuth)
- Basic Email-Validation (Regex)
- Password-Hashing (bcrypt)
- User in DB speichern
- Redirect zu Login-Page
- Kein Email-Verification (erst mal)
- Kein "Forgot Password" (kommt später)

**Tasks:**
- T-010: User Model + Migration (2 SP)
- T-011: POST /register Endpoint (3 SP)
- T-012: Registration Form Component (3 SP)
- T-013: Tests (1 SP)
- T-014: Docs (1 SP)

**DoD:**
User kann Account erstellen und sich danach einloggen.

---

### Sprint 2: Email Verification (8 SP)

**Scope:**
- Send Verification Email (Nodemailer/SendGrid)
- Verification-Token-System
- Email-Verification-Page
- Resend-Email-Funktion

**Tasks:**
- T-015: Email-Service Integration (3 SP)
- T-016: Verification-Token-Logic (2 SP)
- T-017: Verification UI (2 SP)
- T-018: Tests + Docs (1 SP)

---

### Sprint 3: Password Strength & Recovery (10 SP)

**Scope:**
- Password-Strength-Indicator
- "Forgot Password" Flow
- Password-Reset-Emails
- Password-Reset-Page

**Tasks:**
- T-019: Password-Strength-Checker (2 SP)
- T-020: Password-Reset-Logic (4 SP)
- T-021: Reset UI (3 SP)
- T-022: Tests + Docs (1 SP)

---

### Sprint 4: OAuth Integration (15 SP)

**Scope:**
- Google OAuth
- Microsoft OAuth
- GitHub OAuth
- Account-Linking (OAuth + Email)

**Tasks:**
- T-023: OAuth-Strategy-Setup (5 SP)
- T-024: OAuth-UI (Social-Login-Buttons) (3 SP)
- T-025: Account-Linking-Logic (5 SP)
- T-026: Tests + Docs (2 SP)
```

**Vorteil:** Nach Sprint 1 können User sich registrieren! Jeder weitere Sprint verbessert das Feature.

---

## 🔀 Multi-Feature-Sprints

**Neu hinzugefügt:** 2026-01-09

### Problem: Was, wenn ein Sprint mehrere Features umsetzen soll?

Die obigen Prinzipien fokussieren auf **1 Feature pro Sprint**. Aber was ist, wenn:
- Mehrere kleine Features (jeweils <5 SP) in einen Sprint passen?
- Features logisch zusammengehören (z.B. Login + Logout + Session-Management)?
- Ein großes Feature + mehrere Bug-Fixes geplant sind?
- Team-Entwicklung mit parallelen Features?

### Lösung: 4 Multi-Feature-Strategien

**Detaillierte Dokumentation:**
→ Siehe `multi-feature-sprint-strategies.md` (ausführliche 50+ Seiten Anleitung)

**Template:**
→ Siehe `templates/multi-feature-sprint-template.md`

#### Kurz-Übersicht der Strategien:

**1. Primary/Secondary-Klassifizierung**
```
Primary Feature (MUST): Payment Integration (12 SP)
Secondary Features (SHOULD):
  - Loading Spinner (2 SP)
  - Error Messages (2 SP)

Release-Kriterium: Primary MUSS fertig sein.
                   Secondary sind optional.
```

**Wann nutzen?**
- 1 großes Feature + mehrere kleine Features
- Unsicherheit, ob alles fertig wird

---

**2. Feature-Set (Thematisches Bundling)**
```
Feature-Set: Session-Management (15 SP)
  - Login (5 SP)
  - Logout (2 SP)
  - Remember-Me (3 SP)
  - Session-Timeout (5 SP)

Release-Kriterium: ALLE Features MÜSSEN fertig sein.
                   (Feature-Set nur komplett sinnvoll)
```

**Wann nutzen?**
- Features gehören logisch zusammen
- Features ergeben erst gemeinsam Sinn

---

**3. Mini-Milestones (Sequenziell)**
```
Milestone 1 (Tag 1-2): Export-Funktion (5 SP)
Milestone 2 (Tag 3-4): Dark-Mode (7 SP)
Milestone 3 (Tag 5): Keyboard-Shortcuts (3 SP)

Release-Strategie: Nach jedem Milestone Staging-Deploy.
                   Am Sprint-Ende: Alle in Production.
```

**Wann nutzen?**
- Features sind unabhängig
- Klare zeitliche Abfolge möglich
- Kontinuierliches Feedback gewünscht

---

**4. Parallele Tracks (Team-Setting)**
```
Track A (Developer Alice): Notifications (8 SP)
Track B (Developer Bob): Search (7 SP)
Track C (Developer Charlie): API-Docs (5 SP)

Integration-Point: Tag 5 - Merge & Integration-Tests
```

**Wann nutzen?**
- Team mit mehreren Entwicklern
- Features komplett unabhängig
- Keine geteilten Komponenten

---

### Sprint-Goal bei Multi-Feature

**❌ Schlecht:**
```
"Als User kann ich Feature A, Feature B und Feature C nutzen."
→ Zu vage, kein Fokus
```

**✅ Gut (Primary/Secondary):**
```
"Als Nutzer kann ich Zahlungen durchführen (Primary).
Optional: Ladebalken sehen & bessere Fehlermeldungen (Secondary)."
→ Klare Priorisierung
```

**✅ Gut (Feature-Set):**
```
"Als Nutzer kann ich Session-Management nutzen (Login, Logout, Remember-Me, Timeout),
um sicher und bequem auf die Plattform zuzugreifen."
→ Übergeordnetes Ziel + enthaltene Features
```

**✅ Gut (Mini-Milestones):**
```
"Als Nutzer erlebe ich eine verbesserte User-Experience durch:
- Export-Funktion (Daten portabel)
- Dark-Mode (Augen schonen)
- Keyboard-Shortcuts (schneller arbeiten)"
→ Gemeinsames Thema: UX-Verbesserungen
```

---

### Definition of Done bei Multi-Feature

**Option A: Globale DoD** (alle Features müssen erfüllen)
- Jedes Feature hat gleiche DoD-Kriterien
- Sprint releasebar, wenn ALLE Features DoD erfüllen

**Option B: Feature-spezifische DoD** (unterschiedlich je Feature)
- Feature A: 100% DoD
- Feature B: 80% DoD (nicht fertig)
- → Entscheidung: Feature B verschieben oder Sprint verlängern

**Option C: Gewichtete DoD** (Primary/Secondary)
- Primary: 100% DoD → Sprint releasebar!
- Secondary: Best-Effort (können verschoben werden)

---

### Entscheidungsbaum

```
Sind die Features logisch zusammengehörig?
├─ JA → Feature-Set
└─ NEIN
   │
   Ist ein Feature deutlich wichtiger?
   ├─ JA → Primary/Secondary
   └─ NEIN
      │
      Mehrere Entwickler parallel?
      ├─ JA → Parallele Tracks
      └─ NEIN → Mini-Milestones
```

---

### Weitere Informationen

**Vollständige Anleitung:**
- `multi-feature-sprint-strategies.md` - 50+ Seiten mit:
  - Detaillierte Strategie-Beschreibungen
  - Praktische Beispiele (E-Commerce, SaaS, Bug-Fixes)
  - Demo-Szenarien
  - Anti-Patterns vermeiden
  - Risiko-Management

**Templates:**
- `templates/multi-feature-sprint-template.md` - Ready-to-use Template
  - Alle 4 Strategien enthalten
  - Feature-spezifische DoD-Checklists
  - Demo-Szenarien für verschiedene Strategien

---

## 🔄 Aktualisierter Workflow (v2.0 → v2.1)

### Was ändert sich?

| Phase | v2.0 | v2.1 (Neu) |
|-------|------|------------|
| **Phase 1** | PRD erstellen | ✅ Unverändert |
| **Phase 2** | User Stories | ✅ Unverändert |
| **Phase 3** | Tasks erstellen | ➕ Walking-Skeleton-Prinzip anwenden |
| **Phase 4** | Sprint Planning | ➕ Vertikales Slicing + Sprint-Goals |
| **Phase 5** | Implementation | ➕ DoD-Checklist + Feature-Flags + Demo |
| **Neu** | - | ➕ CI/CD-Pipeline erweitern |

### Konkrete Changes

#### Phase 3: Task-Erstellung (ERWEITERT)

**Alt:**
```
/todo "Erstelle aus user-stories.md detaillierte Development Tasks"
```

**Neu:**
```
/todo "Erstelle aus user-stories.md detaillierte Development Tasks.
WICHTIG:
1. Wende Walking-Skeleton-Prinzip an (Sprint 1 = minimal, aber komplett)
2. Markiere Tasks, die Feature-Flags benötigen (bei >2 Sprints)
3. Füge pro Task DoD-Kriterien hinzu"
```

**Output:** `tasks.md` mit Walking-Skeleton-Markierungen

---

#### Phase 4: Sprint Planning (ERWEITERT)

**Alt:**
```
Gruppiere Tasks in Sprints (13-21 SP, Dependencies beachten)
```

**Neu:**
```
Gruppiere Tasks in Sprints mit folgenden Regeln:

1. **Vertikales Slicing:**
   Jeder Sprint muss enthalten:
   - Backend-Komponente
   - Frontend-Komponente
   - Tests (Unit + Integration + E2E)
   - Dokumentation
   - Deployment-Tasks

2. **Sprint-Goal:**
   Formuliere pro Sprint ein konkretes, testbares Ziel:
   "Als [User] kann ich [Aktion], um [Nutzen] zu erzielen."

3. **Story Points:**
   - Optimal: 13-21 SP
   - Minimum: 8 SP (sonst zu klein)
   - Maximum: 25 SP (sonst zu groß)

4. **Feature-Flags:**
   - Markiere Sprints, die Teil eines größeren Features sind
   - Definiere, wann Feature-Flag aktiviert wird

5. **DoD-Integration:**
   - Kopiere DoD-Checklist in jedes Sprint-Plan
```

**Output:** `sprint-plan.md` mit Sprint-Goals und DoD

---

#### Phase 5: Implementation (ERWEITERT)

**Alt:**
```
1. Plan Mode aktivieren
2. Implementation Plan
3. Code schreiben
4. Tests
5. Code Review
6. Commit
```

**Neu:**
```
1. Plan Mode aktivieren
2. Implementation Plan
3. Code schreiben
4. Tests (Unit + Integration + E2E!)
5. Code Review
6. **DoD-Checklist durchgehen** (ALLE Punkte abhaken!)
7. Commit
8. **Deploy to Staging**
9. **Sprint-Demo vorbereiten** (Demo-Notes + Screenshots)
10. **Sprint-Demo durchführen** (Stakeholder-Feedback)
11. **Release-Entscheidung**:
    - Go → Deploy to Production
    - No-Go → Feedback als Tasks für nächsten Sprint
```

**Output:** `sprint-X-demo-notes.md` + Deployment

---

## 📋 Neue Templates

### Template 1: Sprint-Plan (v2.1)

`sprint-X-plan.md`:

```markdown
# Sprint [X] - [Feature-Name]

**Sprint-Goal:**
Als [User-Typ] kann ich [Aktion], um [Nutzen] zu erzielen.

**Story Points:** [X SP]
**Dauer:** [Start-Datum] - [End-Datum]
**Feature-Flag:** [Falls relevant: `FLAG_NAME=false` → aktivieren in Sprint Y]

---

## Tasks

### Backend
- [ ] T-XXX: [Task-Beschreibung] (X SP)
- [ ] T-YYY: [Task-Beschreibung] (Y SP)

### Frontend
- [ ] T-ZZZ: [Task-Beschreibung] (Z SP)

### Tests
- [ ] T-AAA: Unit Tests (X SP)
- [ ] T-BBB: Integration Tests (Y SP)
- [ ] T-CCC: E2E Tests (Z SP)

### Dokumentation
- [ ] T-DDD: API Docs (1 SP)
- [ ] T-EEE: User Docs (1 SP)

### Deployment
- [ ] T-FFF: Migrations (1 SP)
- [ ] T-GGG: Deployment Script (1 SP)

---

## Definition of Done

[Copy komplette DoD-Checklist von oben]

---

## Demo-Szenario

**Ziel:** Sprint-Goal demonstrieren

1. [Schritt 1]
2. [Schritt 2]
3. [Erwartetes Ergebnis]

---

## Risiken & Abhängigkeiten

**Risiken:**
- ⚠️ [Risiko 1] → Mitigation: [Plan]

**Abhängigkeiten:**
- [Externe Abhängigkeit, z.B. API-Key für Third-Party-Service]
```

---

### Template 2: Feature-Flag-Dokumentation

`FEATURE_FLAGS.md`:

```markdown
# Feature Flags

Dieses Projekt nutzt Feature-Flags für schrittweises Rollout.

---

## Aktive Feature-Flags

### `ENABLE_ADVANCED_SEARCH`
**Status:** 🔴 Disabled (in Entwicklung)
**Sprints:** Sprint 5-7
**Geplante Aktivierung:** Sprint 7 (2026-02-15)
**Beschreibung:** Erweiterte Suchfunktion mit Elasticsearch-Backend
**Rollback-Plan:** Flag auf `false` setzen → alte Suche aktiv

### `ENABLE_PAYMENTS`
**Status:** 🟢 Enabled
**Sprints:** Sprint 8-10
**Aktiviert seit:** 2026-01-20
**Beschreibung:** Stripe-Integration für Zahlungen
**Rollback-Plan:** Flag auf `false` → Payment-Button versteckt

---

## Archivierte Feature-Flags

### `ENABLE_NEW_DASHBOARD`
**Status:** ✅ Permanent aktiviert (Code-Cleanup durchgeführt)
**Entfernt in:** v2.5.0
**Beschreibung:** Neues Dashboard-Design (jetzt Standard)
```

---

## 🎓 Best Practices Zusammenfassung

### 1. Sprint-Planung

✅ **DO:**
- Plane Sprints vertikal (End-to-End Features)
- Definiere klare Sprint-Goals
- Halte Sprints zwischen 13-21 SP
- Inkludiere ALLE Layer (Backend, Frontend, Tests, Docs, Deployment)

❌ **DON'T:**
- Plane horizontal (erst Backend, dann Frontend)
- Überlade Sprints (>25 SP)
- Vergiss Tests oder Docs
- Plane Features, die ohne nachfolgende Sprints nicht nutzbar sind

---

### 2. Implementation

✅ **DO:**
- Gehe IMMER durch DoD-Checklist
- Schreibe E2E-Tests (mindestens 1 Happy-Path)
- Deploye nach jedem Sprint auf Staging
- Führe Sprint-Demos durch
- Sammle Stakeholder-Feedback

❌ **DON'T:**
- Commite ohne DoD-Check
- Überspringe E2E-Tests ("kommt später")
- Deploye direkt zu Production ohne Staging
- Überspringe Sprint-Demos

---

### 3. Feature-Flags

✅ **DO:**
- Nutze Feature-Flags für >2-Sprint-Features
- Dokumentiere Flags in FEATURE_FLAGS.md
- Aktiviere Flags erst, wenn Feature komplett
- Räume alte Flags auf (nach 2-3 Releases)

❌ **DON'T:**
- Lass inaktive Flags jahrelang im Code
- Vergiss zu dokumentieren, wann Flag aktiviert wird
- Aktiviere Flags ohne Tests

---

### 4. Walking Skeleton

✅ **DO:**
- Sprint 1: Minimal, aber komplett End-to-End
- Sprint 2+: Iterativ verbessern
- Frage: "Was ist das absolute Minimum?"

❌ **DON'T:**
- Sprint 1: Versuche, alles perfekt zu machen
- Baue Features, die erst in Sprint 5 nutzbar sind

---

## 📊 Erfolgs-Metriken

Wie misst du, ob v2.1 funktioniert?

### KPIs pro Sprint

| Metrik | Ziel | Messung |
|--------|------|---------|
| **Definition of Done Erfüllung** | 100% | DoD-Checklist vollständig abgehakt? |
| **Test Coverage** | ≥80% | Code Coverage Report |
| **Deployment-Frequenz** | 1x pro Sprint | Anzahl Staging-Deployments |
| **Sprint-Demo-Teilnahme** | ≥3 Stakeholder | Meeting-Teilnehmer |
| **Sprint-Goal-Erreichung** | 100% | Demo-Szenario erfolgreich? |
| **Rollback-Rate** | <5% | Anzahl Rollbacks / Deployments |
| **Time-to-Production** | <24h nach Sprint-Demo | Stunden zwischen Demo und Prod-Deployment |

### Qualitäts-Metriken

| Metrik | Ziel |
|--------|------|
| **Bugs nach Release** | <3 bugs/sprint |
| **Security Vulnerabilities** | 0 (critical/high) |
| **E2E-Test-Erfolgsrate** | 100% |
| **CI/CD-Pipeline-Erfolgsrate** | ≥95% |

---

## 🚀 Migration von v2.0 zu v2.1

### Für laufende Projekte

Wenn du bereits ein Projekt mit v2.0 am Laufen hast:

**Option 1: Soft-Migration (Empfohlen)**
```
1. Finish current sprint mit v2.0
2. Ab nächstem Sprint: v2.1 anwenden
3. Sprint Planning neu machen (vertikal statt horizontal)
4. DoD-Checklist einführen
5. Sprint-Demos starten
```

**Option 2: Harter Cut**
```
1. Aktuellen Sprint abschließen
2. Re-Planning aller verbleibenden Sprints (v2.1-Style)
3. Tasks umgruppieren (vertikal)
4. Sofort mit DoD und Demos starten
```

### Für neue Projekte

Nutze v2.1 von Anfang an:

```bash
# Phase 1-3: Unverändert (v2.0)
/create-prd "..."
/review @PRD.md
/compact "..."
/todo "User Stories..."
/compact "..."
/todo "Tasks... WALKING SKELETON!"

# Phase 4: v2.1 (Vertikal + Sprint-Goals)
"Erstelle Sprint-Plan mit:
- Vertikalen Slices
- Sprint-Goals
- DoD-Checklist pro Sprint
- Feature-Flag-Strategie (wenn nötig)"

# Phase 5: v2.1 (DoD + Demos)
[Pro Sprint]
1. Implementation
2. DoD-Check
3. Deploy Staging
4. Sprint-Demo
5. Release-Decision
6. Deploy Production (wenn Go)
```

---

## 📚 Zusätzliche Ressourcen

### Externe Links

- **Vertical Slicing:** https://www.agilealliance.org/glossary/vertical-slice
- **Walking Skeleton:** https://wiki.c2.com/?WalkingSkeleton
- **Definition of Done:** https://www.scrum.org/resources/blog/walking-through-definition-done
- **Feature Toggles:** https://martinfowler.com/articles/feature-toggles.html
- **INVEST Criteria:** https://www.agilealliance.org/glossary/invest

### Interne Dokumente

- `v2/prd-to-code-workflow.md` - Basis-Workflow (v2.0)
- `v2/CHEATSHEET.md` - Quick-Reference
- `v2/bug-fix-guidelines.md` - Bug-Fix-Prozesse
- `.github/workflows/sprint-release.yml` - CI/CD-Pipeline
- `FEATURE_FLAGS.md` - Feature-Flag-Dokumentation

---

## ❓ FAQ

### F: Muss ich ALLE DoD-Punkte abhaken?
A: **Ja!** Sonst ist der Sprint nicht releasebar. Wenn ein Punkt nicht anwendbar ist (z.B. "keine DB-Migration in diesem Sprint"), markiere als "N/A" mit Begründung.

### F: Was, wenn ich den Sprint-Goal nicht erreiche?
A: **Dann ist der Sprint nicht releasebar.** Entweder:
1. Weiterarbeiten bis Sprint-Goal erreicht (Sprint verlängern)
2. Scope reduzieren (Sprint-Goal anpassen + stakeholder approval)
3. Sprint als "nicht releasebar" markieren und im nächsten Sprint finishen

### F: Brauche ich wirklich E2E-Tests für jeden Sprint?
A: **Ja, mindestens 1 Happy-Path-Test.** Sonst weißt du nicht, ob das Feature End-to-End funktioniert. E2E-Tests sind der Beweis, dass dein Sprint releasebar ist.

### F: Was ist, wenn Stakeholder nicht an Sprint-Demos teilnehmen?
A: **Asynchrone Alternative:**
1. Erstelle Video-Aufzeichnung der Demo
2. Schreibe ausführliche Demo-Notes mit Screenshots
3. Teile via Slack/Email
4. Sammle schriftliches Feedback (Kommentare im Dokument)

### F: Kann ich v2.0 und v2.1 mischen?
A: **Nicht empfohlen.** Entweder konsequent v2.0 ODER v2.1. Mischen führt zu Inkonsistenzen.

### F: Wie lange dauert ein Sprint mit v2.1?
A: **Ungefähr gleich wie v2.0** (1-3 Tage für 13-21 SP). Der zusätzliche Aufwand (DoD, Demos) ist minimal (~10-15% mehr Zeit), aber die Qualität steigt signifikant.

---

## 📝 Changelog

### v2.1 (2026-01-09)
- ➕ Added: Vertikales Slicing in Sprint Planning
- ➕ Added: Sprint-Goal Definition
- ➕ Added: Definition of Done Checklist
- ➕ Added: Feature-Flag-Strategie
- ➕ Added: CI/CD-Pipeline Erweiterung
- ➕ Added: Sprint-Demo-Prozess
- ➕ Added: Walking-Skeleton-Prinzip
- 📝 Updated: Phase 3 (Tasks mit Walking-Skeleton)
- 📝 Updated: Phase 4 (Sprint Planning vertikal)
- 📝 Updated: Phase 5 (DoD + Demos)

### v2.0 (2025-XX-XX)
- Initial release mit OpusPlan + Extended Thinking

---

## 🎯 Zusammenfassung: Warum v2.1?

**Problem:** Sprints waren oft erst nach mehreren Iterationen releasebar.

**Lösung:** 7 Prinzipien für Sprint-Releasebarkeit:

1. ✅ Vertikales Slicing → Jeder Sprint ist End-to-End
2. ✅ Sprint-Goals → Jeder Sprint hat nutzbares Ziel
3. ✅ Definition of Done → Klare Release-Kriterien
4. ✅ Feature-Flags → Deploy früh, aktiviere später
5. ✅ CI/CD-Automation → Automatisierte Qualitätssicherung
6. ✅ Sprint-Demos → Stakeholder-Feedback früh einholen
7. ✅ Walking Skeleton → Minimal starten, iterativ verbessern

**Ergebnis:** Nach **jedem** Sprint kann deployed werden! 🚀

---

**Next Steps:**
1. Lies dieses Dokument
2. Entscheide: Soft-Migration oder neues Projekt
3. Wende v2.1 bei nächstem Sprint an
4. Sammle Erfahrungen und iteriere

**Viel Erfolg mit v2.1!** 🎉
