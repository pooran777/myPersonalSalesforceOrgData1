public class TestTriggerClass {
	set<Id> pset = new set<Id>();
    List<Account> acc = new List<Account>();
    public void insertMethod(List<Contact> newList,List<Contact> oldList,Map<Id,Contact> newMap,map<Id,Contact> oldMap){
         
       
        
         	System.debug('newList=='+newList);
         
         
             System.debug('newMap=='+newMap);
         
       
         	 System.debug('oldList=='+oldList);
         
         
         	 System.debug('oldMap=='+oldMap);
         
        
    }
}