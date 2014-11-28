@isTest
public class Test_salesOrderCon 
{
    static testmethod void Testmethod_salesOrderCon()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name ='Standard User'];

        User u = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = p.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'Manager', 
                           timezonesidkey='Asia/Kolkata', username='gctestm@gmail.com');
        insert u;
        
        Product__c pr = new Product__c(Name='Test product', Product_Price__c=500.00, Product_Code__c='TP');                                          
        insert pr;  
        
        Product__c pr1 = new Product__c(Name='Test product1', Product_Price__c=500.00, Product_Code__c='TP1');                                          
        insert pr1; 
        
        Product__c pr2 = new Product__c(Name='Test product2', Product_Price__c=500.00, Product_Code__c='TP2');                                          
        insert pr2; 
        
        Account a = new Account(Name='Test Customer',Phone__c ='9966565678', Class__c='A', Billing_State__c ='Andhra Pradesh');                 
        insert a;  
        
        system.debug('  Account   '+ a.id);
        
        Date deactivationdate = Date.Today().AddDays(30);
        Date activationdate = Date.Today().AddDays(-1);
              
        Campaign__c camp = new Campaign__c(Name = 'Test Campaign', Activation_Date__c = activationdate , Deactivation_Date__c = deactivationdate , Campaign_Description__c = 'Test Description', isActive__c = TRUE);
        insert camp;
        
        Campaign_Line_Item__c campli = new Campaign_Line_Item__c(Name = 'Test Campaign-{1}',Campaign__c = camp.id, Product__c = pr.id, Quantity__c = 5 ,Product_Price__c = 300.00 , Product_Type__c = 'Paid');
        insert campli;
        
                
        Demo_Product__c demo = new Demo_Product__c(Sales_Executive__c = u.id, From__c = activationdate ,To__c = deactivationdate ,is_active__c = True );
        insert demo;

        Demo_Product_Line_Item__c demoline = new Demo_Product_Line_Item__c(Name = 'Test demo-{1}',Demo_Product__c = demo.id, Product__c = pr.id, Quantity__c = 10, Quantity_in__c = 'Each');
        insert demoline;
              
        Date orderdate = date.today().addDays(1);
        
        SalesOrder__c so = new SalesOrder__c(Customer__c = a.id, Close_Date__c = orderdate, Working_with__c = u.id, Campaign__c = camp.id, Demo_Product__c = demo.id);
        insert so;
        
         system.debug('  SalesOrder   '+ so.id);
        
        Sales_Order_Line_Items__c soli = new Sales_Order_Line_Items__c(Name = 'TestOrder-{1}', SalesOrder__c = so.id, Product__c = pr.id, Order_Quantity__c = 5, Price__c = 1000.00, Quantity_in__c ='Each', Product_From__c = 'Sales Order',UniqueNumber__c=1);
        insert soli;
        
        Sales_Order_Line_Items__c soli1 = new Sales_Order_Line_Items__c(Name = 'TestOrder-{2}', SalesOrder__c = so.id, Product__c = pr1.id, Order_Quantity__c = 5, Price__c = 1000.00, Quantity_in__c ='Each', Product_From__c = 'Campaign Products',UniqueNumber__c=2);
        insert soli1;
        
        Sales_Order_Line_Items__c soli2 = new Sales_Order_Line_Items__c(Name = 'TestOrder-{3}', SalesOrder__c = so.id, Product__c = pr2.id, Order_Quantity__c = 5, Price__c = 1000.00, Quantity_in__c ='Each', Product_From__c = 'Demo Products',UniqueNumber__c=3);
        insert soli2;
        
        Demo_Product__c demo1 = [SELECT ID,Sales_Executive__c,From__c,To__c FROM Demo_Product__c WHERE ID =: demo.id];
        
        
        Date logdate = date.today();
        Task t = new Task(WhatId= a.id, Subject='Visited the Customer',Meeting_Type__c= 'Visited the Customer', ActivityDate = logdate, Sales_Order_No__c = so.name);
        insert t;

        system.runas(u){

            ApexPages.StandardController controller2 = new ApexPages.StandardController(new SalesOrder__c());
            
            apexpages.currentpage().getparameters().put('CF00NN0000000a28i_lkid', a.id);
            salesOrderCon socon = new salesOrderCon(controller2); 

            ApexPages.StandardController controllerD = new ApexPages.StandardController(so);
            salesOrderCon soconD = new salesOrderCon(controllerD); 
                                    
            socon.selecteddemo = demo1;
            socon.AddLineItems();
            socon.deleteSalesOrderLine();
            socon.deletedId = 111;
            socon.deleteSalesOrderLine();
            socon.demoProductRefine();
            
            socon.campaignRefine();
            socon.save();
        }
        
    }
}