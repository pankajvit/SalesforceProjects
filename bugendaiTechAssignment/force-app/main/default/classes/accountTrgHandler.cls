public with sharing class accountTrgHandler {
    public static void accountTrgHandlerMethod(List<Account> accList){
        List<Contact> conList = new List<Contact>();
        for(Account acc : accList){
            Contact con = new Contact();
            con.lastName = 'Dummy Contact Record';
            con.accountId = acc.Id;
            conList.add(con);
        }
        insert conList;
    }
}