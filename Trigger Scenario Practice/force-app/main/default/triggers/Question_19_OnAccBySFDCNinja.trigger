// Automatically create related Contact on insertion of Account 
// and update Client Contact lookup field.
trigger Question_19_OnAccBySFDCNinja on Account (after insert) {
    List<Contact> conList = new List<Contact>();
    Map<Id, Id> accountIdVsRelatedContactId = new Map<Id, Id>();
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            for(Account acc : Trigger.new){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.LastName = acc.Name;
                conList.add(con);
            }
        }
    }
    insert conList;

    List<Account> accountListToUpdate = new List<Account>();
    for(Contact con : conList){
        accountIdVsRelatedContactId.put(con.AccountId, con.Id);
    }

    List<Account> accList = [Select Id, Client_Contact__c 
                                from Account
                                Where Id IN :accountIdVsRelatedContactId.keySet()];
    for(Account acc : accList){
        if(accountIdVsRelatedContactId.containsKey(acc.Id) && acc.Client_Contact__c == null){
            acc.Client_Contact__c = accountIdVsRelatedContactId.get(acc.Id);
            accountListToUpdate.add(acc);
        }
    }
    update accountListToUpdate;
}