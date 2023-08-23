public class ObjectController {
    
    public String selectedObject {get; set;}
    public List<SelectOption> ObjectNames {get;set;}
    //public List<SelectOption> fieldNames {get;set;}
    Public List<string> notSelectedFields;
    Public List<string> selectedFields{set;get;}
    //To display list of picklist values in the not selected options block by using selectoption predefined class
    Public List<selectoption> notSelectedOptions{set;get;}
    //To display list of picklist values in the selected options block by using selectoption predefined class          
    Public List<selectoption> selectedOptions{set;get;}
    //created a varible to add and remove
    public List<string> selected{set;get;}
    public List<string> removed{set;get;}
    public Map<String , Schema.SObjectField> fieldMap;
    public Boolean processbtn{get;set;}
    
    public ObjectController(){
        ObjectNames =  ObjectNames();
        //memeory allocation for not selected fields
        notSelectedFields = new List<string>();
        //memeory allocation for  selected fields
        selectedFields = new List<String>();
        //memory allocation for selected and removed methods
        selected = new List<String>();
        removed = new List<String>();
        //memeory allocation for not selectedoption
        notSelectedOptions = new List<SelectOption>();
        //memeory allocation for selectedoption
        selectedOptions = new List<SelectOption>();
        processbtn = true;
    }
    
    public List<SelectOption> ObjectNames(){
        List<Schema.SObjectType> schemaList = Schema.getGlobalDescribe().Values();
        List<SelectOption> ObjNames = new List<SelectOption>();
        ObjNames.add(new SelectOption('','--None--'));
        for(Schema.SObjectType schemaList1 : schemaList){
            if(schemaList1.getDescribe().isCustom() || schemaList1.getDescribe().isAccessible() && schemaList1.getDescribe().isCreateable() && schemaList1.getDescribe().isQueryable() && schemaList1.getDescribe().IsUndeletable())
                ObjNames.add(new SelectOption(schemaList1.getDescribe().getName(),schemaList1.getDescribe().getLabel()));
        }
        ObjNames.sort();
        return ObjNames;
    }
    
    public void ObjectFields() {
        notSelectedFields.clear();
        selectedFields.clear();
        List<SelectOption> fieldNames = new List<SelectOption>();
        if(selectedObject != null){
            Map<String , Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();    
            Schema.SObjectType objectSchema = schemaMap.get(selectedObject);
            fieldMap = objectSchema.getDescribe().fields.getMap();
            for(Schema.SObjectField fieldName : fieldMap.Values()){                
                Schema.DescribeFieldResult fieldResult = fieldName.getDescribe();
                if(fieldResult.isAccessible() && fieldResult.isFilterable() && fieldResult.isGroupable() && fieldResult.isSortable()){
                    notSelectedFields.add(fieldResult.getName());
                }
            }
        }
        getOptions();
    }
    
    public void getOptions() {
        notSelectedOptions.clear();
        selectedoptions.clear();
        if(notSelectedFields.size() > 0) {
            for(String str1 : notSelectedFields) {
                SelectOption p1 = new SelectOption(str1,fieldMap.get(str1).getDescribe().getLabel());
                notSelectedOptions.add(p1);
            }
            notSelectedOptions.sort();
        }
        if(selectedFields.size() > 0) {
            for(String str2 : selectedFields) {
                SelectOption p2 = new SelectOption(str2,fieldMap.get(str2).getDescribe().getLabel());
                selectedOptions.add(p2);
            }   
        }
    }
    public PageReference Reset() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL()); 
 		newpage.setRedirect(true);
        return newpage;
    }
    public void add() { 
        if(selectedFields!=null){
            processbtn = false; 
        }
        for(String str : selected){
            notSelectedFields.remove(notSelectedFields.indexOf(str));
        }
        selectedFields.addAll(selected);
        // System.debug('selectedFields=='+selectedFields);
        getOptions();
    }
    public void remove() {
        if(selectedFields==null){
            processbtn  = true;
        }
        for(String str : removed){
            selectedFields.remove(selectedFields.indexOf(str));
        }
        notSelectedFields.addAll(removed);
        getOptions(); 
    } 
}