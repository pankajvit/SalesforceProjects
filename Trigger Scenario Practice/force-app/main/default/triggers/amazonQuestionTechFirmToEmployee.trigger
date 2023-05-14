trigger amazonQuestionTechFirmToEmployee on Employee__c (after insert, after update, after delete, after undelete) {
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUndelete)){
        TechFirmToEmployeeTriggerHandler.afterInsertAndAfterUndelete(Trigger.new);
    }

    if(Trigger.isAfter && Trigger.isUpdate){
        TechFirmToEmployeeTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
    }

    if(Trigger.isAfter && Trigger.isDelete){
        TechFirmToEmployeeTriggerHandler.afterDelete(Trigger.old);
    }
    
    TechFirmToEmployeeTriggerHandler.finalUpdationOnParentObject();
    
}