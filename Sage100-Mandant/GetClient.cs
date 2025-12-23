public static Sagede.OfficeLine.Engine.Mandant GetClient(string username, string password, string databaseName, short clientId)
{
    Sagede.OfficeLine.Engine.Session session = Sagede.OfficeLine.Engine.ApplicationEngine.CreateSession(databaseName, Sagede.OfficeLine.Shared.ApplicationToken.Abf, null, new Sagede.Core.Tools.NamePasswordCredential(username, password));
    return session.CreateMandant(clientId);
}