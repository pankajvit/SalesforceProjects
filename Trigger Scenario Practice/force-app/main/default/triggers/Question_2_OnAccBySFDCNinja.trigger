//When account is inserted or updated 
//then account billing address should automatically populate in shipping address
trigger Question_2_OnAccBySFDCNinja on Account (before insert, before update) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        for(Account acc : Trigger.new){
            acc.ShippingCity = acc.BillingCity;
            acc.ShippingCountry = acc.BillingCountry;
            acc.ShippingPostalCode = acc.BillingPostalCode;
            acc.ShippingState = acc.BillingState;
            acc.ShippingStreet = acc.BillingStreet;
        }
    }
}