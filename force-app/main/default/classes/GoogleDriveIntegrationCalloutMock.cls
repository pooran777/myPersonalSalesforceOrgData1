@isTest
global class GoogleDriveIntegrationCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        if(req.getEndpoint() == 'https://accounts.google.com/o/oauth2/token'){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            res.setBody('{"access_token": "ya29.A0ARrdaM-pPRRC6ctkJtCPYBAoSAz0AhU4sIimHohbQE09OcGM4GuMNt_s0FNx1AzimpibJ4mF5YWqPHvMM8k1cwJgX5MHyaPpRG340o_wIx9w7L7fmN2Z3tyuJWFCqlDVRnBmPAZ1u1a8J8DSkVtzYEPpdeel","expires_in": "3599",  "refresh_token": "1//0egfR5wED0TFVCgYIARAAGA4SNwF-L9Irs24poqvNHM2hGqGozYsepFG90u1G-47UPY8z8sDfQYLN-i5a-9jECGOqsDf7oT4UnAg",  "scope": "https://www.googleapis.com/auth/drive",  "token_type": "Bearer"}');
            res.setStatusCode(200);
            return res;
        }
        else if(req.getEndpoint() == 'https://www.googleapis.com/drive/v3/files?q=\'root%27%20in%20parents%20and%20trashed=false&orderBy=folder'){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            res.setBody('{"kind": "drive#fileList", "incompleteSearch": false, "items": [{ "kind": "drive#file", "id": "1mduG40LdK1fzvEexEJo666NwqmAYtpSI", "title": "New Folder",  "mimeType": "application/vnd.google-apps.folder"}] }');
            res.setStatusCode(200);
            return res;
        }
        else if (req.getEndpoint() == 'https://www.googleapis.com/drive/v2/files/xyz'){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            res.setBody('{"kind": "drive#fileList", "incompleteSearch": false, "items": [{ "kind": "drive#file", "id": "1mduG40LdK1fzvEexEJo666NwqmAYtpSI", "title": "New Folder",  "mimeType": "application/vnd.google-apps.folder"}] }');
            res.setStatusCode(200);
            return res;
        }
        else if (req.getEndpoint() == 'https://www.googleapis.com/drive/v2/files'){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            res.setBody('{"kind": "drive#fileList", "incompleteSearch": false, "items": [{ "kind": "drive#file", "id": "1mduG40LdK1fzvEexEJo666NwqmAYtpSI", "title": "New Folder",  "mimeType": "application/vnd.google-apps.folder"}] }');
            res.setStatusCode(200);
            return res;
        }
        else if (req.getEndpoint() == 'https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart'){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            res.setBody('{"kind": "drive#fileList", "incompleteSearch": false, "items": [{ "kind": "drive#file", "id": "1mduG40LdK1fzvEexEJo666NwqmAYtpSI", "title": "New Folder",  "mimeType": "application/vnd.google-apps.folder"}] }');
            res.setStatusCode(200);
            return res;
        }
        else{
            HttpResponse res = new HttpResponse();
            return res;
        }
    }
    static testMethod void testParse() {
		String json = '\"kind\": \"drive#fileList\",'+
		' \"incompleteSearch\": false,'+
		' \"files\": ['+
		'  {'+
		'   \"kind\": \"drive#file\",'+
		'   \"id\": \"1PaCweUiphwEkpt1Qb9o-eBc5BK04BBYz\",'+
		'   \"name\": \"Govind\",'+
		'   \"mimeType\": \"application/vnd.google-apps.folder\"'+
		'  }'+
		']';
		//String obj = JSON2Apex.parse(json);
		//System.assert(obj != null);
	}
}