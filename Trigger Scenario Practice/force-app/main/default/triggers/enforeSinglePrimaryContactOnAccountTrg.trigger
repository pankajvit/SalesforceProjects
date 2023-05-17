// Enforce single Primary Contact on account.(Deloitte Interview Scenario)
trigger enforeSinglePrimaryContactOnAccountTrg on Contact (before insert, before update) {
    Set<Id> accIds = new Set<Id>();
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            for(Contact con : Trigger.new){
                if(con.AccountId != null){
                    accIds.add(con.AccountId);
                }
            }
        }else if(Trigger.isUpdate){
            for(Contact con : Trigger.new){
                if(con.AccountId !=null && con.AccountId != Trigger.oldMap.get(con.Id).AccountId){
                    accIds.add(con.AccountId);
                    accIds.add(Trigger.oldMap.get(con.Id).AccountId);
                }else{
                    accIds.add(con.AccountId);
                }
            }
        }
    }
    
    List<Contact> conList = [Select Id, AccountId, lastName, Primary_Contact__c from Contact 
                                Where Primary_Contact__c = true AND AccountId IN :accIds];

    for(Contact con : Trigger.new){
        if(conList!=null && conList.size()>=1){
            con.addError('you can not insert more than one primary contact');
        }
    }
}