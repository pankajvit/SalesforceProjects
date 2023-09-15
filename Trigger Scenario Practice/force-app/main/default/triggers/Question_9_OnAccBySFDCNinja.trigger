// Question-9: Write a trigger on the Account when the Account is updated check all opportunities related to the account. Update all Opportunities stage to close lost if an opportunity created date is greater than 30 days from today and stage not equal to close won.
trigger Question_9_OnAccBySFDCNinja on Account (after update) {
    Set<Id> accIds = new Set<Id>();
    if(Trigger.isAfter && Trigger.isUpdate){
        for(Account acc : Trigger.new){
            accIds.add(acc.Id);
        }
    }

    List<Opportunity> oppList = [Select Id, AccountId, Test_Created_Date__c, StageName 
                                    from Opportunity 
                                    Where AccountId IN :accIds 
                                    AND Test_Created_Date__c < LAST_N_DAYS:30 
                                    AND StageName != 'Closed Won']; 
    List<Opportunity> updateTheseOpportunity = new List<Opportunity>();
    for(Opportunity opp : oppList){
        opp.StageName = 'Closed Lost';
        updateTheseOpportunity.add(opp);
    }
    update updateTheseOpportunity;
}