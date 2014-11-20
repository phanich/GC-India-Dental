@istest
public class Test_BLN_Profilecon{
    static testmethod void Testmethod_BLN_Profilecon(){
        
        User U= new User();
        globalForTestClass globalTest= new globalForTestClass();
        U= globalTest.createUserForGNUser();        
        
          
        system.runas(U){
            
             NAICS_Code__c naicsCodeInfo1= new NAICS_Code__c();
            naicsCodeInfo1= globalTest.createNaicsCode();
            
            NAICS_Code__c naicsCodeInfo2= new NAICS_Code__c();
            naicsCodeInfo2= globalTest.createNaicsCode();
            
            Currency__c currenyInfo= new Currency__c();
            currenyInfo= globalTest.createCurrency();             
            
           

            Country__c countryInfo= new Country__c();
            countryInfo= globalTest.createCountry(currenyInfo.Id);  
            
            State__c stateInfo= new State__c ();
            stateInfo= globalTest.createState(countryInfo.Id);     
            
            Company__c companyInfo= new Company__c();
            companyInfo= globalTest.createCompany(u.Companyname);
            
            Company_Ext__c companyExtInfo= new Company_Ext__c();
            companyExtInfo= globalTest.createCompanyExt(companyInfo.Id, naicsCodeInfo1.Id, naicsCodeInfo2.Id, countryInfo.Id, stateInfo.Id); 
            
                 
           
            GN_User__c  gnUserInfo= new GN_User__c();
            gnUserInfo= globalTest.createGNUser(U, countryInfo.Id, stateInfo.Id);
        
            BLN_Event__c eventInfo= new  BLN_Event__c();
            eventInfo= globalTest.createEvent(countryInfo.Id, Stateinfo.Id ,CompanyInfo.id);        
            
                        
            //User userForGNInfo= new User();
            //userForGNInfo= globalTest.createUserForGNUser();
            
            Role__c roleInfo= new Role__c();
            roleInfo= globalTest.createRole();
            
            UC_Role__c ucRoleInfo= new UC_Role__c();
            ucRoleInfo= globalTest.createUCRole(companyInfo.Id, eventInfo.Id, gnUserInfo.Id, U.Id, roleInfo.Id);
            
            UC_Role__c ucRoleInfo2= new UC_Role__c();
            ucRoleInfo2= globalTest.createUCRole(companyInfo.Id, NULL, gnUserInfo.Id, U.Id, roleInfo.Id);
           
            
            Pay_Address__c payAddressInfo= new Pay_Address__c();
            payAddressInfo= globalTest.createPayAddress(companyInfo.Id, eventInfo.Id, countryInfo.Id);
            
            
            cookie  counter = new Cookie('counter',eventInfo.id,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{counter});
            
            BLN_Profilecon profileCon= new BLN_Profilecon();
            profileCon.cpmdetails();
            profileCon.countryStates();
            profileCon.statesBasedOnCountry();
            profileCon.HomestatesBasedOnCountry();
            ApexPages.CurrentPage().getParameters().put('billid',payAddressInfo.Id);
            profileCon.BillstatesBasedOnCountry();
            ApexPages.CurrentPage().getParameters().put('naicsCodes',naicsCodeInfo1.Id+'-'+naicsCodeInfo2.Id);            
            profileCon.sendNaicsCodes();
            profileCon.updatedetails();
            profileCon.cancel();
            
            
            
        }
    }
}