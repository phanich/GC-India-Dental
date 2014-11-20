@isTest
public class Test_BLN_UserEvents{
    static testmethod void Testmethod_BLN_UserEvents(){
        
        User U= new User();
        globalForTestClass globalTest= new globalForTestClass();
        U= globalTest.createUserForGNUser();        
        
         
        system.runas(U){
        
               
            Company__c companyInfo= new Company__c();
            companyInfo= globalTest.createCompany(u.Companyname);
            
            Currency__c currenyInfo= new Currency__c();
            currenyInfo= globalTest.createCurrency();             
            
            Country__c countryInfo= new Country__c();
            countryInfo= globalTest.createCountry(currenyInfo.Id);  
            
            State__c stateInfo= new State__c ();
            stateInfo= globalTest.createState(countryInfo.Id);     
            
            GN_User__c  gnUserInfo= new GN_User__c();
            gnUserInfo= globalTest.createGNUser(U, countryInfo.Id, stateInfo.Id);
       
            BLN_Event__c eventInfo= new  BLN_Event__c();
            eventInfo= globalTest.createEvent(countryInfo.Id, Stateinfo.Id ,CompanyInfo.id);     
            
            Role__c roleInfo= new Role__c();
            roleInfo= globalTest.createRole();
            
            UC_Role__c ucRoleInfo= new UC_Role__c();
            ucRoleInfo= globalTest.createUCRole(companyInfo.Id, eventInfo.Id, gnUserInfo.id, u.Id, roleInfo.id);  
            
            
            BLN_UserEvents userEvents= new BLN_UserEvents();
            
            userEvents.noevent();
            ApexPages.CurrentPage().getParameters().put('EventName',eventInfo.Id); 
            userEvents.manageEvent();
            
            ApexPages.CurrentPage().getParameters().put('EventName',eventInfo.Id);             
            userEvents.Editevent();
            userEvents.UpdateEvent();
            
            ApexPages.CurrentPage().getParameters().put('EventName',eventInfo.Id);             
            userEvents.deleteEvent();
            
            userEvents.cancel();
            ApexPages.CurrentPage().getParameters().put('EventName',eventInfo.Id);                         
            userEvents.myTickets();
         
        }
    }
    
}