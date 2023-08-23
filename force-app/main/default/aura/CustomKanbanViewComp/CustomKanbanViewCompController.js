({
    init : function(component, event, helper) {  
        helper.getAllObjects(component, event, helper);
    },
    allFields : function(component, event, helper){
        helper.getAllFields(component, event, helper);
        component.set('v.kanbanPicklistField','');
        component.set('v.pickValues',[]);
        component.set('v.recordsList',[]);
        
    },
    fieldChange: function (component, event) {                
        component.set('v.pickValues',[]);
        component.set('v.recordsList',[]);
    },
    
    KanbanViewOfRecords: function(component, event, helper) {
        var action = component.get("c.getRecordsAndPickListValues");  
        console.log('kanbanpicjlist==='+component.get("v.kanbanPicklistField"));
        action.setParams({
            "objName":component.get("v.selectedObject"),
            "kanbanField":component.get("v.kanbanPicklistField")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                //component.set("v.kanbanData", response.getReturnValue());             
                var  pickListFieldVals = [];
                var allrecords = [];
                pickListFieldVals = response.getReturnValue().pickVals;
                allrecords = response.getReturnValue().records;
                component.set("v.recordsList",allrecords);
                //component.set("v.pickValues",pickListFieldVals);
                var temp = component.get("v.kanbanPicklistField");
                console.log('temp==',temp);
                console.log('result==',allrecords);

                  console.log('pickListFieldVals==',pickListFieldVals);
                
                //Use in condition in componenet("{!pickVal == objRecord.pickList}")(Dynamically bind)
                //forEach with Arrow Function
                allrecords.forEach(element => {
                    element.pickList = element[temp]
                    if(element.pickList == null)
                        element.pickList = '--None--';
                });  

                var list = [];
                //Convert each string into object form 
                pickListFieldVals.forEach(ele1 =>{
                    list.push({Name : ele1});
                });
                console.log('list==',list);
                list.forEach(ele1 => {
                    console.log(ele1);
                    var count= 0;
                    allrecords.forEach(ele2 =>{
                        if(ele1.Name == ele2.pickList)
                            count++;
                    });
                    ele1.ct = count; 
                });
                console.log('count111111==',list);
                component.set("v.pickValues",list);
            }
        });
            $A.enqueueAction(action);
    },
                    
    navigateRecord: function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:navigateToSObject");
        editRecordEvent.setParams({
            "recordId": event.target.id
        });
        editRecordEvent.fire();
    },
    allowDrop: function(component, event, helper) {
        //Cancels the event if it is cancelable,
        //Exa:Clicking on a "Submit" button, prevent it from submitting a form
        event.preventDefault();
    },
    drag: function (component, event, helper) {
        //dataTransfer.setData(format, data)
        event.dataTransfer.setData("text", event.target.id);
    },
    
    drop: function (component, event, helper) {
        event.preventDefault();
        // Id of particular record which is droped,in data variable
        var data = event.dataTransfer.getData("text");
        var tar = event.target;
        
        //add the record where we drop    
        tar.appendChild(document.getElementById(data));
        //Call another method of same controller
        var temp = component.get('c.KanbanViewOfRecords');
        $A.enqueueAction(temp);
        
        console.log('1==   :   ' + tar.getAttribute('data-Pick-Val'));
        //document.getElementById(data).style.backgroundColor = "#ffb75d";
        helper.updatePicklistValue(component,data,component.get("v.kanbanPicklistField"),tar.getAttribute('data-Pick-Val'));
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
})