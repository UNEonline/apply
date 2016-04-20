@isTest
private class CommunityControllersTest {

	static {

		//Create portal account owner
		UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
		Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'test2@test.com',
		   	Alias = 'batman',
			Email='bruce.wayne@wayneenterprises.com',
			EmailEncodingKey='UTF-8',
			Firstname='Bruce',
			Lastname='Wayne',
			LanguageLocaleKey='en_US',
			LocaleSidKey='en_US',
			TimeZoneSidKey='America/Chicago'
		);
		insert portalAccountOwner1;

		//Create account
		Account portalAccount1 = new Account(
			Name = 'TestAccount',
			OwnerId = portalAccountOwner1.Id
		);
		Database.insert(portalAccount1);
		    	
		//Create contact
		Contact contact1 = new Contact(
		   	FirstName = 'Test',
		    	Lastname = 'McTesty',
		    	Birthdate = Date.parse('3/1/1986'),
				AccountId = portalAccount1.Id,
		    	Email = System.now().millisecond() + 'test@test.com'
		);
		insert contact1;
		    	
		//Create user
		Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Customer Community Login User%' Limit 1];
		User user1 = new User(
			Username = System.now().millisecond() + 'test12345@test.com',
			ContactId = contact1.Id,
			ProfileId = portalProfile.Id,
			Alias = 'test123',
			Email = 'test12345@test.com',
			EmailEncodingKey = 'UTF-8',
			LastName = 'McTesty',
			CommunityNickname = 'test12345',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			LanguageLocaleKey = 'en_US'
		);
		insert user1;

      	Application__c app = new Application__c(
      		Contact__c = contact1.Id,
      		Application_Status__c = 'In Progress'
      	);
      	insert app;


	}
	
	@isTest static void appPersonal() {
		User u = [SELECT Id FROM User WHERE Email = 'test12345@test.com'];
		System.runAs(u) {
			APP_PersonalInformationController controller = new APP_PersonalInformationController();
			controller.save();
		}
	}
	
	@isTest static void appAcademic() {
		User u = [SELECT Id FROM User WHERE Email = 'test12345@test.com'];
		System.runAs(u) {
			APP_AcademicInformationController controller = new APP_AcademicInformationController();
			controller.save();
		}
	}

	@isTest static void appSignature() {
		User u = [SELECT Id FROM User WHERE Email = 'test12345@test.com'];
		System.runAs(u) {
			APP_SignatureController controller = new APP_SignatureController();
			controller.save();
		}
	}

	@isTest static void appProgram() {
		User u = [SELECT Id FROM User WHERE Email = 'test12345@test.com'];
		System.runAs(u) {
			APP_ProgramController controller = new APP_ProgramController();
			controller.save();
		}
	}

	@isTest static void appSupportingFiles() {
		User u = [SELECT Id FROM User WHERE Email = 'test12345@test.com'];
		Application__c app = [SELECT Id FROM Application__c LIMIT 1];
		Attachment a = new Attachment(
			ParentId = app.Id,
			Name = 'Test.pdf',
			Description = 'Reference',
			Body = Blob.valueOf('encodedContentsString')
		);
		insert a;
		System.runAs(u) {
			APP_SupportingFilesController controller = new APP_SupportingFilesController();
			controller.reference.Body = Blob.valueOf('encodedContentsString');
			controller.reference.Name = 'File.docx';
			Boolean isEducation = controller.getIsEducationProgram();
			controller.getRequireLOR();
			controller.upload();
		}
	}

	@isTest static void homeController() {
		User u = [SELECT Id FROM User WHERE Email = 'test12345@test.com'];
		System.runAs(u) {
			UneOnlineHomeController controller = new UneOnlineHomeController();
			controller.forwardToStartPage();
		}	
	}

	@isTest static void login() {
		LoginController controller = new LoginController();
		controller.forwardToRegisterPage();
		controller.forwardToCustomAuthPage();
		controller.login();
		controller.logout();
		controller.reset();
	}

	@isTest static void forgotPassword() {
		ForgotPasswordController controller = new ForgotPasswordController();
		controller.forgotPassword();
	}

	@isTest static void commSelfReg() {
		CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
		controller.registerUser();
		String testNickname = controller.communityNickname;
	}

	@isTest static void commSelfRegExistingUser() {
		CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
		controller.email = 'test12345@test.com';
		controller.registerUser();
		String testNickname = controller.communityNickname;
	}

	@isTest static void commSelfRegPwdMismatch() {
		CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
		controller.password = 'thisone';
		controller.password = 'thatone';
		controller.registerUser();
	}

	@isTest static void pageMessages() {
		PageMessages.addMessage(new PageMessages.PageMessage(PageMessages.Severity.WARN, 'ARGHH'));
	}

	@isTest static void applicationPDF() {
		Application__c app = [SELECT Id FROM Application__c LIMIT 1];
		ApplicationPDF controller = new ApplicationPDF(new ApexPages.StandardController(app));
		controller.doSaveAll();
	}
}