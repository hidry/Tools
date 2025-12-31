# Bug Fix Guidelines v2.0
## Lightweight Process für Bug-Bearbeitung mit Claude Code

---

## 🎯 Wann diesen Guide nutzen?

**Nutze Bug Fix Guidelines für:**
- ✅ Bug Fixes (1-30 Story Points)
- ✅ Hotfixes (Production-Critical)
- ✅ Kleinere Defects und Regressions
- ✅ Performance-Issues (isoliert)
- ✅ Security-Vulnerabilities (einzelne)

**Nutze PRD-to-Code Workflow für:**
- ❌ Features (40-120 Story Points)
- ❌ Neue Funktionalität
- ❌ Große Refactorings mit Business Value
- ❌ Produktneuentwicklungen

---

## 📊 Entscheidungsbaum

```
Bug entdeckt
  │
  ├─ Production-Critical? (System down, Data Loss, Security Breach)
  │   └─ JA → 🚨 Hotfix-Prozess (siehe unten)
  │
  ├─ Schätzung: <5 Story Points? (1-2h Fix)
  │   ├─ JA → ✅ Prozess 1: Direkt-Fix
  │   └─ NEIN → weitermachen
  │
  ├─ Schätzung: 5-15 Story Points? (0.5-2 Tage)
  │   ├─ JA → ✅ Prozess 2: Strukturierter Fix
  │   └─ NEIN → weitermachen
  │
  ├─ Schätzung: 15-30 Story Points? (3-5 Tage)
  │   ├─ JA → ✅ Prozess 3: Komplexer Bug
  │   └─ NEIN → Bug zu groß, in kleinere Bugs splitten
```

---

## Prozess 1: Direkt-Fix (<5 SP, 1-2h)

**Typische Bugs:**
- Typos, Off-by-One Errors
- Kleine UI-Glitches
- Einfache Validierungsfehler
- Missing Null-Checks

### Workflow

**User-Eingaben:**
```bash
git checkout -b bugfix/fix-login-validation
claude
```

```text
Behebe folgenden Bug:

Bug-Beschreibung: [Kurzbeschreibung]
Erwartetes Verhalten: [Was sollte passieren]
Aktuelles Verhalten: [Was passiert stattdessen]
Reproduktion: [Schritte zum Reproduzieren]

Schreibe produktiven, produktionsreifen Code:
• Tests: Mindestens 80% Coverage für geänderten Code
• Regression Tests: Stelle sicher, dass der Fix keine neuen Bugs einführt
```

**Workflow:**
1. Claude analysiert Bug
2. Claude identifiziert Root Cause
3. Claude implementiert Fix
4. Claude schreibt Tests (inkl. Regression Tests)
5. Claude führt Tests aus
6. User: "Committe den Bug Fix"

**Commit-Message:**
```
fix(module): fix login validation error

Fixes issue where empty email bypassed validation
```

**Push & PR:**
```bash
git push -u origin bugfix/fix-login-validation
gh pr create --title "Fix: Login Validation Error" --body "Fixes #123"
```

---

## Prozess 2: Strukturierter Fix (5-15 SP, 0.5-2 Tage)

**Typische Bugs:**
- Race Conditions
- Memory Leaks (isoliert)
- Komplexere Validierungsfehler
- API Integration Issues
- Authentifizierungs-Bugs

### Workflow

**User-Eingaben:**
```bash
git checkout -b bugfix/fix-oauth-refresh-race-condition
claude
```

```text
Alt + M                          # Plan Mode (zweimal drücken bis "Plan" angezeigt wird)

Analysiere und behebe folgenden Bug:

Bug-Beschreibung: [Detaillierte Beschreibung]
Erwartetes Verhalten: [Was sollte passieren]
Aktuelles Verhalten: [Was passiert stattdessen]
Reproduktion: [Schritte zum Reproduzieren]
Fehler-Logs: [Relevante Logs/Stack Traces]

Root Cause Analysis:
1. Identifiziere betroffene Komponenten
2. Analysiere Code-Flow
3. Finde Root Cause
4. Erstelle Fix-Plan mit folgenden Schritten:
   - Code-Änderungen
   - Test-Strategie (Unit + Integration Tests)
   - Regression-Test-Plan
```

**Workflow:**
1. Claude erstellt Root Cause Analysis und Fix-Plan in Plan Mode
2. User reviewt Plan, gibt Feedback/Approval
3. User startet Execution mit Alt + M
4. Claude implementiert Fix nach Plan
5. Claude schreibt Tests (>80% Coverage + Regression Tests)
6. Claude führt alle Tests aus
7. User: "Committe den Bug Fix"

**Commit-Message:**
```
fix(oauth): resolve race condition in refresh token flow

Root cause: Concurrent refresh requests competed for token update
Solution: Implement mutex lock for token refresh operations
Tests: Added integration tests for concurrent refresh scenarios
```

**Push & PR:**
```bash
git push -u origin bugfix/fix-oauth-refresh-race-condition
gh pr create --title "Fix: OAuth Refresh Token Race Condition" --body "Fixes #456"
```

---

## Prozess 3: Komplexer Bug (15-30 SP, 3-5 Tage)

**Typische Bugs:**
- Architektur-Level Issues
- Performance-Probleme (System-Wide)
- Komplexe Race Conditions
- Data Corruption Issues
- Multi-Component Bugs

### Workflow

**Setup:**
```bash
git checkout -b bugfix/fix-data-corruption-on-concurrent-writes
claude
```

**Phase 1: Bug Analysis Document (OpusPlan + Thinking 8k, 1-2h)**

**User-Eingaben:**
```text
Tab                              # Extended Thinking (8k)
Alt + M                          # Plan Mode (zweimal drücken bis "Plan" angezeigt wird)

Erstelle Bug Analysis Document für folgenden Bug:

Bug-Beschreibung: [Sehr detaillierte Beschreibung]
Erwartetes Verhalten: [Was sollte passieren]
Aktuelles Verhalten: [Was passiert stattdessen]
Reproduktion: [Detaillierte Schritte zum Reproduzieren]
Fehler-Logs: [Alle relevanten Logs/Stack Traces]
Umgebung: [OS, Browser, Versions, etc.]

Das Bug Analysis Document soll enthalten:
1. Executive Summary (1-2 Sätze)
2. Symptome & Auswirkungen
3. Root Cause Analysis
   - Betroffene Komponenten
   - Code-Flow Diagramm
   - Root Cause (detailliert)
4. Proposed Solution
   - Lösungsansatz
   - Alternativen (mit Pros/Cons)
   - Empfehlung
5. Impact Analysis
   - Breaking Changes?
   - Performance Impact?
   - Migration notwendig?
6. Test Strategy
   - Unit Tests
   - Integration Tests
   - Regression Tests
   - E2E Tests (falls notwendig)

Ausgabe: bug-analysis.md
```

**Workflow:**
1. Claude erstellt Bug Analysis Document
2. User reviewt, gibt Feedback
3. Claude arbeitet Feedback ein
4. User: "Committe das Bug Analysis Document"

**Commit-Message:**
```
docs: add bug analysis for data corruption issue
```

---

**Phase 2: Tasks erstellen (Sonnet, 30-60 min)**

**User-Eingaben:**
```text
/compact "Behalte Bug Analysis, Root Cause, Proposed Solution"

/todo "Erstelle aus bug-analysis.md konkrete Development Tasks für Bug Fix.

Format:
- Task-ID: T-XXX
- Titel: [Kurzbeschreibung]
- Beschreibung: [Technische Schritte]
- Acceptance Criteria: (Code, Tests >80%, Review, Merged)
- Story Points: [1-5]
- Dependencies: [Task-IDs]
- Priority: [Must/Should/Could]

Ausgabe: bug-fix-tasks.md"
```

**Workflow:**
1. Claude analysiert Bug Analysis Document
2. Claude generiert Tasks
3. Claude speichert bug-fix-tasks.md
4. User reviewt Tasks
5. User: "Committe die Tasks"

**Commit-Message:**
```
docs: add bug fix tasks (X tasks, Y SP)
```

---

**Phase 3: Implementation (OpusPlan, 2-4h)**

**User-Eingaben:**
```text
Alt + M                          # Plan Mode (zweimal drücken bis "Plan" angezeigt wird)

Implementiere ALLE Tasks aus bug-fix-tasks.md.

Schreibe produktiven, produktionsreifen Code:
• Standard: Clean Code, SOLID Principles
• Tests: Mindestens 80% Coverage
• Regression Tests: Stelle sicher, dass der Fix keine neuen Bugs einführt
• Dokumentation: Inline Comments für komplexe Logik
```

**Workflow:**
1. Claude erstellt Implementierungsplan in Plan Mode
2. User reviewt Plan, gibt Feedback/Approval
3. User startet Execution mit Alt + M
4. Claude implementiert Tasks
5. Claude führt Code Review durch
6. Claude erstellt Tests (>80% Coverage)
7. Claude führt alle Tests aus
8. User: "Committe den Bug Fix"

**Commit-Message:**
```
fix(database): resolve data corruption on concurrent writes

Root cause: Missing transaction isolation for concurrent write operations
Solution: Implement optimistic locking with version field
Tests: Added comprehensive integration tests for concurrent scenarios
```

**Push & PR:**
```bash
git push -u origin bugfix/fix-data-corruption-on-concurrent-writes
gh pr create --title "Fix: Data Corruption on Concurrent Writes" --body "$(cat bug-analysis.md)"
```

---

## 🚨 Hotfix-Prozess (Production-Critical)

**Wann nutzen?**
- System down
- Data Loss
- Security Breach (aktiv ausgenutzt)
- Payment Processing kaputt

### Workflow

**Setup (Fast-Track):**
```bash
git checkout main
git pull origin main
git checkout -b hotfix/fix-payment-gateway-down
claude
```

**User-Eingaben:**
```text
🚨 HOTFIX - PRODUCTION-CRITICAL 🚨

Bug-Beschreibung: [Was ist kaputt]
Business Impact: [€€€ / User Impact]
Erwartetes Verhalten: [Was sollte passieren]
Aktuelles Verhalten: [Was passiert stattdessen]

Schnellstmögliche Analyse und Fix:
1. Root Cause identifizieren
2. Minimal Invasive Fix (keine Refactorings!)
3. Tests für Fix (Fokus auf Regression)
4. Deploy-Ready machen

⚠️ WICHTIG: Keine Over-Engineering, nur Fix!
```

**Workflow:**
1. Claude analysiert Bug (Fokus: Speed)
2. Claude identifiziert Root Cause
3. Claude implementiert minimal invasive Fix
4. Claude schreibt Tests (Fokus: Regression)
5. Claude führt Tests aus
6. User: "Committe den Hotfix"

**Commit-Message:**
```
hotfix: fix payment gateway connection timeout

Critical production issue - payment processing down
Root cause: Missing connection timeout configuration
Solution: Set explicit timeout to 30s
```

**Fast-Track Merge:**
```bash
git push -u origin hotfix/fix-payment-gateway-down
gh pr create --title "🚨 HOTFIX: Payment Gateway Down" --body "Production-critical - immediate merge required"
# Nach Review: Sofort mergen
git checkout main
git merge hotfix/fix-payment-gateway-down
git push origin main
git tag -a v1.2.3-hotfix -m "Hotfix: Payment Gateway"
git push origin v1.2.3-hotfix
```

**Post-Hotfix:**
```text
Nach Hotfix-Deployment:

Erstelle Follow-Up Task für:
• Root Cause Deep-Dive
• Langfristige Lösung (falls Hotfix nur Workaround)
• Monitoring/Alerting verbessern
• Postmortem Document
```

---

## 💡 Best Practices

### Bug-Priorisierung
- 🔴 **P0 (Hotfix)**: Production down, Data Loss, Security Breach
- 🟠 **P1 (Hoch)**: Wichtige Features kaputt, viele User betroffen
- 🟡 **P2 (Mittel)**: Einzelne Features kaputt, wenige User betroffen
- 🟢 **P3 (Niedrig)**: Kosmetische Issues, Edge Cases

### Root Cause Analysis
- ✅ Immer Root Cause finden, nicht nur Symptom fixen
- ✅ "5 Why's" Methode nutzen
- ✅ Code-Flow Diagramm erstellen bei komplexen Bugs
- ✅ Logs/Stack Traces vollständig analysieren

### Testing Strategy
- ✅ Mindestens 80% Coverage für geänderten Code
- ✅ Regression Tests für Bug (verhindert Wiederauftreten)
- ✅ Integration Tests bei Multi-Component Bugs
- ✅ E2E Tests bei kritischen User-Flows

### Git Workflow
- ✅ Branch-Naming: `bugfix/` (normale Bugs), `hotfix/` (Production-Critical)
- ✅ Conventional Commits: `fix(module): description`
- ✅ PR-Body: Bug-Beschreibung, Root Cause, Solution
- ✅ Hotfixes: Tag erstellen nach Merge (`v1.2.3-hotfix`)

### Context Management
- ✅ Prozess 1: Kein `/compact` notwendig (kurz)
- ✅ Prozess 2: Kein `/compact` notwendig (Plan Mode reicht)
- ✅ Prozess 3: `/compact` zwischen Phases nutzen
- ✅ Hotfix: Kein `/compact` (Speed!)

---

## 📈 Vergleich: Bug Fix vs PRD-to-Code

| Aspekt | Bug Fix Guidelines | PRD-to-Code Workflow |
|--------|-------------------|---------------------|
| **Zweck** | Bugs beheben | Features entwickeln |
| **Größe** | 1-30 Story Points | 40-120 Story Points |
| **Dauer** | 1h - 5 Tage | 2-15 Tage |
| **Phasen** | 1-3 Phasen | 5 Phasen |
| **Dokumentation** | Minimal (nur Prozess 3) | Umfangreich (PRD, Stories, Tasks) |
| **Plan Mode** | Prozess 2-3 | Phase 1 + 5 |
| **Extended Thinking** | Nur Prozess 3 | Phase 1 + 3 |
| **Git Strategy** | `bugfix/` oder `hotfix/` | `feature/` |
| **Context Mgmt** | Minimal | `/compact` zwischen Phasen |

---

**Version**: 2.0
**Last Updated**: 2025-01-XX
**Author**: Based on Anthropic Best Practices 2025
