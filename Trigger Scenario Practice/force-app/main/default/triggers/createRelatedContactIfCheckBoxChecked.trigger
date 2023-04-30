// Trigger to create a related Contact of Account with same phone as Account’s phone 
// if custom checkbox field on Account is checked.
trigger createRelatedContactIfCheckBoxChecked on Account (after insert, after update) {
    
    if(Trigger.isAfter && Trigger.isInsert || Trigger.isUpdate){
        List<Id> createContactOnTheseAccount = new List<Id>();
        for(Account acc : Trigger.new){
            if(acc.Create_Related_Contact__c == true){
                createContactOnTheseAccount.add(acc.Id);
            }
        }

        List<Account> listOfAccount = [Select Id, Name, Phone from Account Where Id IN :createContactOnTheseAccount];
        List<Contact> createRelatedContact = new List<Contact>();
        for(Account acc : listOfAccount){
            Contact con = new Contact();
            con.Phone = acc.Phone;
            con.lastName = acc.Name;
            con.AccountId = acc.Id;
            createRelatedContact.add(con);
        }
        insert createRelatedContact;
    }

}