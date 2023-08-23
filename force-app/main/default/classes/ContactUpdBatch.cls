global class ContactUpdBatch implements Database.Batchable<sObject>,Database.Stateful{
    global List<Contact> csvList = new List<Contact>();
    
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext bc){
        String Query = 'Select id,lastname,Status__c ,CreatedDate,lastModifiedDate,IsDeleted,Description from Contact Where CreatedDate = YESTERDAY';
        return Database.getQueryLocator(Query);
    }
    
    // Execute method
    global void execute(Database.BatchableContext bc,List<Contact> cList){
        if(cList.size() > 0){
            for(Contact con : cList){  
                if(con.Status__c == null){
                    con.status__C = 'Ready for Approval';
                }
            }
            for(Contact con: cList){
                csvList.add(con);
            }
            try{
                update cList;
            } 
            catch(Exception e) {
                System.debug(e);
            }
        }
    }
    
    // Finish Method
    global void finish(Database.BatchableContext bc){ 
        String header = 'Record Id, LastName,Status,Created Date, Modified Date,IsDeleted,Description \n';
        String finalstr = header ;
        string recordString ='';
        for(Contact con: csvList){
            if(con.Description == null){
                recordString = '"'+con.id+'","'+con.LastName+'","'+con.Status__c+'","'+con.CreatedDate+'","'+con.LastModifiedDate+'","'+con.IsDeleted+'","'+con.Description+'"\n';
            }
            else{
                recordString = '"'+con.id+'","'+con.LastName+'","'+con.Status__c+'","'+con.CreatedDate+'","'+con.LastModifiedDate+'","'+con.IsDeleted+'",'+con.Description.escapeCsv()+'\n';
            }
            finalstr = finalstr +recordString;
        }	
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        string csvname= 'Contact.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{'pooranchand@briskminds.com'};
            String subject ='Contact CSV';
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody('Contact CSV ');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});  
    }
}