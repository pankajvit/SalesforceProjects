public with sharing class CrudAppController {
    @AuraEnabled
        public static String getDataByFilter(String searchKey) {
            List<wrapperClass> wrapperList = new List<wrapperClass>();
            List<Crud__c> allRec = new List<Crud__c>(); 
            if(searchKey != null && searchKey !=''){
                String key = '%'+ searchKey +'%';  
                 allRec = [SELECT Id,Name,Gender__c,Subject__c,Message__c FROM Crud__c WHERE Name LIKE : key];
 
            }else{  
                allRec = [SELECT Id,Name,Gender__c,Subject__c,Message__c FROM Crud__c];

            }
            Integer i = 1;
            
            for(Crud__c obj : allRec){
                wrapperClass wrapOj = new wrapperClass(
                    i,
                    obj.Id,
                    obj.Name,
                    obj.Gender__c,
                    obj.Subject__c,
                    obj.Message__c 
                    );
                    wrapperList.add(wrapOj);
                    i++;
            }

            
            return JSON.serialize(wrapperList);
        }


        // fetch data form account 
        @AuraEnabled(cacheable = true)
        public static String fetchData(){
            List<wrapperClass> wrapperList = new List<wrapperClass>();
            try {
                
                    
                List<Crud__c> crudList = [SELECT Id,Name,Gender__c,Subject__c,Message__c FROM Crud__c];
                Integer i = 1;
       
                if(!crudList.isEmpty()){
                    for(Crud__c obj : crudList){                         
    
                        wrapperClass wrapOj = new wrapperClass(
                        i,
                        obj.Id,
                        obj.Name,
                        obj.Gender__c,
                        obj.Subject__c,
                        obj.Message__c 
                        );
                        wrapperList.add(wrapOj);
                        i++;
                    }
                }
    
                return JSON.serialize(wrapperList);
    
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
            
        }


        public class wrapperClass{

            @AuraEnabled   
            public Integer SrNo;
            @AuraEnabled   
            public Id Id;
            @AuraEnabled   
            public String Name;
            @AuraEnabled   
            public String Gender;
            @AuraEnabled   
            public String Subject;
            @AuraEnabled   
            public String Message;
            @AuraEnabled   
            public String URL; 
            public wrapperClass(Integer SrNo, Id Id, String Name, String Gender, String Subject, String Message){
                this.SrNo = SrNo;
                this.Id   = Id;
                this.Name = Name;
                this.Gender = Gender;
                this.Subject = Subject;
                this.URL = '/'+Id;
                this.Message = Message; 
    
            }
        }
}