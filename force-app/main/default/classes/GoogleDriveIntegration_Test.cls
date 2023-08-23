@isTest
public class GoogleDriveIntegration_Test {
   /* @testSetup static void testData(){
        TestDataFactory.createAttachment();
    }
    */
    @isTest static void testAccessToken() {
        Test.setMock(HttpCalloutMock.class, new GoogleDriveIntegrationCalloutMock());
        Test.startTest();
        Boolean isExist = Integration.checkUser();
        String authURI = Integration.createAuthURL();
        String res = Integration.getAccessToken(authURI);
        Test.stopTest();
        System.debug(res);
        System.assertEquals('ya29.A0ARrdaM-pPRRC6ctkJtCPYBAoSAz0AhU4sIimHohbQE09OcGM4GuMNt_s0FNx1AzimpibJ4mF5YWqPHvMM8k1cwJgX5MHyaPpRG340o_wIx9w7L7fmN2Z3tyuJWFCqlDVRnBmPAZ1u1a8J8DSkVtzYEPpdeel', res);
    }
    
    
    @isTest static void testGetData1() {
        Test.setMock(HttpCalloutMock.class, new GoogleDriveIntegrationCalloutMock());
        Boolean isExist = Integration.checkUser();
        String authURI = Integration.createAuthURL();
        String res = Integration.getAccessToken(authURI);
        
        Test.startTest();
         Integration.ListFiles('root');
        Test.stopTest();
    }
    
    @isTest static void testGetData2() {
        Test.setMock(HttpCalloutMock.class, new GoogleDriveIntegrationCalloutMock());
        Boolean isExist = Integration.checkUser();
        String authURI = Integration.createAuthURL();
        String res = Integration.getAccessToken(authURI);
        
        Test.startTest();
         Integration.ListFiles('');
        Test.stopTest();
    }
    
    @isTest static void testaccessTokenByRefreshToken1() {
        Test.setMock(HttpCalloutMock.class, new GoogleDriveIntegrationCalloutMock());
        Boolean isExist = Integration.checkUser();
        String authURI = Integration.createAuthURL();
        String res = Integration.getAccessToken(authURI);
        
        Test.startTest();
        Integration.getAccessTokenByRefreshToken('root');
        Test.stopTest();
    }
    
    @isTest static void testaccessTokenByRefreshToken2() {
        Test.setMock(HttpCalloutMock.class, new GoogleDriveIntegrationCalloutMock());
        Boolean isExist = Integration.checkUser();
        String authURI = Integration.createAuthURL();
        String res = Integration.getAccessToken(authURI);
        
        Test.startTest();
        Integration.getAccessTokenByRefreshToken('');
        Test.stopTest();
    }
    
    @isTest static void testDeleteFile() {
        Test.setMock(HttpCalloutMock.class, new GoogleDriveIntegrationCalloutMock());
        Boolean isExist = Integration.checkUser();
        String authURI = Integration.createAuthURL();
        String res = Integration.getAccessToken(authURI);        
        Test.startTest();
        Integration.deleteFile('xyz', 'root');
        Test.stopTest();
    }
    
    @isTest static void testCreateFolder1() {
        Test.setMock(HttpCalloutMock.class, new GoogleDriveIntegrationCalloutMock());
        Boolean isExist = Integration.checkUser();
        String authURI = Integration.createAuthURL();
        String res = Integration.getAccessToken(authURI);        
        Test.startTest();
        Integration.createFolder( 'root','New Folder','application/vnd.google-apps.folder');
        Test.stopTest();
    }
    
    @isTest static void testCreateFolder2() {
        Test.setMock(HttpCalloutMock.class, new GoogleDriveIntegrationCalloutMock());
        Boolean isExist = Integration.checkUser();
        String authURI = Integration.createAuthURL();
        String res = Integration.getAccessToken(authURI);        
        Test.startTest();
        Integration.createFolder('','New Folder','application/vnd.google-apps.folder');
        Test.stopTest();
    }
    
    @isTest static void testUploadFiles1() {
        Test.setMock(HttpCalloutMock.class, new GoogleDriveIntegrationCalloutMock());
        Boolean isExist = Integration.checkUser();
        String authURI = Integration.createAuthURL();
        String res = Integration.getAccessToken(authURI);
        Test.startTest();
        String responseData = Integration.UploadFile('', 'root');
        Test.stopTest();
    }
    
    @isTest static void testUploadFiles2() {
        Test.setMock(HttpCalloutMock.class, new GoogleDriveIntegrationCalloutMock());
        Boolean isExist = Integration.checkUser();
        String authURI = Integration.createAuthURL();
        String res = Integration.getAccessToken(authURI); 
        Test.startTest();
        String responseData = Integration.UploadFile('cjsfghearuiladbheru', '');
        Test.stopTest();
    }    
}