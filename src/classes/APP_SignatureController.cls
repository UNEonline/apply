public with sharing class APP_SignatureController {
		
	public Application__c app {get; set;}
	public String step {get; set;}

	public APP_SignatureController() {
		User u = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
		app = [SELECT Electronic_Signature__c FROM Application__c WHERE Contact__c = :u.ContactId];
	}

	public PageReference save() {
		//PageReference pageRef = new PageReference('/apply/apex/UneOnlineHome?s=5');
		PageReference pageRef = new PageReference('/apply/apex/UneOnlineHome?s=' + step);
		app.Signature_Complete__c = true;
		
		update app;
		return pageRef;
	}
}