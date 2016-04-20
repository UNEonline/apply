public with sharing class APP_AcademicInformationController {

	public Application__c app {get; set;}
	public Boolean isEducationProgram;
	public String step {get; set;}
	
	public APP_AcademicInformationController() {
		
		//System.debug('USERID: ' + UserInfo.getUserId());
		User u = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];

		app = [SELECT Institution_1__c, Institution_2__c, Institution_3__c, Classroom_Access_Verification__c, 
		Employed_as_Teacher__c, How_many_years_teaching__c, Employed_as_Teacher_Explain__c,
		Degree_Conferred_1__c, Degree_Conferred_2__c, Degree_Conferred_3__c, 
		Year_Attended_1_From__c, Year_Attended_2_From__c, Year_Attended_3_From__c, 
		Year_Attended_1_To__c, Year_Attended_2_To__c, Year_Attended_3_To__c,
		Certification_Verification__c, Program__c
		FROM Application__c WHERE Contact__c = :u.ContactId];

	}

	public Boolean getIsEducationProgram() {
		Set<String> educationPrograms = new Set<String>{
			'Master of Science in Education – General',
			'Master of Science in Education – Reading Specialist',
			'Certificate of Advanced Graduate Study – Advanced Educational Leadership',
			'Post-Master’s Graduate Certificate (Education)',
			'Doctor of Education – Transformative Leadership'
		};
		if(educationPrograms.contains(app.Program__c))
			return true;
		return false;	
	}

	public PageReference save() {

		//PageReference pageRef = new PageReference('/apply/apex/UneOnlineHome?s=3');
		PageReference pageRef = new PageReference('/apply/apex/UneOnlineHome?s=' + step);

		if(getIsEducationProgram()){
			if(!app.Certification_Verification__c || !app.Classroom_Access_Verification__c) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please check all agreement checkboxes.'));
				return null;
			} 
		} 

		app.Academic_Information_Complete__c = true;
		update app;
		return pageRef;

	}
}