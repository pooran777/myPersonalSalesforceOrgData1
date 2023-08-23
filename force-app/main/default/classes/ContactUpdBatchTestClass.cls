@isTest
Private class ContactUpdBatchTestClass {
  /*  @testSetup static void setupMethod(){
        List<Contact> con = new List<Contact>(); 
        for(Integer i=1;i<=20;i++){
            con.add(new Contact());
        }
    }*/
    @isTest
    static void testMethod1(){
        Contact[] con = new List<Contact>();   
        for (Integer i=1;i<=10;i++) {
            Contact m = new Contact(lastName = 'contact ' + i );
            con.add(m);
        }
        insert con;
        
         Datetime yesterday = Datetime.now().addDays(-1);
        Test.setCreatedDate(con[0].Id, yesterday);     
        Test.startTest();
            ContactUpdBatch c = new ContactUpdBatch();
            Database.executeBatch(c);
        Test.stopTest();
        
        Contact[] conList = [SELECT Id,lastName,Status__c FROM Contact Where CreatedDate = YESTERDAY];
		//System.assertEquals(conList[0].Status__c,'Ready for Approval');
    }
}





/*@isTest
public class ContactBatchApex_Test {
    @TestSetup
    static void setData() {
        List<Account> accList = ContactTestDataFactory.createAccount(2);
        List<Contact> contactList = ContactTestDataFactory.createContactyesterday(10, accList[0]);
    }
    @isTest
    static void updateStatusField() {
        Account acct = [Select Id,Name From Account Where Name = 'TestTrigggerAccountNew1'];
        List<Contact> conList = [Select Name, Status_c, Contact_Datec, Contact_Date_Timec, Contact_Booleanc, Contact_Text_Area_c From Contact Where AccountId =: acct.id];
        Test.startTest();
            ContactBatchApex a = new ContactBatchApex();
            Database.executeBatch(a);

            ContactBatchApexSchedule schClass = new ContactBatchApexSchedule();
            schClass.execute(null);
        Test.stopTest();
        system.debug('in test class');
        List<Contact> conToUpdate = [Select Id, Name, Status__c From Contact WHERE createdDate = yesterday];
        System.debug('conToUpdate list is :' + conToUpdate);
        System.assertEquals('Ready for Approval', conToUpdate[0].Status__c);
    }
    
}*/


/*@isTest
private class accListountUpdate {
 
static testmethod void test() {
 
// Create test accounts to be updated
// by the batch job.
 
Account[] accList = new List();
for (Integer i=0;i<200;i++) {
Account m = new Account(Name = 'Account ' + i);
accList.add(m);
}
insert accList;
 
Test.startTest();
AccountUpdate c = new AccountUpdate();
Database.executeBatch(c);
Test.stopTest();
 
// Verify accounts updated
Account[] accUpdatedList = [SELECT Id,Name FROM Account];
System.assert(accUpdatedList[0].Name.Contains('Updated'));
}
}*/