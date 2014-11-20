public with sharing class BLN_Role_DAO {
	
	 
	
	  //BY Mallik
		public Role__c userRole(String roles){
			
			  Role__c role = [SELECT ID, NAME FROM Role__c WHERE Role_ShortName__c =: roles limit 1];
			
			return role;
		}
	 
}