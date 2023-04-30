// Trigger to prevent duplication of account record 
// based on name whenever a record is inserted or updated.
trigger preventDuplicateAccountRecordByName on Account (before insert, before update) {
    if(Trigger.isBefore && Trigger.isInsert || Trigger.isUpdate){
        List<String> accNames = new List<String>();
        for(Account acc : Trigger.new){
            if(acc.Name != null){
                accNames.add(acc.Name);
            }
        }

        List<Account> accList = [Select Id, Name from Account Where Name IN :accNames];
        Map<String, Account> accNameVsRecord = new Map<String, Account>();
        for(Account acc : accList){
            accNameVsRecord.put(acc.Name, acc);
        }
        for(Account acc : Trigger.new){
            if(accNameVsRecord.containsKey(acc.Name)){
                acc.addError('Your inserted account is duplicate. Already data exist');
            }
        }
    }
}