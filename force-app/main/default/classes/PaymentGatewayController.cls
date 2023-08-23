public with sharing class PaymentGatewayController {
    @AuraEnabled
    public static String payByAuthrizePayment(String cardNumber, String expireMonth, String expireYear, String cvv, String amount){
        Payment_Gateway__mdt authData = [SELECT Login_ID__c, Transaction_Key__c FROM Payment_Gateway__mdt];
         System.debug(authData);

        System.debug('enter in payByAuthrizePayment method');
        //create JSON body JSON Genertor
        
        JSONGenerator payBody = JSON.createGenerator(true);
        payBody.writeStartObject();//1
        payBody.writeFieldName('createTransactionRequest');
         
        payBody.writeStartObject();//2
        payBody.writeFieldName('merchantAuthentication');
         
        payBody.writeStartObject();//3
        payBody.writeStringField('name', authData.Login_ID__c);
        payBody.writeStringField('transactionKey', authData.Transaction_Key__c);
        payBody.writeEndObject();
         
        payBody.writeStringField('refId', '123456');
        payBody.writeFieldName('transactionRequest');
         
        payBody.writeStartObject();//4
        payBody.writeStringField('transactionType', 'authCaptureTransaction');
        payBody.writeStringField('amount', amount);
        payBody.writeFieldName('payment');
         
        payBody.writeStartObject();//5
        payBody.writeFieldName('creditCard');
         
        payBody.writeStartObject();//6
        payBody.writeStringField('cardNumber', cardNumber);
        payBody.writeStringField('expirationDate', expireYear + '-' + expireMonth);
        payBody.writeStringField('cardCode', cvv);
        
        payBody.writeEndObject();       
        payBody.writeEndObject();
        payBody.writeEndObject();
        payBody.writeEndObject();
        payBody.writeEndObject();

            // Instantiate a new http object
        Http h = new Http();
         
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://apitest.authorize.net/xml/v1/request.api');
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setBody(payBody.getAsString());
        System.debug(payBody.getAsString());

        // Send the request, and return a response
        HttpResponse res = new HttpResponse();
        res = h.send(req);
        System.debug(res);
        
        String responseBody = res.getBody();
        if(String.IsNotBlank(res.getBody())){
            System.debug(res.getBody());
            if(responseBody.contains('"description":"This transaction has been approved."') || responseBody.contains('"description":"Your order has been received. Thank you for your business!"')){
                return 'This transaction has been approved.';
            }
            else {
                string error = responseBody.substringBetween('"errorText":"','"');
                throw newMessageException('Error encountered: ' + error);   
            }
        } else{
            throw newMessageException('Error encountered. Status Code: ' + res.getStatus());   
        }
    }

    private static AuraHandledException newMessageException(String message) {
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
    }

    @AuraEnabled
    
    public static String payByEcheck(String routingNumber, String accountNumber, String accountHolderName, String amount){
        Payment_Gateway__mdt authData = [SELECT Login_ID__c, Transaction_Key__c FROM Payment_Gateway__mdt];
             
        JSONGenerator payBody = JSON.createGenerator(true);
        payBody.writeStartObject();//1
        payBody.writeFieldName('createTransactionRequest');
         
        payBody.writeStartObject();//2
        payBody.writeFieldName('merchantAuthentication');
         
        payBody.writeStartObject();//3
        payBody.writeStringField('name', authData.Login_ID__c);
        payBody.writeStringField('transactionKey', authData.Transaction_Key__c);
        payBody.writeEndObject();
         
        payBody.writeStringField('refId', '123456');
        payBody.writeFieldName('transactionRequest');
         
        payBody.writeStartObject();//4
         
        payBody.writeStringField('transactionType', 'authCaptureTransaction');
         
        payBody.writeStringField('amount', amount);
         
        payBody.writeFieldName('payment');
         
        payBody.writeStartObject();//5
        payBody.writeFieldName('bankAccount');
         
        payBody.writeStartObject();//6
        // payBody.writeStringField('accountType', 'Saving');
        payBody.writeStringField('routingNumber', routingNumber);
        payBody.writeStringField('accountNumber', accountNumber);
        payBody.writeStringField('nameOnAccount', accountHolderName);
        payBody.writeStringField('bankName', '');
        payBody.writeStringField('checkNumber', '');
        payBody.writeEndObject();
        payBody.writeEndObject();           
        payBody.writeEndObject();
        payBody.writeEndObject();
        payBody.writeEndObject();
       
 
        // Instantiate a new http object
        Http h = new Http();
         
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://apitest.authorize.net/xml/v1/request.api');
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setBody(payBody.getAsString());
        // Send the request, and return a response
        HttpResponse res = new HttpResponse();
        res = h.send(req);
        
        String responseBody = res.getBody();
        if(String.IsNotBlank(res.getBody())){
            System.debug(res.getBody());
            if(responseBody.contains('"description":"This transaction has been approved."') || responseBody.contains('"description":"Your order has been received. Thank you for your business!"')){
                return 'This transaction has been approved.';
            }
            else {
                string error = responseBody.substringBetween('"errorText":"','"');
                throw newMessageException('Error encountered: ' + error);   
            }
        } else{
            throw newMessageException('Error encountered. Status Code: ' + res.getStatus());   
        }
    }
}