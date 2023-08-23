global class CustomKanabanView {
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
        //Use compareTo method of Comparable interface for sorting
        wrapperRecordList.sort();
        return json.serialize(wrapperRecordList);//Convert Object to String
    }
    
    @AuraEnabled
    public static String getObjectFields(String selectedObject) {
        List <wrapperClass> wrapperRecordList = new List<wrapperClass>();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
        for (Schema.SObjectField fieldName: fieldMap.Values()) {
            Schema.DescribeFieldResult fieldResult = fieldName.getDescribe();
            Schema.DisplayType theResult = fieldMap.get(fieldResult.getName()).getDescribe().GetType(); //get field type          
            if (theResult == Schema.DisplayType.Picklist){//if it's a picklist
                wrapperClass wrapperObj = new wrapperClass();
                wrapperObj.label = fieldResult.getLabel();
                wrapperObj.apiName = fieldResult.getName(); 
                wrapperRecordList.add(wrapperObj);
            }      
        }
        wrapperRecordList.sort();
        return json.serialize(wrapperRecordList);
    } 
    
    @AuraEnabled
    public static kanbanWrap getRecordsAndPickListValues(String objName, String kanbanField) {
        List<String> lstPickvals=new List<String>();
        lstPickvals.add('--None--');
        for (Schema.PicklistEntry a : Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(kanbanField).getDescribe().getPickListValues())
            lstPickvals.add(a.getValue());
        System.debug('lstPickvals=='+lstPickvals);
        
        /*String query = 'SELECT Id, ';
for(String s:objFields){
query += s+' ,';
}
query = query.removeEnd(',');   
query += ' FROM ' + objName;
*/
        String query = objName == 'case' ? 'SELECT CaseNumber,' : 'SELECT 	Name,';
       
        query += 'CreatedDate,'+kanbanField+' FROM ' + objName;
        return new kanbanWrap(Database.query(query), lstPickvals);
    }  
    @AuraEnabled
    public static String getUpdateStage(Id recId, String kanbanField, String kanbanNewValue) {
        SObject obj = recId.getSObjectType().newSObject(recId);
        obj.put(kanbanField,kanbanNewValue);
        update obj;
        return 'Success';
    }
    public class kanbanWrap{
        @AuraEnabled
        public List<sObject> records {get;set;}
        @AuraEnabled
        public List<String> pickVals {get;set;}
        
        public kanbanWrap(List<sObject> recs, List<String> pVals){
            this.records = recs;
            this.pickVals = pVals;
        }
    }  
    global class wrapperClass implements Comparable{
        @AuraEnabled global String label;
        @AuraEnabled global String apiName;
        
        global Integer compareTo(Object ObjToCompare) { 
            return label.CompareTo(((wrapperClass)ObjToCompare).label);
        }   
    }
}