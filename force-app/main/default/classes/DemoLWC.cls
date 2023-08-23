public class DemoLWC {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String strAccountName) {
        System.debug('enter in method');
        String strKey = '%'+strAccountName+'%';
         List<Account> accList = [SELECT Id,Name,AccountNumber FROM Account WHERE name like :strKey ];
         return accList;
       }
}