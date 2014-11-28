@isTest
public class Test_updateGoals{
    static testmethod void testmethod_updateGoals(){
    
        Profile mp = [SELECT Id FROM Profile WHERE Name ='Sales Manager'];

        User mu = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = mp.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'Manager', 
                           timezonesidkey='Asia/Kolkata', username='gctestm@gmail.com');
        insert mu;
        
        Profile ep = [SELECT Id FROM Profile WHERE Name ='Sales Executive'];

        User eu = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = ep.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'Executive', GC_Manager__c = mu.id, 
                           timezonesidkey='Asia/Kolkata', username='gcteste@gmail.com');
        insert eu;
        
        system.runAs(eu){   
            
            Product__c pr = new Product__c(Name='Test product', Product_Price__c=500.00, Product_Code__c='TP');                                          
            insert pr;  
            
            Account a = new Account(Name='Test Customer',Phone__c ='9966565678', Class__c='A', Billing_State__c ='Andhra Pradesh', OwnerId = eu.id);                 
            insert a;  

            Date deactivationdate = Date.Today().AddDays(30);
            Date activationdate = Date.Today().AddDays(-1);
             
            Goal__c goa = new Goal__c(Start_Date__c = Date.Today().AddDays(-1)  , End_Date__c = deactivationdate , Sales_Executive__c = eu.id , isActive__c = TRUE);
            insert goa;
            
            Goal_Line_Item__c goali = new Goal_Line_Item__c(Name = 'Test Goal-{1}', Goal__c= goa.id, Product__c = pr.id, Product_Quantity_in__c = 'Each', Quantity_Goal__c = 50 ,Revenue_Goal__c = 30000.00);
            insert goali;
             
             
            Goal__c managergoal = new Goal__c(Start_Date__c = Date.Today().AddDays(-1)  , End_Date__c = deactivationdate , Sales_Executive__c = mu.id , isActive__c = TRUE);
            insert managergoal;
            
            Goal_Line_Item__c managerGoali = new Goal_Line_Item__c(Name = 'Test Goal-{1}', Goal__c= managergoal.id, Product__c = pr.id, Product_Quantity_in__c = 'Each', Quantity_Goal__c = 50 ,Revenue_Goal__c = 30000.00);
            insert managerGoali; 
             
                  
            Campaign__c camp = new Campaign__c(Name = 'Test Campaign', Activation_Date__c = activationdate , Deactivation_Date__c = deactivationdate , Campaign_Description__c = 'Test Description', isActive__c = TRUE);
            insert camp;
            
            Campaign_Line_Item__c campli = new Campaign_Line_Item__c(Name = 'Test Campaign-{1}',Campaign__c = camp.id, Product__c = pr.id, Quantity__c = 5 ,Product_Price__c = 300.00);
            insert campli;
              
                  
            Date orderdate = date.today().addDays(1);
            
            SalesOrder__c so = new SalesOrder__c(Customer__c = a.id, Close_Date__c = orderdate, Working_with__c = mu.id, Campaign__c = camp.id);
            insert so;
            
            Sales_Order_Line_Items__c soli = new Sales_Order_Line_Items__c(Name = 'TestOrder-{1}', SalesOrder__c = so.id, Product__c = pr.id, Order_Quantity__c = 5, Price__c = 1000.00, Quantity_in__c ='Each', Product_From__c = 'Sales Order');
            insert soli;
            
            Sales_Order_Line_Items__c soli1 = new Sales_Order_Line_Items__c(Name = 'TestOrder-{2}', SalesOrder__c = so.id, Product__c = pr.id, Order_Quantity__c = 5, Price__c = 1000.00, Quantity_in__c ='Each', Product_From__c = 'Campaign Products');
            insert soli1;
    
        }    
        
    }
}