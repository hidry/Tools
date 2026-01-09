# Multi-Feature-Sprints: Strategien & Best Practices (v2.1)

**Datum:** 2026-01-09
**Problem:** Was tun, wenn ein Sprint mehrere Features (nicht nur eines) umsetzen soll?

---

## 📋 Inhaltsverzeichnis

1. [Wann macht Multi-Feature-Sprint Sinn?](#wann-macht-multi-feature-sprint-sinn)
2. [Vier Strategien für Multi-Feature-Sprints](#vier-strategien)
3. [Sprint-Goal-Formulierung](#sprint-goal-formulierung)
4. [Definition of Done für Multi-Feature](#definition-of-done)
5. [Demo-Szenario bei mehreren Features](#demo-szenario)
6. [Praktische Beispiele](#praktische-beispiele)
7. [Anti-Patterns vermeiden](#anti-patterns)

---

## 🎯 Wann macht Multi-Feature-Sprint Sinn?

### ✅ Gute Gründe für Multi-Feature-Sprints

**1. Kleine Features (jeweils <5 SP)**
```
Beispiel:
- Feature A: Add export button (3 SP)
- Feature B: Add import button (3 SP)
- Feature C: Add help tooltip (2 SP)
Total: 8 SP → Zu klein für 3 separate Sprints!
```

**2. Zusammengehörige Features (Feature-Set)**
```
Beispiel: Session-Management
- Login (5 SP)
- Logout (2 SP)
- Remember-Me (3 SP)
- Session-Timeout (5 SP)
Total: 15 SP → Macht Sinn als ein Sprint!
```

**3. Ein großes Feature + mehrere Bug-Fixes**
```
Beispiel:
- Payment Integration (12 SP) ← Hauptfeature
- Fix validation bug (2 SP)
- Fix typo (1 SP)
Total: 15 SP → Bug-Fixes "füllen" den Sprint
```

**4. Parallele Entwicklung (Team-Setting)**
```
Beispiel: 2 Entwickler
- Developer A: Feature X (8 SP)
- Developer B: Feature Y (7 SP)
Total: 15 SP → Beide Features parallel
```

### ❌ Schlechte Gründe (Vermeiden!)

**1. "Wir müssen schneller sein"**
```
❌ FALSCH:
Sprint 1: 5 Features à 4 SP = 20 SP
→ Kein Feature wird richtig fertig (Tests fehlen, DoD nicht erfüllt)
```

**2. "Diese Features sind ähnlich"**
```
❌ FALSCH:
Sprint 1: User Registration + User Login + Password Reset
→ Besser: 1 Feature pro Sprint, dann ist jedes sofort nutzbar!
```

**3. "Wir haben noch Story Points übrig"**
```
❌ FALSCH:
Sprint hat 15 SP geplant, nach Tag 3 sind 12 SP fertig
→ "Lass uns noch 3 SP Features reinpacken!"
→ Besser: Sprint früher abschließen, nächsten Sprint starten
```

---

## 🔧 Vier Strategien für Multi-Feature-Sprints

### Strategie 1: Primary/Secondary-Klassifizierung

**Wann nutzen?**
- 1 großes Feature + mehrere kleine Features
- Unsicherheit, ob alle Features fertig werden

**Konzept:**
- **1 Primary Feature:** MUSS für Sprint-Release fertig sein
- **1-3 Secondary Features:** Nice-to-have, können zurückgestellt werden

**Sprint-Goal:**
```markdown
## Sprint X Goal (Primary/Secondary)

**Primary Goal (MUST):**
Als [User-Typ] kann ich [Primäre Aktion], um [Nutzen] zu erzielen.

**Secondary Goals (SHOULD):**
- Als [User-Typ] kann ich zusätzlich [Sekundäre Aktion 1]
- Als [User-Typ] kann ich zusätzlich [Sekundäre Aktion 2]

**Release-Kriterium:**
Sprint ist releasebar, wenn Primary Goal erreicht ist.
Secondary Goals sind optional (aber angestrebt).
```

**Beispiel:**
```markdown
## Sprint 3 Goal

**Primary Goal (MUST):**
Als Nutzer kann ich Zahlungen via Stripe durchführen, um Produkte zu kaufen.

**Secondary Goals (SHOULD):**
- Als Nutzer sehe ich einen Ladebalken während der Zahlung
- Als Nutzer erhalte ich bessere Fehlermeldungen bei Validierung

**Release-Kriterium:**
Payment-Integration funktioniert → Sprint releasebar.
Loading-Spinner & Error-Messages → Nice-to-have (oder nächster Sprint).
```

**DoD-Anpassung:**
```markdown
## Definition of Done (Primary/Secondary-Sprint)

### Primary Feature: Payment Integration
- [x] Alle AC erfüllt
- [x] E2E-Tests vorhanden
- [x] 80% Coverage
- [x] Deployed auf Staging
- [x] Demo funktioniert
→ MUSS 100% erfüllt sein!

### Secondary Feature 1: Loading Spinner
- [x] Implementiert
- [ ] Tests fehlen noch ← OK, kann verschoben werden
→ Optional für Release

### Secondary Feature 2: Error Messages
- [x] Implementiert
- [x] Tests vorhanden
→ Bonus: Auch fertig geworden!

**Sprint Release-Entscheidung:**
Primary Feature 100% → ✅ RELEASEBAR!
Secondary Features: 1/2 komplett → Bonus
```

---

### Strategie 2: Feature-Set (Thematisches Bundling)

**Wann nutzen?**
- Features gehören logisch zusammen
- Features ergeben erst gemeinsam Sinn
- Beispiel: Login + Logout + Session-Management

**Konzept:**
- Gruppiere Features als "Feature-Set"
- Sprint-Goal beschreibt übergeordnetes Ziel
- Alle Features müssen für Release fertig sein

**Sprint-Goal:**
```markdown
## Sprint X Goal (Feature-Set)

**Übergeordnetes Ziel:**
Als [User-Typ] kann ich [übergeordnete Fähigkeit] nutzen.

**Enthaltene Features:**
1. [Feature A] - [Kurzbeschreibung]
2. [Feature B] - [Kurzbeschreibung]
3. [Feature C] - [Kurzbeschreibung]

**Akzeptanzkriterium:**
User kann den kompletten [Use-Case] durchführen, der alle 3 Features nutzt.
```

**Beispiel:**
```markdown
## Sprint 4 Goal (Feature-Set: Session-Management)

**Übergeordnetes Ziel:**
Als Nutzer kann ich meine Session verwalten (anmelden, abmelden, automatisch eingeloggt bleiben).

**Enthaltene Features:**
1. Login - Nutzer kann sich mit Email/Passwort anmelden
2. Logout - Nutzer kann sich abmelden
3. Remember-Me - Nutzer kann "Angemeldet bleiben" aktivieren
4. Session-Timeout - Session läuft nach 24h ab

**Akzeptanzkriterium:**
Ein Nutzer kann sich anmelden, abmelden, und automatisch eingeloggt bleiben (wenn gewünscht).
Sessions expiren korrekt nach 24h.

**Demo-Szenario:**
1. Login mit "Remember-Me" aktiviert
2. Browser schließen & neu öffnen → Noch eingeloggt
3. Logout → Ausgeloggt
4. Login ohne "Remember-Me" → Session-Cookie wird nach Browser-Close gelöscht
```

**Task-Organisation:**
```markdown
## Sprint 4 Tasks (Feature-Set)

### Feature 1: Login
**Backend:**
- [ ] T-020: POST /login Endpoint (3 SP)
- [ ] T-021: JWT-Token-Generation (2 SP)

**Frontend:**
- [ ] T-022: Login-Form Component (3 SP)

**Tests:**
- [ ] T-023: Unit + E2E Tests (2 SP)

**Subtotal:** 10 SP

---

### Feature 2: Logout
**Backend:**
- [ ] T-024: POST /logout Endpoint (1 SP)
- [ ] T-025: Token-Invalidation (2 SP)

**Frontend:**
- [ ] T-026: Logout-Button Component (1 SP)

**Tests:**
- [ ] T-027: E2E Test (1 SP)

**Subtotal:** 5 SP

---

### Feature 3: Remember-Me
**Backend:**
- [ ] T-028: Refresh-Token-Logic (3 SP)

**Frontend:**
- [ ] T-029: Remember-Me-Checkbox (1 SP)

**Tests:**
- [ ] T-030: Tests (1 SP)

**Subtotal:** 5 SP

---

### Feature 4: Session-Timeout
**Backend:**
- [ ] T-031: Token-Expiry-Logic (2 SP)
- [ ] T-032: Cron-Job für Cleanup (2 SP)

**Tests:**
- [ ] T-033: Tests (1 SP)

**Subtotal:** 5 SP

---

**Sprint Total:** 25 SP (Feature-Set komplett)
```

**DoD-Anpassung:**
```markdown
## Definition of Done (Feature-Set)

### Funktional
- [x] ALLE Features funktionieren zusammen (nicht einzeln!)
- [x] Demo-Szenario (mit allen Features) erfolgreich

### Technisch
- [x] Jedes Feature hat eigene Tests (10 + 5 + 5 + 5 = 25 SP Tests)
- [x] Integration-Tests für Feature-Interaktion (z.B. Login → Logout)
- [x] E2E-Test über alle Features (kompletter User-Flow)

### Release
Sprint ist NUR releasebar, wenn ALLE Features fertig sind!
Sonst: Unvollständiges Feature-Set → schlechte UX
```

---

### Strategie 3: Mini-Milestones (Sequenziell innerhalb Sprint)

**Wann nutzen?**
- Features sind unabhängig
- Features haben keine gemeinsame Logik
- Klare zeitliche Abfolge möglich

**Konzept:**
- Teile Sprint in Mini-Milestones (z.B. Tag 1-2, Tag 3-4, Tag 5)
- Jedes Feature = eigener Mini-Milestone
- Jedes Feature hat eigene Mini-DoD
- Sprint-DoD = Aggregation aller Mini-DoDs

**Sprint-Goal:**
```markdown
## Sprint X Goal (Mini-Milestones)

**Ziel:** Mehrere unabhängige Verbesserungen ausliefern

**Milestones:**

**Milestone 1 (Tag 1-2):** Feature A fertigstellen
- Als [User] kann ich [A]

**Milestone 2 (Tag 3-4):** Feature B fertigstellen
- Als [User] kann ich [B]

**Milestone 3 (Tag 5):** Feature C fertigstellen
- Als [User] kann ich [C]

**Release-Strategie:**
- Nach jedem Milestone: Deployment auf Staging möglich
- Am Sprint-Ende: Alle 3 Features zusammen in Production
```

**Beispiel:**
```markdown
## Sprint 5 Goal (Mini-Milestones)

**Ziel:** Drei User-Experience-Verbesserungen

**Milestone 1 (Tag 1-2): Export-Funktion**
- Als Nutzer kann ich meine Daten als CSV exportieren (5 SP)

**Milestone 2 (Tag 3-4): Dark-Mode**
- Als Nutzer kann ich Dark-Mode aktivieren (7 SP)

**Milestone 3 (Tag 5): Keyboard-Shortcuts**
- Als Power-User kann ich Keyboard-Shortcuts nutzen (3 SP)

**Total:** 15 SP

**Release-Strategie:**
- Tag 2: Export deployed auf Staging → Mini-Demo
- Tag 4: Dark-Mode deployed auf Staging → Mini-Demo
- Tag 5: Keyboard-Shortcuts deployed auf Staging
- Tag 6: Final-Demo → Production-Release (alle 3 Features)
```

**Task-Organisation:**
```markdown
## Sprint 5 Tasks (Mini-Milestones)

### Milestone 1: Export-Funktion (Tag 1-2)
- [ ] T-040: Backend CSV-Export (2 SP)
- [ ] T-041: Frontend Export-Button (2 SP)
- [ ] T-042: Tests (1 SP)

**Mini-DoD:**
- [ ] Export funktioniert E2E
- [ ] Tests grün
- [ ] Deployed auf Staging
- [ ] Mini-Demo erfolgreich

---

### Milestone 2: Dark-Mode (Tag 3-4)
- [ ] T-043: CSS Dark-Theme (3 SP)
- [ ] T-044: Theme-Toggle Component (2 SP)
- [ ] T-045: LocalStorage-Persistence (1 SP)
- [ ] T-046: Tests (1 SP)

**Mini-DoD:**
- [ ] Dark-Mode funktioniert in allen Components
- [ ] Theme bleibt nach Reload erhalten
- [ ] Tests grün
- [ ] Deployed auf Staging
- [ ] Mini-Demo erfolgreich

---

### Milestone 3: Keyboard-Shortcuts (Tag 5)
- [ ] T-047: Keyboard-Event-Handler (2 SP)
- [ ] T-048: Shortcut-Overlay (1 SP)

**Mini-DoD:**
- [ ] Shortcuts funktionieren (Ctrl+S, Ctrl+E, etc.)
- [ ] Tests grün
- [ ] Deployed auf Staging

---

**Sprint-DoD:**
Alle 3 Mini-DoDs erfüllt → Sprint releasebar!
```

**Vorteile:**
- ✅ Kontinuierliches Feedback (Mini-Demos)
- ✅ Klare Fortschritts-Tracking
- ✅ Frühes Risiko-Management (Feature 1 fertig → weiter zu Feature 2)
- ✅ Flexibilität (Feature 3 kann notfalls verschoben werden)

---

### Strategie 4: Parallele Tracks (Team-Setting)

**Wann nutzen?**
- Team mit mehreren Entwicklern
- Features sind komplett unabhängig
- Keine geteilten Komponenten/Dependencies

**Konzept:**
- Jedes Team-Mitglied bekommt eigenes Feature
- Features werden parallel entwickelt
- Sprint-DoD = Alle Features fertig

**Sprint-Goal:**
```markdown
## Sprint X Goal (Parallele Tracks)

**Team-Ziel:** [X] unabhängige Features fertigstellen

**Track A (Developer Alice):**
Als [User] kann ich [Feature A]

**Track B (Developer Bob):**
Als [User] kann ich [Feature B]

**Track C (Developer Charlie):**
Als [User] kann ich [Feature C]

**Integration-Point:**
Tag 5 - Alle Features werden integriert & gemeinsam getestet
```

**Beispiel:**
```markdown
## Sprint 6 Goal (Parallele Tracks - 3 Developers)

**Team-Ziel:** 3 neue Features für Q1-Release

**Track A (Alice): Notifications**
Als Nutzer erhalte ich Push-Notifications bei wichtigen Events (8 SP)

**Track B (Bob): Search**
Als Nutzer kann ich die Datenbank durchsuchen (7 SP)

**Track C (Charlie): API-Dokumentation**
Als Developer kann ich die API-Docs einsehen (5 SP)

**Total:** 20 SP (verteilt auf 3 Personen)

**Integration-Points:**
- Tag 3: Merge-Point 1 (erste Integration)
- Tag 5: Final-Merge + Integration-Tests
- Tag 6: E2E-Tests + Demo
```

**Task-Organisation:**
```markdown
## Sprint 6 Tasks (Parallele Tracks)

### Track A: Notifications (Alice)
- [ ] T-050: WebSocket-Integration (3 SP)
- [ ] T-051: Notification-Component (2 SP)
- [ ] T-052: Backend-Events (2 SP)
- [ ] T-053: Tests (1 SP)

**Alice's DoD:**
- [ ] Feature funktioniert E2E
- [ ] Tests grün (≥80%)
- [ ] Code Review (von Bob oder Charlie)
- [ ] Merged in main (nach Integration-Tests)

---

### Track B: Search (Bob)
- [ ] T-054: Elasticsearch-Integration (4 SP)
- [ ] T-055: Search-UI Component (2 SP)
- [ ] T-056: Tests (1 SP)

**Bob's DoD:**
- [ ] Search funktioniert E2E
- [ ] Tests grün (≥80%)
- [ ] Code Review (von Alice oder Charlie)
- [ ] Merged in main

---

### Track C: API-Docs (Charlie)
- [ ] T-057: Swagger-Setup (2 SP)
- [ ] T-058: Endpoint-Documentation (2 SP)
- [ ] T-059: Docs-Website (1 SP)

**Charlie's DoD:**
- [ ] Alle Endpoints dokumentiert
- [ ] Swagger-UI funktioniert
- [ ] Code Review
- [ ] Merged in main

---

**Sprint-DoD (Gesamt):**
- [ ] Alle 3 Features einzeln funktionieren
- [ ] Integration-Tests bestanden (Features stören sich nicht)
- [ ] Merge-Konflikte resolved
- [ ] E2E-Test über Sprint-Scope (nicht Feature-übergreifend, aber parallel nutzbar)
- [ ] Gemeinsame Sprint-Demo
```

**Risiken & Mitigation:**
```markdown
**Risiko 1: Merge-Konflikte**
→ Mitigation: Tägliche Merges in Entwicklungs-Branch

**Risiko 2: Feature A blockiert Feature B**
→ Mitigation: Features MÜSSEN unabhängig sein (Voraussetzung für diese Strategie!)

**Risiko 3: Ungleiche Auslastung (Alice fertig, Bob kämpft)**
→ Mitigation: Pair-Programming, Alice hilft Bob
```

---

## 📝 Sprint-Goal-Formulierung

### Schlechte Multi-Feature-Goals (Vermeiden!)

❌ **Zu vage:**
```
"Als User kann ich verschiedene neue Features nutzen."
→ Welche Features? Was ist der Nutzen?
```

❌ **Einfache Aufzählung:**
```
"Als User kann ich:
- Feature A nutzen
- Feature B nutzen
- Feature C nutzen"
→ Kein übergeordnetes Ziel erkennbar
```

❌ **Zu komplex:**
```
"Als User kann ich mich einloggen, ausloggen, mein Profil bearbeiten,
Notifications sehen, und die Suche nutzen."
→ Zu viele Features, kein Fokus
```

### Gute Multi-Feature-Goals

✅ **Feature-Set-Formulierung:**
```
"Als Nutzer kann ich Session-Management nutzen (Login, Logout, Remember-Me, Timeout),
um sicher und bequem auf die Plattform zuzugreifen."
→ Übergeordnetes Ziel + enthaltene Features
```

✅ **Primary/Secondary-Formulierung:**
```
"Als Nutzer kann ich Zahlungen durchführen (Primary).
Optional: Ladebalken sehen & bessere Fehlermeldungen (Secondary)."
→ Klare Priorisierung
```

✅ **Thematische Klammer:**
```
"Als Nutzer erlebe ich eine verbesserte User-Experience durch:
- Export-Funktion (Daten portabel)
- Dark-Mode (Augen schonen)
- Keyboard-Shortcuts (schneller arbeiten)"
→ Gemeinsames Thema: UX-Verbesserungen
```

---

## ✅ Definition of Done für Multi-Feature

### Option A: Globale DoD (alle Features müssen erfüllen)

```markdown
## Global DoD (gilt für JEDES Feature im Sprint)

Für jedes Feature (A, B, C):

### Funktional
- [ ] Alle AC erfüllt
- [ ] Feature funktioniert E2E
- [ ] Keine Critical Bugs

### Technisch
- [ ] Code Review
- [ ] ≥80% Coverage
- [ ] Unit + Integration + E2E Tests

### Deployment
- [ ] Migrations (falls nötig)
- [ ] Docs aktualisiert

**Sprint ist releasebar, wenn ALLE Features diese DoD erfüllen.**
```

### Option B: Feature-spezifische DoD + Sprint-DoD

```markdown
## Feature A: Export-Funktion - DoD
- [x] CSV-Export funktioniert
- [x] Tests vorhanden (85% Coverage)
- [x] Docs aktualisiert

## Feature B: Dark-Mode - DoD
- [x] Theme-Switch funktioniert
- [x] Tests vorhanden (90% Coverage)
- [x] Docs aktualisiert

## Feature C: Keyboard-Shortcuts - DoD
- [ ] Shortcuts implementiert ← NICHT FERTIG!
- [ ] Tests fehlen ← NICHT FERTIG!

---

## Sprint-DoD (Gesamt)
- [x] Feature A: 100% ✅
- [x] Feature B: 100% ✅
- [ ] Feature C: 60% ❌

**Release-Entscheidung:**
- Option 1: Release A + B, C verschieben auf nächsten Sprint
- Option 2: Warten, bis C fertig ist (Sprint verlängern)
- Option 3: C aus Scope nehmen (wenn Primary/Secondary verwendet)
```

### Option C: Gewichtete DoD (Primary/Secondary)

```markdown
## Primary Feature: Payment Integration - DoD
**Gewichtung: MUST (100% erforderlich für Release)**
- [x] Payment funktioniert E2E
- [x] Tests vorhanden (95% Coverage)
- [x] Security-Audit durchgeführt
- [x] Docs aktualisiert
→ ✅ 100% erfüllt → RELEASE MÖGLICH!

---

## Secondary Feature 1: Loading Spinner - DoD
**Gewichtung: SHOULD (Nice-to-have)**
- [x] Spinner implementiert
- [ ] Tests fehlen (40% Coverage)
→ ⚠️ 70% erfüllt → Optional

## Secondary Feature 2: Error Messages - DoD
**Gewichtung: SHOULD (Nice-to-have)**
- [x] Messages implementiert
- [x] Tests vorhanden (85% Coverage)
→ ✅ 100% erfüllt → Bonus!

---

**Sprint-Release-Entscheidung:**
Primary Feature 100% → ✅ SPRINT RELEASEBAR!
Secondary: 1/2 komplett → Akzeptabel (nicht blockierend)
```

---

## 🎬 Demo-Szenario bei mehreren Features

### Strategie 1: Sequenzielles Demo (Feature nach Feature)

```markdown
## Sprint X Demo (3 Features)

**Gesamt-Dauer:** 30 Minuten

### Teil 1: Feature A - Export (10 Min)
**Setup:**
- Login als Test-User
- Navigiere zu /data

**Demo:**
1. Klicke "Export CSV"
2. Datei wird heruntergeladen
3. Öffne CSV → Daten korrekt

**Erwartung:** ✅ Export funktioniert

---

### Teil 2: Feature B - Dark-Mode (10 Min)
**Setup:**
- Bleibe eingeloggt

**Demo:**
1. Klicke Theme-Toggle (Mond-Icon)
2. UI wechselt zu Dark-Mode
3. Reload-Page → Theme bleibt erhalten
4. Toggle zurück zu Light-Mode

**Erwartung:** ✅ Dark-Mode funktioniert & persistiert

---

### Teil 3: Feature C - Keyboard-Shortcuts (10 Min)
**Setup:**
- Bleibe eingeloggt

**Demo:**
1. Drücke "?" → Shortcut-Overlay erscheint
2. Drücke "Ctrl+S" → Daten werden gespeichert
3. Drücke "Ctrl+E" → Export wird ausgelöst
4. Drücke "Esc" → Overlay schließt

**Erwartung:** ✅ Shortcuts funktionieren
```

### Strategie 2: Integriertes Demo (Features zusammen)

```markdown
## Sprint X Demo (Session-Management Features)

**Gesamt-Dauer:** 20 Minuten

**Story:** Ein Tag im Leben eines Nutzers

### Morgens: Login mit Remember-Me
1. Öffne /login
2. Gebe Credentials ein
3. Aktiviere "Angemeldet bleiben"
4. Klicke "Login"
5. → Dashboard wird angezeigt ✅

### Mittags: Browser schließen & neu öffnen
1. Schließe Browser
2. Öffne Browser neu
3. Navigiere zu App
4. → Noch eingeloggt (Remember-Me funktioniert) ✅

### Abends: Logout
1. Klicke "Logout"-Button
2. → Zu Login-Page redirected ✅
3. Versuche /dashboard zu öffnen
4. → Redirected zu Login (Session beendet) ✅

### Nächster Tag: Session-Timeout
1. Simuliere 24h später (manuell Timestamp ändern)
2. Versuche API-Call zu machen
3. → 401 Unauthorized (Session expired) ✅
4. User wird zu Login redirected

**Erwartung:** Kompletter Session-Lifecycle funktioniert!
```

### Strategie 3: Paralleles Demo (Team-Demo)

```markdown
## Sprint X Demo (Parallele Tracks - 3 Developers)

**Gesamt-Dauer:** 30 Minuten (3x10 Min parallel)

### Track A: Alice demonstriert Notifications (10 Min)
- Setup: 2 Browser-Fenster (Admin + User)
- Admin erstellt Event → User erhält Notification ✅

### Track B: Bob demonstriert Search (10 Min)
- Setup: Testdaten vorhanden
- User sucht "Projekt" → Ergebnisse werden angezeigt ✅

### Track C: Charlie demonstriert API-Docs (10 Min)
- Setup: Swagger-UI öffnen
- Zeige Endpoint-Docs → Try-Out funktioniert ✅

**Gemeinsamer Teil (10 Min):**
Integration-Test: Alle 3 Features parallel nutzen
- Suche nach Projekt → Projekt gefunden
- Notifications laufen im Hintergrund
- API-Docs zeigen korrekte Endpoints
→ ✅ Keine Konflikte, alles funktioniert zusammen!
```

---

## 📊 Praktische Beispiele

### Beispiel 1: E-Commerce Sprint (Primary/Secondary)

```markdown
## Sprint 7: Shopping-Cart + Optimierungen

**Primary Goal (MUST - 12 SP):**
Als Kunde kann ich Produkte in den Warenkorb legen und zur Kasse gehen.

**Tasks:**
- T-060: Cart-Model + API (4 SP)
- T-061: Add-to-Cart UI (3 SP)
- T-062: Cart-Page (3 SP)
- T-063: Tests (2 SP)

**Secondary Goals (SHOULD - 6 SP):**
1. Als Kunde sehe ich Produktempfehlungen (3 SP)
2. Als Kunde kann ich Wishlist nutzen (3 SP)

**Release-Strategie:**
- Primary fertig → Release (Cart funktioniert)
- Secondary fertig → Bonus (bessere UX)
- Secondary nicht fertig → Nächster Sprint

**DoD:**
Primary: 100% (alle Punkte erfüllt)
Secondary: Best-Effort (mindestens 1/2)
```

### Beispiel 2: SaaS Dashboard (Feature-Set)

```markdown
## Sprint 8: Analytics Dashboard (Feature-Set)

**Übergeordnetes Ziel:**
Als Admin kann ich Analytics nutzen, um Business-Metriken zu verstehen.

**Features (zusammengehörig):**
1. User-Statistics-Widget (5 SP)
   - Aktive User, Neue User, Churn-Rate

2. Revenue-Chart-Widget (5 SP)
   - Umsatz pro Tag/Woche/Monat

3. Export-Report-Widget (3 SP)
   - PDF-Report-Generation

4. Dashboard-Layout (2 SP)
   - Grid-Layout mit Drag&Drop

**Total:** 15 SP

**Warum Feature-Set?**
- Dashboard macht nur mit mehreren Widgets Sinn
- Widgets teilen gemeinsames Grid-Layout
- Export benötigt Daten von anderen Widgets

**DoD:**
Alle 4 Features müssen fertig sein → Sonst unvollständiges Dashboard
```

### Beispiel 3: Bug-Fix-Sprint (Mini-Milestones)

```markdown
## Sprint 9: Bug-Fixes + kleine Features

**Milestone 1 (Tag 1):**
Bug #234: Fix memory leak (5 SP - Critical!)

**Milestone 2 (Tag 2-3):**
Feature: Add CSV-Import (7 SP)

**Milestone 3 (Tag 4):**
Bug #235: Fix validation error (3 SP)

**Total:** 15 SP

**Release-Strategie:**
- Milestone 1: Hotfix-Release (sofort nach Fix)
- Milestone 2: Regular-Release (nach Sprint)
- Milestone 3: Included in Regular-Release

**DoD:**
Jedes Milestone hat eigene Mini-DoD:
- Milestone 1: Bug fixed + Tests + Hotfix deployed
- Milestone 2: Feature funktioniert + Tests + Staging
- Milestone 3: Bug fixed + Tests + Staging
```

---

## ⚠️ Anti-Patterns vermeiden

### Anti-Pattern 1: "Feature-Salad"

❌ **FALSCH:**
```markdown
Sprint X: 10 Features à 2 SP = 20 SP

Features:
- Add button A
- Add button B
- Fix typo C
- Update color D
- Add tooltip E
- ... (weitere 5 Features)

Problem:
- Kein Fokus
- Keine zusammenhängende Story
- Demo wird chaotisch ("und hier noch ein Button, und hier noch...")
- Stakeholder verwirrt: "Was war das Ziel?"
```

✅ **RICHTIG:**
```markdown
Sprint X: 3 zusammenhängende Features (Primary/Secondary)

Primary: User-Profile-Editing (10 SP)
Secondary 1: Avatar-Upload (5 SP)
Secondary 2: Profile-Visibility-Settings (5 SP)

Theme: "User-Profile-Management"
→ Klarer Fokus, zusammenhängende Story
```

### Anti-Pattern 2: "Fake-Multi-Feature"

❌ **FALSCH:**
```markdown
Sprint X: Login + Logout + Session-Timeout

Behandelt als 3 separate Features:
- Feature 1: Login (5 SP)
- Feature 2: Logout (2 SP)
- Feature 3: Session-Timeout (3 SP)

Problem:
- Das sind keine separaten Features, sondern 1 Feature-Set!
- Login ohne Logout macht keinen Sinn
- Sollte als 1 Feature "Session-Management" behandelt werden
```

✅ **RICHTIG:**
```markdown
Sprint X: Session-Management (Feature-Set)

Behandelt als 1 zusammenhängendes Feature mit Komponenten:
- Component A: Login (5 SP)
- Component B: Logout (2 SP)
- Component C: Session-Timeout (3 SP)

Total: 10 SP für 1 Feature-Set
```

### Anti-Pattern 3: "Optimistische Parallelität"

❌ **FALSCH:**
```markdown
Sprint X: 3 Features parallel (Solo-Developer!)

Developer versucht, 3 Features gleichzeitig zu entwickeln:
- Morgens: Feature A
- Mittags: Feature B
- Abends: Feature C
→ Context-Switching, nichts wird richtig fertig
```

✅ **RICHTIG:**
```markdown
Sprint X: 3 Features sequenziell (Solo-Developer)

Mini-Milestones:
- Tag 1-2: Feature A (komplett fertig + Tests)
- Tag 3-4: Feature B (komplett fertig + Tests)
- Tag 5: Feature C (komplett fertig + Tests)
→ Klarer Fokus, Features werden nacheinander abgeschlossen
```

### Anti-Pattern 4: "Scope-Creep"

❌ **FALSCH:**
```markdown
Sprint X startet mit 1 Feature (15 SP)

Tag 3: "Oh, wir haben noch Zeit, lass uns Feature B hinzufügen!" (5 SP)
Tag 4: "Feature C wäre auch nice!" (3 SP)
→ Sprint-Goal ändert sich, DoD wird verwässert
```

✅ **RICHTIG:**
```markdown
Sprint X: 1 Primary Feature (15 SP)

Tag 3: Primary Feature fertig!
→ Sprint KANN früher enden (nächsten Sprint starten)
ODER: Nutze Extra-Zeit für:
- Refactoring
- Dokumentation verbessern
- Tech-Debt reduzieren
- Next Sprint vorbereiten

NICHT: Neue Features hinzufügen ohne Planning!
```

---

## 📋 Entscheidungsbaum: Welche Strategie?

```
START

Sind die Features logisch zusammengehörig?
├─ JA → Strategie 2: Feature-Set
│        (z.B. Login + Logout + Session-Timeout)
│
└─ NEIN
   │
   Ist ein Feature deutlich wichtiger als die anderen?
   ├─ JA → Strategie 1: Primary/Secondary
   │        (z.B. Payment + Loading-Spinner + Error-Messages)
   │
   └─ NEIN
      │
      Werden Features von mehreren Personen parallel entwickelt?
      ├─ JA → Strategie 4: Parallele Tracks
      │        (z.B. Developer A: Feature X, Developer B: Feature Y)
      │
      └─ NEIN → Strategie 3: Mini-Milestones
                 (z.B. Export, Dark-Mode, Shortcuts nacheinander)
```

---

## 🎯 Best Practices Zusammenfassung

### ✅ DO's

1. **Klare Priorisierung:** Primary/Secondary oder Feature-Set
2. **Thematische Klammer:** Features sollten zusammenpassen
3. **Realistische Planung:** Max. 3-4 Features pro Sprint (Solo-Dev)
4. **Feature-DoD definieren:** Jedes Feature hat eigene DoD
5. **Integration-Tests:** Teste Features zusammen (keine Konflikte)
6. **Gestaffeltes Demo:** Jedes Feature einzeln + gemeinsame Integration

### ❌ DON'Ts

1. **Keine Feature-Salad:** Nicht 10 zufällige kleine Features
2. **Kein Scope-Creep:** Sprint-Goal nicht während Sprint ändern
3. **Keine parallele Entwicklung (Solo):** Context-Switching vermeiden
4. **Nicht alles "MUST":** Wenn Multi-Feature, dann Primary/Secondary nutzen
5. **Keine abhängigen Features ohne Strategie:** Wenn Feature B Feature A braucht, dann Feature-Set!

---

## 📝 Template: Multi-Feature-Sprint-Plan

```markdown
# Sprint [X] - [Theme/Topic] (Multi-Feature)

**Strategie:** [Primary/Secondary | Feature-Set | Mini-Milestones | Parallele Tracks]

---

## Sprint-Goal

[Formulierung abhängig von gewählter Strategie - siehe Beispiele oben]

---

## Features

### Feature A: [Name]
**Story Points:** [X] SP
**Typ:** [Primary/Secondary | Feature-Set-Component | Milestone | Track]
**Owner:** [Name, falls Team]

**User Story:**
Als [User] kann ich [Aktion], um [Nutzen] zu erzielen.

**Tasks:**
- [ ] T-XXX: [Task] (X SP)
- [ ] T-YYY: [Task] (Y SP)

**DoD (Feature-spezifisch):**
- [ ] AC erfüllt
- [ ] E2E-Test vorhanden
- [ ] Tests grün (≥80%)
- [ ] Deployed auf Staging

---

### Feature B: [Name]
[Gleiche Struktur wie Feature A]

---

## Sprint-DoD (Gesamt)

**Release-Kriterium:**
[Abhängig von Strategie - siehe Beispiele]

**Checklist:**
- [ ] Alle Features einzeln funktionieren
- [ ] Integration-Tests bestanden
- [ ] Keine Feature-Konflikte
- [ ] Demo-Szenario erfolgreich
- [ ] Staging-Deployment erfolgreich

---

## Demo-Szenario

[Sequenziell | Integriert | Parallel - siehe Beispiele oben]

---

## Risiken & Dependencies

**Feature-übergreifende Risiken:**
- [Risiko 1] → Mitigation: [Plan]

**Dependencies zwischen Features:**
- Feature B benötigt Feature A → Reihenfolge beachten!
```

---

## 🔗 Siehe auch

- **Haupt-Workflow:** `prd-to-code-workflow.md`
- **Sprint-Release-Enhancements:** `sprint-release-enhancements.md`
- **Single-Feature-Template:** `templates/sprint-release-plan-template.md`
- **DoD-Checklist:** `templates/definition-of-done-checklist.md`

---

**Version:** v2.1
**Autor:** Claude
**Datum:** 2026-01-09
