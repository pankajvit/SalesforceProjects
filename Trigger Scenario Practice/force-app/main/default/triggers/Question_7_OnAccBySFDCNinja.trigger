// Trigger to create a related Contact of Account with same phone as Account’s phone 
// if custom checkbox field on Account is checked
trigger Question_7_OnAccBySFDCNinja on Account (after insert, after update) {
    Set<Id> accIds = new Set<Id>();
    if(Trigger.isAfter && Trigger.isInsert){
        for(Account acc : Trigger.new){
            if(acc.Create_Related_Contact__c == True){
                    accIds.add(acc.Id);
            }
        }
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        for(Account acc : Trigger.new){
            if(acc.Create_Related_Contact__c == True 
                && Trigger.oldMap.get(acc.Id).Create_Related_Contact__c != True){
                    accIds.add(acc.Id);
            }
        }
    }

    List<Account> accList = [Select Id, Name, Phone from Account Where Id =: accIds];
    List<Contact> conList = new List<Contact>();
    for(Account acc : accList){
        Contact con = new Contact();
        con.Phone = acc.Phone;
        con.lastName = acc.Name;
        con.AccountId = acc.Id;
        conList.add(con);
    }
    insert conList;
}