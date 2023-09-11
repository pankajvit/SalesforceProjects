@isTest
public with sharing class MobileHandlerTest {
    @isTest
    public static void trgOnMobileHandlerMethodTest(){
        List<Mobile__c> mobileList = new List<Mobile__c>();
        Mobile__c mobile1 = new Mobile__c(Name='Samsung S12', Price__c=100, Brand__c='Samsung',
                                Sales_Season__c='No');
        mobileList.add(mobile1);
        Mobile__c mobile2 = new Mobile__c(Name='Apple iphone 9', Price__c=100, Brand__c='Apple',
                                Sales_Season__c='No');
        mobileList.add(mobile2);
        Mobile__c mobile3 = new Mobile__c(Name='iphone', Price__c=100, Brand__c='Apple',
                                Sales_Season__c='Yes');
        mobileList.add(mobile3);
        Mobile__c mobile4 = new Mobile__c(Name='Samsung S10', Price__c=100, Brand__c='Samsung',
                                Sales_Season__c='Yes');
        mobileList.add(mobile4);

        insert mobileList;

        List<Mobile__c> mob1List = [Select Name, Price__c, Brand__c, Sales_Season__c, Discount_del__c, Net_Price_After_Discount__c, Discount_Status__c
                                        from Mobile__c
                                        Where Name = 'Samsung S12'];
        
        System.assertEquals(5, mob1List[0].Discount_del__c, 'Discount value is not matching with the value of test data');
        System.assertEquals(95, mob1List[0].Net_Price_After_Discount__c, 'Net Price After Discount is not matching with the value of test data');
        System.assertEquals('Congrats! You got 5% discount', mob1List[0].Discount_Status__c, 'Discount Status is not matching with the value of test data');

        List<Mobile__c> mob2List = [Select Name, Price__c, Brand__c, Sales_Season__c, Discount_del__c, Net_Price_After_Discount__c, Discount_Status__c
                                        from Mobile__c
                                        Where Name = 'Apple iphone 9'];
        
        System.assertEquals(0, mob2List[0].Discount_del__c, 'Discount value is not matching with the value of test data');
        System.assertEquals(100, mob2List[0].Net_Price_After_Discount__c, 'Net Price After Discount is not matching with the value of test data');
        System.assertEquals('Sorry!! We can not give discount on this product. Sales Season is Off', mob2List[0].Discount_Status__c, 'Discount Status is not matching with the value of test data');

        List<Mobile__c> mob3List = [Select Name, Price__c, Brand__c, Sales_Season__c, Discount_del__c, Net_Price_After_Discount__c, Discount_Status__c
                                        from Mobile__c
                                        Where Name = 'iphone'];

        System.assertEquals(20, mob3List[0].Discount_del__c, 'Discount value is not matching with the value of test data');
        System.assertEquals(80, mob3List[0].Net_Price_After_Discount__c, 'Net Price After Discount is not matching with the value of test data');
        System.assertEquals('Congrats! You got 20% discount', mob3List[0].Discount_Status__c, 'Discount Status is not matching with the value of test data');

        List<Mobile__c> mob4List = [Select Name, Price__c, Brand__c, Sales_Season__c, Discount_del__c, Net_Price_After_Discount__c, Discount_Status__c
                                        from Mobile__c
                                        Where Name = 'Samsung S10'];
        
        System.assertEquals(10, mob4List[0].Discount_del__c, 'Discount value is not matching with the value of test data');
        System.assertEquals(90, mob4List[0].Net_Price_After_Discount__c, 'Net Price After Discount is not matching with the value of test data');
        System.assertEquals('Congrats! You got 10% discount', mob4List[0].Discount_Status__c, 'Discount Status is not matching with the value of test data');

    }
}