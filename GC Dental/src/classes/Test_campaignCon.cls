@isTest
public class Test_campaignCon 
{
    static testmethod void Testmethod_campaignCon()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name ='Marketing Manager'];

        User u = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = p.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'NSM', 
                           timezonesidkey='Asia/Kolkata', username='gcteste@gmail.com');
        insert u;
        
        Product__c pr = new Product__c(Name='Test product', Product_Price__c=500.00, Product_Code__c='TP');                                          
        insert pr;  
        
        Date deactivationdate = Date.Today().AddDays(30);
        Date activationdate = Date.Today().AddDays(-1);
        
        
        Campaign__c camp = new Campaign__c(Name = 'Test Campaign', Activation_Date__c = activationdate , Deactivation_Date__c = deactivationdate , Campaign_Description__c = 'Test Description', isActive__c = TRUE);
        insert camp;
        
        Campaign_Line_Item__c campli = new Campaign_Line_Item__c(Name = 'Test Campaign-{1}',Campaign__c = camp.id, Product__c = pr.id, Quantity__c = 5 ,Product_Price__c = 300.00);
        insert campli;
        
        system.runas(u){
            ApexPages.StandardController controller = new ApexPages.StandardController(camp);
            campaignCon campcon = new campaignCon(controller); 
            campcon.addMore();
            campcon.deleteCampaignLine();
            campcon.deletedId = 111;
            campcon.deleteCampaignLine();
            campcon.findDuplicate();
            campcon.saveAllRecords();
        }
        
        
    }
}