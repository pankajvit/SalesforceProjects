// Question - 11 by SFDC Ninja - Trigger to show an Error if there are already two contacts present on an Account 
// and the user tries to add one more contact on it.
trigger Question_11_OnContactBySFDCNinja on Contact (before insert, before update, after undelete) {
    Set<Id> accIds = new Set<Id>();
    if(Trigger.isInsert || Trigger.isUndelete){
        for(Contact con : Trigger.new){
            if(con.AccountId != null){
                accIds.add(con.AccountId);
            }
        }
    }
    if(Trigger.isUpdate){
        for(Contact con : Trigger.new){
            if(con.AccountId != Trigger.oldMap.get(con.Id).AccountId){
                accIds.add(con.AccountId);
            }
        }
    }

    List<AggregateResult> aggregateResultList = [Select AccountId, Count(Id) totCount from Contact
                                                    Where AccountId IN :accIds
                                                    Group by AccountId];
    Map<Id, Integer> accIdVsCount = new Map<Id, Integer>();
    for(AggregateResult aggr : aggregateResultList){
        accIdVsCount.put((Id)aggr.get('AccountId'), (Integer)aggr.get('totCount'));
    }

    for(Contact con : Trigger.new){
        if(accIdVsCount.containsKey(con.AccountId)){
            if(accIdVsCount.get(con.AccountId) >= 2){
                con.addError('you cannot have more than two contacts');
            }
        }
    }
}