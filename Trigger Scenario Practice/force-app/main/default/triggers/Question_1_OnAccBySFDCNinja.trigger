trigger Question_1_OnAccBySFDCNinja on Account (before insert, before update) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        for(Account acc : Trigger.new){
            if(String.isBlank(acc.Phone)){
                acc.addError('you can not leave phone field empty');
            }
        }
    }
}