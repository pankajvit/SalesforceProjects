// Send Email to Contacts on Account type update
trigger Question_14_OnAccBySFDCNinja on Account (after update) {
    Set<Id> accIds = new Set<Id>();
    if (Trigger.isAfter && Trigger.isUpdate) {
        for (Account acc : Trigger.new) {
            if (acc.Type != null && acc.Type != Trigger.oldMap.get(acc.Id).Type) {
                accIds.add(acc.Id);
            }
        }
    }

    List<Contact> conList = [SELECT Id, AccountId, Email 
                             FROM Contact
                             WHERE AccountId IN :accIds];

    List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
    for (Contact con : conList) {
        if (con.Email != null) {
            // Create a new email message
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

            // Set the recipient address
            email.setToAddresses(new List<String>{con.Email});

            // Set the email subject and body
            email.setSubject('Hey, Account Type is updated');
            email.setHtmlBody('Hi Team, Account Type is updated');

            // Add the email message to the list
            emailMessages.add(email);
        }
    }

    // Send the email messages outside the loop
    try {
        Messaging.sendEmail(emailMessages);
        System.debug('Emails sent successfully!');
    } catch (Exception e) {
        System.debug('Error sending emails: ' + e.getMessage());
    }
}
