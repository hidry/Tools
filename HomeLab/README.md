# HomeLab Projekt

Dokumentation und Konfiguration für das persönliche Home Lab Setup.

## Übersicht

Dieses Projekt dokumentiert den Aufbau und die Verwaltung eines Home Labs bestehend aus:

- **ThinkCentre** mit Proxmox
  - Home Assistant VM
  - Windows VM
- **FritzBox** mit USB-Festplatte
- **Netzwerk-Switch**

## Struktur

```
HomeLab/
├── README.md           # Diese Datei
├── docs/              # Dokumentation
│   ├── server-rack-setup.md    # Rack-Setup Anleitung
│   └── setup-log.md            # Setup-Verlauf und Entscheidungen
├── config/            # Konfigurationsdateien
│   └── network-diagram.md      # Netzwerk-Topologie
└── scripts/           # Automatisierungs-Skripte
```

## Hardware-Setup

### ThinkCentre (Proxmox Host)
- **Betriebssystem**: Proxmox VE
- **VMs**:
  - Home Assistant
  - Windows
- **Standort**: Technikraum

### Netzwerk
- **Router**: FritzBox mit USB-Platte
- **Switch**: [Modell eintragen]
- **Verkabelung**: [Details eintragen]

### Storage
- USB-Festplatte an FritzBox (Netzwerk-Backups)

## Dokumentation

- [Server Rack Setup Guide](docs/server-rack-setup.md) - Detaillierte Anleitung zur physischen Organisation
- [Setup Log](docs/setup-log.md) - Chronologischer Verlauf der Einrichtung
- [Netzwerk-Diagramm](config/network-diagram.md) - Topologie und IP-Adressen

## Nächste Schritte

- [ ] Rack-Lösung auswählen und beschaffen
- [ ] Hardware im Rack montieren
- [ ] Verkabelung optimieren
- [ ] Monitoring einrichten
- [ ] Backup-Strategie implementieren
- [ ] USV evaluieren und ggf. beschaffen
- [ ] Dokumentation vervollständigen

## Ressourcen

- [r/homelab](https://reddit.com/r/homelab) - Reddit Community
- [r/selfhosted](https://reddit.com/r/selfhosted) - Self-Hosting Community
- [Proxmox Dokumentation](https://pve.proxmox.com/wiki/Main_Page)
- [Home Assistant Dokumentation](https://www.home-assistant.io/docs/)

## Wartung

- **Reinigung**: Alle 3-6 Monate Staub entfernen
- **Backups**: [Backup-Schedule eintragen]
- **Updates**: [Update-Strategie eintragen]
