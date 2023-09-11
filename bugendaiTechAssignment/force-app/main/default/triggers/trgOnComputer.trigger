trigger trgOnComputer on Computer__c(before insert, before update) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        trgOnComputerHandler.trgOnComputerHandlerMethod(Trigger.new);
    }
}