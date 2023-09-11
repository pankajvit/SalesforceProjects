public class UpdateContactTitleBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'SELECT Id, Title FROM Contact WHERE Title = null';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext context, List<Contact> scope) {
        for (Contact con : scope) {
            con.Title = 'CEO';
        }
        update scope;
    }

    public void finish(Database.BatchableContext context) {
        // Optional: Add any finishing operations here
    }
}