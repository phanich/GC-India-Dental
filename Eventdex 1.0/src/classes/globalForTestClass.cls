public without sharing class globalForTestClass{

    /**
        * @author : Manasa Gandham
        * @date 10/11/2014
        * @ This class is used for Code Coverage of all Test Classes
    */ 
    
    public User createUser(){
    
         //Account acc= new Account(Name='Globalnest');
         //insert acc;
         
         //contact con = new contact(firstname='testcontactfn',lastname='testcontactln',AccountId=acc.id);
         //insert con;
         Profile p = [select id from profile where name='System Administrator'];
         userRole r=[SELECT ID FROM userRole WHERE name =: 'CEO'];   
         // ------------------ Eventadmin Insert ---------------------

         User u = new User(alias = 'Test', email='testcode@noemail.com',
                           emailencodingkey='UTF-8',profileid = p.Id,lastname='codeTesting', languagelocalekey='en_US',
                           localesidkey='en_US',country='United States Of America', userRoleId= r.id, CompanyName= 'GlobalNest',
                           timezonesidkey='America/Los_Angeles', username='testcode@noemail.com');
         insert u;
         return u;     
         
    }
    
    public BLN_Event__c createEvent(id countryId, Id stateId, Id companyId){
    
        BLN_Event__c insertEvent= new BLN_Event__c();
        insertEvent.Name= 'Default Event(Boothleads)';
        insertEvent.Start_Date__c= system.today();
        insertEvent.End_Date__c= system.today()+4; 
        insertEvent.Start_Time__c= '7:00 AM';
        insertEvent.End_Time__c= '4:00 PM'; 
        insertEvent.Hosting_Location__c= 'Hyderabad';
        insertEvent.Organizer_Email__c= 'manasatest@gmail.com';
        insertEvent.organizer_id__c= companyId;
        insertEvent.BLN_State__c= stateId;
        insertEvent.BLN_Country__c= countryId;
        insertEvent.Event_Ticket_Options__c='Collect info from Buyers only';
        
        insert insertEvent;      
        return insertEvent;
        
    }
    
    public Item_Type__c createItemType(){
    
        Item_Type__c insertItemType= new Item_Type__c();
        insertItemType.Name= 'Package';
        insertItemType.Badge_Label__c= 'BadgeLabel';
        insertItemType.Order__c= 22.12;
        insertItemType.Add_On__c= TRUE;
        
        insert insertItemType;
        
        return insertItemType;
    }
    
    public Item_Pool__c createItemPool(Id eventId, Id itemTypeId, Id itemPoolId, Id trackId){
        
        Item_Pool__c insertItemPool= new Item_Pool__c();
        
        //BLN_Event__c insertEvent= new BLN_Event__c();
        //insertEvent= createEvent();  
        
        //Item_Type__c insertItemType= new Item_Type__c();
        //insertItemType= createItemType();
               
        insertItemPool.Event__c= eventId;
        insertItemPool.Item_Pool_Name__c= 'ItemPool';
        insertItemPool.item_type__c= itemTypeId;
        insertItemPool.Item_Count__c= 12;
        insertItemPool.Addon_Parent__c= itemPoolId;
        insertItemPool.Track__c= trackId;
        insertItemPool.Addon_Count__c= 4;
        insert insertItemPool;
        
        return insertItemPool;
    }
    
    public BLN_Item__c createItem(Id itemPoolId, Id itemTypeId, Id eventId){
        
        //Item_Pool__c insertItemPool= new Item_Pool__c();
        //insertItemPool= createItemPool();
        
        //Item_Type__c insertItemType= new Item_Type__c();
        //insertItemType= createItemType();
       
        
        BLN_Item__c insertItem= new BLN_Item__c();
        insertItem.item_name__c= 'testItem';
        insertItem.Item_Pool__c= itemPoolId;
        insertItem.item_type__c= itemTypeId;
        insertItem.Event__c= eventId;
        insertItem.price__c= 22.50;
        insertItem.Payment__c= 'Paid';
        insertItem.item_count__c= 10;
        
        insert insertItem;
        return insertItem;
    }
    
    
    public User createUserForGNUser(){
    
         Account acc= new Account(Name='Globalnest');
         insert acc;
    
        contact con = new contact(firstname='gn',lastname='user',AccountId=acc.id);
        insert con;
        Profile p = [select id from profile where name='Event Admin'];
        //userRole r=[SELECT ID FROM userRole WHERE name =: 'Custom Role'];   userRoleId= r.id,
        User insertUser= new User(alias = 'gn', email='gnuser@noemail.com', firstname= 'fngn', Phone= '9878654345',ContactId= con.Id,
                                  emailencodingkey='UTF-8',profileid = p.Id,lastname='gnuser', languagelocalekey='en_US',
                                  localesidkey='en_US',country='United States Of America', CompanyName= 'GlobalNest',
                                  timezonesidkey='America/Los_Angeles', username='gnuser@noemail.com', Title= 'SFDC Developer');
        insert insertUser;
        return insertUser;        
    }    
    
    public GN_User__c createGNUser(User userInfo, Id CountryId, Id stateId){
        
        GN_User__c insertGNUser= new GN_User__c();
        
        //User insertUser= new User();
        //insertUser= createUserForGNUser();
        
        insertGNUser.User__c= userInfo.Id;
        insertGNUser.Company_Name__c= userInfo.CompanyName;
        insertGNUser.Email__c= userInfo.email;
        insertGNUser.First_Name__c= userInfo.firstname;
        insertGNUser.Last_Name__c= userInfo.lastname;
        insertGNUser.Phone__c= userInfo.Phone;
        insertGNUser.Title__c= userInfo.Title;
        insertGNUser.Country__c= CountryId;
        insertGNUser.State__c= stateId;
        
        insert insertGNUser;
        return insertGNUser;
        
    }
    
    public Company__c createCompany(String compName){
        
        Company__c insertCompany= new Company__c();
        insertCompany.Name= compName;        
        insert insertCompany;
        
        return insertCompany;
    }
    
    public Company_Ext__c createCompanyExt(Id companyId, Id primaryNaicsId, Id secondaryNaicsId, Id countryId, Id stateId){
        Company_Ext__c insertCompanyExt= new Company_Ext__c();
        insertCompanyExt.Company__c= companyId;
        insertCompanyExt.Primary_NAICS_Code__c= primaryNaicsId;
        insertCompanyExt.Secondary_NAICS_Code__c= secondaryNaicsId;
        insertCompanyExt.BLN_Business_Country__c= countryId;
        insertCompanyExt.BLN_Business_State__c= stateId;
        
        insert insertCompanyExt;
        return insertCompanyExt;
        
    }
    
    
    
    public Promotion__c createPromotion(Id eventId, String promotionName, String promotionType, String discountType){
              
        Promotion__c insertPromotion= new Promotion__c();        
         
        //BLN_Event__c insertEvent= new BLN_Event__c();
        //insertEvent= createEvent();      
       
        insertPromotion.Name= promotionName;
        insertPromotion.Promo_Code__c= 'BASIC-0001';
        insertPromotion.Event__c= eventId;
        insertPromotion.Eff_TimeStamp__c= system.today();
        insertPromotion.Exp_TimeStamp__c= system.today()+2;
        insertPromotion.Discount_Value__c = 8;
        insertPromotion.Discount_Type__c= discountType;
        insertPromotion.Promotion_Type__c= promotionType;
        insertPromotion.Status__c= 'Active and Enable for online registrations';
        insertPromotion.Type__c= 'Promo code';
        
        insert insertPromotion;
        return insertPromotion;
        
    }
    
    public Item_Promotion__c createItemPromotion(Id itemId, Id itemPromotionId, String itemDiscType){
        
        Item_Promotion__c insertItemPromotion= new Item_Promotion__c();
        
        //Promotion__c insertPromotion= new Promotion__c();
        //insertPromotion= createPromotion();
        
        //BLN_Item__c insertItem= new BLN_Item__c();
        //insertItem= createItem();
       
        insertItemPromotion.Buy_Item__c= itemId;
        insertItemPromotion.Buy_Item_Quantity__c= 2;
        insertItemPromotion.Item_Discount_Type__c= itemDiscType;
        insertItemPromotion.Item_Discount_Value__c= 10;
        insertItemPromotion.Free_Item__c= itemId;
        insertItemPromotion.Free_Item_Quantity__c= 4;
        insertItemPromotion.Promotion__c= itemPromotionId;
        
        insert insertItemPromotion;
        return insertItemPromotion;
        
    }
    
    
    public Order_Item__c createOrderItem(Id itemId, Id orderId, Id promotionId, Id currencyId){
        
        Order_Item__c insertOrderItem= new Order_Item__c();
        
        //Item_Promotion__c insertItemPromotion= new Item_Promotion__c();
        //insertItemPromotion= createItemPromotion();
        
        //Order__c insertOrder= new Order__c();
        //insertOrder= createOrder();     
           
        insertOrderItem.Item__c= itemId;
        insertOrderItem.Order__c= orderId;
        insertOrderItem.Promotion__c= promotionId;
        insertOrderItem.Item_Discount__c= 10;
        insertOrderItem.Item_Price__c= 20;
        insertOrderItem.Item_Quantity__c= 2;
        insertOrderItem.Item_Total__c= 2;
        insertOrderItem.Status__c= 'Active';
        insertOrderItem.Currency__c= currencyId;
        
        insert insertOrderItem;
        return insertOrderItem;
        
    }
    
    
    public Ticket__c createTicket(Id eventId, Id itemId, Id itemPoolId, Id itemTypeId, Id orderId, id GNuserid){
        
        Ticket__c insertTicket= new Ticket__c();        
        
        //Order_Item__c insertOrderItem= new Order_Item__c();  
        //insertOrderItem= createOrderItem();
              
        //BLN_Item__c insertItem= new BLN_Item__c();
        //insertItem= createItem();
                        
        insertTicket.Event__c = eventId;
        insertTicket.Item__c = itemId;
        insertTicket.Item_Pool__c = itemPoolId;
        insertTicket.Item_Type__c = itemTypeId;                    
        insertTicket.Badge_Label__c =  'badgeLabel';
        insertTicket.Order__c= orderId;
        insertTicket.Ticket_Status__c= 'Booked';
        insertTicket.Client_GN_User__c = GNuserid;
        
        insert insertTicket;
        return insertTicket;
    }
    
    public Currency__c createCurrency(){
        
        Currency__c insertCurrency= new Currency__c();
        insertCurrency.Name= 'USD';
        insertCurrency.Currency_Name__c= 'US Dollar';
        insertCurrency.Currency_Symbol__c= '$';
        
        insert insertCurrency;
        return insertCurrency;
    }
    
    public Order__c createOrder(Id gnUserId, Id userId, Id compId, Id eventId, Id currencyId){
        
        Order__c insertOrder= new Order__c();
        
        insertOrder.Client_GN_User__c = gnUserId;
        insertOrder.Client_Company__c= compId;
        insertOrder.Client_User__c= userId;
        insertOrder.Events__c= eventId;
        insertOrder.Order_Total__c= 2;
        insertOrder.Transaction_Status__c= 'Completed';
        insertOrder.Amount_Paid__c= 25.12;
        insertOrder.Fee_Amount__c= 23.29;
        insertOrder.Currency_Code__c= currencyId;
        
        insert insertOrder;      

        return insertOrder;        
        
    }
    
    public BLN_Room__c createRoom(Id eventId){
    
        BLN_Room__c insertRoom= new BLN_Room__c();
        insertRoom.Name= 'New Room';
        insertRoom.Event__c= eventId;
        insertRoom.Room_Number__c= 'Room-0001';
        insert insertRoom;
        
        return insertRoom;
        
    }
    
    public Agenda__c createAgenda(Id eventId, Id trackId){
        
        Agenda__c insertAgenda= new Agenda__c();
        insertAgenda.Event__c= eventId;
        insertAgenda.BLN_Track__c= trackId;
        insertAgenda.Agenda_Type__c= 'Event level Agenda';
        insertAgenda.Agenda_Description__c= 'It is for test';
        
        insert insertAgenda;
        return insertAgenda;
        
    }
    
    public BLN_Track__c createTrack(Id eventId){
    
        BLN_Track__c insertTrack= new BLN_Track__c();
        insertTrack.name= 'New Track';
        insertTrack.Event__c= eventId;
        
        insert insertTrack;        
        return insertTrack;
    }
    
    public Participant__c createParticipant(Id userId, Id timeSlotId){
    
        Participant__c insertParticipant= new Participant__c();
        insertParticipant.Ext_ID__c= 'PARTICIPANT-1';
        insertParticipant.GN_User__c= userId;
        insertParticipant.Participant_Role__c= 'Speaker';
        insertParticipant.Time_Slot__c= timeSlotId;
        
        insert insertParticipant;
        return insertParticipant;
    }
    
    public Time_Slots__c createTimeSlot(Id agendaId, Id roomId){
        
        Time_Slots__c insertTimeSlot= new Time_Slots__c();
        insertTimeSlot.Agenda__c= agendaId;
        insertTimeSlot.Room__c= roomId;
        insertTimeSlot.Slot_Start_date__c= system.today();
        insertTimeSlot.Slot_End_date__c= system.today()+2;
        
        insert insertTimeSlot;
        return insertTimeSlot;
    }
    
    public Hash_Tag__c createHashTag(Id eventId){
    
        Hash_Tag__c HashTag = new Hash_Tag__c ();
        HashTag.Event__c = eventId;
        HashTag.Tag_Text__c = 'SPONSOR';
        
        insert HashTag;
        return HashTag;

    }
    public ItemPool_Tag_Junction__c createtagjunction(Id itemPoolId, Id HashTagId){
    
    ItemPool_Tag_Junction__c Tagjunction = new ItemPool_Tag_Junction__c ();
    Tagjunction.Pool_Id__c = itemPoolId;
    Tagjunction.Tag_Id__c = HashTagId;
    
    insert Tagjunction;
    return Tagjunction;
    
    }
    
    public Role__c createRole(){
        Role__c insertRole= new Role__c();
        insertRole.name= 'Company Admin';
        insertRole.Role_ShortName__c= 'CA';
        insert insertRole;
        return insertrole;
    }
    
    public UC_Role__c createUCRole(Id companyId, Id eventId, Id gnUserId, Id userId, Id roleId){
        
        UC_Role__c insertUCRole= new UC_Role__c();
        insertUCRole.Company__c= companyId;
        insertUCRole.Event__c= eventId;
        insertUCRole.Role__c= 'Company Admin';
        insertUCRole.RoleId__c= roleId;
        insertUCRole.GN_User__c= gnUserId;
        insertUCRole.User__c= userId;
        
        insert insertUCRole;
        return insertUCRole;
    }
    
    public Country__c createCountry(Id currencyId){
        Country__c insertCountry= new Country__c();
        insertCountry.Long_Name__c = 'United States Of America';
        insertCountry.Short_Name__c= 'US';
        insertCountry.Currency__c= currencyId;
        insertCountry.Order__c= 123;
        insert insertCountry;
        return insertCountry;
    }
    
    public State__c createState(Id countryId){
        State__c insertState= new State__c();
        insertState.Country__c= countryId;
        insertState.Long_Name__c= 'Andhra Pradesh';
        insertState.Order__c= 123;
        insertState.Short_Name__c= 'AP';
        
        insert insertState;
        return insertState;
    }
    
    public NAICS_Code__c createNaicsCode(){
        NAICS_Code__c insertNaicsCode= new NAICS_Code__c();
        insertNaicsCode.Name= 'Naics Code1';
        insertNaicsCode.Description__c= 'Naics Desc';
        
        insert insertNaicsCode;        
        return insertNaicsCode;
    }
    
    
    public Pay_Address__c createPayAddress(Id companyId, Id eventId, Id countryId){
        
        Pay_Address__c insertPayAddress= new Pay_Address__c();
        insertPayAddress.City__c= 'Hyderabad';
        insertPayAddress.Company__c= companyId;
        insertPayAddress.Event__c= eventId;
        insertPayAddress.BLN_Country__c= countryId;
        
        insert insertPayAddress;
        return insertPayAddress;
    }
    
    
    public Reg_Setting__c createRegSettings(Id eventId, Id itemPoolId, Id itemId, Id companyId, Id tagId, String settingType, String columnName){
    
        Reg_Setting__c insertRegSettings= new Reg_Setting__c();
        insertRegSettings.Event__c= eventId;
        insertRegSettings.Setting_Type__c= settingType;
        insertRegSettings.Group_Name__c= 'Basic Information'; 
        insertRegSettings.Item__c= itemId;
        insertRegSettings.Item_Pool__c= itemPoolId;
        insertRegSettings.Organizer__c= companyId;
        insertRegSettings.Tag_Id__c= tagId;
        insertRegSettings.Column_Name__c= columnName;
        
        insert insertRegSettings;
        return insertRegSettings;
    }
    
    public Hash_Tag__c createTag(Id eventId){
    
        Hash_Tag__c inserttag= new Hash_Tag__c();
        inserttag.Event__c= eventId;
        inserttag.RowId__c= 'Row1';
        inserttag.Table_Name__c= 'Tab01';
        inserttag.Tag_Text__c= 'Exhibitor';
        
        insert insertTag;        
        return insertTag;
    }
    
    public Question__c createQuestion(Id eventId){
        Question__c insertQue=new Question__c();
        insertQue.Event__c= eventId;
        insertQue.Question_Text__c= 'Who are you?' ;
        insertQue.Answer_Type__c='Text' ;
        insertQue.Question_Order__c=1 ;
    
        insert insertQue;
        return insertQue;
    }

    public Item_Question__c createItemQuestion(Id eventId, Id itemId, Id questionId){
        Item_Question__c insertItemQue=new Item_Question__c();
        insertItemQue.Event__c= eventId;
        insertItemQue.Item__c= itemId;
        insertItemQue.Question__c= questionId;
        insertItemQue.Question_Level__c='Event Level' ;
        insertItemQue.isRequired__c= True;
        insertItemQue.Visibility__c= True;
    
        insert insertItemQue;
        return insertItemQue;
    }
    
    public Answer__c createAnswer(Id questionId){
        Answer__c insertAns=new Answer__c();
        insertAns.Question__c= questionId;
        insertAns.Answer_Text__c= 'Yes I agree' ;
        insertAns.Answer_Order__c=1 ;
        insertAns.Answer_Default__c=True ;
    
        insert insertAns;
        return insertAns;
    }
    
    public User_Answer__c createUserAnswer(Id userId,Id itemQueId,Id answerId){
        User_Answer__c insertUsrAns=new User_Answer__c();
        insertUsrAns.UAnswer_Text__c= 'TP Answer';
        insertUsrAns.User__c= userId ;
        insertUsrAns.Item_Question__c=itemQueId;
        insertUsrAns.Answer__c=answerId;
    
        insert insertUsrAns;
        return insertUsrAns;
    }
    
    public EmailCampaign__c createEmailCampaign(BLN_Event__c EventInfo){
    
        EmailCampaign__c insertEmailCampaign= new EmailCampaign__c();
        insertEmailCampaign.Name =  'Lead Retrieval Sign Up Reminder';
        //insertEmailCampaign.CampEmailTemplate__c= et.CampEmailTemplate__c;
        insertEmailCampaign.CampFromEmailId__c =EventInfo.Organizer_Email__c;
        insertEmailCampaign.CampSubject__c  = 'Lead Retrieval Sign Up Reminder';
        insertEmailCampaign.Event__c=EventInfo.Id;
        insertEmailCampaign.Available_to_Use__c = true;
        insertEmailCampaign.Template_Type__c = 'Standard';
        insertEmailCampaign.CampType__c = 'Reminder';
        insertEmailCampaign.ToListType__c='Selected Contacts';
        insertEmailCampaign.System_Template_Type__c='TempType';
        insertEmailCampaign.Product_Type__c = 'Lead Retrieval';
        
        insert insertEmailCampaign;
        return insertEmailCampaign;    
     }
     
     public Event_Price__c createEventPrice(Id EventId, Id ItemTypeId){
         
         Event_Price__c insertEventPrice= new Event_Price__c();
         insertEventPrice.BL_Fee_Amount__c= 15.00;
         insertEventPrice.BL_Fee_Level__c= 'E - Event';
         insertEventPrice.BL_Fee_Percentage__c= 25.00;
         insertEventPrice.Event__c= eventId;
         insertEventPrice.Item_Count__c= 50;
         insertEventPrice.Item_type__c= ItemTypeId;
         
         insert insertEventPrice;
         return insertEventPrice;
     }
     
     public Registration_Template__c createRegistrationTemplate(){
         Registration_Template__c insertRegistrationTemplate= new Registration_Template__c();
         insertRegistrationTemplate.Header_Image_URL__c= '';
         insertRegistrationTemplate.Order__c= 1;
         insertRegistrationTemplate.Styles__c='width:250px;';
         insertRegistrationTemplate.Template_Image_URL__c= '';
         
         insert insertRegistrationTemplate;
         return insertRegistrationTemplate;
     }
}