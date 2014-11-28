@isTest
public class Test_goalCon 
{
    static testmethod void Testmethod_goalCon()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name ='National Sales Manager'];

        User u = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = p.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'NSM', 
                           timezonesidkey='Asia/Kolkata', username='gcteste@gmail.com');
        insert u;
        
        Profile mp = [SELECT Id FROM Profile WHERE Name ='Sales Manager'];
        
        User eu = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = mp.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'Manager', 
                           timezonesidkey='Asia/Kolkata', username='gctestex@gmail.com');
        insert eu;
        
        Product__c pr = new Product__c(Name='Test product', Product_Price__c=500.00, Product_Code__c='TP');                                          
        insert pr;  
        
        Date activationdate = date.newInstance(2013, 11, 03);
        Date deactivationdate = date.newInstance(2015, 11, 03);
        
        Goal__c goa = new Goal__c(Start_Date__c = activationdate , End_Date__c = deactivationdate , Sales_Executive__c = eu.id , isActive__c = TRUE);
        insert goa;
        
        Goal_Line_Item__c goali = new Goal_Line_Item__c(Name = 'Test Goal-{1}', Goal__c= goa.id, Product__c = pr.id, Product_Quantity_in__c = 'Each', Quantity_Goal__c = 50 ,Revenue_Goal__c = 30000.00);
        insert goali;
        
        system.runAs(u){
            ApexPages.StandardController controller = new ApexPages.StandardController(goa);
            goalCon goacon = new goalCon(controller);
            goacon.addMore();
            goacon.deleteGoalLine();
            goacon.deletedId = 111;
            goacon.deleteGoalLine();
            goacon.findDuplicate();
            goacon.saveAllRecords(); 
        }
    }
}