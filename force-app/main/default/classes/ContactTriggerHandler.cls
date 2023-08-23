public class ContactTriggerHandler {
    Set<Id> parentIds = new Set<Id>();
    List<Account> parentLeadsById = new List<Account>();
    List<Contact> newConList = new List<Contact>();
    List<Contact> existingConList = new List<Contact>();
    list<Contact> conToUpdate = new list<Contact>();
    
    //Prevent recursive trigger
    public static Boolean isFirstTime = true;
    
    //After Insert
    public void afterContactInsert(List<Contact> newList){
        Map<Integer,Contact> conMap = new Map<Integer,Contact>();
        if(isFirstTime == true){
            isFirstTime = false;
            for(Contact con : newList){
                parentIds.add(con.AccountId);
            }
            System.debug('newList==='+newList);
            if(parentIds.size()>0){
                parentLeadsById = [SELECT ID, Name, (select Id, Name, Sequence_Number__c from Contacts) FROM Account Where Id IN :parentIds];    
                newConList = [select Id, Name, Sequence_Number__c, AccountId from Contact where AccountId IN :parentIds and Id IN :newList];
                existingConList = [Select Id, Name, Sequence_Number__c, AccountId From Contact Where AccountId IN: parentIds and Id Not IN : newList];
            }
            for(Account acc : parentLeadsById){
                conMap.clear();
                for(Contact con : existingConList){
                    if(acc.Id == con.AccountId){
                        conMap.put((Integer)con.Sequence_Number__c,con);
                    }
                }
                for(Contact con : newConList){
                    if(acc.Id == con.AccountId){
                        if(conMap.containsKey((Integer)con.Sequence_Number__c)){
                            for(Integer i=conMap.size() ; i>=con.Sequence_Number__c ;i--){
                                conMap.put(i+1,conMap.get(i));
                                conMap.get(i).Sequence_Number__c++;
                            }
                        }
                        else{
                            con.Sequence_Number__c = conMap.size()+1;
                            conMap.put(conMap.size()+1 ,con);
                            
                        }
                        conMap.put((Integer)con.Sequence_Number__c,con);
                    }
                }
                conToUpdate.addAll(conMap.values());
            }
            update conToUpdate;  
        }
    }     
    
    
    
    //After Delete
    public void afterContactDelete(List<Contact> oldList){
        conToUpdate.clear();
        Map<Integer,Contact> conMap = new Map<Integer,Contact>();  
        if(isFirstTime == true){
            isFirstTime = false;
            for(Contact con : oldList){
                parentIds.add(con.AccountId);
            }
            if(parentIds.size() >0){      
                // All Account those releted Contact was deleted 
                parentLeadsById = [SELECT ID, Name, (select Id, Name, Sequence_Number__c from Contacts ORDER BY Sequence_Number__c ASC) FROM Account Where Id IN :parentIds]; 
            }
            if(parentLeadsById.size() >0){
                for(Account leadObj: parentLeadsById){         //all account
                    conMap.clear();
                    for(Contact con: leadObj.Contacts){        // all present contact on account 
                        if(!conMap.containsKey((Integer)con.Sequence_Number__c)){
                            con.Sequence_Number__c = conMap.size()+1;
                            conMap.put((Integer)con.Sequence_Number__c ,con);                       
                        }
                    }	
                    conToUpdate.addAll(conMap.values());  
                }
                UPDATE conToUpdate;
            }
        }
    }
    
    
    public void afterContactUpdate(List<Contact> newList , Map<Id,Contact> oldList) {
        if(isFirstTime == true){
            Map<Integer,Contact> conMap = new Map<Integer,Contact>();
            List<Contact> newValidContactList = new List<Contact>();
            List<Contact> existingValidContactList = new List<Contact>();
            List<Contact> invalidContactList= new List<Contact>();
            isFirstTime = false;
            parentIds.clear();
            existingConList.clear();
            newConList.clear();
            conToUpdate.clear();
            for(Contact con : newList){
                parentIds.add(con.AccountId);
            }
            for(Id idMap : oldList.keySet()){
                parentIds.add(oldList.get(idMap).AccountId);
            }
            existingConList = [SELECT Id, Name, Sequence_Number__c,AccountId FROM Contact WHERE AccountId IN :parentIds AND Id NOT IN :newList ORDER BY Sequence_Number__c];
            newConList = [SELECT Id, Name, Sequence_Number__c,AccountId FROM Contact WHERE AccountId IN :parentIds AND Id IN :newList];
            for(id accid : parentIds) {
                Integer totalContact = 0;
                conMap.clear();
                newValidContactList.clear();
                existingValidContactList.clear();
                invalidContactList.clear();
                for(Contact con : existingConList) {
                    if(con.AccountId == accid) {
                        totalContact++;
                    }
                }
                for(Contact con : newConList) {
                    if(con.AccountId == accid) {
                        totalContact++;
                    }
                }
                for(Contact con : existingConList) {
                    if(con.AccountId == accid) {
                        if(con.Sequence_Number__c > totalContact || con.Sequence_Number__c < 1 || con.Sequence_Number__c == null) {
                            invalidContactList.add(con);
                        } else {
                            existingValidContactList.add(con);
                        }
                    }
                }
                for(contact con: newConList) {
                    if(con.AccountId == accid) {
                        if(con.AccountId != oldList.get(con.Id).AccountId || con.Sequence_Number__c > totalContact ||con.Sequence_Number__c < 1 || con.Sequence_Number__c == null) {
                            invalidContactList.add(con);
                        }
                        else{
                            newValidContactList.add(con);
                        }
                    }                 
                }
                for(Contact newCon : newValidContactList) {
                    Integer sqno = (Integer)newCon.Sequence_Number__c;
                    if(conMap.containsKey(sqno)) {
                        integer j = sqno+1;
                        while(conMap.containsKey(j)) {
                            j++;
                        }
                        for(integer i=j;i>sqno;i--) {
                            if(i <= totalContact) {
                                conMap.put((i),conMap.get(i-1));
                                conMap.get(i).Sequence_Number__c++;
                            } 
                            else {
                                invalidContactList.add(conMap.get(i-1));
                            }
                        }
                    }
                    conMap.put(sqno,newCon);
                    conMap.get(sqno).Sequence_Number__c = sqno;
                }
                for(Contact exsCon : existingValidContactList) {
                    Integer sqno = (Integer)exsCon.Sequence_Number__c;
                    Integer j=1;
                    while(conMap.containsKey(j)) {
                        j++;
                    }
                    if(!conMap.containsKey(j)) {
                        conMap.put(j,exsCon);
                        conMap.get(j).Sequence_Number__c = j;
                    } 
                    else {
                        conMap.put(sqno,exsCon);
                        conMap.get(sqno).Sequence_Number__c = sqno;
                    }
                }
                for (Contact invCon : invalidContactList) {
                    Integer i = 1;
                    while (i <= totalContact) {
                        if (!conMap.containsKey(i)) {
                            conMap.put(i,invCon);
                            conMap.get(i).Sequence_Number__c = i;
                            break;
                        }
                        i++;
                    }
                }
                conToUpdate.addAll(conMap.values());
            }
            update conToUpdate; 
        }
    }
    
    //After Undelete
    public void afterContactUndelete(List<Contact> newList){
        Map<Integer,Contact> conMap = new Map<Integer,Contact>();
        List<Contact> newContact = new List<Contact>();
        if(isFirstTime == true){
            isFirstTime =false;
            for(Contact con : newList){
                System.debug('newCOn==='+con.LastName+ '  '+con.Sequence_Number__c);
                parentIds.add(con.AccountId);
            }
            if(parentIds.size()>0){
                parentLeadsById = [SELECT ID,Name, (select Id,lastname,Sequence_Number__c from contacts where Id NOT IN : newList) FROM Account where Id IN :parentIds];
                newContact = [SELECT Id,lastname,Sequence_Number__c,AccountId FROM Contact where Id IN : newList];
            }
            if(parentLeadsById.size()>0){
                for(Account acc : parentLeadsById){
                    conMap.clear();
                    for(Contact con : acc.contacts){
                        conMap.put((Integer)con.Sequence_Number__c,con);
                        System.debug('con====='+con.Lastname +'  '+con.Sequence_Number__c);
                    }
                    for(Contact con : newContact){
                        if(acc.Id == con.AccountId){
                            conMap.put(conMap.size()+1,con);
                            conMap.get(conMap.size()).Sequence_Number__c = conMap.size();
                        }
                    }
                    conToUpdate.addAll(conMap.values());
                }
                update conToUpdate;
            }
        }
    }
}