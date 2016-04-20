public with sharing class APP_PersonalInformationController {

	public Contact c {get; set;}
	public Application__c app {get; set;}
	//public String birthdate {get; set;}
	public String step {get; set;}

	public APP_PersonalInformationController() {

		/* System.debug('USERID: ' + UserInfo.getUserId()); */
		User u = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];

		c = [ SELECT 
		Id, 
		FirstName, 
		MiddleName, 
		LastName, 
		MailingStreet, 
		MailingCity, 
		MailingStateCode, 
		MailingPostalCode, 
		MailingCountryCode, 
		Email, 
		Phone, 
		HomePhone,
		Former_Last_Name__c, 
		Secondary_Email__c, 
		Birthdate, 
		Gender__c, 
		Country_of_Birth__c, 
		Native_Language__c, 
		Ethnicity__c, 
		Hispanic_Latino__c, 
		Citizenship__c, 
		Emergency_Contact_Name__c, 
		Emergency_Contact_Phone__c, 
		Emergency_Contact_Relationship__c, 
		Emergency_Contact_Address__c
		FROM Contact WHERE Id = :u.ContactId];

		app = [SELECT 
		License__c, 
		License_Explain__c, 
		Military__c,
		License_Suspended_Revoked__c, 
		License_Suspended_Revoked_Explain__c, 
		Spouse_Dependant_Military__c, 
		Text_How_did_you_hear_about_us__c
		FROM Application__c WHERE Contact__c = :c.Id];

		//if(c.Birthdate != null) 
			//birthdate = c.Birthdate.format();
		
	}

	public PageReference save() {
		//PageReference pageRef = new PageReference('/apply/apex/UneOnlineHome?s=2');	
		PageReference pageRef = new PageReference('/apply/apex/UneOnlineHome?s=' + step);
		app.Personal_Information_Complete__c = true;
		//c.Birthdate = Date.parse(String.valueOf(birthdate.trim()));

		update app;
		update c;
		return pageRef;
	}
}