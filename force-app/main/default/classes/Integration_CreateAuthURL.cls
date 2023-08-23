global class Integration_CreateAuthURL {
/*    global String AuthenticationURI='';
    global Integration_CreateAuthURL(String Clientkey,String redirect_uri){
        String key = EncodingUtil.urlEncode(Clientkey,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        
        //Authentication URL to authenticate the app created by Application Designer to connect to google
        //when ever any rest api connection is made 
        //1. get the AuthenticationToken for an App (to be identified that this is the app being used for the connection) 
         String  authuri = 'https://accounts.google.com/o/oauth2/v2/auth?'+        
            'client_id='+key+
            '&response_type=code'+
            '&scope=https%3A//www.googleapis.com/auth/drive.metadata.readonly'+         
            '&redirect_uri='+uri+
            '&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oa2cb.example.com/myHome&'+
            '&login_hint=pooranchand@briskminds.com&'+
            'access_type=offline';
            System.debug('authuri==='+authuri);
        AuthenticationURI=authuri;
    }*/
}