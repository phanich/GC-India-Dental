@isTest
public class Test_DemoproductsCon{
static testmethod void Testmethod_DemoproductsCon(){

Profile p = [SELECT Id FROM Profile WHERE Name ='National Sales Manager'];

User mu = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = p.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'NSM', 
                           timezonesidkey='Asia/Kolkata', username='gctestm@gmail.com');

insert mu;

Profile mp = [SELECT Id FROM Profile WHERE Name ='Sales Manager'];
        
        User sm = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = mp.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'Manager', 
                           timezonesidkey='Asia/Kolkata', username='gctestex@gmail.com');
        insert sm;
        
        
Demo_Product__c demo = new Demo_Product__c();
demo.Sales_Executive__c = sm.id;
demo.From__c = date.newInstance(2013, 11, 11);
demo.To__c = date.newInstance(2014, 11, 11);
demo.is_active__c = True;
insert demo;

Product__c pro = new Product__c();
pro.Name = 'Test product';
pro.Product_Code__c = 'abc';
pro.Product_Price__c = 10.00;
insert pro;

Demo_Product_Line_Item__c demoline = new Demo_Product_Line_Item__c();
demoline.Name = 'Test demo-{1}';
demoline.Demo_Product__c = demo.id;
demoline.Product__c = pro.id;
demoline.Quantity__c = 10;
demoline.Quantity_in__c = 'Each';
insert demoline;

system.runas(mu){
ApexPages.StandardController controller = new ApexPages.StandardController(demo);
DemoproductsCon Dmo = new DemoproductsCon(controller);
Dmo.addMore();
Dmo.deletedemoLine();
Dmo.saveAllRecords();
Dmo.findDuplicate();
}
}
}