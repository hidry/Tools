# Sprint [X] - [Feature-Name]

**Datum:** [YYYY-MM-DD]
**Version:** v2.1 (Sprint-Release-Workflow)

---

## 🎯 Sprint-Goal

**Als [User-Typ] kann ich [Aktion durchführen], um [Nutzen] zu erzielen.**

**Konkret:**
[Beschreibe in 1-2 Sätzen, was nach diesem Sprint funktionieren soll]

**Akzeptanzkriterium:**
[Konkrete, testbare Bedingung - z.B. "User kann X tun und sieht Y"]

---

## 📊 Sprint-Übersicht

| Attribut | Wert |
|----------|------|
| **Story Points** | [X SP] |
| **Geschätzte Dauer** | [X] Tage |
| **Start-Datum** | [YYYY-MM-DD] |
| **End-Datum** | [YYYY-MM-DD] |
| **Feature-Flag** | [Falls relevant: `FLAG_NAME=false`, Aktivierung in Sprint Y] |
| **Abhängigkeiten** | [Externe Dependencies, z.B. API-Keys, Services] |

---

## 📝 Tasks (Vertikal Organisiert)

### 🔧 Backend-Komponente

- [ ] **T-XXX:** [Task-Beschreibung] ([X] SP)
  - **Akzeptanzkriterium:** [Wie testest du, dass es funktioniert?]
  - **Dependencies:** [T-YYY oder "None"]
  - **Priority:** [Must/Should/Could]

- [ ] **T-YYY:** [Task-Beschreibung] ([Y] SP)
  - **Akzeptanzkriterium:** [...]
  - **Dependencies:** [...]
  - **Priority:** [...]

**Backend Total:** [X] SP

---

### 🎨 Frontend-Komponente

- [ ] **T-ZZZ:** [Task-Beschreibung] ([Z] SP)
  - **Akzeptanzkriterium:** [...]
  - **Dependencies:** [T-XXX - Backend muss fertig sein]
  - **Priority:** [...]

- [ ] **T-AAA:** [Task-Beschreibung] ([A] SP)
  - **Akzeptanzkriterium:** [...]
  - **Dependencies:** [...]
  - **Priority:** [...]

**Frontend Total:** [X] SP

---

### 🧪 Tests

- [ ] **T-BBB:** Unit Tests - Backend ([X] SP)
  - **Coverage-Ziel:** ≥80% für neuen Code
  - **Critical Paths:** [Welche Funktionen MÜSSEN getestet sein?]

- [ ] **T-CCC:** Unit Tests - Frontend ([X] SP)
  - **Coverage-Ziel:** ≥80%
  - **Critical Components:** [Welche Components?]

- [ ] **T-DDD:** Integration Tests ([X] SP)
  - **Scope:** [z.B. "API + DB Integration"]
  - **Test-Cases:** [Liste kritische Pfade]

- [ ] **T-EEE:** E2E Test - Happy Path ([X] SP)
  - **Scope:** Sprint-Goal End-to-End testen
  - **Test-Szenario:**
    1. [Schritt 1]
    2. [Schritt 2]
    3. [Erwartetes Ergebnis]

**Tests Total:** [X] SP

---

### 📚 Dokumentation

- [ ] **T-FFF:** API Documentation ([1] SP)
  - **Format:** Swagger/OpenAPI
  - **Neue Endpoints:** [Liste]

- [ ] **T-GGG:** User Documentation ([1] SP)
  - **Format:** README.md / Wiki / Docs-Site
  - **Inhalt:** [Was muss dokumentiert werden?]

- [ ] **T-HHH:** Code Comments ([0.5] SP)
  - **Scope:** Komplexe Logik kommentieren

**Dokumentation Total:** [X] SP

---

### 🚀 Deployment

- [ ] **T-III:** Database Migrations ([X] SP)
  - **Migrations:** [Liste Migration-Files]
  - **Rollback-Test:** Migration Up + Down testen

- [ ] **T-JJJ:** Environment Variables ([0.5] SP)
  - **Neue Vars:** [Liste, z.B. `API_KEY`, `FEATURE_FLAG_X`]
  - **Update:** `.env.example` aktualisieren

- [ ] **T-KKK:** Deployment Script ([1] SP)
  - **Script:** `scripts/deploy-sprint-X.sh`
  - **Beinhaltet:** Build, Migration, Health-Check

**Deployment Total:** [X] SP

---

## ✅ Definition of Done

Ein Sprint ist NUR releasebar, wenn ALLE Kriterien erfüllt sind:

### Funktionale Kriterien
- [ ] Alle Acceptance Criteria der User Stories erfüllt
- [ ] Feature funktioniert End-to-End (Backend → Frontend → User)
- [ ] Sprint-Goal erreicht (Demo-Szenario erfolgreich durchführbar)
- [ ] Keine Known Bugs (Critical/High Priority)
- [ ] Edge Cases getestet (z.B. leere Felder, lange Inputs, Sonderzeichen)

### Technische Kriterien
- [ ] Code Review abgeschlossen (mindestens 1 Reviewer, alle Kommentare addressed)
- [ ] Unit Tests: ≥80% Coverage für neuen Code
- [ ] Integration Tests: Alle kritischen API-Pfade getestet
- [ ] E2E Tests: Mindestens 1 Happy-Path-Test pro User Story
- [ ] CI/CD Pipeline: Alle Checks bestanden (grün)
- [ ] Keine Compiler Warnings (kritische)
- [ ] Linter-Checks bestanden (ESLint/PSScriptAnalyzer)
- [ ] Performance-Tests (wenn relevant): Antwortzeiten <2s

### Deployment-Kriterien
- [ ] Database Migrations getestet (Up + Down)
- [ ] Deployment-Script vorhanden (`deploy-sprint-X.sh/.ps1`)
- [ ] Rollback-Plan dokumentiert (`ROLLBACK.md`)
- [ ] Environment Variables dokumentiert (`.env.example` aktualisiert)
- [ ] Secrets sicher hinterlegt (nicht im Code!)
- [ ] Health-Check-Endpoint funktioniert (`/health`)

### Dokumentations-Kriterien
- [ ] API Documentation aktualisiert (Swagger/OpenAPI)
- [ ] User-facing Dokumentation aktualisiert (README.md, Wiki, Docs-Seite)
- [ ] CHANGELOG.md aktualisiert (Conventional Commits Format)
- [ ] Architecture Decision Records (ADRs) erstellt (bei Architektur-Änderungen)
- [ ] Code Comments für komplexe Logik (mind. 1 Comment pro 50 Zeilen)
- [ ] Deployment-Instructions für DevOps (`DEPLOYMENT.md`)

### Sicherheits-Kriterien
- [ ] OWASP Top 10 Checklist durchgegangen
- [ ] Input Validation implementiert (Frontend + Backend)
- [ ] Authentication korrekt (z.B. JWT-Tokens, Sessions)
- [ ] Authorization korrekt (RBAC, Permissions)
- [ ] SQL Injection-Schutz (Prepared Statements/ORM)
- [ ] XSS-Schutz (Output Escaping)
- [ ] CSRF-Schutz (Tokens bei State-Changing Operations)
- [ ] Rate Limiting (API Endpoints)
- [ ] Keine Secrets im Code (`.env` check)

### Rückwärts-Kompatibilität
- [ ] Breaking Changes dokumentiert (BREAKING.md, wenn unvermeidbar)
- [ ] Migration-Guide für User (bei Breaking Changes)
- [ ] Alte API-Versionen unterstützt (deprecated, aber funktional)
- [ ] Database Migrations rückwärts-kompatibel (oder explizit dokumentiert)

### Qualitätssicherung
- [ ] Smoke-Tests auf Staging erfolgreich
- [ ] Browser-Kompatibilität getestet (Chrome, Firefox, Safari, Edge)
- [ ] Responsive Design getestet (Mobile, Tablet, Desktop)
- [ ] Accessibility (a11y) Basics geprüft (Keyboard-Navigation, Screen-Reader)
- [ ] Keine Console Errors im Browser

---

## 🎬 Demo-Szenario

**Ziel:** Sprint-Goal live demonstrieren

**Vorbereitungen:**
- [ ] Feature auf Staging deployed
- [ ] Demo-Szenario lokal getestet (Dry-Run)
- [ ] Screenshots erstellt

**Demo-Schritte:**

### Schritt 1: [Setup]
**Aktion:** [Was wird vorbereitet?]
**Screenshot:** `./screenshots/sprint-X-setup.png`

### Schritt 2: [Hauptaktion]
**Aktion:** [Was wird gezeigt?]
**Erwartetes Ergebnis:** [Was sollte passieren?]
**Screenshot:** `./screenshots/sprint-X-action.png`

### Schritt 3: [Verifikation]
**Aktion:** [Wie wird überprüft, dass es funktioniert?]
**Erwartetes Ergebnis:** [Success-Kriterium]
**Screenshot:** `./screenshots/sprint-X-result.png`

**Demo-Dauer:** ~[X] Minuten

---

## ⚠️ Risiken & Mitigation

| Risiko | Wahrscheinlichkeit | Impact | Mitigation |
|--------|-------------------|--------|------------|
| [Risiko 1, z.B. "API Rate-Limit"] | [Hoch/Mittel/Niedrig] | [Hoch/Mittel/Niedrig] | [Mitigation-Plan] |
| [Risiko 2] | [...] | [...] | [...] |

---

## 🔗 Abhängigkeiten

**Externe Abhängigkeiten:**
- [ ] [z.B. "Stripe API-Key beantragt"] - **Verantwortlich:** [Name]
- [ ] [z.B. "S3 Bucket erstellt"] - **Verantwortlich:** [Name]

**Interne Abhängigkeiten:**
- [ ] [z.B. "Sprint 2 muss abgeschlossen sein"] - **Blocker bis:** [Datum]

---

## 📈 Success-Metriken

**Wie messen wir Erfolg?**

| Metrik | Ziel | Wie gemessen? |
|--------|------|---------------|
| Test Coverage | ≥80% | Code Coverage Report |
| E2E-Test-Erfolgsrate | 100% | Playwright/Cypress Report |
| Sprint-Goal erreicht | Ja | Demo erfolgreich? |
| DoD vollständig | 100% | Alle Checkboxen abgehakt? |
| Deployment-Erfolg | 1. Versuch | CI/CD-Pipeline grün? |

---

## 🚀 Deployment-Plan

### Staging-Deployment
**Wann:** Sofort nach DoD-Erfüllung
**Wie:** CI/CD-Pipeline (automatisch) oder `./scripts/deploy.sh staging`
**Smoke-Test:** [Welcher Test nach Deployment?]

### Production-Deployment
**Wann:** Nach erfolgreicher Sprint-Demo + Stakeholder-Approval
**Wie:** `./scripts/deploy.sh production`
**Monitoring:** [Welche Metriken überwachen? z.B. Error-Rate, Response-Time]
**Rollback-Plan:** [Siehe ROLLBACK.md]

---

## 🔄 Rollback-Plan

**Falls Deployment fehlschlägt:**

### Option 1: Rollback zu vorherigem Release
```bash
# Git-Tag finden
git tag -l

# Checkout previous tag
git checkout v1.X.X

# Deploy
./scripts/deploy.sh production
```

### Option 2: Feature-Flag deaktivieren (falls verwendet)
```bash
# In .env.production setzen:
ENABLE_FEATURE_X=false

# Neu deployen
./scripts/deploy.sh production
```

### Option 3: Database-Migration rückgängig machen
```bash
# Migration down
npm run db:migrate:down

# Deploy previous version
./scripts/deploy.sh production
```

**Verantwortlich für Rollback:** [Name/Rolle]
**Rollback-Timeout:** Max. 15 Minuten nach Fehler-Detektion

---

## 📋 Checklist: Sprint-Abschluss

**Vor Commit:**
- [ ] Alle Tasks abgeschlossen (siehe oben)
- [ ] DoD-Checklist 100% abgehakt
- [ ] Code Review durchgeführt
- [ ] Alle Tests grün (lokal + CI/CD)

**Vor Staging-Deployment:**
- [ ] Deployment-Script getestet
- [ ] Migrations getestet (Up + Down)
- [ ] Environment Variables dokumentiert

**Vor Sprint-Demo:**
- [ ] Feature auf Staging deployed
- [ ] Demo-Szenario durchgespielt (Dry-Run)
- [ ] Screenshots erstellt
- [ ] Demo-Notes vorbereitet

**Nach Sprint-Demo:**
- [ ] Stakeholder-Feedback dokumentiert
- [ ] Release-Entscheidung getroffen (Go/No-Go)
- [ ] Bei Go: Production-Deployment durchgeführt
- [ ] Bei No-Go: Feedback-Items als neue Tasks erfasst

**Finale Schritte:**
- [ ] CHANGELOG.md aktualisiert
- [ ] Git-Tag erstellt (`v1.X.X`)
- [ ] Commit mit Conventional Commit Message
- [ ] Push to remote

---

## 📝 Notizen

[Platz für zusätzliche Notizen während der Sprint-Durchführung]

---

## 🔗 Referenzen

- **PRD:** [Link zu PRD.md]
- **User Stories:** [Link zu user-stories.md]
- **Tasks:** [Link zu tasks.md]
- **Previous Sprint:** [Link zu sprint-[X-1]-plan.md]
- **Next Sprint:** [Link zu sprint-[X+1]-plan.md] (falls bereits geplant)

---

**Template-Version:** v2.1
**Erstellt am:** [YYYY-MM-DD]
**Autor:** [Name]
