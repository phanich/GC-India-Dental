@istest
public class Test_BLN_EventstaffCon{
    static testmethod void Testmethod_BLN_EventstaffCon(){
    
    User U= new User();
    globalForTestClass globalTest= new globalForTestClass();
    U= globalTest.createUser();
    
    system.runas(U){
        
            BLN_Event__c eventInfo= new  BLN_Event__c();
            eventInfo= globalTest.createEvent();
            
            User userForGN= new User();
            userForGN= globalTest.createUserForGNUser();
            
            GN_User__c  gnUser= new GN_User__c();
            gnUser= globalTest.createGNUser(userForGN);
            
            Company__c companyInfo= new Company__c();
            companyInfo= globalTest.createCompany(userForGN.Companyname);
            
            Currency__c currenyInfo= new Currency__c();
            currenyInfo= globalTest.createCurrency();
            
            Role__c roleid = new Role__c();
            roleid.Name = 'Full Admin';
            
            insert roleid;
           
           
            UC_Role__c UCR = new UC_Role__c();
            UCR.Company__c = companyInfo.id;
            UCR.RoleId__c = roleid.id;
            UCR.GN_User__c = gnUser.id;
            UCR.Event__c = eventInfo.id;
            
            insert UCR;
            
            
                     
            Item_Type__c itemType= new Item_Type__c();
            itemType= globalTest.createItemType();
            
            Item_Pool__c ItemPool= new Item_Pool__c();
            ItemPool= globalTest.createItemPool(eventInfo.id, itemType.Id);
            
            BLN_Item__c item= new BLN_Item__c();
            item= globalTest.createItem(ItemPool.Id, itemType.Id, eventInfo.id);
            
            Order__c insertOrder1= new Order__c();
            insertOrder1= globalTest.createOrder(gnUser.Id, userForGN.id, companyInfo.Id, eventInfo.Id, currenyInfo.Id);
            
            Ticket__c ticket= new Ticket__c();
            ticket= globalTest.createTicket(eventInfo.id, item.Id, itemPool.Id, itemType.Id,insertOrder1.Id,gnUser.id);
            
            Hash_Tag__c HTag = new Hash_Tag__c ();
            HTag = globalTest.createHashTag(eventInfo.id);
            
            ItemPool_Tag_Junction__c Tagjun = new ItemPool_Tag_Junction__c ();
            Tagjun = globalTest.createtagjunction(itemPool.Id,HTag.id);
            
            cookie  counter = new Cookie('counter',eventInfo.id,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{counter});
            
            ApexPages.Currentpage().getparameters().put('UCID',UCR.id);
            
            BLN_EventstaffCon Eventstaff = new BLN_EventstaffCon();
            
            Eventstaff.AddStaff();
            Eventstaff.selecteditem = item.id;
            //Eventstaff.saveStaff();
            Eventstaff.cancel();
            Eventstaff.editstaff();
            
            
            
            
            
            
            
            }
        }
    }