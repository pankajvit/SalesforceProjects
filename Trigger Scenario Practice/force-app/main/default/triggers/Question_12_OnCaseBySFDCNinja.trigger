// Question - 12 by SFDCNinja - When a case is inserted on any Account, Put the latest Case Number on the Account 
// in Latest Case Inserted field.
trigger Question_12_OnCaseBySFDCNinja on Case (after insert) {
    Set<Id> accIds = new Set<Id>();
    if(Trigger.isAfter && Trigger.isInsert){
        for(Case c : Trigger.new){
            if(c.AccountId != null){
                accIds.add(c.AccountId);
            }
        }
    }

    List<Account> accList = [Select Id, Name, Latest_Case_Number__c,
                                (SELECT Id, CaseNumber, CreatedDate 
                                    FROM Cases 
                                    WHERE AccountId!=null 
                                    ORDER BY CreatedDate DESC
                                    LIMIT 1)
                                from Account
                                Where Id IN :accIds];
    List<Account> updateTheseAccounts = new List<Account>();

    for(Account acc : accList){
        acc.Latest_Case_Number__c = acc.Cases[0].CaseNumber;
        updateTheseAccounts.add(acc);
    }
    update updateTheseAccounts;
}