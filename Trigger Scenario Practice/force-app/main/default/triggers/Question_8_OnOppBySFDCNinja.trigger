// Trigger to find sum of all related Opportunities Amount of an Account.
trigger Question_8_OnOppBySFDCNinja on Opportunity (after insert, after update, after delete, after undelete) {
    Set<Id> accIds = new Set<Id>();
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUndelete)){
        for(Opportunity opp : Trigger.new){
            if(opp.AccountId != null){
                accIds.add(opp.AccountId);
            }
        }
    }

    if(Trigger.isAfter && Trigger.isUpdate){
        for(Opportunity opp : Trigger.new){
            if(opp.AccountId != null){
                if(opp.AccountId != Trigger.oldMap.get(opp.Id).AccountId){
                    accIds.add(opp.AccountId);
                    accIds.add(Trigger.oldMap.get(opp.Id).AccountId);
                }else {
                    accIds.add(opp.AccountId);
                }
            }
        }
    }

    if(Trigger.isAfter && Trigger.isDelete){
        for(Opportunity opp : Trigger.old){
            if(opp.AccountId != null){
                accIds.add(opp.AccountId);
            }
        }
    }

    List<AggregateResult> aggregateResultList = [Select AccountId, Sum(Amount) totAmt from Opportunity
                                                    Where AccountId IN :accIds
                                                    Group by AccountId];
    Map<Id, Decimal> accIdVsAmount = new Map<Id, Decimal>();

    for(AggregateResult aggr : aggregateResultList){
        accIdVsAmount.put((Id)aggr.get('AccountId'),(Decimal)aggr.get('totAmt'));
    }

    List<Account> accList = [Select Id, Name, Total_Opp_Amount__c from Account Where Id IN :accIds];
    List<Account> updateTheseAccount = new List<Account>();
    for(Account acc : accList){
        if(accIdVsAmount.containsKey(acc.Id)){
            acc.Total_Opp_Amount__c = accIdVsAmount.get(acc.Id);
            updateTheseAccount.add(acc);
        }
    }
    update updateTheseAccount;
}