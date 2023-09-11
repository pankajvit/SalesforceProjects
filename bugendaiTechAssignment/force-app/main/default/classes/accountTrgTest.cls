@isTest
public with sharing class accountTrgTest {
    @isTest
    public static void accountTrgHandlerMethodTest(){
        Account acct = new Account(Name='Test Account');
        insert acct;

        Id accId = acct.Id;
        List<Contact> conList = [Select lastName, AccountId 
                                    from Contact
                                    Where AccountId = :accId];
        System.assertEquals('Dummy Contact Record', conList[0].lastName, 'lastName value is not matching with the lastName value of test data');


    }
}