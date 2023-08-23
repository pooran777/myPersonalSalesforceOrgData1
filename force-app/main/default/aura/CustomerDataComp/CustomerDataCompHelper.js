({
    getAllObjects: function(component,event) {
        var action = component.get("c.listObjects");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {           
                var allValues =  JSON.parse(response.getReturnValue());
                var listofObjects = [];
                for(var i =0 ; i<allValues.length ;i++){
                    listofObjects.push({ value:allValues[i].apiName, label:allValues[i].label});
                } 
                component.set("v.listObjects",  listofObjects);
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
    getAllFields : function(component,event) {
        var action = component.get('c.listObjectFields'); 
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
                component.set('v.listFields', options);
            }
            else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.");
            }else if (state === "ERROR") {
				var errors = response.getError();
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
	MasterData : function(component,event) {
		var action = component.get("c.createMasterData");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {           
				var data= JSON.parse(response.getReturnValue());
				var keyData = Object.keys(data);
				console.log('object values-->',Object.values(data));
				//console.log('========',Object.getOwnPropertyNames(value));
				var masterData = [];
				for(var i=keyData.length-1; i>=0; i--){
					masterData.push({value:data[keyData[i]] , label:keyData[i]});	
				}
				console.log('value==',data);
				component.set('v.masterData',masterData);		
			}
		});
		$A.enqueueAction(action);
	},
})