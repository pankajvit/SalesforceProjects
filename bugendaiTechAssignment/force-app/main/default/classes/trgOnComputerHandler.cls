public with sharing class trgOnComputerHandler {
    public static void trgOnComputerHandlerMethod(List<Computer__c> computerList){
        for(Computer__c cmp : computerList){
            if(cmp.RAM_In_GB__c > 6 && cmp.Processor_In_GHz__c > 6 && cmp.HardDisk_In_GB__c > 500){
                cmp.Capacity__c = 'High Capacity';
            }
            else if((cmp.RAM_In_GB__c > 1 && cmp.RAM_In_GB__c < 6) 
                        && (cmp.Processor_In_GHz__c > 2 && cmp.Processor_In_GHz__c < 6) 
                        && (cmp.HardDisk_In_GB__c > 50 && cmp.HardDisk_In_GB__c < 500)){
                cmp.Capacity__c = 'Medium Capacity';
            }else if(cmp.RAM_In_GB__c < 1 && cmp.Processor_In_GHz__c < 2 && cmp.HardDisk_In_GB__c < 50){
                cmp.Capacity__c = 'Low Capacity';
            }
        }
    }
}