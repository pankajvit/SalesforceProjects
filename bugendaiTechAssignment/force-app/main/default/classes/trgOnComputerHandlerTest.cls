@isTest
public with sharing class trgOnComputerHandlerTest {
    @isTest
    public static void trgOnComputerHandlerMethodTest(){
        List<Computer__c> compList = new List<Computer__c>();
        Computer__c computer1 = new Computer__c(Name='Lenovo ABC', RAM_In_MB__c=512, Processor_In_GHz__c=1, HardDisk_In_GB__c=20);
        compList.add(computer1);
        Computer__c computer2 = new Computer__c(Name='Hp officeWork', RAM_In_MB__c=3000, Processor_In_GHz__c=4, HardDisk_In_GB__c=220);
        compList.add(computer2);
        Computer__c computer3 = new Computer__c(Name='Dell latitutde', RAM_In_MB__c=9000, Processor_In_GHz__c=9, HardDisk_In_GB__c=700);
        compList.add(computer3);
        insert compList;

        List<Computer__c> listForComp1Test = [Select Name, RAM_In_MB__c, Processor_In_GHz__c, HardDisk_In_GB__c, Capacity__c 
                                                from Computer__c
                                                Where Name='Lenovo ABC'];
        System.assertEquals('Low Capacity', listForComp1Test[0].Capacity__c, 'Capacity value is not matching with the value of first test data');

        List<Computer__c> listForComp2Test = [Select Name, RAM_In_MB__c, Processor_In_GHz__c, HardDisk_In_GB__c, Capacity__c 
                                                from Computer__c
                                                Where Name='Hp officeWork'];
        System.assertEquals('Medium Capacity', listForComp2Test[0].Capacity__c, 'Capacity value is not matching with the value of second test data');

        List<Computer__c> listForComp3Test = [Select Name, RAM_In_MB__c, Processor_In_GHz__c, HardDisk_In_GB__c, Capacity__c 
                                                from Computer__c
                                                Where Name='Dell latitutde'];        
        System.assertEquals('High Capacity', listForComp3Test[0].Capacity__c, 'Capacity value is not matching with the value of third test data');
    }
}