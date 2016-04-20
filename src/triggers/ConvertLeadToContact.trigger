trigger ConvertLeadToContact on Lead (after update) {
	
	List<Lead> leadsToConvert = new list<Lead>();
	for(Lead l: Trigger.new){
		if(l.Program__c == 'SPHP')
			if(!l.isConverted)
				leadsToConvert.add(l);
	}

	Id acctId = null;
	List<Account> acctList = [SELECT Id FROM Account WHERE Name = 'SPHP Applicants'];
	if(acctList.size() == 1)
		acctId = acctList[0].Id;

	LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
	List<Database.LeadConvert> leadConverts = new list<Database.LeadConvert>();

	for(Lead l : leadsToConvert){
		Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(l.Id);
		lc.setConvertedStatus(convertStatus.MasterLabel);
		lc.setDoNotCreateOpportunity(true);
		lc.setAccountId(acctId);
		leadConverts.add(lc);
	}

	if(!leadConverts.isEmpty()){ 
		Database.LeadConvertResult[] lcrList = Database.convertLead(leadConverts, false);
		for(Database.LeadConvertResult lcr : lcrList)
			System.assert(lcr.isSuccess());
	}


}