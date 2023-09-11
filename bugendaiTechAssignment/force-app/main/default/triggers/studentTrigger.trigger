trigger studentTrigger on Student__c(before insert, before update) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        StudentStatus.studentStatusHandler(Trigger.new);
    }
}