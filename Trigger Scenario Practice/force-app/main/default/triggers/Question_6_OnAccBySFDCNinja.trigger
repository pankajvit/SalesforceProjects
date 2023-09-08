// Trigger to prevent duplication of account record based on name whenever a record is inserted or updated
trigger Question_6_OnAccBySFDCNinja on Account (before insert, before update, After undelete) {
    List<String> nameList = new List<String>();
    if((Trigger.isBefore || Trigger.isAfter) && (Trigger.isInsert || Trigger.isUpdate)){
        for(Account acc : Trigger.new){
            nameList.add(acc.name);
        }
    }else if(Trigger.isBefore && Trigger.isUpdate){
        for(Account acc : Trigger.new){
            if(acc.Name != Trigger.oldMap.get(acc.Id).Name){
                nameList.add(acc.Name);
            }
        }
    }

    List<Account> accList = [Select Id, Name from Account where Name IN :nameList];

    Map<String, Account> nameVsRecords = new Map<String, Account>();

    for(Account acc : accList) {
        nameVsRecords.put(acc.Name, acc);
    }

    for(Account acc : Trigger.new){
        if(nameVsRecords.containsKey(acc.Name)){
            acc.addError('Account Name already exists');
        }
    }
}