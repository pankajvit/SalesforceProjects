// Trigger to show an Error if there are already two contacts present on an Account and the user tries to add one more contact on it.
trigger limitationOfTwoContactOnAccount on Contact (before insert, before update, After undelete) {
    List<Id> accIds = new List<Id>();
    if(Trigger.isBefore || Trigger.isAfter && (Trigger.isInsert || Trigger.isUndelete)){
        for(Contact con : Trigger.new){
            if(con.AccountId != null){
                accIds.add(con.AccountId);
            }
        }
    }

    if(Trigger.isBefore && Trigger.isUpdate){
        for(Contact con : Trigger.new){
            if(con.AccountId != null && con.AccountId != Trigger.oldMap.get(con.Id).AccountId){
                accIds.add(con.AccountId);
            }
        }
    }
    AggregateResult[] contactList = [SELECT AccountId, COUNT(Id) totalAssociatedContact 
                                    from Contact 
                                    Where AccountId IN :accIds 
                                    GROUP BY AccountId];
    Map<String, Integer> accIdVsTheirNumberOfContact = new Map<String, Integer>();

    for(AggregateResult con : contactList){
        accIdVsTheirNumberOfContact.put(String.valueOf(con.get('AccountId')), Integer.valueOf(con.get('totalAssociatedContact')));
        if(Integer.valueOf(con.get('totalAssociatedContact')) == null){
            accIdVsTheirNumberOfContact.put(String.valueOf(con.get('AccountId')), 0);
        }
    }

    for(Contact con : Trigger.new){
        system.debug(accIdVsTheirNumberOfContact.get(con.AccountId));
        if(accIdVsTheirNumberOfContact.get(con.AccountId) >= 2 && accIdVsTheirNumberOfContact.get(con.AccountId) !=null){
            con.addError('you can not insert more than two contact with one account');
        }
    }
}