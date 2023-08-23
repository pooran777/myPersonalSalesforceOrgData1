trigger TestTrigger1 on Contact (before update) {   
    TestTriggerClass obj = new TestTriggerClass(); 
     List<Contact> old = new List<Contact>();
         List<Contact> neww = new List<Contact>();
    if(Trigger.isbefore){
        if(Trigger.isUpdate){
            old = [SELECT Id,Name,Sequence_Number__c from Contact where Id IN:Trigger.old];
            neww = [SELECT Id,Name,Sequence_Number__c from Contact where Id IN:Trigger.new];
            System.debug('old=='+old);
            System.debug('old=='+neww);
        }
    }
}