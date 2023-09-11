trigger trgOnMobile on Mobile__c (before insert, before update) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        trgOnMobileHandler.trgOnMobileHandlerMethod(Trigger.new);
    }
}