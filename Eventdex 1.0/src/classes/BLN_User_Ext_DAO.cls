public without sharing class BLN_User_Ext_DAO{
  /**
* @author :Manasa Gandham
* @date 10/31/2014
* @ This class is used for DML operations on User Ext object
*/ 

    public LIST<User_Ext__c> userExtsForUserIds(SET<Id> UserIds){
        LIST<User_Ext__c> userExtsList= new LIST<User_Ext__c>();
        userExtsList= [SELECT ID, User__c, Address1__c, Address2__c, City__c, State__r.Long_Name__c, Country__r.Long_Name__c, Zip_Code__c FROM  User_Ext__c WHERE User__c IN : UserIds];
        return userExtsList;
    }
}