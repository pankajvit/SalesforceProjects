// Trigger to count number of OpportunityLineItems  associated 
// with an opportunity and display the count on Account’s custom field.(Congnizant Interview Scenario)
trigger grandChildTrg on OpportunityLineItem (after insert, after delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            trgController.trgMethod(Trigger.new);
        }
        if(Trigger.isDelete){
            trgController.trgMethod(Trigger.old);
        }
    }
}