public with sharing class APP_SupportingFilesController {
  
  public Application__c app {get; set;}
  
  public Attachment reference {get; set;}
  public Attachment statementEssay {get; set;}
  public Attachment resume {get; set;}
  public Attachment teachingLicense {get; set;}

  private List<Attachment> attachments;
  private Map<String,Blob> idToBlob;
  //private Application__c app;

  public Boolean isEducationProgram;
  public Boolean requireLOR;

  public APP_SupportingFilesController() {

    //System.debug('USERID: ' + UserInfo.getUserId()); 
    User u = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
    Contact c = [SELECT Id FROM Contact WHERE Id = :u.ContactId];

    app = [SELECT 
    Program__c, 
    Concentration__c, 
    Start_Term__c, 
    Bachelors_Transcript_Received__c,
    Masters_Transcript_Received__c,
    LOR1_Received__c,
    LOR2_Received__c,
    LOR3_Received__c 
    FROM Application__c WHERE Contact__c = :c.Id];
    
    //List<Attachment> uploadedAttachments = [SELECT Id, Name, Description, Body, LastModifiedDate FROM Attachment WHERE ParentId = 'a03J000000A37Q5'];
    List<Attachment> uploadedAttachments = [SELECT 
    Id, 
    Name, 
    Description, 
    Body, 
    LastModifiedDate 
    FROM Attachment WHERE ParentId = :app.Id];

    Map<String,Attachment> nameToAttachment = new Map<String,Attachment>();
    
    idToBlob = new Map<String,Blob>();

    for(Attachment a : uploadedAttachments){
      nameToAttachment.put(a.Description, a);
      idToBlob.put(a.Id, a.Body);
    }

    //System.debug('uploadedAttachments: ' + uploadedAttachments);
    //System.debug('nameToAttachment: ' + nameToAttachment);

    reference = (nameToAttachment.get('Reference-1') != null) ? nameToAttachment.get('Reference-1') : new Attachment(Description='Reference-1');
    resume = (nameToAttachment.get('Resume') != null) ? nameToAttachment.get('Resume') : new Attachment(Description='Resume');
    statementEssay = (nameToAttachment.get('StatementEssay') != null) ? nameToAttachment.get('StatementEssay') : new Attachment(Description='StatementEssay');
    teachingLicense = (nameToAttachment.get('TeachingLicense') != null) ? nameToAttachment.get('TeachingLicense') : new Attachment(Description='TeachingLicense');
    //bachelorTranscripts = nameToAttachment.get('BachelorTranscripts');
    //masterTranscripts = nameToAttachment.get('MasterTranscripts');

    // These are attachments that the applicant can upload in the Community
    attachments = new List<Attachment>{ 
      reference, resume, statementEssay, teachingLicense
    };
  }

  public PageReference upload() {

    List<Attachment> attachmentsToUpsert = new List<Attachment>();

    // System.debug('attachments' + attachments); 

    for (Attachment a : attachments){
		if(a.Body != null){
			if(a.Id == null){
				a.OwnerId = UserInfo.getUserId();
	    		a.ParentId = app.Id;
	    		String fileExtension = getFileExtension(a.Name);
	    		a.Name = a.Description+fileExtension;
	    		attachmentsToUpsert.add(a);
	    		continue;
			}		
			if(a.Body != idToBlob.get(a.Id))
				attachmentsToUpsert.add(a);
		}
	}

    System.debug('idToBlob' + idToBlob);
    System.debug('attachmentsToUpsert' + attachmentsToUpsert);

      try {
        upsert attachmentsToUpsert; 
        
      } catch (DMLException e) {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachments'));
          return null;
      }

      PageReference pr = new PageReference('/UneOnlineHome');
      pr.getParameters().put('s','3');
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachments uploaded successfully'));
       return pr;
  }

  private String getFileExtension(String fileName){
  	System.debug('fileName: ' + fileName);
	String[] ext = fileName.split('\\.');
	if(ext[1] != null)
		return '.'+ext[1];
	return '';
  }

  // program dependent booleans
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
  public Boolean getRequireLOR() {
    Set<String> LORprograms = new Set<String>{
      'Master of Science in Health Informatics',
      'Graduate Certification in Health Informatics'
    };
    if(LORprograms.contains(app.Program__c))
      return true;
    return false;  
  }  
}