trigger lookupWithContactOnAccount on Account (after insert) {
    List<Contact> conList = new List<Contact>();
    List<Id> accIds = new List<Id>();
    if(Trigger.isAfter && Trigger.isInsert){
        for(Account acc : Trigger.new){
            accIds.add(acc.Id); 
            //acc.Client_Contact__c = con.Id;
        }
    }

    List<Account> accList = [Select Id, Name from Account Where Id IN :accIds];
    List<Account> updateTheseAccount = new List<Account>();
    for(Account acc : accList){
        Contact con = new Contact();
        con.lastName = acc.name;
        con.AccountId = acc.Id;
        insert con;
        acc.Client_Contact__c = con.Id;
        updateTheseAccount.add(acc);
    }
    update updateTheseAccount;   
}