global with sharing class ServerSidePagination {
    
    @AuraEnabled                                                                                                                                                                                                                                                                                             
    //Method to get the List of All Objects
    public static String fetchObjectList(){
        List <wrapperClass> wrapperRecordList = new List<wrapperClass>();
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();
        for(SObjectType sot:gd){
            Schema.DescribeSObjectResult describeSObjectResultObj = sot.getDescribe();
            if(describeSObjectResultObj.isQueryable() && describeSObjectResultObj.isUpdateable() && describeSObjectResultObj.isAccessible() && describeSObjectResultObj.isCreateable()){
                wrapperClass wrapperObj = new wrapperClass ();
                String label = describeSObjectResultObj.getLabel();
                if(describeSObjectResultObj.getName().endsWith('__c') || label == 'Account' || label == 'Campaign' || label == 'Asset' || label == 'Case' || label == 'Contact' || label == 'Contract' || 
                   label == 'Idea' || label == 'Lead' || label == 'Opportunity' || label == 'Order' || label == 'Product2' || label == 'Solution' || label ==   'User'){
                       wrapperObj.label = describeSObjectResultObj.getLabel();
                       wrapperObj.apiName = describeSObjectResultObj.getName();
                       wrapperRecordList.add(wrapperObj);
                   }	
            }
        }
        wrapperRecordList.sort();
        return json.serialize(wrapperRecordList);
    }
    
    @AuraEnabled
    public static String getObjectFields(String selectedObject) {
        List <wrapperClass> wrapperRecordList = new List<wrapperClass>();
        
        Map<String, String> allFields = new Map<String, String>();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
        for (Schema.SObjectField fieldName: fieldMap.Values()) {  
            Schema.DescribeFieldResult fieldResult = fieldName.getDescribe();
            if(fieldResult.isAccessible() && fieldResult.isFilterable() && fieldResult.isGroupable() && fieldResult.isSortable()){
                // allFields.put(fieldResult.getName(), fieldResult.getLabel());
                wrapperClass wrapperObj = new wrapperClass ();
                wrapperObj.label = fieldResult.getLabel();
                wrapperObj.apiName = fieldResult.getName(); 
                wrapperRecordList.add(wrapperObj);    
            }  	
        }
        //System.debug(wrapperRecordList);
        wrapperRecordList.sort();
        return json.serialize(wrapperRecordList);
        //return allFields;
    }
    
    @AuraEnabled
    public static wrapperClass getAllRecords(String selectedObject,List<String> selectedFields ,Integer pageNumber,Integer recordToDisply){
        Integer pageSize = recordToDisply;
        Integer offset = (pageNumber - 1) * pageSize;
        
        wrapperClass wrapperObj;
        if(selectedObject != null && selectedFields != null){
            String s1 = 'SELECT ';
            String s3='';
            for(string s2 : selectedFields) {
                s1 +=s2 + ',';                                           
            }   
            s1 = s1.substring(0, s1.length()-1);         
            s1 += ' FROM ' + selectedObject +  ' LIMIT ' + pageSize + ' OFFSET '+ offset; 	
            
            //Removing single quotes from the query
            s3 = String.escapeSingleQuotes(s1);
            
            String temp = 'select count() from ' + selectedObject;
            integer  count= database.countQuery(temp);
            
            wrapperObj= new wrapperClass();
            wrapperObj.pageSize = pageSize;
            wrapperObj.page = pageNumber;
            
            wrapperObj.recordList=Database.query(s3);
            wrapperObj.total = count;
        }
        return wrapperObj;
    }   

    global class wrapperClass implements Comparable{
        
        @AuraEnabled global String label;
        @AuraEnabled global String apiName;
        
        @AuraEnabled global Integer pageSize;
        @AuraEnabled global Integer page;
        @AuraEnabled global Integer total;
        @AuraEnabled global List<sObject> recordList;
        
        global Integer compareTo(Object ObjToCompare) { 
            return label.CompareTo(((wrapperClass)ObjToCompare).label);
        }   
    }
}