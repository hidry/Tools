# Server Rack Setup für Home Lab

Leitfaden zur Organisation von Home-Server-Infrastruktur im Technikraum.

## Übersicht

Diese Anleitung hilft bei der Entscheidung, wie man ein kleines Home Lab optimal organisiert:
- ThinkCentre (Proxmox, Home Assistant, Windows)
- FritzBox mit USB-Festplatte
- Netzwerk-Switch

## Optionen im Vergleich

### 1. Fertiges Mini-Rack kaufen (Empfohlen für Einsteiger)

**Vorteile:**
- Schnell einsatzbereit
- Professionelles Erscheinungsbild
- Standardisierte 19" Mounting-Optionen
- Gute Belüftung
- Kabelmanagement integriert

**Nachteile:**
- Höhere Kosten (150-400 €)
- Weniger flexibel in den Abmessungen
- Oft größer als nötig

**Empfohlene Produkte:**
- **9-12 HE Wandschrank** (ca. 200-350 €)
  - Digitus DN-10-12U-EC oder ähnlich
  - Lanberg WF02-6409-10B (9HE)
  - Ideal für kleine Setups

- **Open Frame Rack** (ca. 80-150 €)
  - Günstiger
  - Bessere Belüftung
  - Weniger Schutz vor Staub

**Zusätzliches Zubehör:**
- Fachböden/Shelfs für Nicht-19"-Geräte (20-40 €)
- Kabelmanagement-Zubehör (10-30 €)
- Steckdosenleiste 19" (optional, 30-80 €)

### 2. Eigenbau aus Holz

**Vorteile:**
- Kostengünstig (30-60 € Material)
- Maßgeschneidert für Ihre Geräte
- Flexibles Design
- Einfache Werkzeuge ausreichend

**Nachteile:**
- Zeitaufwand (4-8 Stunden)
- Weniger professionell
- Keine Standard-Rack-Montage
- Brandschutz beachten (behandeltes Holz verwenden)

**Materialempfehlung:**
- Multiplexplatten 18-21mm (stabiler als Spanplatte)
- Holzschrauben, Winkel
- Gummifüße oder Filzgleiter
- Optional: Holzlasur/Lack

**Konstruktion:**
```
Empfohlene Abmessungen für Ihr Setup:
- Breite: 50-60 cm
- Tiefe: 40-45 cm (abhängig von ThinkCentre-Tiefe)
- Höhe: 60-80 cm (3-4 Ebenen)

Ebenen:
1. Unten: Switch (kompakt)
2. Mitte: ThinkCentre (Hauptgerät, gute Belüftung)
3. Oben: FritzBox (Wärmeabfuhr nach oben)
4. Optional: USB-Platte auf separatem Shelf
```

### 3. Eigenbau aus Aluprofilen (Typ Item, Bosch Rexroth)

**Vorteile:**
- Sehr stabil und modular
- Professionelle Optik
- Erweiterbar und umbaubar
- Langlebig
- Kein Brandschutzthema

**Nachteile:**
- Höhere Materialkosten (100-200 €)
- Spezialwerkzeug teilweise nötig
- Planungsaufwand
- Verbinder und Zubehör teuer

**Materialempfehlung:**
- Profile 30x30 mm oder 40x40 mm
- Winkelverbinder, Nutensteine
- Optional: Acrylplatten als Fachböden

**Systeme:**
- **Item Typ I** (teurer, hochwertig)
- **Motedis** (guter Kompromiss)
- **Makerbeam/OpenBeam** (günstiger für kleine Projekte)

### 4. IKEA-Hack (Günstige Alternative)

**Vorteile:**
- Sehr günstig (20-50 €)
- Schnell verfügbar
- Einfacher Aufbau

**Beispiele:**
- **HYLLIS** Regal (15-20 €)
  - Metallregal, 4 Ebenen
  - 60x27x140 cm
  - Gut für vertikale Anordnung

- **BROR** Regal (40-60 €)
  - Robuster, Metall + Holz
  - Verstellbare Ebenen
  - 65x40x190 cm

**Nachteile:**
- Weniger maßgeschneidert
- Kabelmanagement selbst lösen

## Empfehlung für Ihr Setup

**Für ThinkCentre + FritzBox + Switch empfehle ich:**

### Option A: Kleines 9HE Wandrack (Best Practice)
- **Kosten:** ca. 250-300 € komplett
- **Aufbau:** 1-2 Stunden
- **Erweiterbar:** Ja, durch 19" Zubehör

**Aufbau:**
```
[9HE Wandschrank]
├─ 1-2 HE: Leerraum / Kabelmanagement oben
├─ 3-4 HE: Fachboden → FritzBox + USB-Platte
├─ 5-7 HE: Fachboden → ThinkCentre (mit Abstand für Belüftung)
├─ 8 HE: Switch (auf 19" Patch Panel oder Shelf)
└─ 9 HE: Kabelmanagement unten / PDU
```

### Option B: IKEA HYLLIS + Holzplatten (Budget)
- **Kosten:** ca. 30-40 €
- **Aufbau:** 30 Minuten
- **Erweiterbar:** Begrenzt

**Aufbau:**
```
[HYLLIS Regal 4 Ebenen]
├─ Ebene 4: FritzBox
├─ Ebene 3: USB-Platte (wenn separat)
├─ Ebene 2: ThinkCentre (Hauptwärme)
└─ Ebene 1: Switch
```

### Option C: Holz-Eigenbau (Maßgeschneidert)
- **Kosten:** ca. 50-70 €
- **Aufbau:** 4-6 Stunden
- **Erweiterbar:** Mittel

## Wichtige Überlegungen

### 1. Belüftung
- **ThinkCentre** erzeugt die meiste Wärme
- Mindestens 5-10 cm Abstand an allen Seiten
- Nicht in geschlossenem Schrank ohne Lüftung
- Wärmeabfuhr nach oben beachten

### 2. Kabelmanagement
- Strom: Alle Geräte an Überspannungsschutz
- Netzwerk: Kurze Patch-Kabel verwenden
- Kabelbinder oder Klettverschluss-Strips
- Beschriftung der Kabel

### 3. Zugänglichkeit
- USB-Platte an FritzBox: Zugang für Wartung
- ThinkCentre: USB-Ports sollten erreichbar sein
- Switch: LEDs sollten sichtbar sein

### 4. Stromversorgung
Geschätzter Verbrauch:
- ThinkCentre: 65-150W (je nach Last)
- FritzBox: 10-20W
- Switch: 5-15W (abhängig von Typ)
- USB-Platte: 5-10W

**Gesamt:** ca. 85-195W → Standard-Steckdosenleiste ausreichend

### 5. Netzwerkverkabelung
- Kurze Patchkabel zwischen Switch und Geräten
- Uplink zur Wand/Verteiler einplanen
- Cat6 oder Cat6a für Zukunftssicherheit

### 6. Wartung
- Staubfilter/Reinigung alle 3-6 Monate
- Backup-Zugänglichkeit (USB-Platte)
- Monitoring-Zugang (evtl. KVM für ThinkCentre)

## Schritt-für-Schritt: Empfohlene Lösung

**Ich empfehle für Ihr Setup: Option A (9HE Wandrack)**

### Materialliste (ca. 280 €)

1. **9HE Wandschrank** (ca. 200 €)
   - z.B. Lanberg WF02-6409-10B
   - Maße: ca. 50cm tief, 60cm breit

2. **2x 19" Fachboden/Shelf** (ca. 40-60 €)
   - Für ThinkCentre und FritzBox
   - Traglast: mind. 10kg

3. **Steckdosenleiste** (ca. 20-30 €)
   - Optional: 19" PDU
   - Mind. 6 Steckplätze

4. **Kabelmanagement** (ca. 20 €)
   - Kabelbinder
   - Klettverschluss-Strips
   - Kabelführungen

### Aufbauanleitung

1. **Wandmontage**
   - Rack an stabiler Wand montieren
   - Traglast beachten (mind. 30kg)
   - Wasserwaage verwenden

2. **Fachböden einsetzen**
   - Oberer Boden (ca. 3-4 HE): FritzBox + USB-Platte
   - Mittlerer Boden (ca. 5-7 HE): ThinkCentre
   - Ausreichend Zwischenraum für Belüftung

3. **Switch montieren**
   - Direkt auf 19" Schienen oder auf Shelf
   - Im unteren Bereich (8 HE)

4. **Verkabelung**
   ```
   FritzBox → USB-Platte (USB)
   FritzBox → Switch (LAN)
   ThinkCentre → Switch (LAN)
   Alle Geräte → Steckdosenleiste → Wand
   ```

5. **Kabelmanagement**
   - Kabel bündeln und führen
   - An Rack-Rahmen befestigen
   - Beschriften für spätere Wartung

### Alternative: Budget-Lösung (IKEA + DIY)

**Materialliste (ca. 40 €)**

1. **IKEA HYLLIS** (ca. 15-20 €)
2. **Multiplexplatten-Reste** (ca. 10-15 €)
   - Als zusätzliche Ablagen/Verstärkung
3. **Kabelmanagement** (ca. 10 €)
4. **Gummifüße** (ca. 5 €)

**Aufbau:**
- HYLLIS zusammenbauen
- Optional: Multiplexplatten auf Ebenen legen (bessere Stabilität)
- Geräte von unten nach oben: Switch → ThinkCentre → FritzBox
- Kabel an Rahmen führen

## Zusammenfassung

| Kriterium | 9HE Rack | Holz-Eigenbau | Alu-Profile | IKEA-Hack |
|-----------|----------|---------------|-------------|-----------|
| Kosten | 250-300 € | 50-70 € | 100-200 € | 30-40 € |
| Zeitaufwand | 2h | 6h | 4h | 0.5h |
| Professionalität | ★★★★★ | ★★☆☆☆ | ★★★★☆ | ★★☆☆☆ |
| Erweiterbarkeit | ★★★★★ | ★★☆☆☆ | ★★★★★ | ★☆☆☆☆ |
| Belüftung | ★★★★☆ | ★★★☆☆ | ★★★★★ | ★★★☆☆ |
| Empfehlung | **Beste Wahl** | DIY-Fans | Modular-Fans | Budget |

## Nächste Schritte

1. **Budget festlegen**
2. **Platzbedarf im Technikraum messen**
3. **Gewünschte Erweiterungen überlegen** (z.B. NAS, weitere Server)
4. **Lösung wählen** basierend auf obiger Tabelle
5. **Materialbeschaffung**
6. **Aufbau und Installation**

## Zusätzliche Tipps

### Monitoring & Management
- **Proxmox Web-UI**: Zugriff über LAN
- **Home Assistant**: Dashboard für Monitoring
- **Optional**: Kleine Display/Tablet als Status-Monitor

### Backup-Strategie
- USB-Platte an FritzBox für Netzwerk-Backups
- Proxmox: Backup-Jobs einrichten
- 3-2-1 Regel: Mindestens eine Off-Site-Kopie

### Stromabsicherung
- **USV** (Unterbrechungsfreie Stromversorgung) erwägen
  - Kosten: 100-200 € für 600-800VA
  - Schützt vor Datenverlust bei Stromausfall
  - Proxmox kann automatisch herunterfahren

### Labelung
- Geräte beschriften
- Kabel markieren (Quelle → Ziel)
- Netzwerk-Ports dokumentieren

### Dokumentation
- Netzwerk-Diagramm erstellen
- IP-Adressen dokumentieren
- Zugangsdaten sicher speichern (z.B. KeePass)

## Ressourcen

### Online-Communities
- r/homelab (Reddit)
- r/selfhosted (Reddit)
- homelab.de (Forum)

### Shops für Rack-Zubehör
- reichelt.de
- digitec.ch / galaxus.ch (Schweiz)
- amazon.de
- pollin.de (günstig)

### Aluminium-Profile
- motedis.de
- item24.de
- dold-mechatronik.de

## Fazit

Für Ihr Setup mit ThinkCentre (Proxmox), FritzBox und Switch empfehle ich:

**Best Practice:** 9HE Wandrack mit Fachböden (ca. 280 €)
- Professionell, erweiterbar, gutes Kabelmanagement

**Budget-Option:** IKEA HYLLIS (ca. 30 €)
- Funktional, schnell, günstig

**DIY-Premium:** Alu-Profile (ca. 150 €)
- Modular, individuell, langlebig

Die Wahl hängt von Ihrem Budget, handwerklichen Fähigkeiten und Erweiterungsplänen ab. Für die meisten Home Labs ist ein kleines 9HE Wandrack die beste Investition.
