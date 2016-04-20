public with sharing class ApplicationPDF {

	public ApexPages.StandardController standardContactController;
	public ApexPages.StandardController contactController {get; set;}
	public Contact contact {get; set;}
		
	public ApplicationPDF(ApexPages.StandardController cntrl) {		
		standardContactController = cntrl;
		
		Application__c con = (Application__c)cntrl.getRecord();
		Application__c app = [SELECT Contact__c FROM Application__c WHERE Id = :con.Id];
		contact = this.getContactDetails(app.Contact__c);

		contactController = new ApexPages.StandardController(contact);
	}

	public pageReference doSaveAll() {
		standardContactController.save();
		contactController.save();
		return null;
	}

	public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Contact.FieldSets.Application_PDF.getFields();
    }

	private Contact getContactDetails(Id contactId) {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name FROM Contact WHERE Id =:contactId';
        return Database.query(query);
    }

}