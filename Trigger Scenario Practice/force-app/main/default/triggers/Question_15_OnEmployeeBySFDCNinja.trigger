// Tech firm object has two field – Max Salary & Min Salary 
// Employee object has one field – Salary
// Show min & max salary of employee records on Parent company record.
trigger Question_15_OnEmployeeBySFDCNinja on Employee__c (after insert, after update, after delete, after undelete) {
    Set<Id> techFirmId = new Set<Id>();
    if(Trigger.isAfter && Trigger.isInsert || Trigger.isUndelete){
        for(Employee__c emp : Trigger.new){
            if(emp.Tech_firm__c != null){
                techFirmId.add(emp.Tech_firm__c);
            }
        }
    }else if(Trigger.isAfter && Trigger.isUpdate){
        for(Employee__c emp : Trigger.new){
            if(emp.Tech_firm__c != null && emp.Tech_firm__c != Trigger.oldMap.get(emp.Id).Tech_firm__c) {
               techFirmId.add(emp.Tech_firm__c);
               techFirmId.add(Trigger.oldMap.get(emp.Id).Tech_firm__c); 
            }else{
                techFirmId.add(emp.Tech_firm__c);
            }
        }
    }else if(Trigger.isAfter && Trigger.isDelete){
        for(Employee__c emp : Trigger.old){
            if(emp.Tech_firm__c != null){
                techFirmId.add(emp.Tech_firm__c);
            }
        }
    }

    List<AggregateResult> aggregateResultList = [Select Tech_firm__c, 
                                                    min(Salary__c) minSalary,
                                                    max(Salary__c) maxSalary 
                                                    from Employee__c
                                                    Where Tech_firm__c IN :techFirmId
                                                    GROUP BY Tech_firm__c];
    Map<Id, Decimal> TechFirmIdVsMinSalary = new Map<Id, Decimal>();
    Map<Id, Decimal> TechFirmIdVsMaxSalary = new Map<Id, Decimal>();
    for(AggregateResult aggr : aggregateResultList){
        TechFirmIdVsMinSalary.put((Id)aggr.get('Tech_firm__c'), (Decimal)aggr.get('minSalary'));
        TechFirmIdVsMaxSalary.put((Id)aggr.get('Tech_firm__c'), (Decimal)aggr.get('maxSalary'));
    }
    
    List<Tech_firm__c> updateTheseTechFirm = new List<Tech_firm__c>();
    List<Tech_firm__c> techFirmList = [Select Id, Max_Salary__c, Min_Salary__c 
                                        from Tech_firm__c
                                        Where Id IN :techFirmId];
    for(Tech_firm__c techfirm : techFirmList){
        if(TechFirmIdVsMinSalary.containsKey(techfirm.Id) && TechFirmIdVsMaxSalary.containsKey(techfirm.Id)){
            techfirm.Max_Salary__c = TechFirmIdVsMaxSalary.get(techfirm.Id);
            techfirm.Min_Salary__c = TechFirmIdVsMinSalary.get(techfirm.Id);
            updateTheseTechFirm.add(techfirm);
        }
    }
    update updateTheseTechFirm;
}