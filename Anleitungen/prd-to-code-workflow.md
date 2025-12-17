# Claude Code PRD-to-Code Workflow
## Spec-Driven Development mit Claude Code, Commands & wshobson/agents

---

## Voraussetzungen

- PRD-Command installieren: `/create-prd` (bzw. `/create_prd`)  
  Quelle: https://www.buildwithclaude.com/command/create-prd

- Todo-Template installieren:  
  ```bash
  npm install -g claude-code-templates@latest
  claude-code-templates --command=project-management/todo --yes
  ```

---

## Phase 1: PRD erstellen und reviewen (Opus)

1. **Neuen Branch erstellen**
   ```bash
   git checkout -b feature/oauth-ms-accounts
   ```

2. **Claude Code starten**
   ```bash
   claude
   ```

3. **Extended Thinking aktivieren**  
   - Im Claude-Terminal: `Tab` drücken (einmalig).

4. **Modell auf Opus stellen**
   - Command: `/model -> opus` (oder im Model-Menü Opus wählen).

5. **Plan Mode aktivieren (Windows Terminal / PowerShell)**  
   - `Alt + M` zweimal drücken, bis „Plan" angezeigt wird.

6. **PRD generieren**
   ```text
   /create-prd "Implementiere oAuth für Microsoft-Konten für User inkl. Refresh etc. Ziel ist es, dass User sich mit Claude Desktop mittels Remote-MCP mit den MCP-Endpunkten der API verbinden können."
   ```

7. **PRD-Review durchführen und Feedback einarbeiten**
   ```text
   /review @PRD.md: Führe ein Review des PRD durch. Prüfe auf Verständlichkeit, Lücken, widersprüchliche Anforderungen und unklare Akzeptanzkriterien. Schlage konkrete Änderungen vor.
   ```
   - Feedback einarbeiten, PRD speichern.  
   - Bei Bedarf `/review @PRD.md` erneut, bis der PRD-Stand passt.

8. **Plan ausführen (optional)**
   - `Alt + M` einmal drücken, um den Plan-Modus zu verlassen, wenn du ihn nur zum Planen nutzen wolltest.

---

## Phase 2: User Stories aus PRD ableiten (Sonnet)

9. **Modell auf Sonnet wechseln**
   - `/model -> sonnet`

10. **User Stories erzeugen**
   ```text
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

11. **Context resetten**
   ```text
   /clear
   ```

---

## Phase 3: Tasks & Validierung

12. **Tasks aus User Stories ableiten (Sonnet)**
   ```text
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
   ```

13. **Modell auf Opus stellen (für Validierung)**
   - `/model -> opus`

14. **User Stories + Tasks validieren und Feedback einarbeiten**
   ```text
   Validiere user-stories.md + tasks.md auf:
   ✓ Dependencies: Keine Zirkularabhängigkeiten?
   ✓ Duplikate: Keine doppelten Stories/Tasks?
   ✓ Schätzung: Gesamtbudget realistisch?
   ✓ Coverage: Alle PRD-Features abgedeckt?
   ✓ INVEST: Stories erfüllen INVEST-Kriterien?

   Gib einen strukturierten Validierungsbericht aus und schlage konkrete Anpassungen vor.
   ```
   - Danach: Feedback aus dem Validierungsbericht in `user-stories.md` und `tasks.md` einarbeiten (analog zum PRD-Review in Phase 1).  
   - Optional: bei größeren Anpassungen eine kurze zweite Validierungsrunde anstoßen.

15. **Context resetten**
   ```text
   /clear
   ```

---

## Phase 4: Sprint-Plan erstellen (Sonnet)

16. **Modell auf Sonnet wechseln**
   - `/model -> sonnet`

17. **Sprints planen**
   ```text
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

---

## Phase 5: Implementierung nach Sprint-Plan (Opus)

18. **Modell auf Opus wechseln**
   - `/model -> opus`

19. **Sprint 1 implementieren**
   ```text
   Implementiere ALLE Tasks aus Sprint 1 basierend auf sprint-plan.md.
   Schreibe produktiven, produktionsreifen Code:

   • Sprache: [C#/.NET]
   • Standard: Clean Code, SOLID Principles
   • Tests: Mindestens 80% Coverage
   • Dokumentation: Inline Comments für komplexe Logik
   ```

20. **Sprint 2 implementieren**
   ```text
   Implementiere ALLE Tasks aus Sprint 2 basierend auf sprint-plan.md.
   Schreibe produktiven, produktionsreifen Code:

   • Sprache: [C#/.NET]
   • Standard: Clean Code, SOLID Principles
   • Tests: Mindestens 80% Coverage
   • Dokumentation: Inline Comments für komplexe Logik
   ```

21. **Sprint 3 implementieren (falls vorhanden)**
   ```text
   Implementiere ALLE Tasks aus Sprint 3 basierend auf sprint-plan.md.
   Schreibe produktiven, produktionsreifen Code:

   • Sprache: [C#/.NET]
   • Standard: Clean Code, SOLID Principles
   • Tests: Mindestens 80% Coverage
   • Dokumentation: Inline Comments für komplexe Logik
   ```

---

---

# CHEAT-SHEET: Quick Reference

## Voraussetzungen
- `/create-prd` installiert
- `/todo` installiert:
  ```bash
  npm install -g claude-code-templates@latest
  claude-code-templates --command=project-management/todo --yes
  ```

---

## Phase 1 – PRD (Opus)

1. Branch & Claude starten
   ```bash
   git checkout -b feature/oauth-ms-accounts
   claude
   ```
2. Thinking an: `Tab`  
3. Modell: `/model -> opus`  
4. Plan Mode (Windows Terminal): `Alt + M` zweimal (bis „Plan")  
5. PRD erzeugen:
   ```text
   /create-prd "Implementiere oAuth für Microsoft-Konten für User inkl. Refresh etc. Ziel ist es, dass User sich mit Claude Desktop mittels Remote-MCP mit den MCP-Endpunkten der API verbinden können."
   ```
6. PRD reviewen & überarbeiten:
   ```text
   /review @PRD.md: Führe ein Review des PRD durch, schlage konkrete Verbesserungen vor.
   ```
   Änderungen einarbeiten, ggf. `/review @PRD.md` wiederholen.

---

## Phase 2 – User Stories (Sonnet)

7. Modell: `/model -> sonnet`  
8. User Stories generieren:
   ```text
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
9. Context reset:
   ```text
   /clear
   ```

---

## Phase 3 – Tasks & Validierung

10. Tasks erzeugen (Sonnet):
   ```text
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
   ```

11. Modell: `/model -> opus`  
12. Stories + Tasks validieren & anpassen:
   ```text
   Validiere user-stories.md + tasks.md auf:
   ✓ Dependencies: Keine Zirkularabhängigkeiten?
   ✓ Duplikate: Keine doppelten Stories/Tasks?
   ✓ Schätzung: Gesamtbudget realistisch?
   ✓ Coverage: Alle PRD-Features abgedeckt?
   ✓ INVEST: Stories erfüllen INVEST-Kriterien?

   Gib einen strukturierten Validierungsbericht aus und schlage konkrete Anpassungen vor.
   ```
   Feedback in `user-stories.md` und `tasks.md` einarbeiten.

13. Context reset:
   ```text
   /clear
   ```

---

## Phase 4 – Sprint-Plan (Sonnet)

14. Modell: `/model -> sonnet`  
15. Sprint-Plan erstellen:
   ```text
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

---

## Phase 5 – Implementierung (Opus)

16. Modell: `/model -> opus`  
17. Sprint 1 implementieren:
   ```text
   Implementiere ALLE Tasks aus Sprint 1 basierend auf sprint-plan.md.
   Schreibe produktiven, produktionsreifen Code:

   • Sprache: [C#/.NET]
   • Standard: Clean Code, SOLID Principles
   • Tests: Mindestens 80% Coverage
   • Dokumentation: Inline Comments für komplexe Logik
   ```

18. Sprint 2 & 3 analog:
   ```text
   Implementiere ALLE Tasks aus Sprint 2/3 basierend auf sprint-plan.md.
   (gleiche Qualitätskriterien wie oben)
   ```

---

## Tipps

- Nach jedem großen Block (PRD fertig, Stories fertig, Tasks validiert) einen Git-Commit setzen für klare Milestones.
- `/clear` zwischen den Phasen reduziert Context-Bloat und verbessert die Modell-Performance.
- `Alt + M` unter Windows Terminal zum Wechseln zwischen Plan Mode und normaler Eingabe – zweimal drücken für volle Aktivierung.
- Bei längeren Implementierungsphasen: keinen `/clear` zwischen Sprints, damit Claude Code-Patterns konsistent hält.
