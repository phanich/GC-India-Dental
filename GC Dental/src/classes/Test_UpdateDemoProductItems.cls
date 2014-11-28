@isTest
public class Test_UpdateDemoProductItems{
    static testmethod void testmethod_UpdateDemoProductItems(){
    
    Profile p = [SELECT Id FROM Profile WHERE Name ='Sales Manager'];

        User u = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = p.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'Manager', 
                           timezonesidkey='Asia/Kolkata', username='gctestm@gmail.com');
        insert u;
        
        Product__c pr = new Product__c(Name='Test product', Product_Price__c=500.00, Product_Code__c='TP');                                          
        insert pr;  
        
        Account a = new Account(Name='Test Customer',Phone__c ='9966565678', Class__c='A', Billing_State__c ='Andhra Pradesh');                 
        insert a;  
        
        Date activationdate = date.newInstance(2013, 11, 03);
        Date deactivationdate = date.newInstance(2015, 11, 03);
              
        Campaign__c camp = new Campaign__c(Name = 'Test Campaign', Activation_Date__c = activationdate , Deactivation_Date__c = deactivationdate , Campaign_Description__c = 'Test Description', isActive__c = TRUE);
        insert camp;
        
        Campaign_Line_Item__c campli = new Campaign_Line_Item__c(Name = 'Test Campaign-{1}',Campaign__c = camp.id, Product__c = pr.id, Quantity__c = 5 ,Product_Price__c = 300.00);
        insert campli;
        
                
        Demo_Product__c demo = new Demo_Product__c(Sales_Executive__c = u.id, From__c = date.newInstance(2013, 11, 11),To__c = date.newInstance(2014, 11, 11),is_active__c = True );
        insert demo;

        Demo_Product_Line_Item__c demoline = new Demo_Product_Line_Item__c(Name = 'Test demo-{1}',Demo_Product__c = demo.id, Product__c = pr.id, Quantity__c = 10, Quantity_in__c = 'Each');
        insert demoline;
              
        Date orderdate = date.today();
        
        SalesOrder__c so = new SalesOrder__c(Customer__c = a.id, Close_Date__c = orderdate, Working_with__c = u.id, Campaign__c = camp.id, Demo_Product__c = demo.id);
        insert so;
        
        Sales_Order_Line_Items__c soli = new Sales_Order_Line_Items__c(Name = 'TestOrder-{1}', SalesOrder__c = so.id, Product__c = pr.id, Order_Quantity__c = 5, Price__c = 1000.00, Quantity_in__c ='Each', Product_From__c = 'Sales Order');
        insert soli;
        
        Sales_Order_Line_Items__c soli1 = new Sales_Order_Line_Items__c(Name = 'TestOrder-{2}', SalesOrder__c = so.id, Product__c = pr.id, Order_Quantity__c = 5, Price__c = 1000.00, Quantity_in__c ='Each', Product_From__c = 'Campaign Products');
        insert soli1;
        
        Sales_Order_Line_Items__c soli2 = new Sales_Order_Line_Items__c(Name = 'TestOrder-{3}', SalesOrder__c = so.id, Product__c = pr.id, Order_Quantity__c = 5, Price__c = 1000.00, Quantity_in__c ='Each', Product_From__c = 'Demo Products');
        insert soli2;
        
        Goal__c goa = new Goal__c(Start_Date__c = activationdate , End_Date__c = deactivationdate , Sales_Executive__c = u.id , isActive__c = TRUE);
        insert goa;
        
        Goal_Line_Item__c goali = new Goal_Line_Item__c(Name = 'Test Goal-{1}', Goal__c= goa.id, Product__c = pr.id, Product_Quantity_in__c = 'Each', Quantity_Goal__c = 50 ,Revenue_Goal__c = 30000.00);
        insert goali;
        
        
        soli2.Order_Quantity__c = 8;
        soli2.Price__c = 0.00;
        update soli2;
        
        soli2.Order_Quantity__c = 0;
        soli2.Price__c = 0.00;
        delete soli2;
    }
}