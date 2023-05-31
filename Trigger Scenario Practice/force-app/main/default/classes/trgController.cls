public class trgController {
    public static void trgMethod(List<OpportunityLineItem> oliList){
        Set<Id> oppId = new Set<Id>();
        Map<Id, Decimal> oliMap = new Map<Id, Decimal>();
        List<Account> listToUpdate = new List<Account>();
        if(!oliList.isEmpty()){
            for(OpportunityLineItem oliObj : oliList){
                oppId.add(oliObj.OpportunityId);
            }
        }

        if(!oppId.isEmpty()){
            List<Opportunity> oppList = [Select Id, AccountId 
                                            from Opportunity
                                            Where Id IN :oppId];
            if(!oppList.isEmpty()){
                for(Opportunity oppObj : oppList){
                    oliMap.put(oppObj.AccountId,0);
                }
            }
            for(AggregateResult aggr : [Select count(Id) oli, Opportunity.AccountId from OpportunityLineItem Where Opportunity.AccountId IN :oliMap.keyset() group by Opportunity.AccountId]){
                oliMap.put((Id) aggr.get('AccountId'), (Decimal) aggr.get('oli'));
            }

            for(Id accIds : oliMap.keyset()){
                Account acc = new Account();
                acc.Id = accIds;
                acc.Number_of_Products__c = oliMap.get(accIds);
                listToUpdate.add(acc);
            }
            if(!listToUpdate.isEmpty()){
                try{
                    update listToUpdate;
                }
                catch(exception ex){
                    System.debug('Error while updating account records -->'+ex.getMessage());
                }
            }
        }
    }
}