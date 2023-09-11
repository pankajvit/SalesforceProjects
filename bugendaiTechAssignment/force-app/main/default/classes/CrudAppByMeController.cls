public with sharing class CrudAppByMeController {
    @AuraEnabled(cacheable = true)
    public static String fetchData(){
        try {           
            List<Crud__c> crudList = [SELECT Id,Name,Gender__c,Subject__c,Message__c FROM Crud__c LIMIT 20];
            return JSON.serialize(crudList);
        }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}