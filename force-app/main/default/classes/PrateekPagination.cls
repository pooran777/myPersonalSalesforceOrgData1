public class PrateekPagination {
    public string Standardcontrollerobjects{get;set;}
    public List<SelectOption>objects {set;get;}
    public List<SelectOption> fsoptions {set;get;}
    public List<SelectOption>fnsoptions {set;get;}
    public List<String>objList {set;get;}
    public Map<String,Schema.SObjectType> mobjects {set;get;}
    public Map<String,Schema.SObjectField>mfields;
    public List<String> fields{set;get;}
    public Boolean tick{get;set;}
    public set<String> fselected{set;get;}
    public set <String>fnotselected{set;get;}
    public String selectedobj{set;get;}
    public List<String> sfields{set;get;}
    public List<String> rfields{set;get;}
    // public List<String> sobjects{get;set;}
    public Boolean check{get;set;}
    public Boolean checkfornone{set;get;}
    public Boolean checkforadd{set;get;}
    public List <String>StandardcontrollerobjectsList{get;set;}
    public List<String>fselectedlist{get;set;}
    public List<String>fieldsname{get;set;}
    public Map<String,String> fieldmap{get;set;}
    public List<String> selectedFieldApi{get;set;}
    public Boolean condition{get;set;}
    public Boolean checkprocess{get;set;}
    public Boolean showcomponent{get;set;}
    public Boolean hidebuttons{get;set;}
    
    public PrateekPagination(){ 
        showcomponent=false;
        hidebuttons=false;
        Standardcontrollerobjects=System.Label.StandardObjectsCustomLabels;
        tick=false;  
        condition=false;
        selectedFieldApi=new List<String>();
        fselectedlist=new List<String>();
        fieldmap=new Map<String,String>();
        StandardcontrollerobjectsList=Standardcontrollerobjects.split(',');
        check=true;
        checkforadd=false;
        checkfornone=false;
        checkprocess=true;
        
        //  sobjects=new List<String>();
        objects = new List<SelectOption>();
        objList = new List<String>();
        sfields = new List<String>();
        rfields = new List<String>();
        fields = new List<String>();
        fieldsname=new List<String>();
        fselected = new set<String>();
        fnotselected = new set<String>();
        fsoptions = new List<SelectOption>();
        fnsoptions = new List<SelectOption>();
        mobjects = Schema.getGlobalDescribe(); 
        objList.addAll(mobjects.keySet());
        objList.sort();
        for(String ss: StandardcontrollerobjectsList){
            objects.add(new Selectoption(ss,ss));
        }
        // objects.add(new SelectOption('None','None'));
        for(String s : objlist){
            // Set<String> desiredStandardObjects = new Set<String>{'Account','User','Contact','Opportunity'};
            
            Schema.DescribeSObjectResult  sobjectDescribe = mobjects.get(s).getDescribe();
            if((sobjectDescribe.isCustom() && !sobjectDescribe.getName().contains('ChangeEvent')) &&(objects.size()<1000)){
                String s1=sObjectDescribe.getName() ;//.replace('__c','');
                objects.add(new SelectOption(s1 ,sObjectDescribe.getLabel())); 
            }     
        }        
        
    }
    
    Public void details(){
        system.debug('selectedobj2346u');
        hidebuttons=true;
        showcomponent=false;
        fnotselected.clear();
        fselected.clear();
        checkfornone=true;
        fnsoptions.clear();    
        fsoptions.clear();
        mfields = mobjects.get(selectedobj).getDescribe().fields.getMap();
        condition=true;      
        fields.clear();
        for(String s1:mfields.keySet()){
            Schema.DescribeFieldResult result=mFields.get(s1).getDescribe(); 
            fields.add(result.getLabel());
            fieldmap.put(result.getLabel(),s1);
        }
        fnotselected.addAll(fields);
        show();
    }
    public void show(){
        fnsoptions.clear();
        fsoptions.clear();
        for(String s : fnotselected ){
            SelectOption op = new SelectOption(s,s);
            fnsoptions.add(op);
        }
        for(String s1 : fselected){
            fselectedlist.add(s1);
            selectoption op1 = new SelectOption(s1,s1);
            fsoptions.add(op1);
            for(String s:fselectedlist){
                selectedFieldApi.add(fieldmap.get(s));
            }
        }
        if(!sfields.isEmpty()){
            check=false;
        }
        if(!rfields.isEmpty()){
            check=false;
        }
    }
    
    public void resetall(){
        if(fnotselected.size()>0){
            fnotselected.clear();
        }
        fselected.clear();
        checkfornone=false;
        selectedobj='none';
        condition=false;
        hidebuttons=false;
        showcomponent=false;
        checkprocess=false;
    }
    public void resetshowcomponent(){
        system.debug('selectedobj=='+selectedobj);
        showcomponent=true;
        checkprocess=true;
    }
    public void addFields(){ 
        selectedFieldApi.clear();
        fnotselected.removeAll(sfields);
        System.debug(fnotselected);
        fselected.addAll(sfields);
        if(!fselected.isEmpty()){
            checkprocess=false;
        }
        show();
    }
    public void removeFields(){
        
        fnotselected.addAll(rfields);
        fselected.removeAll(rfields);
        show();
    }
    
    public void ResetFieldsList(){
        fnsoptions.clear();
        fsoptions.clear();
    }
    public void resetCheck(){
        check=false;
        tick=true;
    }
    public void resetcheckforadd(){
        checkforadd=true;
    }  
}