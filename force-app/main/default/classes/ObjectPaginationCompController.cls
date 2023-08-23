public class ObjectPaginationCompController {
    
    
    public String selectedObject{get;set;}
    public List<String> selectedFields{get;set;}
    public List<SObject> recordList{get;set;}
    public List<SObject> recordList1;
    Public Boolean ShowpageBlock{get;set;}
    public List<SObject> SObjectRecords{get;set;}
    public ApexPages.StandardSetController setCon{get;set;}
    public String s3;
    
    Public Integer size{get;set;} 
    Public Integer noOfRecords{get; set;} 
    public List<SelectOption> paginationSizeOptions{get;set;}
    
    
    public List <WrapperClass> wrapperRecordList{get;set;}
    Map<Id, WrapperClass> mapHoldingSelectedRecords{get;set;}
    
    public String SelectedId {get;set;}
    
    public List<String> alphaList {get; set;}
    public String alphaSearch{get;set;}  
    
    public String sortField{get;set;}
    public String sortDir;
    
    public String keyPrefixOfObject{get;set;}
    
    public String csvFile{get;set;} 
    
    public ObjectPaginationCompController(){
        size=5;
        ShowpageBlock = false;
        SObjectRecords = new List<SObject>();                                
        sortDir = 'Desc';
        mapHoldingSelectedRecords = new Map<Id, WrapperClass>();
        paginationSizeOptions = new List<SelectOption>(); 
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));                                   
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
        
        // initialization alpha list
        alphaList = new list<string>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','Others','All'};
            //csvFile = '';
    }
    
    //To update sObject list as per the alphabet selected by the user
    public void sortAlphabetically(){                                                        
        if (alphaSearch=='All'){
            System.debug('recordList==='+recordList.size());
            recordList = Database.query(s3);
        }
        else{
            String s4 = s3;
            recordList1 = recordList;
            s4 = s4 +  ' WHERE Name'+ ' Like \'' + alphaSearch + '%\'' ;   	
            
            //System.debug('alphaSearch==='+alphaSearch);
            recordList = Database.query(s4);  
            if(recordList.isEmpty()){
                recordList = recordList1;
            }
        }
        setCon = new ApexPages.StandardSetController(recordList);
        SObjectRecords();
    }		    
    
    public void fieldvalues(){
        
        recordList = new List<SObject>();
        
        if(selectedObject != null && selectedFields != null){
            String s1 = 'Select ';
            for(string s2 : selectedFields) {
                s1 +=s2 + ',';                                           
            }   
            s1 = s1.substring(0, s1.length()-1);         
            s1 += ' from ' + selectedObject;	
            //Removing single quotes from the query
            s3 = String.escapeSingleQuotes(s1);
            recordList=Database.query(s3);
            setCon = new ApexPages.StandardSetController(recordList); 
            setCon.setPageSize(size);  
            noOfRecords = setCon.getResultSize();
            ShowpageBlock = true;
            SObjectRecords();
            // Prefix value of an object
            schema.SObjectType sObjType = schema.getGlobalDescribe().get(selectedObject);
            keyPrefixOfObject = sObjType.getDescribe().getKeyPrefix();
        }          
    }  
    
    public void sortByFields(){
        if(sortField == null){
            sortField='Name';
        }
        String s5 = s3;
        sortDir = sortDir.equals('Asc') ? 'Desc' : 'Asc';
        s5 = s5  + ' order by '+sortField + ' ' + sortDir ;
        System.debug('s5=='+s5);
        recordList = Database.query(s5);
        setCon = new ApexPages.StandardSetController(recordList);
        setCon.setPageSize(size);  
        noOfRecords = setCon.getResultSize();
        SObjectRecords();
    }
    
    //Changes the size of pagination
    public void refreshPageSize() {
        setCon.setPageSize(size);      
        SObjectRecords();
    }
    
    public void SObjectRecords() {
        wrapperRecordList = new List<WrapperClass>(); 
        for (SObject sObj : (List<SObject>) setCon.getRecords()) {
            if(mapHoldingSelectedRecords != null && mapHoldingSelectedRecords.containsKey(sObj.id)){
                wrapperRecordList.add(mapHoldingSelectedRecords.get(sObj.id));   
            }
            else{
                wrapperRecordList.add(new WrapperClass(sObj));
            }
        }  
    }   
    
    // returns the first page of the page set
    public void first() {
        updateSearchItemsMap();
        setCon.first();
        SObjectRecords();
    }
    
    // returns the last page of the page set
    public void last() {
        updateSearchItemsMap();
        setCon.last();
        SObjectRecords();
    }
    
    // returns the previous page of the page set
    public void previous() {
        updateSearchItemsMap();
        setCon.previous();
        SObjectRecords();
    }
    
    // returns the next page of the page set
    public void next() {
        updateSearchItemsMap();
        setCon.next();
        SObjectRecords();
    }
    
    //This is the method which manages to remove the deselected records, and keep the records which are selected in map.
    private void updateSearchItemsMap() {
        for(WrapperClass wrp : wrapperRecordList){
            if(wrp.isSelected){
                mapHoldingSelectedRecords.put(wrp.record.id, wrp);
            }
            if(wrp.isSelected == false && mapHoldingSelectedRecords.containsKey(wrp.record.id)){
                mapHoldingSelectedRecords.remove(wrp.record.id);
            }
        }
    }
    
    //wrapper class being used for checkbox showing.
    public class WrapperClass {
        public Boolean isSelected {get;set;}
        public SObject record {get;set;}
        public WrapperClass(SObject record) {
            this.record = record;
            this.isSelected = false;
        }
    }
    
    //Inline delete
    public void deleteRecord(){
        Database.delete(SelectedId);
        fieldvalues();
    }
    
    Public List<sObject> del;
    // Delete All Seleted
    public void deleteSelected(){
        del=new List<sObject>();
        for(WrapperClass cc: wrapperRecordList){
            if(cc.isSelected){
                del.add(cc.record);
            }
        }
        delete del;  
        fieldvalues();
    }
    
    public void downloadCSV() {
        List<SObject> selectedRecord =new List<SObject>();
        if(selectedFields.size()>0){
            csvFile = String.join(selectedFields,',');
        }
        csvFile = csvFile + '\\n';
        for(WrapperClass wrp : wrapperRecordList){
            if(wrp.isSelected){
                selectedRecord.add(wrp.record);    
            }
        }
        System.debug('size=='+selectedRecord.size());
        Integer count = 0;
        for(Integer i=0;i<selectedRecord.size();i++){
            count++;
            for(String str: selectedFields){
                str = selectedRecord[i].get(str) + '';
                csvFile += str + ',';
            }
            csvFile = csvFile.removeEnd(','); 
            csvFile = csvFile + '\\n';
        }
        System.debug('===='+count);
    } 
}