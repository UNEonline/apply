public with sharing class UneOnlineHomeController {

    public Contact c {get; set;}
    public String step {get; set;}
    public String stage {get; set;}

    public Boolean personalInfoComplete {get; set;}
    public Boolean academicInfoComplete {get; set;}
    public Boolean signatureComplete {get; set;}
    public Boolean programComplete {get; set;}
    public Boolean supportingFilesComplete {get; set;}

	public UneOnlineHomeController() {
		step = ApexPages.currentPage().getParameters().get('s');
	}

	// On page load.
    public PageReference forwardToStartPage() {

        System.debug('USER: ' + UserInfo.getUserType());

         if (UserInfo.getUserType() == 'Guest'){
            // redirect to login page if not logged in
            return new PageReference('/Login');
        }
        else {
            User u = [SELECT 
                ContactId 
                FROM User WHERE Id = :UserInfo.getUserId()];
            System.debug('u...' + u.ContactId);

            //Contact c = [SELECT 
            c = [SELECT
                Id,
                Status__c
                FROM Contact WHERE Id = :u.ContactId];
            
            Application__c app;
            List<Application__c> appList = [SELECT 
                Application_Status__c, 
                Personal_Information_Complete__c, 
                Academic_Information_Complete__c, 
                Supporting_Files_Complete__c, 
                Signature_Complete__c, 
                Program_Complete__c 
                FROM Application__c 
                WHERE Contact__c = :c.Id
            ];

            // application object exists
            if(appList.size() > 0) {
                app = appList[0];
            }
            
            // application object does not exist yet
            else {
                // create application object
                app = new Application__c(Contact__c = c.Id);
                insert app;

                // change contact status to 'Applicant'
                c.Status__c = 'Applicant';
                update c;
            }
            
            // get variables related to application progress
            programComplete = app.Program_Complete__c;
            personalInfoComplete = app.Personal_Information_Complete__c;
            academicInfoComplete = app.Academic_Information_Complete__c;
            supportingFilesComplete = app.Supporting_Files_Complete__c;            
            signatureComplete = app.Signature_Complete__c;            
            
            // set stage of application (progress status bubbles)
            stage = convertStatus(app.Application_Status__c);

            return null;
        }
    }

    public String convertStatus(String status){
        if(status == 'In Progress')
            return 'inprogress';
        if(status == 'Complete')
            return 'complete';   
        if((status == 'Accepted') || (status == 'Deposited') || (status == 'Denied') || (status == 'Declined Acceptance'))
            return 'reviewed';     
        return '';     
    }

}