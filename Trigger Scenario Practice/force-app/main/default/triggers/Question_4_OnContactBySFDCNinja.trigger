// Whenever a Contact’s description is updated 
// then its Parent Account’s description should also get updated by it
trigger Question_4_OnContactBySFDCNinja on Contact (after update) {
    Set<Id> accIds = new Set<Id>();
    List<Account> accList = new List<Account>();
    if(Trigger.isAfter && Trigger.isUpdate){
        for(Contact con : Trigger.new){
            if(con.Description != Trigger.oldMap.get(con.Id).Description){
                Account acc = new Account();
                acc.Id = con.AccountId;
                acc.Description = con.Description;
                accList.add(acc);
            }
        }
        update accList;
    }
}