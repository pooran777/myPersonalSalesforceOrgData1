global with sharing class multiselectLookupController {
    
  @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
    return [SELECT Id, Name FROM Account];
  }
}