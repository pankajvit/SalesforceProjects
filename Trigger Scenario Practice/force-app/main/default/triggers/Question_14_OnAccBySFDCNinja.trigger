// Send Email to Contacts on Account type update
trigger Question_14_OnAccBySFDCNinja on Account (after update) {
    Set<Id> accIds = new Set<Id>();
    if(Trigger.isAfter && Trigger.isUpdate){
        for(Account acc : Trigger.new){
            if(acc.Type !=null && acc.Type != Trigger.oldMap.get(acc.Id).Type){
                accIds.add(acc.Id);
            }    
        }
    }

    List<Contact> conList = [Select Id, AccountId, Email 
                                from Contact
                                Where AccountId IN :accIds];
    
}