# Sprint [X] - [Theme] (Multi-Feature)

**Datum:** [YYYY-MM-DD]
**Strategie:** [Primary/Secondary | Feature-Set | Mini-Milestones | Parallele Tracks]
**Version:** v2.1 (Multi-Feature-Sprint)

> **Hinweis:** Dieses Template ist für Sprints mit mehreren Features.
> Für Single-Feature-Sprints nutze: `sprint-release-plan-template.md`

---

## 🎯 Sprint-Goal

### [Wähle eine Strategie]

#### Option 1: Primary/Secondary-Strategie

**Primary Goal (MUST):**
Als [User-Typ] kann ich [Primäre Aktion], um [Nutzen] zu erzielen.

**Secondary Goals (SHOULD):**
- Als [User-Typ] kann ich zusätzlich [Sekundäre Aktion 1]
- Als [User-Typ] kann ich zusätzlich [Sekundäre Aktion 2]

**Release-Kriterium:**
Sprint ist releasebar, wenn Primary Goal erreicht ist.
Secondary Goals sind optional (aber angestrebt).

---

#### Option 2: Feature-Set-Strategie

**Übergeordnetes Ziel:**
Als [User-Typ] kann ich [übergeordnete Fähigkeit] nutzen.

**Enthaltene Features:**
1. [Feature A] - [Kurzbeschreibung]
2. [Feature B] - [Kurzbeschreibung]
3. [Feature C] - [Kurzbeschreibung]

**Akzeptanzkriterium:**
User kann den kompletten [Use-Case] durchführen, der alle Features nutzt.

**Release-Kriterium:**
ALLE Features müssen fertig sein (Feature-Set nur komplett sinnvoll).

---

#### Option 3: Mini-Milestones-Strategie

**Ziel:** Mehrere unabhängige Verbesserungen ausliefern

**Milestones:**

**Milestone 1 (Tag 1-2):** Feature A fertigstellen
- Als [User] kann ich [A]

**Milestone 2 (Tag 3-4):** Feature B fertigstellen
- Als [User] kann ich [B]

**Milestone 3 (Tag 5):** Feature C fertigstellen
- Als [User] kann ich [C]

**Release-Strategie:**
Nach jedem Milestone: Deployment auf Staging möglich.
Am Sprint-Ende: Alle Features zusammen in Production.

---

#### Option 4: Parallele-Tracks-Strategie

**Team-Ziel:** [X] unabhängige Features fertigstellen

**Track A ([Developer-Name]):**
Als [User] kann ich [Feature A]

**Track B ([Developer-Name]):**
Als [User] kann ich [Feature B]

**Track C ([Developer-Name]):**
Als [User] kann ich [Feature C]

**Integration-Points:**
- Tag [X]: Erste Integration & Merge
- Tag [Y]: Final-Merge + Integration-Tests
- Tag [Z]: E2E-Tests + Demo

---

## 📊 Sprint-Übersicht

| Attribut | Wert |
|----------|------|
| **Anzahl Features** | [X] Features |
| **Total Story Points** | [X] SP |
| **Geschätzte Dauer** | [X] Tage |
| **Start-Datum** | [YYYY-MM-DD] |
| **End-Datum** | [YYYY-MM-DD] |
| **Strategie** | [Primary/Secondary, Feature-Set, etc.] |

---

## 📝 Features & Tasks

### Feature A: [Name] [PRIMARY/SECONDARY/MILESTONE-1/TRACK-A]

**Story Points:** [X] SP
**Gewichtung:** [MUST/SHOULD/COULD] oder [PRIMARY/SECONDARY]
**Owner:** [Name, falls Team-Sprint]

#### User Story
Als [User-Typ] kann ich [Aktion durchführen], um [Nutzen] zu erzielen.

#### Acceptance Criteria
- [ ] AC1: [Konkrete Bedingung]
- [ ] AC2: [Konkrete Bedingung]
- [ ] AC3: [Konkrete Bedingung]

#### Tasks (Vertikal organisiert)

**Backend:**
- [ ] **T-XXX:** [Task-Beschreibung] ([X] SP)
  - **Akzeptanzkriterium:** [Wie testen?]
  - **Dependencies:** [T-YYY oder "None"]

**Frontend:**
- [ ] **T-YYY:** [Task-Beschreibung] ([Y] SP)
  - **Akzeptanzkriterium:** [Wie testen?]
  - **Dependencies:** [T-XXX - Backend muss fertig sein]

**Tests:**
- [ ] **T-ZZZ:** Unit Tests (Backend + Frontend) ([X] SP)
- [ ] **T-AAA:** Integration Tests ([X] SP)
- [ ] **T-BBB:** E2E Test - Happy Path ([X] SP)

**Dokumentation:**
- [ ] **T-CCC:** API Docs ([1] SP)
- [ ] **T-DDD:** User Docs ([1] SP)

**Deployment:**
- [ ] **T-EEE:** Migrations (falls nötig) ([X] SP)
- [ ] **T-FFF:** Deploy-Script ([1] SP)

**Feature A Total:** [X] SP

#### Definition of Done (Feature A)

- [ ] **Funktional:**
  - [ ] Alle AC erfüllt
  - [ ] Feature funktioniert E2E
  - [ ] Keine Critical Bugs

- [ ] **Technisch:**
  - [ ] Code Review abgeschlossen
  - [ ] ≥80% Coverage
  - [ ] Unit + Integration + E2E Tests grün
  - [ ] CI/CD Pipeline grün

- [ ] **Deployment:**
  - [ ] Migrations getestet (Up + Down)
  - [ ] Deployed auf Staging
  - [ ] Smoke-Tests bestanden

- [ ] **Dokumentation:**
  - [ ] API Docs aktualisiert
  - [ ] User Docs aktualisiert
  - [ ] CHANGELOG.md aktualisiert

**Feature A Status:** [ ] Completed (100% DoD erfüllt)

---

### Feature B: [Name] [PRIMARY/SECONDARY/MILESTONE-2/TRACK-B]

**Story Points:** [X] SP
**Gewichtung:** [MUST/SHOULD/COULD] oder [PRIMARY/SECONDARY]
**Owner:** [Name, falls Team-Sprint]

#### User Story
Als [User-Typ] kann ich [Aktion durchführen], um [Nutzen] zu erzielen.

#### Acceptance Criteria
- [ ] AC1: [Konkrete Bedingung]
- [ ] AC2: [Konkrete Bedingung]

#### Tasks

[Gleiche Struktur wie Feature A]

#### Definition of Done (Feature B)

[Gleiche Struktur wie Feature A]

**Feature B Status:** [ ] Completed (100% DoD erfüllt)

---

### Feature C: [Name] [SECONDARY/MILESTONE-3/TRACK-C]

[Optional - falls 3. Feature vorhanden]

**Feature C Status:** [ ] Completed (100% DoD erfüllt)

---

## ✅ Sprint Definition of Done (Gesamt)

> **Wichtig:** Die Sprint-DoD hängt von der gewählten Strategie ab!

### Strategie 1: Primary/Secondary

**Release-Kriterium:**
- [x] **Primary Feature:** 100% DoD erfüllt → ✅ RELEASEBAR!
- [ ] **Secondary Feature 1:** [X]% DoD erfüllt → Optional
- [ ] **Secondary Feature 2:** [X]% DoD erfüllt → Optional

**Sprint ist releasebar, wenn Primary Feature 100% ist.**
Secondary Features sind Bonus (können verschoben werden).

---

### Strategie 2: Feature-Set

**Release-Kriterium:**
- [ ] **Feature A:** 100% DoD erfüllt
- [ ] **Feature B:** 100% DoD erfüllt
- [ ] **Feature C:** 100% DoD erfüllt

**UND:**
- [ ] Integration-Tests bestanden (Features funktionieren zusammen)
- [ ] Keine Feature-Konflikte
- [ ] Demo-Szenario (alle Features) erfolgreich

**Sprint ist NUR releasebar, wenn ALLE Features fertig sind.**
(Feature-Set nur komplett sinnvoll)

---

### Strategie 3: Mini-Milestones

**Milestone 1:** [Feature A]
- [ ] Feature A: 100% DoD erfüllt
- [ ] Deployed auf Staging
- [ ] Mini-Demo erfolgreich

**Milestone 2:** [Feature B]
- [ ] Feature B: 100% DoD erfüllt
- [ ] Deployed auf Staging
- [ ] Mini-Demo erfolgreich

**Milestone 3:** [Feature C]
- [ ] Feature C: 100% DoD erfüllt
- [ ] Deployed auf Staging

**Sprint-Release:**
- [ ] Alle Milestones erreicht
- [ ] Final-Demo erfolgreich
- [ ] Alle Features in Production

---

### Strategie 4: Parallele Tracks

**Track A:** [Developer A - Feature A]
- [ ] Feature A: 100% DoD erfüllt
- [ ] Code Review (von Developer B oder C)
- [ ] Merged in main

**Track B:** [Developer B - Feature B]
- [ ] Feature B: 100% DoD erfüllt
- [ ] Code Review
- [ ] Merged in main

**Track C:** [Developer C - Feature C]
- [ ] Feature C: 100% DoD erfüllt
- [ ] Code Review
- [ ] Merged in main

**Integration:**
- [ ] Alle Features merged ohne Konflikte
- [ ] Integration-Tests bestanden
- [ ] Features stören sich nicht gegenseitig
- [ ] Gemeinsame Demo erfolgreich

---

## 🎬 Demo-Szenario

### [Wähle Demo-Stil basierend auf Strategie]

#### Option 1: Sequenzielles Demo (Feature nach Feature)

**Gesamt-Dauer:** [X] Minuten

**Teil 1: Feature A ([X] Min)**
1. [Setup-Schritt]
2. [Demo-Aktion]
3. [Erwartetes Ergebnis]
**Screenshot:** `./screenshots/sprint-X-feature-a.png`

**Teil 2: Feature B ([X] Min)**
1. [Setup-Schritt]
2. [Demo-Aktion]
3. [Erwartetes Ergebnis]
**Screenshot:** `./screenshots/sprint-X-feature-b.png`

**Teil 3: Feature C ([X] Min)**
1. [Setup-Schritt]
2. [Demo-Aktion]
3. [Erwartetes Ergebnis]
**Screenshot:** `./screenshots/sprint-X-feature-c.png`

---

#### Option 2: Integriertes Demo (Features zusammen)

**Gesamt-Dauer:** [X] Minuten

**Story:** [Erzähle eine zusammenhängende User-Story, die alle Features nutzt]

**Schritt 1:** [Feature A nutzen]
- [Aktion]
- [Erwartung]

**Schritt 2:** [Feature B nutzen]
- [Aktion]
- [Erwartung]

**Schritt 3:** [Feature C nutzen]
- [Aktion]
- [Erwartung]

**Finale Verifikation:**
- [Zeige, dass alle Features zusammen funktionieren]

---

#### Option 3: Paralleles Demo (Team-Demo)

**Developer A demonstriert Feature A:** ([X] Min)
- [Demo-Schritte]

**Developer B demonstriert Feature B:** ([X] Min)
- [Demo-Schritte]

**Developer C demonstriert Feature C:** ([X] Min)
- [Demo-Schritte]

**Gemeinsamer Teil:** Integration-Test ([X] Min)
- [Zeige, dass alle Features parallel funktionieren]
- [Keine Konflikte]

---

## ⚖️ Priorisierung & Release-Strategie

### Bei Primary/Secondary:

**Wenn Primary nicht fertig wird:**
- ❌ Sprint NICHT releasebar
- → Sprint verlängern ODER Primary-Scope reduzieren

**Wenn Secondary nicht fertig wird:**
- ✅ Sprint TROTZDEM releasebar
- → Secondary in nächsten Sprint verschieben

### Bei Feature-Set:

**Wenn ein Feature nicht fertig wird:**
- ❌ Sprint NICHT releasebar (unvollständiges Feature-Set)
- → Fehlende Features fertigstellen ODER ganzes Set verschieben

### Bei Mini-Milestones:

**Wenn Milestone 1 nicht fertig wird:**
- ⚠️ Milestone 2+3 verzögern sich
- → Aber: Milestone 1 kann einzeln released werden (wenn fertig)

**Wenn Milestone 3 nicht fertig wird:**
- ✅ Milestone 1+2 können released werden
- → Milestone 3 in nächsten Sprint

### Bei Parallelen Tracks:

**Wenn Track A verzögert:**
- → Pair-Programming: Track B/C helfen Track A
- → Oder: Track B/C releasen, Track A in nächsten Sprint

---

## ⚠️ Risiken & Abhängigkeiten

### Feature-übergreifende Risiken

| Risiko | Wahrscheinlichkeit | Impact | Mitigation |
|--------|-------------------|--------|------------|
| [Risiko 1] | [Hoch/Mittel/Niedrig] | [Hoch/Mittel/Niedrig] | [Mitigation-Plan] |
| [Risiko 2] | [...] | [...] | [...] |

### Dependencies zwischen Features

**Feature B benötigt Feature A:**
- [ ] Feature A muss vor Feature B implementiert werden
- [ ] Oder: Feature A stellt Interface bereit, Feature B konsumiert

**Feature C blockiert Feature B:**
- [ ] [Beschreibung der Blockade]
- [ ] [Mitigation-Plan]

### Externe Abhängigkeiten

- [ ] [z.B. "API-Key für Feature A beantragt"] - **Verantwortlich:** [Name]

---

## 📈 Success-Metriken

### Pro Feature

| Feature | Ziel | Wie gemessen? | Status |
|---------|------|---------------|--------|
| Feature A | DoD 100% | Checklist abgehakt | [ ] |
| Feature B | DoD 100% | Checklist abgehakt | [ ] |
| Feature C | DoD 100% | Checklist abgehakt | [ ] |

### Sprint-Gesamt

| Metrik | Ziel | Aktuell | Status |
|--------|------|---------|--------|
| Features fertig | [X]/[Y] | [ ]/[Y] | [ ] |
| Test Coverage | ≥80% | [X]% | [ ] |
| E2E-Tests | 100% | [X]% | [ ] |
| Demo erfolgreich | Ja | [ ] | [ ] |
| Staging-Deployment | Erfolg | [ ] | [ ] |

---

## 🚀 Deployment-Plan

### Staging-Deployment

**Strategie-abhängig:**

**Primary/Secondary:**
- Primary fertig → Deploy Primary auf Staging
- Secondary fertig → Deploy Secondary zusätzlich

**Feature-Set:**
- Alle Features fertig → Deploy komplett
- Nicht einzeln deployen (unvollständiges Feature-Set verwirrt User)

**Mini-Milestones:**
- Nach jedem Milestone → Deploy auf Staging
- Kontinuierliches Feedback

**Parallele Tracks:**
- Nach Integration → Deploy alle Features zusammen
- Vorher: Nur auf Dev-Environment

### Production-Deployment

**Nach erfolgreicher Sprint-Demo:**
- [ ] Release-Entscheidung: Go/No-Go
- [ ] Bei Go: Deployment nach Production
- [ ] Monitoring: [Welche Metriken?]

---

## 🔄 Rollback-Plan

### Feature-spezifischer Rollback

**Feature A Rollback:**
```bash
# Falls Feature A Probleme macht:
git revert [commit-hash-feature-a]
./scripts/deploy.sh production
```

**Feature B Rollback:**
```bash
# Falls Feature B Probleme macht:
git revert [commit-hash-feature-b]
./scripts/deploy.sh production
```

### Kompletter Sprint-Rollback

```bash
# Rollback zu vor diesem Sprint:
git checkout [previous-sprint-tag]
./scripts/deploy.sh production
```

### Feature-Flag-Rollback (falls verwendet)

```bash
# In .env.production:
ENABLE_FEATURE_A=false
ENABLE_FEATURE_B=false

./scripts/deploy.sh production
```

---

## 📋 Sprint-Fortschritt

### Feature A: [Name]
- [ ] Implementierung (Tag 1-2)
- [ ] Tests (Tag 2)
- [ ] Code Review (Tag 3)
- [ ] DoD-Check (Tag 3)
- [ ] Staging-Deployment (Tag 3)

### Feature B: [Name]
- [ ] Implementierung (Tag 3-4)
- [ ] Tests (Tag 4)
- [ ] Code Review (Tag 5)
- [ ] DoD-Check (Tag 5)
- [ ] Staging-Deployment (Tag 5)

### Feature C: [Name]
- [ ] Implementierung (Tag 5)
- [ ] Tests (Tag 5)
- [ ] Code Review (Tag 6)
- [ ] DoD-Check (Tag 6)
- [ ] Staging-Deployment (Tag 6)

### Sprint-Finalisierung
- [ ] Integration-Tests (Tag 6)
- [ ] Demo-Vorbereitung (Tag 6)
- [ ] Sprint-Demo (Tag 7)
- [ ] Production-Deployment (Tag 7, nach Approval)

---

## 📝 Notizen

### Feature A
[Platz für Notizen während der Implementation]

### Feature B
[Platz für Notizen während der Implementation]

### Feature C
[Platz für Notizen während der Implementation]

### Sprint-Gesamt
[Platz für Sprint-übergreifende Notizen]

---

## 🔗 Referenzen

- **PRD:** [Link zu PRD.md]
- **User Stories:** [Link zu user-stories.md]
- **Tasks:** [Link zu tasks.md]
- **Multi-Feature-Strategien:** `../multi-feature-sprint-strategies.md`
- **Previous Sprint:** [Link zu sprint-[X-1]-plan.md]
- **Next Sprint:** [Link zu sprint-[X+1]-plan.md]

---

## 📊 Sprint-Retrospektive (Nach Sprint)

### Was lief gut?
- [Positive Punkte]

### Was lief schlecht?
- [Probleme]

### Was lernen wir für nächste Multi-Feature-Sprints?
- [Lessons Learned]

### Strategie-Bewertung
**Gewählte Strategie:** [Primary/Secondary | Feature-Set | Mini-Milestones | Parallele Tracks]

**War die Strategie richtig?**
- [ ] Ja, perfekt für diesen Sprint
- [ ] Nein, Strategie [X] wäre besser gewesen

**Begründung:**
[Erklärung]

---

**Template-Version:** v2.1 (Multi-Feature)
**Erstellt am:** [YYYY-MM-DD]
**Autor:** [Name]
