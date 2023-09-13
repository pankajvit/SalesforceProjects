// Prevent a user from deleting an Active account.
trigger Question_10_OnAccBySFDCNinja on Account (before delete) {
    if(Trigger.isBefore && Trigger.isDelete){
        for(Account acc : Trigger.old){
            if(acc.Active__c == 'Yes'){
                acc.addError('you can not delete any active account');
            }
        }
    }
}