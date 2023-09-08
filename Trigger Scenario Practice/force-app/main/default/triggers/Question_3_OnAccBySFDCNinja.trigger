// Whenever Account’s Phone field is updated 
// then all related Contact’s phone field should also get updated with Parent Account’s Phone
trigger Question_3_OnAccBySFDCNinja on Account (after update) {
    List<Id> accIds = new List<Id>();
    if(Trigger.isAfter && Trigger.isUpdate){
        for(Account acc : Trigger.new){
            if(acc.Phone != Trigger.oldMap.get(acc.Id).Phone){
                accIds.add(acc.Id);
            }
        }
    }

    List<Contact> contactList = [Select Id, AccountId, Phone, Account.Phone from Contact Where AccountId IN :accIds];
    List<Contact> updateContactList = new List<Contact>();
    for(Contact con : contactList){
        con.Phone = con.Account.Phone;
        updateContactList.add(con);
    }
    update updateContactList;
}