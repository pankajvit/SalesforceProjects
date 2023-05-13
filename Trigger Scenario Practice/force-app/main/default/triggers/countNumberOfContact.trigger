//Scenario - Trigger to count number of contacts associated with an account 
//and display the contacts count on Account’s custom field by SFDC Ninja
trigger countNumberOfContact on Contact (after insert, after update, after delete, after undelete) {
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isundelete)){
        List<Id> listOfAccountId = new List<Id>();
        for(Contact con : Trigger.new){
            if(con.AccountId != null){
                listOfAccountId.add(con.AccountId);
            }
        }

        //List<Contact> conList = [Select Id, lastName from Contact Where AccountId IN :listOfAccountId];
        List<Account> accountList = [Select Id, Number_of_Contacts__c,(Select Id from Contacts) 
                                        from Account 
                                        Where Id IN :listOfAccountId];
        List<Account> accountToUpdate = new List<Account>();

        for(Account acc : accountList){
            acc.Number_of_Contacts__c = acc.Contacts.size();
            accountToUpdate.add(acc);
        }

        update accountToUpdate;
    }

    if(Trigger.isAfter && Trigger.isDelete){
        List<Id> listOfAccountId = new List<Id>();
        for(Contact con : Trigger.old){
            if(con.AccountId != null){
                listOfAccountId.add(con.AccountId);
            }
        }

        List<Contact> conList = [Select Id, lastName from Contact Where AccountId IN :listOfAccountId];
        List<Account> accountList = [Select Id, Number_of_Contacts__c from Account Where Id IN :listOfAccountId];
        List<Account> accountToUpdate = new List<Account>();

        for(Account acc : accountList){
            acc.Number_of_Contacts__c = conList.size();
            accountToUpdate.add(acc);
        }

        update accountToUpdate;
    }

    if(Trigger.isAfter && Trigger.isUpdate){ 
        List<Id> listOfAccountId = new List<Id>();
        for(Contact con : Trigger.new){
            if(con.AccountId != null && con.AccountId != Trigger.oldMap.get(con.Id).AccountId){
                listOfAccountId.add(con.AccountId);
                listOfAccountId.add(Trigger.oldMap.get(con.Id).AccountId);
            }
        }

        //List<Contact> conList = [Select Id, lastName from Contact Where AccountId IN :listOfAccountId];
        List<Account> accountList = [Select Id, Number_of_Contacts__c,(Select Id from Contacts) from Account Where Id IN :listOfAccountId];
        List<Account> accountToUpdate = new List<Account>();

        for(Account acc : accountList){
            acc.Number_of_Contacts__c = acc.Contacts.size();
            accountToUpdate.add(acc);
        }

        update accountToUpdate;
    }
}