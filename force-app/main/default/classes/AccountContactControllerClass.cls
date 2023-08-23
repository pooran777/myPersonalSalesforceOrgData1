public class AccountContactControllerClass {
    public String searchAcc{get;set;}
    public List<Account> accList{get;set;} 
    public List<Contact> conList{get;set;}
    public string accId{get;set;}
    public Boolean NoContact{get;set;}
    public string message {get;set;}
    public Boolean showAccList{get;set;}
    
    public void getAccount(){
        accList = new List<Account>();
        if(searchAcc != '' && searchAcc != null){
            String query='SELECT Id, Name FROM Account WHERE Name LIKE \'%'+searchAcc+'%\''; // RecordTypeId
            accList = Database.query(query);
            showAccList = true;
        }
        else{
            String query='SELECT Id,Name FROM Account'; //RecordTypeId
            accList = Database.query(query);
            showAccList = true;
        }   
    }
    public void getContact(){
        conList = new List<Contact>();
        System.debug('accId1==='+accId);
        if(accId !='' && accId != null){
            System.debug('accId2==='+accId);
            String query = 'SELECT Id, Name,Email FROM Contact WHERE AccountId = \''+accId+'\''; //Pan_No__c,VCC1__Country_Name__c
            conList = Database.query(query);            
            if(conList.isEmpty()){
                NoContact = true;
                message='No contact available for this Account';
            }
            else{
                NoContact = false;
            }
        }
    }
}