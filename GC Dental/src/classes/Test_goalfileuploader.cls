@isTest
public class Test_goalfileuploader
{
    static testmethod void Testmethod_goalfileuploader ()
    {
      
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
            
            Date deactivationdate = Date.Today().AddDays(30);
            Date activationdate = Date.Today().AddDays(-1);
            
            Goal__c goa = new Goal__c(Start_Date__c = Date.Today().AddDays(-1)  , End_Date__c = deactivationdate , Sales_Executive__c = eu.id , isActive__c = TRUE);
            insert goa;
            
            Goal_Line_Item__c goali = new Goal_Line_Item__c(Name = 'Test Goal-{1}', Goal__c= goa.id, Product__c = pr.id, Product_Quantity_in__c = 'Each', Quantity_Goal__c = 50 ,Revenue_Goal__c = 30000.00);
            insert goali;
           

        PageReference pageRef = Page.Goalsimport;
        Test.setCurrentPage(pageRef );
        pageRef.getParameters().put('Id', goa.Id);
        goalfileuploader uploadController = new goalfileuploader ();
        
        String dataFromJavaScript = String.valueOf('Username,Start Date,End Date,Product,Quantity Goal,Quantity IN,Revenue Goalaazz11ttt222ggg' +'\n'+ 'gcteste@gmail.com,1/1/2014,31/1/2014,Test product,10000,Each,10000aazz11ttt222ggg'+'\n'+'????:::::******&&&&&&%%%%;;;;TestfileName.csv');        
                   Apexpages.currentPage().getParameters().put('one', dataFromJavaScript );
         string srtr = String.valueOf('Username, Start Date, End Date, Product, Quantity Goal, Quantity IN, Revenue Goal'+ '\n'+ 'gcteste@gmail.com,1/1/2014,31/1/2014,Test product,10000,Each,10000');
                    List<String> parsedCSV= new List<String>();
           
         parsedCSV.add(srtr);
         uploadController.ReadFile();
         uploadController.exportToCSV();
         uploadController.Goalsview();
         uploadController.Importpage();
         
         
         String dataFromJavaScript1 = String.valueOf('Username,Start Date,End Date,Product,Quantity Goal,Quantity IN,Revenue Goalaazz11ttt222ggg' +'\n'+ 'gcteste@gmail.com,1/1/2014,31/1/2014,Test product,10000,Each,10000aazz11ttt222ggg'+'\n'+'????:::::******&&&&&&%%%%;;;;TestfileName.xlsx');        
                   Apexpages.currentPage().getParameters().put('one', dataFromJavaScript1 );
         string srtr1 = String.valueOf('Username, Start Date, End Date, Product, Quantity Goal, Quantity IN, Revenue Goal'+ '\n'+ 'gcteste@gmail.com,1/1/2014,31/1/2014,Test product,10000,Each,10000');
                    List<String> parsedCSV1= new List<String>();
                    parsedCSV1.add(srtr1);
         uploadController.ReadFile();
         uploadController.exportToCSV();
         uploadController.Goalsview();
         uploadController.Importpage();
         
         String dataFromJavaScript2 = String.valueOf('Username,Start Date,End Date,Product,Quantity Goal,Quantity IN,Revenue Goalaazz11ttt222ggg' +'\n'+ 'gcteste@gmail.com,1/1/2014,31/1/2014,Test product1,12se43,Each,10000aazz11ttt222ggg'+'\n'+'????:::::******&&&&&&%%%%;;;;TestfileName.csv');        
                   Apexpages.currentPage().getParameters().put('one', dataFromJavaScript2);
         string srtr2 = String.valueOf('Username, Start Date, End Date, Product, Quantity Goal, Quantity IN, Revenue Goal'+ '\n'+ 'gcteste@gmail.com,1/1/2014,31/1/2014,Test product1,12se43,Each,10000');
                    List<String> parsedCSV2= new List<String>();
                    parsedCSV2.add(srtr2);
         uploadController.ReadFile();
         uploadController.exportToCSV();
         uploadController.Goalsview();
         uploadController.Importpage();
         
         

   
        }
        
        
        
    }
}