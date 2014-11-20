@isTest
public class Test_BLN_MyticketsCon{
    static testmethod void Testmethod_BLN_MyticketsCon(){
        
        User U= new User();
        globalForTestClass globalTest= new globalForTestClass();
        U= globalTest.createUserForGNUser();        
        
        Currency__c currenyInfo= new Currency__c();
        currenyInfo= globalTest.createCurrency();             
            
        Country__c countryInfo= new Country__c();
        countryInfo= globalTest.createCountry(currenyInfo.Id);  
            
        State__c stateInfo= new State__c ();
        stateInfo= globalTest.createState(countryInfo.Id);
            
        GN_User__c  gnUser= new GN_User__c();
        gnUser= globalTest.createGNUser(u,countryInfo.Id, Stateinfo.Id);
             
        system.runas(U){
        
            
            Company__c companyInfo= new Company__c();
            companyInfo= globalTest.createCompany(u.Companyname);
            
            
            BLN_Event__c eventInfo= new  BLN_Event__c();
            eventInfo= globalTest.createEvent(countryInfo.Id, Stateinfo.Id ,CompanyInfo.id); 
            
            Order__c insertOrder1= new Order__c();
            insertOrder1= globalTest.createOrder(gnUser.Id, u.id, companyInfo.Id, eventInfo.Id, currenyInfo.Id);
            
            Item_Type__c itemType= new Item_Type__c();
            itemType= globalTest.createItemType();
            
            BLN_Track__c trackInfo= new BLN_Track__c();
            trackInfo= globalTest.createTrack(eventInfo.id);
            
            Item_Pool__c ItemPool= new Item_Pool__c();
            ItemPool= globalTest.createItemPool(eventInfo.id, itemType.Id, NULL, trackInfo.id);
            
            Item_Pool__c ItemPool2= new Item_Pool__c();
            ItemPool2= globalTest.createItemPool(eventInfo.id, itemType.Id, ItemPool.Id, trackInfo.id);
            
            BLN_Item__c item= new BLN_Item__c();
            item= globalTest.createItem(ItemPool.Id, itemType.Id, eventInfo.id);
            
            Order_Item__c orderItem= new Order_Item__c();
            orderItem= globalTest.createOrderItem(item.Id, insertOrder1.Id, null, currenyInfo.Id);
        
            Promotion__c promotion= new Promotion__c();
            promotion= globalTest.createPromotion(eventInfo.id, 'promotionName', 'Basic Promo Codes', 'Percent');
            
            Item_Promotion__c itemPromotion= new Item_Promotion__c();
            itemPromotion= globalTest.createItemPromotion(item.Id, promotion.Id, 'Percent');
            
            Ticket__c ticket= new Ticket__c();
            ticket= globalTest.createTicket(eventInfo.id, item.Id, itemPool.Id, itemType.Id, insertOrder1.Id, gnUser.id);
           
            cookie  counter = new Cookie('counter',eventInfo.id,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{counter});
            PageReference pageRef2 = Page.BLN_Mytickets;
            Test.setCurrentPage(pageRef2);
              
            BLN_MyticketsCon myTicketRepTest= new BLN_MyticketsCon();
            myTicketRepTest.displayPermissions();
            myTicketRepTest.getRecordsForExport();
            myTicketRepTest.setRecordsForExport('Manasa');
            myTicketRepTest.onchangeEvent();
            ApexPages.CurrentPage().getParameters().put('guestindex','0');            
            myTicketRepTest.renderDetails();
            
            ApexPages.CurrentPage().getParameters().put('edform',insertOrder1.Id); 
            myTicketRepTest.displayorderEditform();
            myTicketRepTest.Saveord();
            myTicketRepTest.CloseGuests();
            myTicketRepTest.cancelTotalorder();
            myTicketRepTest.exportOrders();
            myTicketRepTest.inncurrentTickets[0].selectCheckBox= TRUE;
            myTicketRepTest.userSelectPerticularToExport();
            myTicketRepTest.cancelOrdDetail();
            
            ApexPages.CurrentPage().getParameters().put('TicketIdparam',ticket.Id);            
            myTicketRepTest.editTicket();
            myTicketRepTest.SaveGuests();
            
            ApexPages.CurrentPage().getParameters().put('canordItemId',orderItem.Id);             
            myTicketRepTest.cancelDirectTicket();
            
            ApexPages.CurrentPage().getParameters().put('canticId',ticket.Id);            
            //myTicketRepTest.cancelPerticularGuestsTic();
            myTicketRepTest.closeCan();
            myTicketRepTest.saveLogic(u, ticket, insertOrder1, gnUser);
        }  
  
    }
}