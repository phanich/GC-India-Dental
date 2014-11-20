@istest
public class Test_BLN_CustomBagdeCon{
    static testmethod void Testmethod_BLN_CustomBagdeCon(){
    
    User U= new User();
        globalForTestClass globalTest= new globalForTestClass();
        U= globalTest.createUserForGNUser();        
        
         Currency__c currenyInfo= new Currency__c();
    currenyInfo= globalTest.createCurrency();             
            
    Country__c countryInfo= new Country__c();
    countryInfo= globalTest.createCountry(currenyInfo.Id);  
            
    State__c stateInfo= new State__c ();
    stateInfo= globalTest.createState(countryInfo.Id);     
    
    
        GN_User__c  gnUserInfo= new GN_User__c();
        gnUserInfo= globalTest.createGNUser(U,countryInfo.Id,stateInfo.Id);
    
    system.runas(U){
    
    Company__c companyInfo= new Company__c();
    companyInfo= globalTest.createCompany(u.Companyname);
            
   
    BLN_Event__c eventInfo= new  BLN_Event__c();
    eventInfo= globalTest.createEvent(countryInfo.Id, Stateinfo.Id ,CompanyInfo.id);   
    
      BLN_Track__c trackInfo= new BLN_Track__c();
            trackInfo= globalTest.createTrack(eventInfo.Id);
           
            Role__c roleInfo= new Role__c();
            roleInfo= globalTest.createRole();
           
    UC_Role__c ucRoleInfo= new UC_Role__c();
    ucRoleInfo= globalTest.createUCRole(companyInfo.Id, eventInfo.Id, gnUserInfo.id, u.Id, roleInfo.Id);    
            
    
            
    
    
    Order__c insertOrder1= new Order__c();
    insertOrder1= globalTest.createOrder(gnUserInfo.Id, U.id, companyInfo.Id, eventInfo.Id, currenyInfo.Id);
    
    Item_Type__c itemType= new Item_Type__c();
    itemType= globalTest.createItemType();
    
    Item_Pool__c ItemPool1= new Item_Pool__c();
    ItemPool1= globalTest.createItemPool(eventInfo.id, itemType.Id, Null, trackInfo.Id);
            
    Item_Pool__c ItemPool2= new Item_Pool__c();
    ItemPool2= globalTest.createItemPool(eventInfo.id, itemType.Id, ItemPool1.Id, trackInfo.Id);
            
            BLN_Item__c item= new BLN_Item__c();
            item= globalTest.createItem(ItemPool1.Id, itemType.Id, eventInfo.id);
    
    Ticket__c ticket= new Ticket__c();
    ticket= globalTest.createTicket(eventInfo.id, item.Id, itemPool1.Id, itemType.Id,insertOrder1.Id,gnUserInfo.Id);
    
    PGateway_Type__c pgt= new PGateway_Type__c(Name='Authorize.Net');
    insert pgt;
    
    Pay_Gateway__c pw= new Pay_Gateway__c(PGateway_Type__c=pgt.id,Company__c=companyInfo.id);
    insert pw;
    
    BadgeTemplate_Styles__c bt= new BadgeTemplate_Styles__c(Name='Custom1',Event__c =eventInfo.id,BadgeName__c='Attendee');
    insert bt;
    
    PageReference pageRef = Page.BLN_Mytickets;
    Test.setCurrentPage(pageRef);
    
    cookie  counter = new Cookie('counter',eventInfo.id,null,-1,false);
    ApexPages.currentPage().setCookies(new Cookie[]{counter});
    
    BLN_CustomBagdeCon bcbc= new BLN_CustomBagdeCon();
    //bcbc.savedimensions();
   // bcbc.editBadge();
   //string delvalue = ApexPages.currentPage().getParameters().get('id');
    //bcbc.deletename();
      bcbc.updatetemplate();
    
    
    }
    
    }
}