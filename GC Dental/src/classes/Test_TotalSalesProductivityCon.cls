@isTest
public class Test_TotalSalesProductivityCon 
{
    static testmethod void Testmethod_TotalSalesProductivityCon()
    {
         Profile p = [SELECT Id FROM Profile WHERE Name ='Standard User'];

         User mu = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = p.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'Manager', 
                           timezonesidkey='Asia/Kolkata', username='gctestm@gmail.com');
         insert mu;
         
         User nu = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = p.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'NSM', 
                           timezonesidkey='Asia/Kolkata', username='gctestn@gmail.com');
         insert nu;
         
         User eu = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = p.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'Executive', 
                           timezonesidkey='Asia/Kolkata', username='gcteste@gmail.com');
         insert eu;
                           
         Account a = new Account(Name='Grand Total',Phone__c ='9966565678', Class__c='A', Billing_State__c ='Andhra Pradesh');                 
         insert a;  
         
         Product__c pr = new Product__c(Name='Test product', Product_Price__c=500.00, Product_Code__c='TP');                                          
         insert pr;                  
                         
        system.runAs(mu){
             TotalSalesProductivityCon tspCon = new TotalSalesProductivityCon();        
             tspCon.productwisereportselect();
             tspCon.executivewisereportselect();
             tspCon.customerwisereportselect();
             tspCon.noofvisitsreportselect();
             tspCon.goalsreportselect();    
        }
        
        system.runAs(nu){
             TotalSalesProductivityCon tspCon = new TotalSalesProductivityCon();          
        }
        
        system.runAs(eu){
             TotalSalesProductivityCon tspCon = new TotalSalesProductivityCon();            
        }
    }
}