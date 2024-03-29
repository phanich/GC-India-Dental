public with sharing class BLN_Pay_Address_DAO{

/***********************************************************************************************
*   Controller Name         : BLN_Pay_Address_DAO
*   Date                    : 16/06/2014 
*   Author                  : Mahesh Sakunala
*   Purpose                 : This class is for inserting and retrieving pay address.
**************************************************************************************************/
    
    // This method is used for inserting pay address during payments.
    public BLN_StatusMessage insertPayAddress(Pay_Address__c PayAddress){
        Database.Upsertresult PayAddressResult = Database.Upsert(PayAddress,false);
        return new BLN_StatusMessage(PayAddressResult);
    }
    //This method is used for getting payment address to show as a billing address in profile page
    public List<Pay_Address__c> getbillingAddress(string cid){
    List<Pay_Address__c> billingaddress = [select id,City__c,Company__c,BLN_Country__c,
                                                  BLN_State__c,Street1_Address__c,Street2_Address__c,Zip__c from Pay_Address__c where Company__c = : cid ];
    return billingaddress;
    }

}