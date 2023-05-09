trigger showLatestCaseNumberOnAccount on Case (after insert, after update) {
    Set<Id> accIds = new Set<Id>();
    if(Trigger.isAfter && Trigger.isInsert){
        for(Case c : Trigger.new){
            if(c.AccountId != null){
                accIds.add(c.AccountId);
            }
        }
    }
    
    List<Case> caseList = [SELECT Id, AccountId, CaseNumber, CreatedDate 
                                FROM Case 
                                Where AccountId IN :accIds
                                Order By CreatedDate DESC NULLS LAST
                                Limit 1];
    Map<Id, Integer> accIdAndLatestCaseNumber = new Map<Id, Integer>();
    for(Case c : caseList){
        accIdAndLatestCaseNumber.put((Id)c.AccountId, Integer.valueOf(c.CaseNumber));
    }

    List<Account> accList= [Select Id, Latest_Case_Number__c from Account Where Id IN :accIds];
    List<Account> updateTheseAccounts = new List<Account>();
    for(Account acc : accList){
        if(accIdAndLatestCaseNumber.containsKey(acc.Id)){
            acc.Latest_Case_Number__c = String.valueOf(accIdAndLatestCaseNumber.get(acc.Id));
            updateTheseAccounts.add(acc);
        } 
    }
    update updateTheseAccounts;
}