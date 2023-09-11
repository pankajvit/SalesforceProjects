// Question – 1: Allow users to modify Opportunity record only if record is not Closed.
// Question – 2: Create Order record from Opportunity when it's marked as Closed Won.
// Question - 3: Assign a Task to follow-up for Opportunity Owner with Primary Contact as soon as new record is created.
// Question – 5: Create Total Amount field in Account record to capture Opportunity’s Amount (Roll-up).  
trigger oppTrg on Opportunity (before update, after insert, after update, after delete, after undelete) {
    // Question – 1 Solution Start: Allow users to modify Opportunity record only if record is not Closed.
    if(Trigger.isBefore && Trigger.isUpdate) {
        for(Opportunity opp : Trigger.new){
            if(opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost'){
                if(opp.Name != Trigger.oldMap.get(opp.Id).Name 
                        || opp.Amount != Trigger.oldMap.get(opp.Id).Amount
                        || opp.CloseDate != Trigger.oldMap.get(opp.Id).CloseDate
                        || opp.AccountId != Trigger.oldMap.get(opp.Id).AccountId){
                    opp.addError('your opportunity is closed. so, you don\'t have permission to modify it');
                }
            }
        }
    }
    // Question – 2: Create Order record from Opportunity when it's marked as Closed Won.
    if(Trigger.isAfter && Trigger.isUpdate){
        List<Order> newOrders = new List<Order>();
        for (Opportunity opp : Trigger.new) {
            // Check if the Opportunity is marked as "Closed Won" and it wasn't closed won in the previous state
            if (opp.StageName == 'Closed Won' && Trigger.oldMap.get(opp.Id).StageName != 'Closed Won') {
                // Create a new Order record based on the Opportunity data
                Order newOrder = new Order();
                newOrder.OpportunityId = opp.Id; // Associate the Opportunity with the Order (assuming custom lookup field Opportunity__c)
                newOrder.AccountId = opp.AccountId; // Associate the Opportunity's Account with the Order
                newOrder.EffectiveDate = Date.today(); // Set the Effective Date for the Order (you can customize this as needed)
                newOrder.Status = 'Draft'; // Set the Status for the Order (you can customize this as needed)
                // Add any other fields from the Opportunity that you want to copy to the Order
                // newOrder.OtherField__c = opp.SomeField__c;
                newOrders.add(newOrder);
            }
        }

        // Insert the newly created Orders (outside of the loop for better performance)
        if (!newOrders.isEmpty()) {
            insert newOrders;
        }
    }
    // Question – 5: Create Total Amount field in Account record to capture Opportunity’s Amount (Roll-up).
    Set<Id> accIds = new Set<Id>();
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUndelete)){
        for(Opportunity opp : Trigger.new){
            if(opp.AccountId != null){
                accIds.add(opp.AccountId);
            }
        }
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        for(Opportunity opp : Trigger.new){
            if(opp.AccountId != null && opp.AccountId != Trigger.oldMap.get(opp.Id).AccountId){
                accIds.add(opp.AccountId);
                accIds.add(Trigger.oldMap.get(opp.Id).AccountId);
            }else{
                accIds.add(opp.AccountId);
            }
        }
    }

    if(Trigger.isAfter && Trigger.isDelete){
        for(Opportunity opp : Trigger.old){
            if(opp.AccountId != null){
                accIds.add(opp.AccountId);
            }
        }
    }

    Map<Id, Decimal> idVsAmount = new Map<Id, Decimal>();
    AggregateResult[] aggregate = [Select AccountId, Sum(Amount) totAmt 
                                        from Opportunity 
                                        where AccountId IN :accIds
                                        Group by AccountId];
    
    for(AggregateResult aggr : aggregate) {
        /*Decimal totalAmount = (Decimal)aggr.get('totAmt');
        if (totalAmount == null) {
            totalAmount = 0;
        }*/
        idVsAmount.put((Id)aggr.get('AccountId'), (Decimal)aggr.get('totAmt'));
    }
    
    System.debug('IdVSAmount Map Value'+ idVsAmount);

    List<Account> accList = [SELECT Id, Name, Total_Amount__c 
                                    FROM Account
                                    Where Id IN :accIds];
    List<Account> updateTheseAccount = new List<Account>();
    for(Account acc : accList){
        if(idVsAmount.containsKey(acc.Id)){
            acc.Total_Amount__c = idVsAmount.get(acc.Id);
        }else {
            acc.Total_Amount__c = 0; // Set Total_Amount__c to 0 for Accounts without Opportunities
        }
        updateTheseAccount.add(acc);
    }
    update updateTheseAccount;
    
}