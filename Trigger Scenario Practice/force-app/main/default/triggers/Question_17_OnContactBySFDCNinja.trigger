// Enforce single Primary Contact on account.(Deloitte Interview Scenario)
trigger Question_17_OnContactBySFDCNinja on Contact (before insert, before update, after undelete) {
    Set<Id> accountIds = new Set<Id>();
    if(Trigger.isInsert){
        if(Trigger.isInsert){
            for(Contact con : Trigger.new){
                if(con.AccountId != null){
                    accountIds.add(con.AccountId);
                }
            }
        }else if(Trigger.isUpdate){
            for(Contact con : Trigger.new){
                if(con.AccountId != null && con.AccountId != Trigger.oldMap.get(con.Id).AccountId){
                    accountIds.add(con.AccountId);
                }
            } 
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isUndelete){
            for(Contact con : Trigger.new){
                if(con.AccountId != null){
                    accountIds.add(con.AccountId);
                }
            }
        }
    }

    // List<AggregateResult> aggregateResults = new List<AggregateResult>();
    // aggregateResults = [Select AccountId, Count(Primary_Contact__c) totalPrimaryContact
    //                         from Contact
    //                         Where Primary_Contact__c=true
    //                         AND AccountId IN :accountIds
    //                         GROUP BY AccountId];
    Map<Id, Integer> accountIdAndNumberofPrimaryContact = new Map<Id, Integer>();
    List<Account> accountList = [Select Id, Name, 
                                    (Select Id, Primary_Contact__c from Contacts 
                                    Where Primary_Contact__c=true)
                                    from Account
                                    Where Id IN :accountIds]; 
    for(Account acc : accountList){
        accountIdAndNumberofPrimaryContact.put(acc.Id, acc.Contacts.size());
    }

    for(Contact con : Trigger.new){
        if(accountIdAndNumberofPrimaryContact.containsKey(con.AccountId)){
            if(accountIdAndNumberofPrimaryContact.get(con.AccountId) >= 1){
                con.addError('you can not have more than one primary contact');
            }
        }
    }
}