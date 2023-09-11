public with sharing class trgOnMobileHandler {
    public static void trgOnMobileHandlerMethod(List<Mobile__c> mobileList){
        Integer discount; 
        for(Mobile__c mob : mobileList){
            if(mob.Sales_Season__c == 'Yes'){
                if(mob.Brand__c == 'Samsung'){
                    discount = 10;
                }else if(mob.Brand__c == 'Apple'){
                    discount = 20;
                }  
            }else if(mob.Sales_Season__c == 'No'){
                if(mob.Brand__c == 'Samsung'){
                    discount = 5;
                }else if(mob.Brand__c == 'Apple'){
                    discount = 0;
                }
            }
            mob.Net_Price_After_Discount__c	 = mob.Price__c - (mob.Price__c * discount / 100);
            mob.Discount_del__c = discount;

            if(discount != 0){
                mob.Discount_Status__c = 'Congrats! You got '+ discount +'% discount';
            }else {
                mob.Discount_Status__c = 'Sorry!! We can not give discount on this product. Sales Season is Off';
            }
        }
    }
}