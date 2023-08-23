({
    init : function(component, event, helper) {
        helper.getAllObjects(component, event, helper);
    },
    allFields : function(component, event, helper){
        //call other( objectChange ) method of same controller
        var a = component.get('c.objectChange');
        $A.enqueueAction(a);
        
        helper.getAllFields(component, event, helper);
    },
    objectChange: function (component, event) {
        component.set('v.selectedField','');
        component.set('v.myData',null);
        component.set('v.myColumns',null);
        component.set('v.page',1);
    },
    allRecords : function(component, event, helper){ 
        component.set("v.processButton", true);
        // get the page Number if it's not define, take 1 as default
        var page = component.get("v.page") || 1;   
        var recordToDisply = 5;
        helper.getAllRecords(component, page, recordToDisply);
    },
    navigate: function(component, event, helper) {
        // this function call on click on the previous page button  
        var page = component.get("v.page") || 1;
        // get the previous button label  
        var direction = event.getSource().get("v.label");
        // get the select option (drop-down) values.  
        var recordToDisply = component.find("recordSize").get("v.value");
        // set the current page,(using ternary operator)  
        page = direction === "Previous" ? (page - 1) : (page + 1);
        // call the helper function       
        helper.getAllRecords(component, page, recordToDisply);
        
    },	
    onSelectChange: function(component, event, helper) { 
        // this function call on the select opetion change,     
        var page = 1
        var recordToDisply = component.find("recordSize").get("v.value");
        helper.getAllRecords(component, page, recordToDisply);
    },
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
    
    //This method will keep record of all selected rows
    onRowSelection : function(component, event, helper) {
        // Avoid any operation if page has changed
        // as this event will be fired when new data will be loaded in page 
        // after clicking on next or prev page
        if(!component.get("v.hasPageChanged") || component.get("v.initialLoad")){
			//set initial load to false
            component.set("v.initialLoad", false);
            //Get currently select rows, This will only give the rows available on current page
            var selectedRows = event.getParam('selectedRows');
            
            //Get all selected rows from datatable, this will give all the selected data from all the pages
            var allSelectedRows = component.get("v.selection");
            
            //Get current page number
            var currentPageNumber = component.get("v.pageNumber");
            
            //Process the rows now
            //Condition 1 -> If any new row selected, add to our allSelectedRows attribute
            //Condition 2 -> If any row is deselected, remove from allSelectedRows attribute
            //Solution - Remove all rows from current page from allSelectedRows attribute and then add again
    
            //Removing all rows coming from curent page from allSelectedRows
            var i = allSelectedRows.length;
            while (i--) {
                var pageNumber = allSelectedRows[i].split("-")[1];
                if (pageNumber && pageNumber == currentPageNumber) { 
                    allSelectedRows.splice(i, 1);
                } 
            }
            
            //Adding all the new selected rows in allSelectedRows
            selectedRows.forEach(function(row) {
                allSelectedRows.push(row.Id);
            });
            
            //Setting new value in selection attribute
            component.set("v.selection", allSelectedRows);
        } else{
             component.set("v.hasPageChanged", false);
        }
    },
})