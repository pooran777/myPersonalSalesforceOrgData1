public class PrateekPaginationComponent {
    public List<List<sobject>> mylist{get;set;}
    public String alphabetString{get;set;}
    public String query{get;set;}
    public List<String> fieldselect{get;set;} 
    public String selectedobject{get;set;}
    public List<sobject> records{get;set;}
    public Integer recperpage{get;set;}
    public Integer recordshow{get;set;}
    public Integer pn {get;set;}
    public Integer total {get;set;}
    public Integer i;
    public List<String> Fieldname{get;set;}
    public Integer j;
    public String Alphabet{get;set;}
    public String queryString{get;set;}
    public Boolean disable_last{get;set;}
    public Boolean disable_next{get;set;}
    public List<sobject> records_total{get;set;}
    public Boolean disable_previous{get;set;}
    public Boolean nextprevious{get;set;}
    public Integer skiprecords;
    public Boolean disable_first{get;set;}
    public Integer pagenumber{get;set;}
    public Boolean checkboxselect{get;set;}
    public Boolean masterselected{get;set;}
    public String selectedrowid{get;set;}
    public String string_of_skiprecords;
    public Boolean disable_name{get;set;}
    public String test{get;set;}
    public List<sobject> namelist{get;set;}
    public List<WrapperClass> wrapperRecordList{get;set;}
    public Set<Id> idSet{get;set;}
    public String alpha{get;set;}
    public List <String> ListOFAlphabets{get;set;}
    public String queryTemp{get;set;}
    public Integer nm;
    public Boolean sortCol;
    public String FieldForSort{get;set;}
    public Integer show{get;set;}
    public String csvString{get;set;}
    public ApexPages.StandardSetController setcon{get;set;}	     
    public PrateekPaginationComponent(){
        System.debug('Inside component constructor >>>>>>>>>>>>>>>>> '+selectedobject);
        WrapperRecordList=new List<WrapperClass>();
        ListOfAlphabets=new List<String>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','Other','All'};
            nm=0;
        
        records=new List<sobject>();
        //a records=[SELECT ID FROM Account];
        sortCol=false;
        fieldname=new List<String>();
        fieldname.add('name');
        fieldselect=new List<String>();
        disable_last=false;
        recordshow=5;
        i=0;
        disable_previous=true;
        disable_first=true;
        skiprecords=0;
        checkboxselect=false;
        masterselected=false;
        recperpage=5;
        j=0;
        nextprevious=false;
        pagenumber=1;
        disable_next=false;
        disable_name=true;
        namelist=new List<sobject>();
        
        // mapHoldingSelectedRecords=new Map<Id,WrapperClass>();
        WrapperRecordList=new List<WrapperClass>();
        idset=new Set<Id>();	       	
        // selectedrowid=ApexPages.currentPage().getParameters().get('!deletethis');
    }    
    public void init(){
        WrapperRecordList.clear();
        
        
        for(Sobject sobj:setCon.getRecords()){
            
            if(idset.contains(sobj.id)){
                WrapperRecordList.add(new WrapperClass(sobj,true));
            }
            else{
                WrapperRecordList.add(new WrapperClass(sobj,false));
            }
            System.debug('WrapperClassList'+wrapperRecordList);
            
        } 
    }
    public void deleterecords(){
        for(Integer i=0; i < records.size(); i++){
            Sobject obb=records.get(i);
            if(obb.id==selectedrowid){
                delete obb;
                records.remove(i);
                break;
            }
        }       
    }
    private void updateSearchItemsMap() {
        System.debug(wrapperRecordList);
        for(WrapperClass wrp : wrapperRecordList){
            if(wrp.isSelected == true){
                idset.add(wrp.SObjectRecord.Id);
                
            }
            else if(idset.contains(wrp.Sobjectrecord.id) && wrp.isSelected == false){
                idset.remove(wrp.SObjectRecord.ID);
                System.debug('Not Working fine set'+idset);
            }
        }
        System.debug(idset);
        //	System.debug('Update method main se aari hai'+mapHoldingSelectedRecords );
    }
    public void Last(){
        Integer l;
        setcon.last();
        // string_of_skiprecords=String.valueOf(records_total.size()-Integer.valueOf(recperpage));
        
        pagenumber=show;
        updateSearchItemsMap();
        
        records=setcon.getRecords();
        
        
        disable_last=true;
        disable_next=true;
        disable_previous=false;
        disable_first=false;
        
        init();
    }
    public void mastercheckbox(){
        if(checkboxselect==false){
            checkboxselect=true;
        }
        else
        {
            checkboxselect=false;
        }
    }
    public void pageJump(){
        
        if(pageNumber <= 0){
            pageNumber = 1;
        }
        
        if(pageNumber <= (setcon.getResultSize() / setcon.getPageSize())+1){
            setcon.setPageNumber(pageNumber);
        }
        else if((pageNumber > (setcon.getResultSize() / setcon.getPageSize())+1) ){
            pageNumber = 1;
            setcon.setPageNumber(1);
        }
        
        setcon = new Apexpages.StandardSetController(Database.getQueryLocator(query));
        
        setcon.setPageSize(recperpage);
        
        show=total/getPageSize()+1;
        updateSearchItemsMap();
        setcon.setPageNumber(pageNumber);
        
        init();
    }
    
    
    
    public void first(){     
        setcon.first();
        pn=1;
        updateSearchItemsMap();
        records=setcon.getRecords();
        pagenumber=1;
        disable_previous=true;
        disable_last=false;
        disable_next=false;
        disable_first=true; 
        
        init();
    }
    public void alphabeticmethod(){
        
        if((selectedObject == 'Case')){
            String queryStr = query;
            if(Alphabet != 'All'){
                queryStr = queryStr+' WHERE Reason Like \''+ Alphabet+'%\'';
                setcon = new apexpages.StandardSetController(database.getQueryLocator(queryStr));
                setcon.setPageSize(recperpage);
            }
            else if(Alphabet == 'All'){
                setcon = new apexpages.StandardSetController(database.getQueryLocator(queryStr));
                setcon.setPageSize(recperpage);
            }
            else{
                setcon = new apexpages.StandardSetController(Database.getQueryLocator(queryStr));
                setcon.setPageSize(recperpage);
            }
            
        }
        else if((selectedObject == 'Solution')){
            String queryTemp = query;
            if(Alphabet != 'All'){
                queryTemp = queryTemp+' WHERE SolutionName Like \''+ Alphabet +'%\''; 
                setcon = new apexpages.StandardSetController(database.getQueryLocator(queryTemp));
                setcon.setPageSize(recperpage);
            }
            else if(Alphabet == 'All'){
                setcon = new apexpages.StandardSetController(database.getQueryLocator(queryTemp));
                setcon.setPageSize(recperpage);
            }
            else{
                setcon = new apexpages.StandardSetController(Database.getQueryLocator(queryTemp));
                setcon.setPageSize(recperpage);
            }
        }
        else{
            WrapperrecordList.clear();
            queryTemp=query;
            if(Alphabet != 'all'){    
                setcon.setPageSize(getPageSize());
                queryTemp=queryTemp+' WHERE Name LIKE \''+ alphabet +'%\'';
                setcon = new ApexPages.StandardSetController(Database.getQueryLocator(queryTemp));             
            }   	
        }    
        for(sObject sobj:setcon.getRecords()){      
            WrapperRecordList.add(new WrapperClass(sObj,false));
        }
    }
    public void CSVDownlaod(){
        
        csvString = String.join(fieldselect,' , ') + '\\n';
        System.debug(csvString);
        for(WrapperClass wrpc : wrapperRecordList) {
            if(wrpc.isSelected == true){
                sObject sobjss = wrpc.Sobjectrecord;
                for(integer i=0; i< fieldselect.size(); i++) {
                    if(sobjss.get(fieldselect[i]) == null){
                        csvString += ''+',';
                    }
                    else{
                        csvString += (sobjss.get(fieldselect[i])) + ' , ';
                    }
                }
                csvString += '\\n';
                System.debug(csvString);
            }
        }
    }
    public void SortColumn(){
        
        System.debug(FieldForSort);
        String Tempquery=query;
        if(sortCol==false){
            Tempquery=Tempquery + ' ORDER BY '+FieldForSort +' ASC ';
            sortCol=true;
        }
        else{
            Tempquery=Tempquery + ' ORDER BY '+FieldForSort +' DESC ';
            sortCol=false;
            System.debug('Condition not running');
        }
        setcon=new apexPages.StandardSetController(database.query(Tempquery));
        setcon.setPageSize(getPageSize());
        WrapperrecordList.clear();
        for(sObject sobj:setcon.getRecords()){
            
            WrapperRecordList.add(new WrapperClass(sObj,false));
        }
        
    }
    public Integer getPageSize(){
        Integer n= Integer.valueOf(recperpage);
        return n;
    }
    public void Query(){
        system.debug('selectedobject=='+selectedobject);
        query=null;
        records.clear();
        show=5;
        Set<String> fieldset=new Set<String>();
        for(String s1:fieldselect){
            fieldset.add(s1);
        }
        fieldselect.clear();
        for(String s2:fieldset ){
            fieldselect.add(s2);
        }   
        //  if(query==null){            
        for(String s:fieldselect){
            fieldname.clear();		
            if(query==null){
                query='SELECT '+s;                 
            }
            else{
                query=query+','+s;
            }
        }
        query=query+' FROM '+selectedobject;
        setcon=new Apexpages.StandardSetController(Database.getQueryLocator(query));  
        
        setcon.setPageSize(getPageSize());
        total=setcon.getResultSize();
        show=(setcon.getResultSize()/Integer.valueOf(recperpage))+1;
        
        records=Database.query(query);
        //	records=setcon.getRecords();
        System.debug('records :: '+records);
        WrapperRecordList=new List<WrapperClass>();
        for(Sobject sob:setcon.getRecords()){
            WrapperRecordList.add(New WrapperClass(sob,false));
        }	
        
    } 
    public void Next(){
        i++;
        disable_first=false;
        
        
        setcon.next();
        pagenumber++;     
        updateSearchItemsMap();
        records=setcon.getRecords();
        wrapperRecordList.clear();
        if(pagenumber==show){
            disable_next=true;
            disable_last=true;
            
        }
        disable_previous=false; 
        disable_first=false;
        init();    
    }
    public PageReference Create(){
        PageReference pr=new PageReference('/lightning/o/'+SelectedObject+'/new?count=1&nooverride=1&useRecordTypeCheck=1&navigationLocation=LIST_VIEW&uid=167984582514616414&backgroundContext=%2Flightning%2Fo%2F'+selectedobject+'%2Flist%3FfilterName%3DRecent');   
        pr.setRedirect(true);
        return pr;
    }
    public void recordSize(){
        updateSearchItemsMap();
        setcon.setPageSize(recperpage);
        records=setcon.getRecords();
        wrapperRecordList.clear();
        show=(setcon.getResultSize()/Integer.valueOf(recperpage))+1;
        
        init();
    }
    public void previous(){
        updateSearchItemsMap();
        setcon.previous();
        pagenumber--;      
        records=setcon.getRecords();
        if(pagenumber==1)
        {
            disable_previous=true;
            disable_first=true;
        }
        if(pagenumber<show){
            disable_last=false;
            disable_next=false;
        }
        
        wrapperRecordList.clear();   
        init();
    }
    public void deleteselectedrecord(){
        updateSearchItemsMap();
        
        if( idSet.size() != 0 ){
            String tempquery = query + ' WHERE ID IN :idSet';
            System.debug(tempquery);
            List<sObject> sObjectList = Database.query(tempquery);
            try{
                delete sObjectList;
            }
            catch(DMLException e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error,'Related records cant be deleted having closed won');
                ApexPages.addMessage(myMsg);
            }
            sObjectList.clear();
        }
        System.debug(recperpage);
        
        setcon = new Apexpages.StandardSetController(Database.getQueryLocator(query));
        setcon.setPageSize(recperpage);
        setcon.setPageNumber(pageNumber);
        init();
    }
    public class WrapperClass{
        public Boolean isSelected {get;set;}
        public Sobject Sobjectrecord{get;set;}
        public WrapperClass(Sobject Sobjectrecord, Boolean isSelected){
            this.Sobjectrecord=Sobjectrecord;
            this.isSelected=isSelected;
        }
    }   
}