@isTest
public with sharing class getRecordDataControllerTest {
    @isTest
    public static void getAccountsMethod(){ 
        Account Ac=new Account();
        ac.Name='Test';
        insert ac;
        String searchString='e';
        List<String> Values= new List<String>();
        Values.add('[\"'+ac.Id+'\"]');
        //Values.add(ac.Id); //wrong approch
        System.debug('Values=='+Values);
        Test.startTest();
        getRecordDataController.getAccounts('Account','Name',searchString,Values);
        Test.stopTest();
    }
}