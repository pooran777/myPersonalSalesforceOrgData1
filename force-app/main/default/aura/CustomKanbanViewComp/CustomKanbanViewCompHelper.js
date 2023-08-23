({
    getAllObjects: function(component, event, helper) {
        var action = component.get("c.fetchObjectList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {        
                //Convert String to Object   
                var allValues =  JSON.parse(response.getReturnValue());
                var listofObjects = [];
                for(var i =0 ; i<allValues.length ;i++){
                    listofObjects.push({ value:allValues[i].apiName, label:allValues[i].label});
                }
                component.set("v.allObject",  listofObjects);
            }                    
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {                       
                        console.log("Error message: " + errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getAllFields : function(component, event, helper) {
        var action = component.get('c.getObjectFields'); 
        action.setParams({
            selectedObject: component.get('v.selectedObject')
        });
        
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if (state === "SUCCESS" || state === "DRAFT") {  
                var listOfFields = JSON.parse(response.getReturnValue());
                var options= [];
                for(var i =0 ; i<listOfFields.length ;i++){
                    options.push({ value:listOfFields[i].apiName, label:listOfFields[i].label});
                }
                
                component.set('v.allField', options);
            }
            else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
            }else if (state === "ERROR") {
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }  
        });
        $A.enqueueAction(action);
    },
    
    updatePicklistValue : function(component, recId, picklistField, picklistVal) {
        var action = component.get("c.getUpdateStage");
        action.setParams({
            "recId":recId,
            "kanbanField":picklistField,
            "kanbanNewValue":picklistVal
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") { 
                //Set background color       
                document.getElementById(recId).style="background-color:limegreen;";
                //milliseconds to display background color (1 Sec = 1000 MilliSeconds)
                setTimeout(function(){ document.getElementById(recId).style.backgroundColor = ""; }, 400);
            }
        });
        $A.enqueueAction(action);
    }
})