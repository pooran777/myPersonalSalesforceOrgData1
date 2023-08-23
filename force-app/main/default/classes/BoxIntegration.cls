public class BoxIntegration {
    //API Secret Key(Client Id)
    private static string Clientkey = '0rrc4cb5uobzoys8vea8r2d5cvwppn2s';
    //API Secret(Client Secert)
    private Static string secret = 'EszHPmr0dXcoPq8eKp4D1lbwXX7IL58y';
    //API Redirect. Use your Lightning Tab or Lightning community URL
    private Static string redirect_uri ='https://pooranchoudhary-developer-edition.ap27.force.com/GoogleDrive/s/?tabset-57fa1=6334d';//( Lightning community URL/s) 
    public static List<Boxcom__c> obj = [Select Access_Token__c,Refresh_Token__c,Expires_In_Seconds__c,UserId__c from Boxcom__c];


    @AuraEnabled
    public static Boolean checkUser(){
        System.debug('enter in user method');
        Id userId = UserInfo.getUserId();
        if(obj.isEmpty())
            return false;
        else
            return true;
    }

    @AuraEnabled
    public static String BoxAuthUri(){
        System.debug('enter in boxAuth method');
        String key = EncodingUtil.urlEncode(Clientkey,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        String authuri = '';
        authuri = 'https://account.box.com/api/oauth2/authorize?'+
        '&client_id='+key+
        '&response_type=code'+
        '&redirect_uri='+uri;
        System.debug('authuri=='+authuri);
        return authuri;
    }
    
    @AuraEnabled
    public static String getAccessToken(String code){
        System.debug('enter in access Token Method');
        System.debug('code===='+code);
        String endpoint = 'https://api.box.com/oauth2/token'; // be sure this is configured in "Remote Site Settings"
        // define transaction variables
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();  
        Http h = new Http();
 
        // Configure the request
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setTimeout(120000);
        string messageBody = 'code=' + code +
                             '&client_id=' + Clientkey + 
                             '&client_secret=' + secret + 
                             '&grant_type=authorization_code';
        req.setBody(messageBody);
        res = h.send(req);
        System.debug('responeBodeAccessToken'+res.getBody());
        if ((res.getStatusCode() == 200 || res.getStatusCode() == 201) && res.getBody() != null) {
            Map<String, Object> untypedMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());   
            System.debug('untypedMap==='+untypedMap);
            String access_token =  String.valueOf(untypedMap.get('access_token'));
            String refresh_token = String.valueOf(untypedMap.get('refresh_token'));
            Integer expireTime = Integer.valueOf(untypedMap.get('expires_in'));
            Datetime expireIn = System.now().addSeconds(expireTime);
            Id userId = UserInfo.getUserId();
            system.debug('access_token:'+access_token);
            System.debug('refresh_token=='+refresh_token);
            System.debug('userId==='+userId); 
            Boxcom__c obj = new Boxcom__c(Access_Token__c = access_token,Refresh_Token__c = refresh_token,Expires_In_Seconds__c = expireIn,UserId__c = userId);
            insert obj;

            if(untypedMap.containsKey('access_token')){
                String str = (String) untypedMap.get('access_token');
                System.debug('access_Token=='+str);
                return str;
            }  
            }else{
                System.debug('enter in else');
                return '';
            }
            return '';
    }
    
   @AuraEnabled
   public static List<cls_entries> ListFiles(String parentID){
       try {
           String accessToken = obj[0].Access_Token__c;
           System.debug('AccessToken=='+accessToken);
           
           String parentFolderId='';
            if(parentID == '' || parentID == null)
                parentFolderId = '0';
            else
                parentFolderId = parentID;

            System.debug('parentFolderId=='+parentFolderId);

           HttpRequest req = new HttpRequest();
           HttpResponse res = new HttpResponse();
           Http h = new Http();

           req.setMethod('GET');
           String endpoint = 'https://api.box.com/2.0/folders/' + parentFolderId;
           req.setEndpoint(endpoint);
           req.setHeader('Content-Type', 'application/json');
           req.setHeader('Authorization', 'Bearer ' + accessToken);
           req.setTimeout(6000);
           res = h.send(req);
           System.debug('responseBODY==============='+res.getBody());


           DataParser convertedData = (DataParser) System.JSON.deserialize(res.getBody(), DataParser.class);
           System.debug('convertedData==='+convertedData);
           
           List<cls_entries> fileList ;
           fileList =  new List<cls_entries>();
           for(cls_entries fil : convertedData.item_collection.entries){
               fileList.add(fil);
           }
           for(cls_entries str:fileList){
               System.debug('aLL FOLDER===='+str);
           }
           return fileList;
       } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
       }
   }

   @AuraEnabled
   public static List<cls_entries> deleteItems(String folder_id, Boolean isFolder, String parentID){
        try {
            System.debug('enter in delete apex');
            String accessToken = obj[0].Access_Token__c;

            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http callout = new Http();

            req.setMethod('DELETE');
            if(isFolder == false){
                System.debug('enter in file delete');
                req.setEndpoint('https://api.box.com/2.0/files/'+folder_id);
            }else{
                System.debug('enter in folder delete');
                req.setEndpoint('https://api.box.com/2.0/folders/'+folder_id);
            } 
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization','Bearer '+  accessToken);
            req.setTimeout(6000);
            res = callout.send(req);

            System.debug('deleteresponseBody=='+res.getBody());
            return ListFiles(parentID);
            
        } catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
        }
   }

   public class DataParser{
	@AuraEnabled public cls_item_collection item_collection;

    }
    class cls_item_collection {
        @AuraEnabled public Integer total_count;	//4
        @AuraEnabled public cls_entries[] entries;
	}
    class cls_entries {
        @AuraEnabled public String type;	//folder
        @AuraEnabled public String id;	//161791242973
        @AuraEnabled public String sequence_id;	//0
        @AuraEnabled public String etag;	//0
        @AuraEnabled public String name;	//Demo
    }
}