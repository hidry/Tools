# Definition of Done Checklist (v2.1)

**Verwendung:** Kopiere diese Checklist in jedes `sprint-X-plan.md` und hake ALLE Punkte ab, bevor du den Sprint als "releasebar" markierst.

---

## ✅ Sprint Definition of Done

Ein Sprint ist NUR releasebar, wenn ALLE Kriterien erfüllt sind:

---

### 🎯 Funktionale Kriterien

- [ ] **Alle Acceptance Criteria der User Stories erfüllt**
  - Jede User Story im Sprint hat klare AC → Alle erfüllt?
  - Test: Gehe durch jede US und prüfe AC einzeln

- [ ] **Feature funktioniert End-to-End (Backend → Frontend → User)**
  - User kann das Feature von Start bis Ende nutzen
  - Test: Manuelle E2E-Demo durchspielen

- [ ] **Sprint-Goal erreicht (Demo-Szenario erfolgreich durchführbar)**
  - Das in Phase 4 definierte Sprint-Goal ist erreichbar
  - Test: Demo-Szenario durchführen

- [ ] **Keine Known Bugs (Critical/High Priority)**
  - Keine Blocker-Bugs bekannt
  - Test: Issue-Tracker prüfen (0 Critical/High)

- [ ] **Edge Cases getestet**
  - Leere Felder, lange Inputs, Sonderzeichen, Grenzwerte
  - Test: Mindestens 3 Edge Cases pro Feature getestet

---

### ⚙️ Technische Kriterien

- [ ] **Code Review abgeschlossen**
  - Mindestens 1 Reviewer (nicht der Autor)
  - Alle Kommentare addressed oder diskutiert
  - Test: GitHub PR approved?

- [ ] **Unit Tests: ≥80% Coverage für neuen Code**
  - Neuer Code (dieser Sprint) hat ≥80% Coverage
  - Test: `npm run test:coverage` oder ähnlich

- [ ] **Integration Tests: Alle kritischen API-Pfade getestet**
  - API-Endpoints mit DB-Interaktion getestet
  - Test: `npm run test:integration` grün

- [ ] **E2E Tests: Mindestens 1 Happy-Path-Test pro User Story**
  - Jede User Story hat mindestens 1 E2E-Test
  - Test: `npm run test:e2e` grün

- [ ] **CI/CD Pipeline: Alle Checks bestanden (grün)**
  - GitHub Actions (oder ähnlich) komplett grün
  - Test: CI/CD-Status prüfen

- [ ] **Keine Compiler Warnings (kritische)**
  - Build ohne kritische Warnings
  - Test: `npm run build` (oder `tsc --noEmit`)

- [ ] **Linter-Checks bestanden**
  - ESLint, PSScriptAnalyzer, etc. ohne Errors
  - Test: `npm run lint` grün

- [ ] **Performance-Tests (wenn relevant): Antwortzeiten <2s**
  - API-Endpoints antworten in <2s (P95)
  - Test: Performance-Test-Report oder manuelles Testen

---

### 🚀 Deployment-Kriterien

- [ ] **Database Migrations getestet (Up + Down)**
  - Migration Up: Funktioniert fehlerfrei
  - Migration Down: Rollback funktioniert
  - Test: Lokal Migration up + down ausführen

- [ ] **Deployment-Script vorhanden**
  - `scripts/deploy-sprint-X.sh` (oder `.ps1`) existiert
  - Test: Script lokal/staging erfolgreich ausgeführt

- [ ] **Rollback-Plan dokumentiert**
  - `ROLLBACK.md` aktualisiert oder in Sprint-Plan dokumentiert
  - Enthält: Wie rollbacken? Wer ist verantwortlich?

- [ ] **Environment Variables dokumentiert**
  - `.env.example` aktualisiert mit neuen Vars
  - Alle neuen Secrets in Vault/Secrets Manager hinterlegt

- [ ] **Secrets sicher hinterlegt (nicht im Code!)**
  - Keine API-Keys, Passwörter, Tokens im Code
  - Test: `git grep -i "api_key\|password\|secret"` (keine Treffer in neuem Code)

- [ ] **Health-Check-Endpoint funktioniert**
  - `/health` oder ähnlicher Endpoint antwortet korrekt
  - Test: `curl https://staging.example.com/health`

---

### 📚 Dokumentations-Kriterien

- [ ] **API Documentation aktualisiert**
  - Swagger/OpenAPI für neue/geänderte Endpoints
  - Test: Swagger-UI zeigt korrekte Endpoints

- [ ] **User-facing Dokumentation aktualisiert**
  - README.md, Wiki, oder Docs-Seite aktualisiert
  - Beschreibt: Was kann User jetzt tun?

- [ ] **CHANGELOG.md aktualisiert**
  - Neue Features/Fixes in CHANGELOG eingetragen
  - Format: Conventional Commits (feat:, fix:, etc.)

- [ ] **Architecture Decision Records (ADRs) erstellt**
  - Bei signifikanten Architektur-Änderungen ADR schreiben
  - Format: `docs/adr/ADR-XXX-[titel].md`

- [ ] **Code Comments für komplexe Logik**
  - Komplexe Algorithmen haben erklärende Kommentare
  - Minimum: 1 Comment pro 50 Zeilen komplexer Logik

- [ ] **Deployment-Instructions für DevOps**
  - `DEPLOYMENT.md` oder Confluence-Seite aktualisiert
  - Enthält: Besondere Deployment-Schritte für diesen Sprint

---

### 🔒 Sicherheits-Kriterien

- [ ] **OWASP Top 10 Checklist durchgegangen**
  - [OWASP Top 10 2021](https://owasp.org/www-project-top-ten/) geprüft
  - Relevant: Injection, Broken Auth, XSS, etc.

- [ ] **Input Validation implementiert (Frontend + Backend)**
  - Frontend: Client-side Validation
  - Backend: Server-side Validation (CRITICAL!)
  - Test: Versuche, ungültige Daten zu senden

- [ ] **Authentication korrekt**
  - JWT-Tokens, Sessions, OAuth - korrekt implementiert
  - Test: Unauth-User kann geschützte Routen NICHT erreichen

- [ ] **Authorization korrekt**
  - RBAC, Permissions, Role-Checks funktionieren
  - Test: User ohne Permission kann Aktion NICHT ausführen

- [ ] **SQL Injection-Schutz**
  - Prepared Statements oder ORM (kein String-Concat!)
  - Test: SQL-Injection-Test mit `' OR '1'='1`

- [ ] **XSS-Schutz**
  - Output Escaping (z.B. React auto-escaping)
  - Test: `<script>alert('XSS')</script>` in Input-Feld

- [ ] **CSRF-Schutz**
  - CSRF-Tokens bei State-Changing Operations (POST/PUT/DELETE)
  - Test: Request ohne CSRF-Token schlägt fehl

- [ ] **Rate Limiting**
  - API-Endpoints haben Rate-Limiting (z.B. 100 req/min)
  - Test: 1000 Requests senden → 429 Too Many Requests

- [ ] **Keine Secrets im Code**
  - Kein API-Key, Passwort, Token in `.js`, `.ts`, `.py`, etc.
  - Test: `git diff main...HEAD | grep -i "secret\|password\|api_key"`

---

### 🔄 Rückwärts-Kompatibilität

- [ ] **Breaking Changes dokumentiert**
  - Falls Breaking Changes unvermeidbar: `BREAKING.md` erstellt
  - Beschreibt: Was bricht? Wie migrieren?

- [ ] **Migration-Guide für User**
  - Bei Breaking Changes: Schritt-für-Schritt-Guide
  - Format: `MIGRATION-v1-to-v2.md`

- [ ] **Alte API-Versionen unterstützt**
  - Alte Endpoints deprecated, aber funktional (z.B. `/v1/users` noch aktiv)
  - Deprecation-Notice in Response-Header oder Docs

- [ ] **Database Migrations rückwärts-kompatibel**
  - Migration fügt nur hinzu, löscht nicht (wenn möglich)
  - Falls Löschung: Explizit dokumentiert + Rollback-Plan

---

### 🎨 Qualitätssicherung

- [ ] **Smoke-Tests auf Staging erfolgreich**
  - Nach Staging-Deployment: Kritische Pfade manuell getestet
  - Test: Login → Feature nutzen → Logout

- [ ] **Browser-Kompatibilität getestet**
  - Chrome, Firefox, Safari, Edge
  - Test: Feature in mindestens 2 Browsern getestet

- [ ] **Responsive Design getestet**
  - Mobile, Tablet, Desktop
  - Test: Chrome DevTools → Responsive Mode

- [ ] **Accessibility (a11y) Basics geprüft**
  - Keyboard-Navigation funktioniert (Tab, Enter, Esc)
  - Screen-Reader-kompatibel (ARIA-Labels)
  - Test: Nur mit Keyboard navigieren (keine Maus!)

- [ ] **Keine Console Errors im Browser**
  - Browser-Console ohne Errors
  - Test: F12 → Console → Keine roten Errors

---

## 📊 DoD-Erfüllungs-Score

**Berechne deinen Score:**

```
Anzahl abgehakte Checkboxen / Gesamt-Checkboxen * 100 = X%
```

**Releasebarkeit:**
- ✅ **100%:** Sprint ist releasebar! 🚀
- ⚠️ **90-99%:** Nahezu bereit, prüfe fehlende Punkte
- 🔴 **<90%:** NICHT releasebar, arbeite an fehlenden Punkten

---

## 🛠️ Häufige "DoD-Fails" & Lösungen

### Problem: "Test Coverage nur 75%"
**Lösung:**
1. Finde untested Code: `npm run test:coverage -- --coverage`
2. Schreibe fehlende Unit-Tests
3. Ziel: ≥80%

### Problem: "E2E-Test fehlt"
**Lösung:**
1. Installiere Playwright/Cypress (falls nicht vorhanden)
2. Schreibe 1 Happy-Path-Test pro User Story
3. Beispiel:
```typescript
test('user can register', async ({ page }) => {
  await page.goto('/register')
  await page.fill('[name=email]', 'test@example.com')
  await page.fill('[name=password]', 'SecurePass123!')
  await page.click('button[type=submit]')
  await expect(page).toHaveURL('/dashboard')
})
```

### Problem: "Deployment-Script fehlt"
**Lösung:**
1. Erstelle `scripts/deploy-sprint-X.sh`:
```bash
#!/bin/bash
set -e

echo "Deploying Sprint X..."
npm run build
npm run db:migrate
npm run start
curl -f http://localhost:3000/health || exit 1
echo "Deployment successful!"
```
2. Mache Script executable: `chmod +x scripts/deploy-sprint-X.sh`

### Problem: "Secrets im Code"
**Lösung:**
1. Finde Secrets: `git grep -i "api_key\|password\|secret"`
2. Verschiebe in `.env`: `API_KEY=xxx`
3. Update Code: `const apiKey = process.env.API_KEY`
4. `.env` in `.gitignore` (sollte schon drin sein!)

---

## 📋 Quick-Checklist (Kompakt)

Nutze diese Mini-Version für schnelle Checks:

```
Funktional:
☐ Alle AC erfüllt ☐ E2E funktioniert ☐ Sprint-Goal erreicht ☐ Keine Bugs

Technisch:
☐ Code Review ☐ 80% Coverage ☐ Tests grün ☐ CI/CD grün

Deployment:
☐ Migrations getestet ☐ Deploy-Script ☐ Rollback-Plan ☐ Secrets sicher

Docs:
☐ API Docs ☐ User Docs ☐ CHANGELOG ☐ ADRs (falls nötig)

Security:
☐ Input-Validation ☐ Auth/Authz ☐ XSS/SQL-Schutz ☐ Keine Secrets im Code

Qualität:
☐ Smoke-Tests ☐ Browser-kompatibel ☐ Responsive ☐ Keine Console-Errors
```

**Alle ☑? → Sprint releasebar! 🎉**

---

## 🔗 Referenzen

- **OWASP Top 10:** https://owasp.org/www-project-top-ten/
- **Scrum DoD:** https://www.scrum.org/resources/blog/walking-through-definition-done
- **Test Coverage Best Practices:** https://martinfowler.com/bliki/TestCoverage.html
- **Conventional Commits:** https://www.conventionalcommits.org/

---

**Version:** v2.1
**Letzte Aktualisierung:** 2026-01-09
