public class UpdateContactsWithoutPhoneNumber implements Database.Batchable<sObject>, Database.AllowsCallouts {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Query contacts without phone numbers
        String query = 'SELECT Id, Phone FROM Contact WHERE Phone = null OR Phone = \'\'';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Contact> scope) {
        // Static phone number to update contacts without a phone number
        String staticPhoneNumber = '6200753817';

        // Update contacts with the static phone number
        for (Contact con : scope) {
            con.Phone = staticPhoneNumber;
        }

        // Save the changes
        update scope;
    }

    public void finish(Database.BatchableContext BC) {
        // Send email notification
        sendEmailNotification();
    }

    private void sendEmailNotification() {
        // Email details
        String recipientEmail = 'pankajvitmca@gmail.com';
        String emailSubject = 'Batch Job Completed';
        String emailBody = 'The batch job of updating contacts Phone no. is completed!!';

        // Create a new email message
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[]{recipientEmail});
        mail.setSubject(emailSubject);
        mail.setPlainTextBody(emailBody);

        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }
}