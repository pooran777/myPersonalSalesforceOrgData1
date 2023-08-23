global with sharing class CustomerData {

    @AuraEnabled
    public static String listObjects(){
        List <customWrapper> WrapperObjectList = new List<customWrapper>();
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();
        for(SObjectType sot:gd){
            Schema.DescribeSObjectResult describeSObjectResultObj = sot.getDescribe();
            if(describeSObjectResultObj.isQueryable() && describeSObjectResultObj.isUpdateable() && describeSObjectResultObj.isAccessible() && describeSObjectResultObj.isCreateable()){
                customWrapper wrapperObj = new customWrapper ();
                wrapperObj.label = describeSObjectResultObj.getLabel();
                wrapperObj.apiName = describeSObjectResultObj.getName();
                WrapperObjectList.add(wrapperObj);
            }
        }
        WrapperObjectList.sort();
        return json.serialize(WrapperObjectList);
    }
    
    @AuraEnabled
    public static String listObjectFields(String selectedObject) {
        List <customWrapper> wrapperFieldList = new List<customWrapper>();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
        for (Schema.SObjectField fieldName: fieldMap.Values()) {  
            Schema.DescribeFieldResult fieldResult = fieldName.getDescribe();
            if(fieldResult.isAccessible() && fieldResult.isFilterable() && fieldResult.isGroupable() && fieldResult.isSortable()){
                customWrapper wrapperField = new customWrapper ();
                wrapperField.label = fieldResult.getLabel();
                wrapperField.apiName = fieldResult.getName(); 
                wrapperFieldList.add(wrapperField);
            }   
        }
        wrapperFieldList.sort();
        return json.serialize(wrapperFieldList);
    }

    @AuraEnabled
    public static String createMasterData(){
        //API URL :> https://aipoddmz.adani.com:443/RESTAdapter/adanirealestate/customermaster/create
        
        /*HttpRequest req = new HttpRequest();
        req.setTimeout(60000);
        req.setMethod('GET');
        req.setEndpoint('https://aipoddmz.adani.com:443/RESTAdapter/adanirealestate/customermaster/create');
        http http = new http();
        HttpResponse res = http.send(req);
        Integer responsecode = res.getStatusCode();
        String response = res.getBody(); */
        
        
        String response = '{ '
            +'"PS_Record_ID": "123432",'	
            +'"SAP_CustomerNo": "",'
            +'"CustomerAcGrp": "ZALE",'
            +'"CustomerSalesOrg": "A000",'
            +'"CustDistChannel": "A0",'
            +'"CustDivision": "00",'
            +'"CustCompCode": "4420",'
            +'"NameLine1": "Name1",'
            +'"NameLine2": "Name2",'
            +'"NameLine3": "Name3",'
            +'"NameLine4": "Name4",'
            +'"NameLine5": "Name5",'
            +'"AddrLine1": "25",'
            
            +'"AddrLine2": "Near incometax road",'
            +'"AddrLine3": "ahmedabad",'
            +'"AddrLine4": "ahmedabad",'
            +'"SearchTerm": "Test",'
            +'"PostalCode": "380015",'
            +'"City": "ahmedabad",'
            +'"State": "06",'
            +'"Country": "IN",'
            +'"StdCommnMethod": "TEL",'
            +'"DoB": "01.03.1980",'
            +'"EmployerName": "Test Employer",'
            +'"AadharCard": "11223344",'
            +'"PANCard": "PAN123",'
            +'"GSTN": "GST123",'
            +'"PassportNo": "Pass123",'
            +'"DrivingLic": "D123",'
            +'"CompRegNo": "REG123",'
            +'"DateFounded": "03.05.1975",'
            +'"CorresAddrLine1": "test",'
            +'"CorresAddrLine2": "test2",'
            +'"CorresAddrLine3": "test3",'
            +'"CorresAddrLine4": "test4",'
            +'"CorresAddrState": "testst",'
            +'"CorresAddrPstlCode": "test12",'
            +'"CompIdentification": "R1",'
            +'"PayTerms": "Z002",'
            +'"Title": "0001",'
            +'"MaritalStatus": "R4",'
            +'"Gender": "R02",'
            +'"Occupation": "R1",'
            +'"EmpDesigLevel": "R5",'
            +'"CitizenStatus": "R04",'
            +'"CustType": "R2",'
            +'"CustMedium": "R03",'
            +'"CustDomain": "R3",'
            +'"PSCustCode": "PS123",'
            +'"PSBookingCode": "B123",'
            +'"UnitCode": "12",'
            +'"ReconAcc": "0011200100",'
            +'"InterestInd": "01",'
            +'"InterestCycle": "01",'
            +'"CashMgmtGroup": "R02",'
            +'"PaymMethod": "C",'
            +'"DunnProced": "Z009",'
            +'"SalesOffice": "4031",'
            +'"CustGrp": "02",'
            +'"Currency": "INR",'
            +'"CustPriceProc": "1",'
            +'"CustStatGrp": "1",'
            +'"ShpCond": "01",'
            +'"AccAssnGrp": "01",'
            +'"ExchRateType": "M",'
            +'"IndustryKey": "0012",'
            +'"TaskIndicator": "I",'
            +'"BankDtls": [' +
            '{'
            +'"TaskIndicator": "I",'
            +'"BankCountry": "IN",'
            +'"BankKey": "0001986",'
            +'"BankAcc": "1234567890",'
            +'"BankAccHolderName": "ABC",'
            +'"BankControlKey": "10",'
            +'"PartnerBankType": "ABC",'
            +'"RefDtls": "REF"'
            +'},'
            +'{'
            +'"TaskIndicator": "I",'
            +'"BankCountry": "IN",'
            +'"BankKey": "0002650",'
            +'"BankAcc": "1234781233",'
            +'"BankAccHolderName": "DEF",'
            +'"BankControlKey": "10",'
            +'"PartnerBankType": "ABC",'
            +'"RefDtls": "REF1"'
            +'}'
            +'],'
            +'"WTaxDtls": ['
            +'{'
            +'"TaskIndicator": "I",'
            +'"WTaxType": "IC",'
            +'"WTaxCode": "C1",'
            +'"WTaxInd": "X",'
            +'"WTaxDateFrom": "10.10.2019",'
            +'"WTaxDateTo": "12.10.2019",'
            +'"WTaxNo": "test2",'
            +'"WTaxExempNo": "4455",'
            +'"WTaxExempRate": "18.50"'
            +'},'
            +'{'
            +'"TaskIndicator": "I",'
            +'"WTaxType": "C1",'
            +'"WTaxCode": "C1",'
            +'"WTaxInd": "X",'
            +'"WTaxDateFrom": "10.10.2019",'
            +'"WTaxDateTo": "12.10.2019",'
            +'"WTaxNo": "Test1",'
            +'"WTaxExempNo": "2233",'
            +'"WTaxExempRate": "20.22"'
            +'}'
            +'],'
            +'"TaxCatDtls": ['
            +'{'
            +'"TaskIndicator": "I",'
            +'"CondType": "JTX1",'
            +'"Country": "IN",'
            +'"Indicator": "1"'
            +'},'
            +'{'
            +'"TaskIndicator": "I",'
            +'"CondType": "JTX2",'
            +'"Country": "IN",'
            +'"Indicator": "1"'
            +'}'
            +'],'
            +'"CustomerEmail": ['
            +'{'
            +'"TaskIndicator": "I",'
            +'"EmailId": "test1@email.com"'
            +'},'
            +'{'
            +'"TaskIndicator": "I",'
            +'"EmailId": "test2@email.com"'
            +'}'
            +'],'
            +'"CustomerPhone": ['
            +'{'
            +'"TaskIndicator": "I",'
            +'"CustPhoneNo": "1111111111"'
            +'},'
            +'{'
            +'"TaskIndicator": "I",'
            +'"CustPhoneNo": "2222222222"'
            +'}'
            +'],'
            
            
            +'"ContactPersons": ['
            +'{'
            +'"TaskIndicator": "I",'
            +'"SAPContactPerNo": "21873",'
            +'"PSContactPerNo": "PS12345",'
            +'"CoAppFirstName": "test1223",'
            +'"CoAppLastName": "String 142",'
            +'"CoAppTitle": "0003",'
            +'"CoAppGender": "1",'
            +'"CoAppRole": "Z003",'
            +'"CoAppFunc": "62",'
            +'"CoAppAadhar": "aadhar345",'
            +'"CoAppPassport": "Pass345",'
            +'"CoAppPAN": "PAN345",'
            +'"CoAppDLNo": "D345",'
            +'"AppPhNo": ['
            +'{'
            +'"TaskIndicator": "I",'
            +'"CoAppPhNo": "3333333333"'
            +'},'
            +'{'
            +'"TaskIndicator": "I",'
            +'"CoAppPhNo": "4444444444"'
            +'}'
            +'],'
            +'"AppEmail": ['
            +'{'
            +'"TaskIndicator": "I",'
            +'"CoAppEmail": "test3@email.com"'
            +'},'
            +'{'
            +'"TaskIndicator": "I",'
            +'"CoAppEmail": "test4@email.com"'
            +'}'
            +']'
            +'},'
            +'{'
            +'"TaskIndicator": "I",'
            +'"SAPContactPerNo": "21873",'
            +'"PSContactPerNo": "PSNO123",'
            +'"CoAppFirstName": "test567",'
            +'"CoAppLastName": "String 142",'
            +'"CoAppTitle": "0003",'
            +'"CoAppGender": "1",'
            +'"CoAppRole": "Z003",'
            +'"CoAppFunc": "62",'
            +'"CoAppAadhar": "aadhar444",'
            +'"CoAppPassport": "Pass444",'
            +'"CoAppPAN": "Pan444",'
            +'"CoAppDLNo": "D444",'
            +'"AppPhNo": ['
            +'{'
            +'"TaskIndicator": "I",'
            +'"CoAppPhNo": "5555555555"'
            +'},'
            +'{'
            +'"TaskIndicator": "I",'
            +'"CoAppPhNo": "6666666666"'
            +'}'
            +'],'
            +'"AppEmail": ['
            +'{'
            +'"TaskIndicator": "I",'
            +'"CoAppEmail": "test5@email.com"'
            +'},'
            +'{'
            +'"TaskIndicator": "I",'
            +'"CoAppEmail": "test6@email.com"'
            +'}'
            +']'
            +'}'
            +']'
            
            +'}';
        
        CustomerMaster customerMasterObj = CustomerMaster.parse(response);
        return JSON.serialize(customerMasterObj);
        /*if(responsecode == 200){
            CustomerMaster customerMasterObj = CustomerMaster.parse(response);
            system.debug('responseCode --- response Pradeep>>--> '+responseCode+ '---'+ response);
            return null;
        }else{
            system.debug('responseCode --- response Pradeep>>--> '+responseCode+ '---'+ response);
            return null;
        }*/
    }
    
    global class customWrapper implements Comparable{
        @AuraEnabled global String label;
        @AuraEnabled global String apiName;

        global Integer compareTo(Object ObjToCompare) { 
            return label.CompareTo(((customWrapper)ObjToCompare).label);
        } 
    }
    
}