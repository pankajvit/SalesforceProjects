// Update the parent Account field with the opportunity name that has the highest amount.(TCS Interview Scenario)
trigger updateParentWithHighestAmountOppName on opportunity (after insert, after update, after delete, after undelete) {
    Set<Id> accIds = new Set<Id>();
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUndelete)){
        for(opportunity opp : Trigger.new){
            if(opp.AccountId != null){
                accIds.add(opp.AccountId);
            }
        }
    }

    List<Account> accList = [Select Id, Name, Highest_Amount_Opportunity_Name__c, 
                                (Select AccountId, Amount, Name from opportunities ORDER BY Amount DESC NULLS LAST LIMIT 1) 
                                from Account
                                Where Id IN :accIds];
    List<Account> updateAccount = new List<Account>();
    for(Account acc : accList){
        for(opportunity opp : acc.opportunities){
            acc.Highest_Amount_Opportunity_Name__c = opp.Name;
            updateAccount.add(acc);
        }
    }
    update updateAccount;
}