public with sharing class UpdParentWithHighestAmtOppNameByInsHdler {
    public static void trgMethod(List<opportunity> oppList, Map<Id, opportunity> oldMap){
        Set<Id> parentIds = new Set<Id>(); // to store parent Id

        if(!oppList.isEmpty()){
            for(opportunity newOpp : oppList){
                if(oldMap != null){
                    opportunity oldOpp = oldMap.get(newOpp.Id);

                    if(oldOpp.AccountId != newOpp.AccountId){
                        parentIds.add(oldOpp.AccountId);
                        parentIds.add(newOpp.AccountId);
                    }else{
                        parentIds.add(newOpp.AccountId);
                    }
                }else{
                    parentIds.add(newOpp.AccountId);
                }
            }
        }

        if(!parentIds.isEmpty()){

            List<Account> accList = [Select Highest_Amount_Opportunity_Name__c, (Select Name, Amount from opportunities 
                                        Where Amount != null ORDER BY Amount DESC LIMIT 1)
                                        from Account
                                        Where Id IN :parentIds];
            
            List<Account> listToUpdate = new List<Account>();
            if(!accList.isEmpty()){
                for(Account acc : accList){
                    if(!acc.opportunities.isEmpty()){
                        acc.Highest_Amount_Opportunity_Name__c = acc.opportunities[0].Name;
                        listToUpdate.add(acc);
                    }else{
                        acc.Highest_Amount_Opportunity_Name__c = '';
                        listToUpdate.add(acc);
                    }
                }
            }

            if(!listToUpdate.isEmpty()){
                update listToUpdate;
            }
        }
    }
}