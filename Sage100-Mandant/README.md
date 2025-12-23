# Sage100-Mandant

C#-Code-Snippet zur Erstellung eines Sage 100 Mandantenobjekts mit Session-Authentifizierung.

## Inhalt

Die Datei `GetClient.cs` enthält eine Methode zur Erstellung eines Sage 100 Mandantenobjekts:

```csharp
public static Sagede.OfficeLine.Engine.Mandant GetClient(
    string username,
    string password,
    string databaseName,
    short clientId)
```

## Beschreibung

Die Methode erstellt eine Session mit der Sage OfficeLine Engine und gibt ein Mandantenobjekt zurück.

### Parameter

- `username`: Benutzername für die Authentifizierung
- `password`: Passwort für die Authentifizierung
- `databaseName`: Name der Datenbank
- `clientId`: ID des Mandanten

### Rückgabewert

Ein `Sagede.OfficeLine.Engine.Mandant` Objekt.
