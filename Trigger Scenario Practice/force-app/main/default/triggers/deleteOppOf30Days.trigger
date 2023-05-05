trigger deleteOppOf30Days on Account (after update) {
    Set<Id> accIds = new Set<Id>();
    if(Trigger.isAfter && Trigger.isUpdate){
        for(Account acc : Trigger.new){
            accIds.add(acc.Id);
        }

        List<Opportunity> oppList = [SELECT Id, AccountId, Name, StageName, CreatedDate FROM Opportunity Where AccountId IN :accIds AND CreatedDate < LAST_N_DAYS:30 AND StageName != 'Closed Won'];

        List<Opportunity> listOfOpportunityToUpdate = new List<Opportunity>();
        for(Opportunity opp : oppList){
            opp.StageName = 'Closed Lost';
            listOfOpportunityToUpdate.add(opp);
        }
        update listOfOpportunityToUpdate;
    }
}
