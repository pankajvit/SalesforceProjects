trigger updateAccountNameAccordingToUpdateOpp on Opportunity (after insert, after update) {
    Set<Id> oppId = new Set<Id>();
    if(Trigger.isAfter && Trigger.isInsert){
        for(Opportunity opp : Trigger.new){
            if(opp.Name != null){
                oppId.add(opp.Id);
            }
        }
    }

    else if(Trigger.isAfter && Trigger.isUpdate){
        for(Opportunity opp : Trigger.new){
            if(opp.Name != null && opp.Name != Trigger.oldMap.get(opp.Id).Name){
                oppId.add(opp.Id);
            }
        }
    }


    List<Opportunity> oppList =  [SELECT Id, AccountId, Name, Account.Name FROM Opportunity Where Id IN :oppId];

    List<Account> accList = new List<Account>();

    for(Opportunity opp : oppList){
        Account acc = new Account();
        acc.Id = opp.AccountId;
        acc.Name = opp.Name;
        accList.add(acc);
    }
    update accList;
}