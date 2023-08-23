({
    getAllObjects: function(component, event, helper) {
        var action = component.get("c.fetchObjectList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {           
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
            //component.set('v.selectedField'," ");  
        });
        $A.enqueueAction(action);
    },
    
    getAllRecords : function(component, page, recordToDisply) {
        var action = component.get('c.getAllRecords');
        action.setParams({
            selectedObject : component.get('v.selectedObject'),
            selectedFields : component.get('v.selectedField'),
            pageNumber:page,
            recordToDisply:recordToDisply
            
        });
        var selected = component.get('v.selectedField')
        var all = component.get('v.allField'); 
        var option = [];
        for(var i =0 ; i<all.length ;i++){
            for(var j =0 ;j<selected.length ; j++){
                if(all[i].value == selected[j]){
                    option.push({label:all[i].label,fieldName:selected[j]})                  
                }
            }
        }
        component.set('v.myColumns',option);
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {   
                var result = response.getReturnValue();
                // set the component attributes value with wrapper class properties.
                component.set('v.myData', result.recordList);   
                component.set("v.page", result.page);
                component.set("v.total", result.total);
                component.set("v.pages", Math.ceil(result.total / recordToDisply));  
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
})