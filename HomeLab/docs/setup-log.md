# HomeLab Setup Log

Chronologische Dokumentation der Einrichtung und Entscheidungen.

## 2026-01-02: Initiale Planung - Server Rack Setup

### Ausgangssituation

**Vorhandene Hardware:**
- ThinkCentre mit Proxmox
  - Home Assistant VM
  - Windows VM
- FritzBox mit angeschlossener USB-Festplatte
- Netzwerk-Switch

**Ziel:** Organisation der Hardware im Technikraum

### Fragestellung

Wie soll die Hardware am besten untergebracht werden?
- Selbstbau (Holz oder Aluminium-Profile Typ I)?
- Fertiglösung kaufen?

### Evaluierte Optionen

#### 1. 9HE Wandrack (Empfohlen)
- **Kosten**: ca. 250-300 €
- **Vorteile**:
  - Professionell
  - Erweiterbar
  - Standard 19" Montage
  - Gutes Kabelmanagement
- **Nachteile**: Höhere Kosten

#### 2. IKEA HYLLIS (Budget)
- **Kosten**: ca. 30-40 €
- **Vorteile**:
  - Sehr günstig
  - Schnell verfügbar
  - Einfacher Aufbau
- **Nachteile**:
  - Weniger professionell
  - Begrenzt erweiterbar

#### 3. Holz-Eigenbau
- **Kosten**: ca. 50-70 €
- **Vorteile**: Maßgeschneidert
- **Nachteile**:
  - Zeitaufwand 4-6h
  - Brandschutz beachten

#### 4. Aluminium-Profile (Typ I)
- **Kosten**: ca. 100-200 €
- **Vorteile**:
  - Sehr modular
  - Professionell
  - Langlebig
- **Nachteile**:
  - Teurer
  - Planungsaufwand

### Entscheidung

**Empfehlung**: 9HE Wandrack mit Fachböden

**Begründung:**
- Beste Balance zwischen Kosten, Professionalität und Erweiterbarkeit
- Standard-19"-Komponenten nutzbar
- Gutes Kabelmanagement
- Ausreichend für aktuelles Setup + zukünftige Erweiterungen

**Alternative für kleines Budget**: IKEA HYLLIS

### Geplanter Rack-Aufbau

```
[9HE Wandschrank - ca. 250-300 €]
├─ 1-2 HE: Kabelmanagement / Leerraum oben
├─ 3-4 HE: Fachboden → FritzBox + USB-Platte
├─ 5-7 HE: Fachboden → ThinkCentre (mit Belüftungsabstand)
├─ 8 HE:   Switch (19" Montage oder Shelf)
└─ 9 HE:   Kabelmanagement unten / PDU
```

### Wichtige Überlegungen

**Belüftung:**
- ThinkCentre erzeugt meiste Wärme
- Mind. 5-10 cm Abstand an allen Seiten
- Wärmeabfuhr nach oben beachten

**Stromversorgung:**
- Geschätzter Gesamtverbrauch: 85-195W
- ThinkCentre: 65-150W
- FritzBox: 10-20W
- Switch: 5-15W
- USB-Platte: 5-10W

**Empfehlung**: USV (600-800VA) für Datenschutz bei Stromausfall

**Verkabelung:**
- Kurze Patchkabel zwischen Geräten
- Kabelmanagement mit Kabelbindern/Klettverschluss
- Alle Kabel beschriften

### Materialliste (9HE Rack)

- [ ] 9HE Wandschrank (z.B. Lanberg WF02-6409-10B) - ca. 200 €
- [ ] 2x 19" Fachboden/Shelf (mind. 10kg Traglast) - ca. 40-60 €
- [ ] Steckdosenleiste (mind. 6 Plätze) - ca. 20-30 €
- [ ] Kabelmanagement-Zubehör - ca. 20 €
  - Kabelbinder
  - Klettverschluss-Strips
  - Kabelführungen

**Gesamt**: ca. 280 €

### Nächste Schritte

- [ ] Budget final bestätigen
- [ ] Platzbedarf im Technikraum ausmessen
- [ ] Rack-Komponenten bestellen
- [ ] Wandmontage vorbereiten (Traglast prüfen)
- [ ] Rack montieren und Geräte einbauen
- [ ] Verkabelung optimieren
- [ ] Dokumentation aktualisieren (Fotos, Netzwerk-Diagramm)

### Ressourcen

**Dokumentation:**
- Detaillierte Anleitung: [server-rack-setup.md](./server-rack-setup.md)
- Vergleichstabelle aller Optionen
- Schritt-für-Schritt Aufbauanleitung

**Shops:**
- reichelt.de
- digitec.ch / galaxus.ch
- amazon.de

---

## Zukünftige Einträge

Weitere Setup-Schritte werden hier chronologisch dokumentiert.
