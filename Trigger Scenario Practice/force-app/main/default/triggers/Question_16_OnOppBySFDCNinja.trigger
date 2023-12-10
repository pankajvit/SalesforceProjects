// Update the parent Account field with the opportunity name that has the highest amount.(TCS Interview Scenario).
trigger Question_16_OnOppBySFDCNinja on Opportunity (after insert, after update, after delete, after undelete) {
    Set<Id> accountIds = new Set<Id>();
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUndelete){
            for(Opportunity opp : Trigger.new){
                if(opp.AccountId != null && opp.Amount != null){
                    accountIds.add(opp.AccountId);
                }
            }
        }
        if(Trigger.isUpdate){
            for(Opportunity opp : Trigger.new){
                if(opp.AccountId != null && opp.Amount != null){
                    if(Opp.AccountId != Trigger.oldMap.get(opp.Id).AccountId){
                        accountIds.add(opp.AccountId);
                        accountIds.add(Trigger.oldMap.get(opp.Id).AccountId);
                    }else{
                        accountIds.add(opp.AccountId);
                    }
                }
            }
        }
        else if(Trigger.isDelete){
            for(Opportunity opp : Trigger.old){
                if(opp.AccountId != null){
                    accountIds.add(opp.AccountId);
                }
            }
        }
    }

    // List<AggregateResult> aggregateResultList = [Select AccountId, Max(Amount) 
    //                                                 from Opportunity
    //                                                 Where AccountId IN :Account
    //                                                 GROUP BY AccountId];
    Map<Id, Decimal> AccountIdAndHighestAmt = new Map<Id, Decimal>();
    Map<Id, String> accountIdAndHighestAmtOpportunityName = new Map<Id, String>();
    List<Opportunity> OpportunityList = [Select Name, Amount, AccountId
                                            from Opportunity
                                            Where AccountId IN :accountIds];
    for(Opportunity opp : OpportunityList){
        if(AccountIdAndHighestAmt.containsKey(opp.AccountId)){
            if(opp.Amount >= AccountIdAndHighestAmt.get(opp.AccountId)){
                accountIdAndHighestAmtOpportunityName.put(opp.AccountId, opp.Name);
                AccountIdAndHighestAmt.put(opp.AccountId, opp.Amount);
            }
        }else{
            AccountIdAndHighestAmt.put(opp.AccountId, opp.Amount);
            accountIdAndHighestAmtOpportunityName.put(opp.AccountId, opp.Name);
        }
        /*
        if(opp.Amount > amount){
            amount = opp.Amount;
            if(accountIdAndHighestAmtOpportunityName.containsKey(opp.AccountId)){
                accountIdAndHighestAmtOpportunityName.put(opp.AccountId, opp.Name);
            }else{
                accountIdAndHighestAmtOpportunityName.put(opp.AccountId, opp.Name);
            }
        }*/
    }
    List<Account> accountList = [Select Id, Highest_Amount_Opportunity_Name__c
                                    from Account
                                    Where Id IN :accountIds];
    List<Account> accountListToBeUpdated = new List<Account>();

    for(Account account : accountList){
        if(accountIdAndHighestAmtOpportunityName.containsKey(account.Id)){
            account.Highest_Amount_Opportunity_Name__c = accountIdAndHighestAmtOpportunityName.get(account.Id);
            accountListToBeUpdated.add(account);
        }
    }
    update accountListToBeUpdated;
}