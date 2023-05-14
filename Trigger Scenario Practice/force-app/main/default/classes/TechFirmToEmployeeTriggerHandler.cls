public with sharing class TechFirmToEmployeeTriggerHandler {
    //public static Set<Id> employeeId = new Set<Id>();
    public static Set<Id> techFirmId = new Set<Id>();
    public static void afterInsertAndAfterUndelete(List<Employee__c> employees){
        for(Employee__c emp : employees){
            if(emp.Tech_firm__c != null){
                //employeeId.add(emp.Id);
                TechFirmToEmployeeTriggerHandler.techFirmId.add(emp.Tech_firm__c);
            }
        }
    }

    public static void afterUpdate(List<Employee__c> newVersionEmp, Map<Id, Employee__c> oldVersionEmp){
        for(Employee__c emp : newVersionEmp){
            if(emp.Tech_firm__c != oldVersionEmp.get(emp.Id).Tech_firm__c){
                //techFirmId.add(emp.Tech_firm__c);
                TechFirmToEmployeeTriggerHandler.techFirmId.add(oldVersionEmp.get(emp.Id).Tech_firm__c);
            }else{
                TechFirmToEmployeeTriggerHandler.techFirmId.add(emp.Tech_firm__c);
            }
        }
    }

    public static void afterDelete(List<Employee__c> employees){
        for(Employee__c emp : employees){
            if(emp.Tech_firm__c != null){
                TechFirmToEmployeeTriggerHandler.techFirmId.add(emp.Tech_firm__c);
            }
        }
    }

    public static void finalUpdationOnParentObject(){
        AggregateResult[] techFirmListWithMinAndMaxSalary = [SELECT Tech_firm__c firmId, max(Salary__c) maxSalary, min(Salary__c) minSalary 
                                    FROM Employee__c
                                    Where Tech_firm__c IN :TechFirmToEmployeeTriggerHandler.techFirmId
                                    GROUP BY Tech_firm__c];

        Map<Id, Decimal> techFirmAndTheirMinSalary = new Map<Id, Decimal>();
        Map<Id, Decimal> techFirmAndTheirMaxSalary = new Map<Id, Decimal>();

        for(AggregateResult agr : techFirmListWithMinAndMaxSalary){
            techFirmAndTheirMinSalary.put((Id)agr.get('firmId'), (Decimal)agr.get('minSalary'));
            techFirmAndTheirMaxSalary.put((Id)agr.get('firmId'), (Decimal)agr.get('maxSalary'));
        }
        List<Tech_firm__c> techFirmList = [SELECT Id, Name, Max_Salary__c, Min_Salary__c 
                                            FROM Tech_firm__c
                                            Where Id IN :TechFirmToEmployeeTriggerHandler.techFirmId];
        List<Tech_firm__c> updateTheseTechFirmData = new List<Tech_firm__c>();

        if(techFirmList != null && techFirmList.size() > 0){
            for(Tech_firm__c techFirm : techFirmList){
                if(techFirmAndTheirMaxSalary.containsKey(techFirm.Id) 
                    && techFirmAndTheirMinSalary.containsKey(techFirm.Id)){
                        techFirm.Max_Salary__c = techFirmAndTheirMaxSalary.get(techFirm.Id);
                        techFirm.Min_Salary__c = techFirmAndTheirMinSalary.get(techFirm.Id);
                }
                updateTheseTechFirmData.add(techFirm);
            }
            update updateTheseTechFirmData;  
        }
    }
}