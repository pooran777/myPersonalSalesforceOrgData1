({
    masterdata : function(component,event,helper) {
        helper.MasterData(component,event);
     },
     init : function(component,event,helper) {
         helper.getAllObjects(component,event);
     },
     allFields : function(component,event, helper){
         helper.getAllFields(component,event);
     },
 })