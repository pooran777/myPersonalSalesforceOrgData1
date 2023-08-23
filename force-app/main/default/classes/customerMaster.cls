public class customerMaster {
    public String PS_Record_ID;	//123432
	public String SAP_CustomerNo;	//
	public String CustomerAcGrp;	//ZALE
	public String CustomerSalesOrg;	//A000
	public String CustDistChannel;	//A0
	public String CustDivision;	//00
	public String CustCompCode;	//4420
	public String NameLine1;	//Name1
	public String NameLine2;	//Name2
	public String NameLine3;	//Name3
	public String NameLine4;	//Name4
	public String NameLine5;	//Name5
	public String AddrLine1;	//25
	public String AddrLine2;	//Near incometax road
	public String AddrLine3;	//ahmedabad
	public String AddrLine4;	//ahmedabad
	public String SearchTerm;	//Test
	public String PostalCode;	//380015
	public String City;	//ahmedabad
	public String State;	//06
	public String Country;	//IN
	public String StdCommnMethod;	//TEL
	public String DoB;	//01.03.1980
	public String EmployerName;	//Test Employer
	public String AadharCard;	//11223344
	public String PANCard;	//PAN123
	public String GSTN;	//GST123
	public String PassportNo;	//Pass123
	public String DrivingLic;	//D123
	public String CompRegNo;	//REG123
	public String DateFounded;	//03.05.1975
	public String CorresAddrLine1;	//test
	public String CorresAddrLine2;	//test2
	public String CorresAddrLine3;	//test3
	public String CorresAddrLine4;	//test4
	public String CorresAddrState;	//testst
	public String CorresAddrPstlCode;	//test12
	public String CompIdentification;	//R1
	public String PayTerms;	//Z002
	public String Title;	//0001
	public String MaritalStatus;	//R4
	public String Gender;	//R02
	public String Occupation;	//R1
	public String EmpDesigLevel;	//R5
	public String CitizenStatus;	//R04
	public String CustType;	//R2
	public String CustMedium;	//R03
	public String CustDomain;	//R3
	public String PSCustCode;	//PS123
	public String PSBookingCode;	//B123
	public String UnitCode;	//12
	public String ReconAcc;	//0011200100
	public String InterestInd;	//01
	public String InterestCycle;	//01
	public String CashMgmtGroup;	//R02
	public String PaymMethod;	//C
	public String DunnProced;	//Z009
	public String SalesOffice;	//4031
	public String CustGrp;	//02
	public String Currency_z;	//INR
	public String CustPriceProc;	//1
	public String CustStatGrp;	//1
	public String ShpCond;	//01
	public String AccAssnGrp;	//01 
	public String ExchRateType;	//M
	public String IndustryKey;	//0012
	public String TaskIndicator;	//I
	public cls_BankDtls[] BankDtls;
	public cls_WTaxDtls[] WTaxDtls;
	public cls_TaxCatDtls[] TaxCatDtls;
	public cls_CustomerEmail[] CustomerEmail;
	public cls_CustomerPhone[] CustomerPhone;
	public cls_ContactPersons[] ContactPersons;
	class cls_BankDtls {
		public String TaskIndicator;	//I
		public String BankCountry;	//IN
		public String BankKey;	//0001986
		public String BankAcc;	//1234567890
		public String BankAccHolderName;	//ABC
		public String BankControlKey;	//10
		public String PartnerBankType;	//ABC
		public String RefDtls;	//REF
	}
	class cls_WTaxDtls {
		public String TaskIndicator;	//I
		public String WTaxType;	//IC
		public String WTaxCode;	//C1
		public String WTaxInd;	//X
		public String WTaxDateFrom;	//10.10.2019
		public String WTaxDateTo;	//12.10.2019
		public String WTaxNo;	//test2
		public String WTaxExempNo;	//4455
		public String WTaxExempRate;	//18.50
	}
	class cls_TaxCatDtls {
		public String TaskIndicator;	//I
		public String CondType;	//JTX1
		public String Country;	//IN
		public String Indicator;	//1
	}
	class cls_CustomerEmail {
		public String TaskIndicator;	//I
		public String EmailId;	//test1@email.com
	}
	class cls_CustomerPhone {
		public String TaskIndicator;	//I
		public String CustPhoneNo;	//1111111111
	}
	class cls_ContactPersons {
		public String TaskIndicator;	//I
		public String SAPContactPerNo;	//21873
		public String PSContactPerNo;	//PS12345
		public String CoAppFirstName;	//test1223
		public String CoAppLastName;	//String 142
		public String CoAppTitle;	//0003
		public String CoAppGender;	//1
		public String CoAppRole;	//Z003
		public String CoAppFunc;	//62
		public String CoAppAadhar;	//aadhar345
		public String CoAppPassport;	//Pass345
		public String CoAppPAN;	//PAN345
		public String CoAppDLNo;	//D345
		public cls_AppPhNo[] AppPhNo;
		public cls_AppEmail[] AppEmail;
	}
	class cls_AppPhNo {
		public String TaskIndicator;	//I
		public String CoAppPhNo;	//3333333333
	}
	class cls_AppEmail {
		public String TaskIndicator;	//I
		public String CoAppEmail;	//test3@email.com
	}
	public static CustomerMaster parse(String json){
		return (CustomerMaster) System.JSON.deserialize(json, CustomerMaster.class);
	}

}