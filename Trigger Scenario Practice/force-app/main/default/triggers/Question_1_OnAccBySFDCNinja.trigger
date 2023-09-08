//While inserting an account 
//if a user left the phone field empty then an error should come 
//stating “You cannot left the phone field empty”
trigger Question_1_OnAccBySFDCNinja on Account (before insert, before update) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        for(Account acc : Trigger.new){
            if(String.isBlank(acc.Phone)){
                acc.addError('you can not leave phone field empty');
            }
        }
    }
}