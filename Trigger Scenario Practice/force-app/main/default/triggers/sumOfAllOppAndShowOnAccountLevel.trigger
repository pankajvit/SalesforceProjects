//Asked by Yogesh - When any Opportunity is created with amount populated or Opportunity
//Amount is updated then populate total Amount on Account Level for all
//related opportunities in Annual Revenue Field. If opportunity is deleted or
//undeleted then update Amount on Account as well. (Hint: rollup summary)
trigger sumOfAllOppAndShowOnAccountLevel on Opportunity (after insert, after update, after delete, after undelete) {
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
            if(opp.AccountId != null && 
                opp.AccountId != Trigger.oldMap.get(opp.Id).AccountId || 
                opp.Amount != Trigger.oldMap.get(opp.Id).Amount){
                    accIds.add(opp.AccountId);
                    accIds.add(Trigger.oldMap.get(opp.Id).AccountId);
            }
        }
    }

    if(Trigger.isAfter && Trigger.isdelete){
        for(Opportunity opp : Trigger.old){
            if(opp.AccountId != null){
                accIds.add(opp.AccountId);
            }
        }
    }

    List<AggregateResult>  allOppWithAggregation= [Select AccountId accId, Sum(Amount) totalAmount 
                                                from Opportunity 
                                                Where AccountId IN :accIds
                                                GROUP BY AccountId];
    Map<Id, Decimal> accIdAndItsOppSum = new Map<Id, Decimal>(); 
    for(AggregateResult agr : allOppWithAggregation){
        accIdAndItsOppSum.put((Id)agr.get('accId'), (Decimal)agr.get('totalAmount'));
    }

    List<Account> accList = [SELECT Id, Name, Total_Opp_Amount__c FROM Account Where Id IN :accIds];
    List<Account> listOfAccountToUpdate = new List<Account>();
    for(Account acc : accList){
        if(accIdAndItsOppSum.containsKey(acc.Id)){
            acc.Total_Opp_Amount__c = accIdAndItsOppSum.get(acc.Id);
            listOfAccountToUpdate.add(acc);
        }
    }
    update listOfAccountToUpdate;
}