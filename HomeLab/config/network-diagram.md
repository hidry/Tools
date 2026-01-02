# Netzwerk-Diagramm

## Physische Topologie

```
Internet
   │
   │
[FritzBox] ─── USB-Festplatte
   │
   │ (LAN)
   │
[Switch]
   │
   ├─── [ThinkCentre (Proxmox)]
   │         ├─ Home Assistant VM
   │         └─ Windows VM
   │
   └─── [weitere Geräte...]
```

## IP-Adressen

| Gerät | IP-Adresse | MAC-Adresse | Notizen |
|-------|------------|-------------|---------|
| FritzBox | [IP eintragen] | [MAC] | Router/DHCP |
| Switch | - | [MAC] | Unmanaged / [IP bei managed] |
| ThinkCentre (Proxmox) | [IP eintragen] | [MAC] | Static IP empfohlen |
| Home Assistant VM | [IP eintragen] | [MAC] | Static IP empfohlen |
| Windows VM | [IP eintragen] | [MAC] | - |

## VLAN-Struktur

_Falls VLANs genutzt werden:_

| VLAN ID | Name | Zweck | Netz |
|---------|------|-------|------|
| 1 | Default | Management | - |
| - | - | - | - |

## Port-Zuordnung Switch

_Falls managed Switch:_

| Port | Gerät | VLAN | PoE | Notizen |
|------|-------|------|-----|---------|
| 1 | FritzBox Uplink | - | - | - |
| 2 | ThinkCentre | - | - | - |
| 3 | - | - | - | - |

## Dienste und Ports

| Dienst | Host | Port | Protokoll | Zugriff |
|--------|------|------|-----------|---------|
| Proxmox Web UI | ThinkCentre | 8006 | HTTPS | LAN |
| Home Assistant | HA VM | 8123 | HTTP/HTTPS | LAN / extern? |
| SSH Proxmox | ThinkCentre | 22 | SSH | LAN |
| RDP Windows VM | Windows VM | 3389 | RDP | LAN |

## Firewall-Regeln

_FritzBox Portfreigaben / Proxmox Firewall:_

| Quelle | Ziel | Port | Protokoll | Zweck |
|--------|------|------|-----------|-------|
| - | - | - | - | - |

## DNS-Einträge

_Lokale DNS-Namen (FritzBox / Pi-hole):_

| Hostname | IP | Gerät |
|----------|-----|-------|
| proxmox.local | [IP] | ThinkCentre |
| homeassistant.local | [IP] | HA VM |
| - | - | - |

## Backup-Strategie

**Netzwerk-Backups:**
- Quelle: Proxmox VMs
- Ziel: USB-Festplatte an FritzBox (via SMB/NFS)
- Frequenz: [Täglich/Wöchentlich]
- Retention: [Anzahl Backups]

**Proxmox Backup-Jobs:**
- [Backup-Schedule definieren]

## Notizen

- Alle VMs sollten statische IPs oder DHCP-Reservierungen haben
- Proxmox Web UI über https://[IP]:8006
- SSH-Zugriff für Wartung dokumentieren
- Backup-Zugangsdaten sicher aufbewahren (KeePass)

---

**Letzte Aktualisierung**: 2026-01-02
**Zu aktualisieren bei**: Hardware-Änderungen, neuen VMs, Netzwerk-Änderungen
