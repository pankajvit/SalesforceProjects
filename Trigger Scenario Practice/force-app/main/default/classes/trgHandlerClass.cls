public with sharing class trgHandlerClass {
    public static void trgMethod(List<Account> accList){
        Set<Id> accIds = new Set<Id>();
        List<Contact> conList = new List<Contact>();
        Map<Id, Account> accmap = new Map<Id, Account>();
        List<Account> listToUpdate = new List<Account>();
        if(!accList.isEmpty()){
            for(Account acc : accList){
                Contact conObj = new Contact();
                conObj.LastName = 'Test Con '+acc.name;
                conObj.AccountId = acc.Id;
                conList.add(conObj);
                accIds.add(acc.Id);
            }
            if(!conList.isEmpty()){
                insert conList;
            }
        }

        if(!accIds.isEmpty()){
            List<Account> acctList = [Select Id, Client_Contact__c from Account where Id IN :accIds];  
            if(!acctList.isEmpty()){
                for(Account accObj : acctList){
                    accmap.put(accObj.Id, accObj);
                }                               
            }  

            if(!conList.isEmpty()){
                for(Contact con : conList){
                    if(accmap.containsKey(con.AccountId)){
                        Account ac = accmap.get(con.AccountId);
                        ac.Client_Contact__c = con.Id;
                        listToUpdate.add(ac);
                    }
                }
            }

            if(!listToUpdate.isEmpty()){
                update listToUpdate;
            }
        }
    }
}