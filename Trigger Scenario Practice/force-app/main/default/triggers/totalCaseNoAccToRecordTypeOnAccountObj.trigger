//Create two record types named as “Partner Case” and “Customer Case” on
//Case Object. On creation of Case, as per the record type populate the total
//number of Partner Case or Customer Case on Account object. Create
//Custom Fields on Account to have total numbers.
trigger totalCaseNoAccToRecordTypeOnAccountObj on Case (after insert, after update, after delete, after undelete) {

    Set<Id> accIds = new Set<Id>();
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUndelete)){
        for(Case c : Trigger.new){
            if(c.AccountId != null){
                accIds.add(c.AccountId);
            }
        }
    }else if(Trigger.isAfter && Trigger.isUpdate){
        for(Case c : Trigger.new){
            if(c.AccountId != Trigger.oldMap.get(c.Id).AccountId){
                accIds.add(c.AccountId);
                accIds.add(Trigger.oldMap.get(c.Id).AccountId);
            }else{
                accIds.add(c.AccountId);
            }
        }
    }else if(Trigger.isAfter && Trigger.isdelete){
        for(Case c : Trigger.old){
            if(c.AccountId != null){
                accIds.add(c.AccountId);  
            }
        }
    }

    //List<Case> caseList = [SELECT Id, CaseNumber, AccountId, RecordType.Name 
                                //FROM Case
                                //Where AccountId IN :accIds];
    
    

    /*for(Case c : caseList){
        if((String.valueOf(c.RecordType.Name)) == 'Partner Case'){
            totalPartnerCase++;
        }
        if((String.valueOf(c.RecordType.Name)) == 'Customer Case'){
            totalCustomerCase++;
        }
    }*/
    Integer totalCustomerCase = 0;
    Integer totalPartnerCase = 0;

    List<Account> accList = [SELECT Id, Name, Total_Customer_Case__c, Total_Partner_Case__c,
                                (SELECT Id, CaseNumber, AccountId, RecordType.Name 
                                FROM Cases) 
                            FROM Account Where Id IN :accIds];

    List<Account> updateAccList = new List<Account>();
    for(Account acc : accList){
        for(Case c : acc.Cases){
            if((String.valueOf(c.RecordType.Name)) == 'Partner Case'){
                totalPartnerCase++;
            }
            if((String.valueOf(c.RecordType.Name)) == 'Customer Case'){
                totalCustomerCase++;
            }
        }
        acc.Total_Customer_Case__c = totalPartnerCase;
        acc.Total_Partner_Case__c = totalCustomerCase;
        updateAccList.add(acc);
        totalCustomerCase = 0;
        totalPartnerCase = 0;
    }

    update updateAccList;
}

