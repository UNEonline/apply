public with sharing class APP_ProgramController {

	public Application__c app {get; set;}
	public String step {get; set;}

	public APP_ProgramController() {			
		/* System.debug('USERID: ' + UserInfo.getUserId()); */
		User u = [SELECT 
			ContactId 
			FROM User WHERE Id = :UserInfo.getUserId()];
		System.debug('u: ' + u);

		app = [SELECT 
			Community_Program__c, 
			Community_Start_Term__c, 
			Program__c, Start_Term__c 
			FROM Application__c WHERE Contact__c = :u.ContactId];	
		System.debug('app: ' + app);

	}

	public PageReference save() {
		//PageReference pageRef = new PageReference('/apply/apex/UneOnlineHome?s=1');
		PageReference pageRef = new PageReference('/apply/apex/UneOnlineHome?s=' + step);
		app.Program_Complete__c = true;
		if (app.Application_Status__c == null) {
        	app.Application_Status__c = 'In Progress';
        }

		update app;
		return pageRef;
	}

}