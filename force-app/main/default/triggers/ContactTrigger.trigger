trigger ContactTrigger on Contact (after insert , after delete , after update ,after undelete) {

    ContactTriggerHandler conTrigger = new ContactTriggerHandler();
    if(Trigger.isAfter){
        if(Trigger.isDelete){
            conTrigger.afterContactDelete(Trigger.old);
        }   
        if(Trigger.isInsert){
            conTrigger.afterContactInsert(Trigger.new);
        }
        if(Trigger.isUpdate){
            conTrigger.afterContactUpdate(Trigger.new,Trigger.oldMap);
         }  
        if(Trigger.isUndelete){
            conTrigger.afterContactUndelete(Trigger.new);
        }
    }
   /*if(Trigger.isBefore){
        if(Trigger.isUpdate){
            conTrigger.beforeContactUpdate(Trigger.new,Trigger.old);         
        }
    }*/  
}