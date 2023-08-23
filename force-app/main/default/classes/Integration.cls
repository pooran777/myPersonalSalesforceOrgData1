public class Integration {
    //API Secret Key(Client Id)
    private static string key = '300994899831-ug2814h9siuun9o3ptmcrdjlieeum10n.apps.googleusercontent.com';
    //API Secret(Client Secert)
    private Static string secret = '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';
    //API Redirect. Use your Lightning Tab or Lightning community URL
    private Static string redirect_uri ='https://pooranchoudhary-developer-edition.ap27.force.com/GoogleDrive/s/?tabset-57fa1=2';//( Lightning community URL/s)         
    private static string tokenUrl='https://accounts.google.com/o/oauth2/token';      
    //After App authentication by app user will have to provide its own google user name and password  	
    //which is different from App created for client id and client secret        
    //for Example you have one google ID as admin@gmail.com and using this you created one app
    //now you wants to fetch files for user@gmail.com from google drive
    //so Client secret is created by admin@gmail.com and access token is received for user@gmail.com
    private static List<object> FileLst = new List<object>();
    private static List<String> File = new List<String>();
    private static List<cls_files> fileList;
    public static List<GoogleDrive__c> obj = [Select Access_Token__c,Refresh_Token__c,Expires_In_Seconds__c,UserId__c from GoogleDrive__c];
    
    @AuraEnabled
    public static Boolean checkUser(){
        System.debug('enter in user method');
        //List<GoogleDrive__c> obj = [Select Access_Token__c,Refresh_Token__c,Expires_In_Seconds__c,UserId__c  from GoogleDrive__c];
        Id userId = UserInfo.getUserId();
        if(obj.isEmpty())
            return false;
        else
            return true;
    }

    @AuraEnabled
    public static String createAuthURL() {
        String key = EncodingUtil.urlEncode(key,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        
        //Authentication URL to authenticate the app created by Application Designer to connect to google
        //when ever any rest api connection is made 
        //1. get the AuthenticationToken for an App (to be identified that this is the app being used for the connection) 
        String  authuri = 'https://accounts.google.com/o/oauth2/v2/auth?'+        
            'client_id='+key+
            '&response_type=code'+
            '&scope= https://www.googleapis.com/auth/drive'+        
            '&redirect_uri='+uri+
            '&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oa2cb.example.com/myHome&'+
            '&login_hint=pooranchand@briskminds.com&'+
            'access_type=offline'+
            '&prompt=consent';
        System.debug('authuri==='+authuri);
        return authuri;
    }
    
    //Get Access token from google drive
    @AuraEnabled
    public static String getAccessToken(String code)
    {
        System.debug('code==='+code);
        System.debug('enter in access tokan method');
        //Getting access token from google
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        //End point for authentication
        req.setEndpoint(tokenUrl);
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        //Message body for Authentication
        String messageBody = 'code='+code+
            '&client_id='+key+
            '&client_secret='+secret+
            '&redirect_uri='+redirect_uri+
            '&grant_type=authorization_code';  
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);
        system.debug('messageBody:'+messageBody);
        
        Http callout = new Http();
        String responseText;
        HttpResponse response = callout.send(req);
        responseText = response.getBody();
        system.debug('responseText:'+responseText);
        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(responseText) ;  
        System.debug('responseMap==='+responseMap);
        String access_token =  String.valueOf(responseMap.get('access_token'));
        String refresh_token = String.valueOf(responseMap.get('refresh_token'));
        Integer expireTime = Integer.valueOf(responseMap.get('expires_in'));
        Datetime expireIn = System.now().addSeconds(expireTime);
        Id userId = UserInfo.getUserId();
        system.debug('access_token:'+access_token);
        System.debug('refresh_token=='+refresh_token);
        System.debug('userId==='+userId); 
        GoogleDrive__c obj = new GoogleDrive__c(Access_Token__c = access_token,Refresh_Token__c = refresh_token,Expires_In_Seconds__c = expireIn,UserId__c = userId);
        insert obj;
        System.debug('obj=='+obj);
        List<cls_files> FilesList = new List<cls_files>();
        /*if (access_token!='' && access_token != null)
        {
            FilesList = ListFiles();
        }*/
        return access_token; 
    }

	public static  List<cls_files> getAccessTokenByRefreshToken(String parentID){    
        System.debug('enter in getAccessTokenByRefreshToken method');   
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(tokenUrl);
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody ='client_id='+key+
                            '&client_secret='+secret+
                            '&refresh_token='+obj[0].Refresh_Token__c+
                            '&grant_type=refresh_token';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);
           system.debug('messageBody:'+messageBody);
        System.debug(req);
        Http callout = new Http();
        String responseText;
        HttpResponse response = callout.send(req);
        responseText = response.getBody();
        system.debug('responseText:'+responseText);
        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(responseText) ;
        System.debug('responseMap==='+responseMap);
        String accessToken = String.valueOf(responseMap.get('access_token'));
        Integer expireTime = Integer.valueOf(responseMap.get('expires_in'));
        Datetime expireIn = System.now().addSeconds(expireTime);

        System.debug(accessToken);
        System.debug('Hello From Data');
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        String parentFolderId;
        if(parentID == '' || parentID == null){
            parentFolderId = 'root';
        }
        else{
            parentFolderId = parentID;
        }
        request.setEndpoint('https://www.googleapis.com/drive/v3/files?q=\''+parentFolderId+'%27%20in%20parents%20and%20trashed=false&orderBy=folder');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('content-type', 'application/x-www-form-urlencoded');
        request.setHeader('content-length', '0');
        request.setTimeout(60000);
        System.debug('request :- ' + request);
        Http http = new Http();
        HTTPResponse responsedata =http.send(request);
        String str = responsedata.getBody();
        DataParser convertedData = (DataParser) System.JSON.deserialize(str, DataParser.class);
        System.debug('convertedData???'+convertedData);

        fileList =  new List<cls_files>();
        for(cls_files fil : convertedData.files){
            fileList.add(fil);
        }
        // Map<String,object> dataResponseMap =(Map<String,object>)JSON.deserializeUntyped(str);
        // System.debug('dataResponseMap=='+dataResponseMap);
        GoogleDrive__c record = [Select Access_Token__c,Refresh_Token__c,Expires_In_Seconds__c,UserId__c from GoogleDrive__c Where UserId__c =: obj[0].UserId__c];
        record.Access_Token__c = accessToken;
        record.Expires_In_Seconds__c = expireIn;
        record.Refresh_Token__c = obj[0].Refresh_Token__c;
        update record;
        return fileList;  
    }
    
    @AuraEnabled
    public static List<cls_files>  ListFiles(String parentID)
    {    
        String accessToken = obj[0].Access_Token__c;
        System.debug('accessToken==>?>?'+accessToken);
        System.debug('expire===' + obj[0].Expires_In_Seconds__c + ' , '+ System.now());
        if(obj[0].Expires_In_Seconds__c < System.now()){
            System.debug('enter in if condition');
            List<cls_files> dataResponseMap =  getAccessTokenByRefreshToken(parentID);
            return dataResponseMap;
        }
        else{
            System.debug('@@@@@@@@@@@@@@@@@@@@'+parentID);
            System.debug('enter in listfile method');
            String parentFolderId='';
            if(parentID == '' || parentID == null)
                parentFolderId = 'root';
            else
                parentFolderId = parentID;

            System.debug('parentFolderId=='+parentFolderId);
            HttpRequest req1 = new HttpRequest();
            req1.setMethod('GET');
            //End point for List of Files in Folder
            String endpoint = 'https://www.googleapis.com/drive/v3/files?q=\''+parentFolderId+'%27%20in%20parents%20and%20trashed=false&orderBy=folder';
            req1.setEndpoint(endpoint);
            req1.setHeader('content-type', 'application/x-www-form-urlencoded');
            req1.setHeader('Content-length', '0');                                       
            //Specific Authorization Syntax
            req1.setHeader('Authorization' , 'Bearer'+' '+ accessToken);
            req1.setTimeout(60*1000);
            Http h2 = new Http();
            HttpResponse resl = h2.send(req1);
            System.debug('^^^^^response'+resl.getBody());
        
            DataParser convertedData = (DataParser) System.JSON.deserialize(resl.getBody(), DataParser.class);
            System.debug('convertedData==='+convertedData);
            
            fileList =  new List<cls_files>();
            for(cls_files fil : convertedData.files){
                fileList.add(fil);
            }
        
            return fileList;
        }
    }
    
    @AuraEnabled
    public static List<cls_files> deleteFile(String fieldId, String parentID){
        String accessToken = obj[0].Access_Token__c;
        System.debug('parentID==='+parentID);
        HttpRequest request = new HttpRequest();
        request.setMethod('DELETE');
        request.setEndpoint('https://www.googleapis.com/drive/v2/files/' + fieldId);
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('content-type', 'application/x-www-form-urlencoded');
        request.setHeader('content-length', '0');
        request.setTimeout(60000);  
        System.debug('request=='+request);
        Http http = new Http();
        HTTPResponse response =http.send(request); 
        return ListFiles(parentID);
    }
	
    @AuraEnabled
    public static List<cls_files> createFolder(String parentFolderId,String title, String mimeType){
        String accessToken = obj[0].Access_Token__c;
        System.debug('enter uploaddata');
        System.debug('parentID==='+parentFolderId);
        System.debug('title==='+title);
        System.debug('mimeType=='+mimeType);
       
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://www.googleapis.com/drive/v2/files');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-type', 'application/json');
        String message ='';
        if(parentFolderId == '' || parentFolderId == null)
            message = '{"title":"'+ title + '","mimeType":"' + mimeType +  '"}';
        else
            message = '{"title":"'+title+'","mimeType" : "' + mimeType +  '","parents": [{"kind": "drive#fileLink","id": "'+parentFolderId+'"}]}';
        System.debug(message);
        request.setBody(message);           
        request.setTimeout(60000);
        Http http = new Http();
        HTTPResponse response =http.send(request); 
        Integer str = response.getStatusCode();
        return ListFiles(parentFolderId);
    }

     @AuraEnabled
   public static String UploadFile(String attachmentId,String FolderId){
		String accessToken = obj[0].Access_Token__c;
        String parentFolderId='';
        if(FolderId == '' || FolderId == null)
            parentFolderId = 'root';
        else
            parentFolderId = FolderId;

        System.debug('enter in uploadFile');
        List<ContentVersion> cvFile = [SELECT title,VersionData,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: attachmentId]; 
        Blob myBlob = cvFile[0].VersionData;
        System.debug('myBlob=='+myBlob);
        String fileType ='/*/';
        System.debug('fileType==='+fileType);
        String filename = cvFile[0].title; 
        String boundary = '----------9889464542212';
        String delimiter = '\r\n--' + boundary + '\r\n';
        String close_delim = '\r\n--' + boundary + '--';
        String bodyEncoded = EncodingUtil.base64Encode(myBlob);

        //String body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "title" : "' + filename + '",' + ' "mimeType" : "' + filetype + '",' + '"parents":[{"kind": "drive#fileLink", "id":"'+ FolderId +'"}]}' + 
                      //delimiter + 'Content-Type: ' + filetype + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n'  + bodyEncoded + close_delim;

        String body=delimiter+'Content-Type: application/json\r\n\r\n'+'{"title":"'+filename+'","mimeType" : " ' + fileType + '","parents": [{"kind": "drive#fileLink","id": "'+parentFolderId+'"}]}'+delimiter+'Content-Type: ' + fileType + '\r\n'+'Content-Transfer-Encoding: base64\r\n'+'\r\n'+bodyEncoded+close_delim;
        Http http = new Http();
        HttpRequest req1 = new HttpRequest();
        req1.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart');
        req1.setHeader('Authorization', 'Bearer ' + accessToken);
        req1.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
        req1.setHeader('Content-length', String.valueOf(body.length()));
        req1.setBody(body);
        req1.setMethod('POST');
        req1.setTimeout(60 * 1000);
        HttpResponse resp1 = http.send(req1);
        System.debug('espone body=='+resp1.getBody());
        file = null;
        filetype = '';
        filename = '';
        return String.valueOf(resp1.getStatuscode());    
    }

    //Wrapper Class
    public class DataParser{
        @AuraEnabled public String kind;	//drive#fileList
        @AuraEnabled public boolean incompleteSearch;
        @AuraEnabled public cls_files[] files;
    }
    class cls_files {
        @AuraEnabled public String kind;	
        @AuraEnabled public String id;	
        @AuraEnabled public String name;	
        @AuraEnabled public String mimeType;	
        //@AuraEnabled public String webContentLink;
        //@AuraEnabled public String title;
    }
}