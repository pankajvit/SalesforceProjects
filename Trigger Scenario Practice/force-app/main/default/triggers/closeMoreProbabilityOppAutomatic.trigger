//Scenario 18 by SFDC Ninja -  Automatically close Opportunities with probability greater than 70% 
//when checkbox is checked on Account. (Accenture Interview Scenario)
trigger closeMoreProbabilityOppAutomatic on Account (after update) {
    Set<Id> accIds = new Set<Id>();
    for(Account acc : Trigger.new){
        if(acc.Close_the_Opportunities__c == true && Trigger.oldMap.get(acc.Id).Close_the_Opportunities__c == false){
            accIds.add(acc.Id);
        }
    }

    List<Opportunity> listOfOpp = [SELECT Id, AccountId, Name, StageName, Probability 
                                    FROM Opportunity 
                                    Where Probability > 70 
                                    AND StageName != 'Closed Won'
                                    AND AccountId IN : accIds];
    List<Opportunity> updateOpp = new List<Opportunity>();
    if(listOfOpp != null && listOfOpp.size() > 0){
        for(Opportunity opp : listOfOpp){
            opp.StageName = 'Closed Won';
            opp.CloseDate = date.today();
            updateOpp.add(opp);
        }
        update updateOpp;
    }
}