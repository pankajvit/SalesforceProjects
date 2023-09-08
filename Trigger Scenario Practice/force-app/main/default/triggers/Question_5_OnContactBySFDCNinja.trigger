// Trigger to count number of contacts associated with an account 
// and display the contacts count on Account’s custom field
trigger Question_5_OnContactBySFDCNinja on Contact (after insert, after update, after delete, after undelete) {
    Set<Id> accIds = new Set<Id>();
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUndelete)) {
        for(Contact con : Trigger.new){
            if(con.AccountId != null){
                accIds.add(con.AccountId);
            }
        }
    }else if(Trigger.isAfter && Trigger.isUpdate){
        for(Contact con : Trigger.new){
            if(con.AccountId != null && con.AccountId != Trigger.oldMap.get(con.Id).AccountId){
                accIds.add(con.AccountId);
                accIds.add(Trigger.oldMap.get(con.Id).AccountId);
            }
        }
    }else if(Trigger.isAfter && Trigger.isDelete){
        for(Contact con : Trigger.old){
            if(con.AccountId != null){
                accIds.add(con.AccountId);
            }
        }   
    }
    
    AggregateResult[] groupedResults = [Select AccountId, count(Id) totalContact from Contact 
                                            where AccountId IN :accIds
                                            GROUP BY AccountId];
    Map<Id, Integer> accIdVsCount = new Map<Id, Integer>();

    for(AggregateResult aggr : groupedResults){
        accIdVsCount.put((Id)aggr.get('AccountId'),(Integer)aggr.get('totalContact'));
    }
    
    List<Account> accList = [Select Id, Number_of_Contacts__c from Account 
                                where Id IN :accIds];
    List<Account> updateTheseAccount = new List<Account>();
    for(Account acc : accList) {
        if(accIdVsCount.containsKey(acc.Id)){
            acc.Number_of_Contacts__c = accIdVsCount.get(acc.Id);
            updateTheseAccount.add(acc);
        }
    }
    update updateTheseAccount;
}