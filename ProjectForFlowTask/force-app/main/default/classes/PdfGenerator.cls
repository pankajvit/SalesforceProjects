public with sharing class PdfGenerator {
    @AuraEnabled
	public static List<Scope_of_Work__c> getScopeOfWorkData(){
		return [SELECT Id, Name, Cloud__r.Name, Region__r.Name, Rate__c, Total_Estimation__c, Rate_Per_Hour__c, totalCostInRange__c FROM Scope_of_Work__c ORDER BY CreatedDate DESC LIMIT 1];
	}

	@AuraEnabled
	public static List<Project_scope__c> getRelatedTaskToSowData(Id sowId){
		//system.debug('SOW Id: ' +sowId);
		return [SELECT Id, Scope_of_Work__c, Task_List__r.Name, Task_List__r.Estimated_Hour__c, Description__c FROM Project_scope__c Where Scope_of_Work__c = :sowId];
	}

	@AuraEnabled
	public static List<Contact> getContactsController(){
		return [SELECT Id, FirstName, LastName FROM Contact LIMIT 100];
	}
}


// changed following data
// return type - List<Project_scope__c>
// parameter - Id sowId
// SELECT Id, Scope_of_Work__c, Task_List__r.Name FROM Project_scope__c
// Task_List__r.Estimated_Hour__c, Description__c
// Where Scope_of_Work__c = :sowId