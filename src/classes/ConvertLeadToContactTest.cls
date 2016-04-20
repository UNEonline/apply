@isTest
private class ConvertLeadToContactTest {
	
	@isTest static void testConvert() {
		Lead l = new Lead(
			FirstName = 'Dave',
			LastName = 'Grohl',
			Company = 'Remio',
			Status = 'Lead',
			Program__c = 'SPHP'
		);
		insert l;

		List<Contact> c = [SELECT Id FROM Contact WHERE LastName = 'Grohl'];
		System.assertEquals(1, c.size());
	}
	
	@isTest static void testDoNotConvert() {
		Lead l = new Lead(
			FirstName = 'Dave',
			LastName = 'Grohl',
			Company = 'Remio',
			Status = 'Lead'
		);
		insert l;

		List<Contact> c = [SELECT Id FROM Contact WHERE LastName = 'Grohl'];
		System.assertEquals(0, c.size());
	}
	
}