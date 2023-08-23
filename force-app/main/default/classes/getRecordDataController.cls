public with sharing class getRecordDataController {
       
@AuraEnabled(cacheable=true)
public static List<SObjectResult> getAccounts(String ObjectName, String fieldName, String value, List<String> selectedRecId) {
    List<SObjectResult> sObjectResultList = new List<SObjectResult>();
    if(selectedRecId == null)
        selectedRecId = new List<String>();

    if(String.isNotEmpty(value)) {
        String query = 'Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value.trim() + '%\' and ID NOT IN: selectedRecId';
        System.debug('query==='+query);
        List<Account> accListt = Database.query(query);
        System.debug('accListt=='+accListt);
        for(sObject so : Database.Query(query)) {
            System.debug('so==='+so);
            String fieldvalue = (String)so.get(fieldName);
            sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
        }
    }
    return sObjectResultList;
}

public class SObjectResult { 
    @AuraEnabled
    public String recName;
    @AuraEnabled
    public Id recId;
    
    public SObjectResult(String recNameTemp, Id recIdTemp) {
        recName = recNameTemp;
        recId = recIdTemp;
    }
}
}