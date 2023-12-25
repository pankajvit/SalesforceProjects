// Automatically close Opportunities with probability greater than 70% when checkbox is checked on Account. 
trigger Question_18_OnOppBySFDCNinja on Account (after insert, after update) {
    Set<Id> accIds = new Set<Id>();
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            for(Account acc : Trigger.new){
                if(acc.Close_the_Opportunities__c == True){
                    accIds.add(acc.Id);
                }
            }
        }
        else if(Trigger.isUpdate){
            for(Account acc : Trigger.new){
                if(acc.Close_the_Opportunities__c == True){
                    accIds.add(acc.Id);
                }
            }
        }
    }

    List<Opportunity> updateTheseOpportunity = new List<Opportunity>();
    List<Account> accList = [Select Id, Name, (Select Id, Probability, StageName, CloseDate 
                                                from Opportunities) 
                                from Account
                                Where Id IN :accIds];
    for(Account acc : accList){
        for(Opportunity opp : acc.Opportunities){
            if(opp.Probability > 70 && opp.StageName != 'Closed Won'){
                opp.StageName = 'Closed Won';
                opp.CloseDate = date.today();
                updateTheseOpportunity.add(opp);
            }
        }
    }
    update updateTheseOpportunity;
}