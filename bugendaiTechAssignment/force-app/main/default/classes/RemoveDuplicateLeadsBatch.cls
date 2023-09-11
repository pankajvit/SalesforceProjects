public class RemoveDuplicateLeadsBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'SELECT Id, Email, Phone FROM Lead';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext context, List<Lead> scope) {
        Map<String, Lead> uniqueLeadsByEmail = new Map<String, Lead>();
        Map<String, Lead> uniqueLeadsByPhone = new Map<String, Lead>();

        for (Lead lead : scope) {
            if (lead.Email != null && !uniqueLeadsByEmail.containsKey(lead.Email)) {
                uniqueLeadsByEmail.put(lead.Email, lead);
            } else if (lead.Email != null) {
                Database.delete(lead);
            }

            if (lead.Phone != null && !uniqueLeadsByPhone.containsKey(lead.Phone)) {
                uniqueLeadsByPhone.put(lead.Phone, lead);
            } else if (lead.Phone != null) {
                Database.delete(lead);
            }
        }
    }

    public void finish(Database.BatchableContext context) {
        // Optional: Add any finishing operations here
    }
}