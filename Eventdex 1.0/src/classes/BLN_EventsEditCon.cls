global with sharing class BLN_EventsEditCon { 
    
    public LIST<eventOptionsWrapper> eventSelectOptions{get; set;}
    public LIST<Event_Price__c> eventOptions{get; set;}
    public BLN_Event__c newEvent {get ; set ;}
     private final BLN_Event__c event_object; 
    
    public class eventOptionsWrapper{
        
        public Boolean eventOptionsBoolean{get; set;}
        public Event_Price__c eventOptionItemType{get; set;}
        
        public eventOptionsWrapper(Boolean b, Event_Price__c ite){
                eventOptionsBoolean = b;
                eventOptionItemType = new Event_Price__c();
                eventOptionItemType = ite;
                
        }
    }
    
    //builds a picklist of values based upon the passed information
    public List<selectOption> getPickValues(Sobject object_name, String field_name, String first_val) {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        if ( first_val != null ) { //if there is a first value being provided
            options.add(new selectOption(first_val, first_val)); //add the first option
        }
        Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            options.add(new selectOption(a.getLabel(), a.getValue()));  //add the value and label to our final list
        }
        return options; //return the List
    }
    
    
    //return the picklist options for users timezone
    public List<selectOption> getUserTimeZones() {
    User u=new User();
        return getPickValues(u,'TimeZoneSidKey', null);
    }
    
    //return the picklist options for event type
    public List<selectOption> getEventTypes() {
        return getPickValues(event_object, 'Event_Type__c', null);
    }
    
    //return the picklist options for event type
    public List<selectOption> getEventStatus() {
        return getPickValues(event_object, 'Event_Status__c', null);
    }
    
    
    public List<selectOption> getLanguageSetting() {
        //return getPickValues(event_object, 'Language_Settings__c', null);
        User u=new User();
        return getPickValues(u,'LocaleSidKey', null);
    }
    
    public List<selectOption> getPaymentType() {
        return getPickValues(new BLN_Item__c(), 'Payment__c', null);
    }
    
    
    
   
    public List<selectOption> getCountry(){
      
        LIST<SelectOption> countryOptions= new LIST<SelectOption>();
     
        for(Country__c c: [SELECT ID, NAME, Short_Name__c, Long_Name__c FROM Country__c ]){
            countryOptions.add(new SelectOption(c.id, c.Long_Name__c));
        }
         
       return countryOptions;
      
    }
    
    public List<SelectOption> itemtypesaddon{get;set;}
    public List<SelectOption> itemtypes{get;set;}
      public void getAddOnItemTypes(){
      
        itemtypesaddon= new LIST<SelectOption>();
        itemtypesaddon.addAll(individualTicketsSelectOptions);
     
        for(Item_Type__c c: [SELECT ID, NAME,Order__c FROM Item_Type__c where Add_On__c=true order by Order__c]){
            itemtypesaddon.add(new SelectOption(c.id, c.name));
        }
         
       
      
    }  
    
    //get package item type
     public List<SelectOption> itemtypespackage{get;set;}
    public void getPackageItemTypes(){
      
        itemtypespackage= new LIST<SelectOption>();
     
        for(Item_Type__c c: [SELECT ID, NAME FROM Item_Type__c where Item_Type_Number__c='IT-000005']){
            itemtypespackage.add(new SelectOption(c.id, c.name));
        }
         
     
      
    } 
    
    
   
     @RemoteAction
    public static List<SObject> statesBasedOnCountry(String country){
         //eventCurrency =  Currencies;
        return [SELECT ID, NAME, Short_Name__c,Long_Name__c, Country__c FROM State__c WHERE Country__c =: country];
 
    }
    
    @RemoteAction
    public static List<SObject> currencyBasedOnCountry(String country){
        Country__c coun = [SELECT id,Name,Currency__c,Currency__r.Currency_Name__c,Currency__r.Currency_Symbol__c from Country__c where id =: country];
         
         //eventCurrency =  Currencies;
        return [SELECT id,Name,Currency_Name__c, Currency_Symbol__c FROM Currency__c WHERE id =: coun.Currency__c];
 
    }
    
    public LIST<selectOption> paymentSelectOptions{get; set;}
    public LIST<selectOption> individualTicketsSelectOptions{get; set;}
    public LIST<Registration_Template__c> regTemplates{get; set;}
     public String itemdefaultmaxqty{get;set;}
     public String itemdefaultminqty{get;set;}
    
    public BLN_EventsEditCon(ApexPages.StandardController controller) {
    this.event_object = (BLN_Event__c)controller.getRecord();
    try{
    itemdefaultmaxqty=(String)BLN_Item__c.max_per_order__c.getDescribe().getDefaultValueFormula();
    itemdefaultminqty=(String)BLN_Item__c.min_per_order__c.getDescribe().getDefaultValueFormula();
    }catch(Exception e){}
        eventOptions = new LIST<Event_Price__c>();
       
        
         eventOptions.addAll(BLN_ItemType_DAO.eventOptionItemTypes(BLN_Event_UtilityCon.displayEventOptions(),ApexPages.currentPage().getParaMeters().get('id'))); 
         eventSelectOptions = new LIST<eventOptionsWrapper>();
         
         for(Event_Price__c itp: eventOptions){
                eventSelectOptions.add(new eventOptionsWrapper(FALSE, itp ));
         }
         
         
         //geting individual ticket standard item types
          individualTicketsSelectOptions = new LIST<selectOption>();
         SET<String> eventOptionsItemTypes = new SET<String>();
        BLN_Event_UtilityCon eventUtility = new BLN_Event_UtilityCon();
         eventOptionsItemTypes.addAll(eventUtility.allMainItemType());
        LIST<Event_Price__c> individualTicketsItemTypess = new LIST<Event_Price__c>();
        individualTicketsItemTypess = BLN_ItemType_DAO.itemTypesforIndividualTickets(eventOptionsItemTypes,ApexPages.currentPage().getParaMeters().get('id'));
        
         individualTicketsSelectOptions = BLN_ItemType_BAL.itemTypeSelectOptions(individualTicketsItemTypess);
         //Adding event option types
         for(Event_Price__c itemtpe:[select item_type__r.id,item_type__r.name,item_type__r.Item_Type_Number__c from Event_Price__c where (item_type__r.Item_Type_Number__c='IT-000010' or item_type__r.Item_Type_Number__c='IT-000004' or item_type__r.Item_Type_Number__c='IT-000003') and Active_Flag__c=true and Event__c=:ApexPages.currentPage().getParaMeters().get('id') order by item_type__r.Order__c])
         individualTicketsSelectOptions.add(new SelectOption(itemtpe.item_type__r.id,itemtpe.item_type__r.name));
         //
          //get all the Add On item types
         getAddOnItemTypes();
         //
         
         //get package item type
         getPackageItemTypes();
         //
         
         //get payment types for Item
         paymentSelectOptions=getPaymentType();
         //
         
         
         regTemplates = new LIST<Registration_Template__c>();
       
       
       regTemplates = [SELECT ID, NAME, Template_Image_URL__c,Order__c   FROM Registration_Template__c ORDER BY Order__c ];
       
       jsonWrapObj=new JSONWrapper();
       
       //for stripe
        authCode = ApexPages.currentPage().getParameters().get('code');
        authorizationCodeURI = 'https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_3jL4mUKJtvfExOYL8WrumSxkX7yh8P5m&scope=read_write';
        HttpResponse resToken;
        if(authCode != NULL){
        
            Http hToken = new Http();
            HttpRequest reqToken = new HttpRequest();
            reqToken.setEndpoint('https://connect.stripe.com/oauth/token?grant_type=authorization_code&code='+authCode+'&client_secret=sk_test_SEppbKiXBACmm9tRsJZkpB8l');
            reqToken.setMethod('POST');
            resToken = hToken.send(reqToken);
            body = resToken.getBody();
           
            jsonWrapObj = (JSONWrapper)JSON.deserialize(body, JSONWrapper.class);
            
            system.debug('********* '+jsonWrapObj.access_token);
        }
       //
    }


   
    @RemoteAction
    global static String savesEventInfo(String eventjsonInput,String eventlogourl) {
    BLN_Event__c ble=new BLN_Event__c();
   
       
    
    //Event object
    EventInfo eveinfo;
   
    // Parse entire JSON response for event mandatory fields.
    JSONParser parser = JSON.createParser(eventjsonInput);
    while (parser.nextToken() != null) {
        
                    eveinfo= (EventInfo)parser.readValueAs(EventInfo.class);
                   

       } 
       //put your update code
      //changetimezone(eveinfo.HostingTimeZone,eveinfo.LanguageSetting); 
      User u=[select id,name,TimeZoneSidKey,LocaleSidKey from User where id=:UserInfo.getUserId()];
        u.TimeZoneSidKey =eveinfo.HostingTimeZone; 
        u.LocaleSidKey=eveinfo.LanguageSetting;
        update u;
     System.debug('Hi '+eveinfo);
       ID eventID;
        BLN_Event__c newEvent  = new BLN_Event__c ();
        DataBase.saveResult docSaveResult;
                
        newEvent.Logo_URL__c=eventlogourl;                
       newEvent.Name = eveinfo.EventName;
       newEvent.City__c =eveinfo.EventCity;
       newEvent.BLN_Country__c  =eveinfo.EventCountry;
       newEvent.Description__c = eveinfo.EventDesc;
       LIST<string> Edatetimeval = eveinfo.EventEDate.split(' ');
       date dd = date.parse(Edatetimeval[0]);
       //string ddval = dd.month()+'-'+dd.date()+'-'+dd.year();
       newEvent.End_Date__c = dd;
       if(eveinfo.EventState!='')
       newEvent.BLN_State__c =eveinfo.EventState;
        newEvent.Street1__c =eveinfo.HostingAddress1;
        newEvent.Street2__c =eveinfo.HostingAddress2;
        LIST<string> Sdatetimeval = eveinfo.EventSDate.split(' ');
        newEvent.Start_Date__c = date.parse(Sdatetimeval[0]);
        newEvent.Time_Zone__c =eveinfo.HostingTimeZone;
        newEvent.Twitter_Hash_Tag__c =eveinfo.EventHashTag;
        newEvent.Twitter_URL__c = eveinfo.TwitterUrl;
        newEvent.Venue_Name__c  = eveinfo.EventLocation;
        newEvent.Website_Url__c =eveinfo.WebUrl;
        newEvent.ZipCode__c =eveinfo.ZipCode;
        newEvent.Phone_Number__c =eveinfo.PhoneNo;
        //newEvent.PO_Box__c =eveinfo.PoBox;
        newEvent.Facebook_URL__c =eveinfo.FacebookUrl;
        if(eveinfo.EventOrgEmail==null)
        eveinfo.EventOrgEmail=userinfo.getuseremail();
        newEvent.Organizer_Email__c =eveinfo.EventOrgEmail;
        newEvent.End_Time__c = Edatetimeval[1]+' '+Edatetimeval[2];
        newEvent.Start_Time__c = Sdatetimeval[1]+' '+Sdatetimeval[2];
        newEvent.Language_Settings__c = eveinfo.LanguageSetting;
        newevent.Event_Status__c= eveinfo.EventStatus;
        if(eveinfo.EventCategory!='')
        newEvent.Event_Type__c=eveinfo.EventCategory;

        //newEvent.Event_Blog_URL__c
        //newEvent.Event_Topic__c
        //newEvent.Event_Type__c 
        //newEvent.is_Corporate__c
        //newEvent.LinkedIn_URL__c
        //newEvent.Logo_URL__c
        //newEvent.Password__c
        //newEvent.Accept_Refund_Policy__c =
       //newEvent.Accept_Tax_Rate__c
       //newEvent.Accept_Terms_Conditions__c   
        //newEvent.Refund_Policy__c
        //newEvent.Registration_Template__c
        //newEvent.Service_Fee__c
        //newEvent.Show_Map__c
        //newEvent.Social_Hashtag__c
        //newEvent.Terms_Conditions__c
        
        //newEvent.Tax_Rate__c
        //newEvent.User_Company__c
        //newEvent.Waitlist__c
       IF(eveinfo.EventID == null){
       
       
         LIST<BLN_Event__c> eventsList = new LIST<BLN_Event__c>();
                        eventsList.add(newEvent);
                        
                        BLN_Events_BAL createEventBAL = new BLN_Events_BAL();
                         eventId = createEventBAL.createEvent(eventsList,eveinfo.OrgName);
       }      
       else{//FOR EVENT UPDATE
       //eveinfo.EventID = EventID;
       newEvent.id=eveinfo.EventID;
        LIST<BLN_Event__c> eventsList = new LIST<BLN_Event__c>();
                        eventsList.add(newEvent);
                        
                        BLN_Events_BAL createEventBAL = new BLN_Events_BAL();
                         eventId = createEventBAL.createEvent(eventsList,eveinfo.OrgName);
       
       
       }
       
       //return the eventId
       system.debug('::::::::::::::::EVENT ID :::::::::::::'+eventId );
    return eventId ;
   
    }
    
    
    class EventInfo {
    public String EventName{get;set;}
    public String EventSDate{get;set;}
    public String EventEDate{get;set;}
    public String EventLocation{get;set;}
    public String EventOrgEmail{get;set;}
    public String EventID{get;set;}
     public String AttendeeReg{get;set;}
    public String CurrencySetting{get;set;}
    public String EventCategory{get;set;}
    public String EventCity{get;set;}
    public String EventCountry{get;set;}
    public String EventDesc{get;set;}
    public String EventHashTag{get;set;}
    public String EventState{get;set;}
    public String EventStatus{get;set;}
    public String FacebookUrl{get;set;}
    public String HostingAddress1{get;set;}
    public String HostingAddress2{get;set;}
    public String HostingTimeZone{get;set;}
    public String LanguageSetting{get;set;}
    public String OrgName{get;set;}
    public String PhoneNo{get;set;}
    //public String PoBox{get;set;}
    public String TwitterUrl{get;set;}
    public String WebUrl{get;set;}
    public String ZipCode{get;set;}
    
    
    
    public EventInfo(String EventName,String EventSDate,String EventEDate,String EventLocation,String EventOrgEmail,String EventID,String AttendeeReg,String CurrencySetting,String EventCategory,String EventCity,String EventCountry,String EventDesc,String EventHashTag,
    String EventState,String EventStatus,String FacebookUrl,String HostingAddress1,String HostingAddress2,String HostingTimeZone,
    String LanguageSetting,String OrgName,String PhoneNo,String TwitterUrl,String WebUrl,String ZipCode) {
    this.EventName=EventName;
    this.EventSDate=EventSDate;
    this.EventEDate=EventEDate;
    this.EventLocation=EventLocation;
    this.EventOrgEmail=EventOrgEmail;
    this.EventID=EventID;
    this.AttendeeReg=AttendeeReg;
    this.CurrencySetting=CurrencySetting;
    this.EventCategory=EventCategory;
    this.EventCity=EventCity;
    this.EventCountry=EventCountry;
    this.EventDesc=EventDesc;
    this.EventHashTag=EventHashTag;
    this.EventState=EventState;
    this.FacebookUrl=FacebookUrl;
    this.HostingAddress1=HostingAddress1;
    this.HostingAddress2=HostingAddress2;
    this.HostingTimeZone=HostingTimeZone;
    this.LanguageSetting=LanguageSetting;
    this.OrgName=OrgName;
    this.PhoneNo=PhoneNo;
    //this.PoBox=PoBox;
    this.TwitterUrl=TwitterUrl;
    this.WebUrl=WebUrl;
    this.ZipCode=ZipCode;
    
    }
}  
    
   //tickets
   public static MAP<String, Boolean> TicketsDisplayInEventsPageBasedOnItemTypes{get; set;}
    public static MAP<ID, Event_Price__c> EventOptionsMAP{get; set;}
     public static MAP<String,  Item_Type__c> itemTypeMap{get; set;}  
     public static LIST<Item_Type__c> ItemTypes{get; set;}
   
    @RemoteAction
    global static List<TicketCreateInfo> getAllBLProduct(String eventid) {
    List<TicketCreateInfo> tcinfo=new List<TicketCreateInfo>();
       
      for(Event_Price__c ep:[select id,name,Active_Flag__c,Item_Type__r.Name,Item_Type__r.Id,BL_Fee_Amount__c from Event_Price__c where Event__c=:eventid and Item_type__r.Item_Type_Number__c in('IT-000003','IT-000004','IT-000007','IT-000010','IT-000008','IT-000009') and Active_Flag__c=true])
      {
          TicketCreateInfo tcinfo1=new TicketCreateInfo();
        tcinfo1.ticketName=ep.Item_Type__r.Name;
        tcinfo1.ticketId=ep.Item_Type__r.Id;
        tcinfo1.ticketPrice=String.valueOf(ep.BL_Fee_Amount__c);
        
         tcinfo.add(tcinfo1);
        }
        
    return tcinfo;
    }
    
     @RemoteAction
     global static List<TicketCreateInfo> getEventproducerpaiditems(String eventid) {
    List<TicketCreateInfo> tcinfo=new List<TicketCreateInfo>();
       
      
        for(Order_Item__c orditem:[select id,name,Item__c,Order__r.Events__c,Order__r.order_type__c,Item_Type__c,Item_Quantity__c from Order_Item__c where Order__r.Events__c=:eventid and Order__r.order_type__c='EVENT PRODUCER'])
        {
         TicketCreateInfo tcinfo1=new TicketCreateInfo();
        tcinfo1.ticketQty=String.valueOf(orditem.Item_Quantity__c);
        tcinfo1.itemId=orditem.Item__c;
        tcinfo1.ticketId=orditem.Item_Type__c;
         tcinfo.add(tcinfo1);
        }
        
    return tcinfo;
    }
   
  @RemoteAction
    global static List<TicketCreateInfo> getTickets(String ittypenumber,String id,String eventid) {
    
    //if(TicketsDisplayInEventsPageBasedOnItemTypes.get(ittypenumber))
    //{
    system.debug(id+'  TICKET NUMBER  '+ittypenumber);
    TicketsDisplayInEventsPageBasedOnItemTypes = BLN_Event_UtilityCon.itemTypesDisplayInEventsPage();
     BLN_EventOptions_DAO evo = new BLN_EventOptions_DAO();
         EventOptionsMAP = evo.queryEventOptions(eventid);
         Event_Price__c ep = new Event_Price__c();
         ep = EventOptionsMAP.get(id);
         
    
   
    
      String x=String.valueOf(TicketsDisplayInEventsPageBasedOnItemTypes.get(ittypenumber));
      ItemTypes = new LIST<Item_Type__c>();
      ItemTypes.addAll( BLN_ItemType_DAO.AllItemTypes(new LIST<String>()));
       itemTypeMap = new MAP<String,  Item_Type__c> ();
      for(Item_Type__c itt : ItemTypes ){
            itemTypeMap.put(itt.Item_Type_Number__c, itt);
        }
      Item_Type__c  itemType = ItemTypeMap.get(ittypenumber);
    String y=String.valueOf(ep.BL_Fee_Amount__c);
    
    
     // }
        //return itemType.Name+';'+x+';'+y;
        
        TicketCreateInfo tcinfo1=new TicketCreateInfo();
        tcinfo1.ticketName=itemType.Name;
        tcinfo1.ticketId=itemType.id;
        tcinfo1.ticketPrice=y;
       
        tcinfo1.show=true;//TicketsDisplayInEventsPageBasedOnItemTypes.get(ittypenumber);
        
        List<TicketCreateInfo> tcinfo=new List<TicketCreateInfo>();
        tcinfo.add(tcinfo1);
        
        if(ittypenumber=='IT-000003')
        {
          itemType = ItemTypeMap.get('IT-000004');
          ep = EventOptionsMAP.get([select id,name from Event_Price__c where Event__c=:eventid and Item_type__r.Item_Type_Number__c='IT-000004'].id);
          TicketCreateInfo tcinfo2=new TicketCreateInfo();
        tcinfo2.ticketName=itemType.Name;
        tcinfo2.ticketId=itemType.id;
        tcinfo2.ticketPrice=String.valueOf(ep.BL_Fee_Amount__c);
        
        tcinfo2.show=TicketsDisplayInEventsPageBasedOnItemTypes.get('IT-000004');
        
         tcinfo.add(tcinfo2);
        }
        return tcinfo;
    } 
    
   global class TicketCreateInfo
    {
     public String ticketName{get;set;}
     public String ticketPrice{get;set;}
     public String ticketQty{get;set;}
     public String ticketId{get;set;}
     public boolean show{get;set;}
      public String itemId{get;set;}
    
       
    } 
  
  
  @RemoteAction
    global static String savesTicketInfo(String tcktjsonInput,String eventID,String currentdate,String EventEDate) {
      String message='';
    //Remove existing records for update
    /*List<BLN_Item__c> delitems=[select id,name from BLN_Item__c where Event__c=:eventID];
    delete delitems;
    List<Item_Pool__c> delitemspool=[select id,name from Item_Pool__c where Event__c=:eventID];
    delete delitemspool;*/
     List<ItemPool_Tag_Junction__c> delhashtags=[select id,name,Tag_Id__r.Event__c from ItemPool_Tag_Junction__c where Tag_Id__r.Event__c=:eventID];
    delete delhashtags;
    //Ticket object
    List<ticket> tcinfo;
   
    // Parse entire JSON response for event mandatory fields.
    JSONParser parser = JSON.createParser(tcktjsonInput);
    while (parser.nextToken() != null) {
        
                    tcinfo= (List<ticket>)parser.readValueAs(List<ticket>.class);
                   

       } 
       
       System.debug('My Ticket Info '+tcinfo);
       //check for item updation
                
         
           for(integer i=0;i<tcinfo.size();i++)
    {
        
        if(tcinfo[i].grouptickets.size()!=0){
        
         for(integer j=0;j<tcinfo[i].grouptickets.size();j++){
         if(tcinfo[i].grouptickets[j].itemid.length()!=0)
        {
         for( BLN_Item__c olditem:[Select id,min_per_order__c,max_per_order__c, 
                        item_type__c, item_name__c, item_count__c,Item_Pool__c,Item_Pool__r.Item_Pool_Name__c,Available_Tickets__c From BLN_Item__c where Event__c=:eventID])
                        { 
             if(tcinfo[i].grouptickets[j].itemid==olditem.id&&olditem.Item_Pool__c==tcinfo[i].poolid&&Decimal.valueOf(tcinfo[i].grouptickets[j].qty)<olditem.item_count__c)
             {
                   Decimal minusquantity=(olditem.item_count__c-Decimal.valueOf(tcinfo[i].grouptickets[j].qty));  
                   if(minusquantity>olditem.Available_Tickets__c)    
                   {
                      
                      message=' Your total tickets for '+tcinfo[i].grouptickets[j].tname+' are '+olditem.item_count__c+'  and  sold/booked tickets are  '+(olditem.item_count__c-olditem.Available_Tickets__c)+'. So you can’t reduce the tickets to less than '+(olditem.item_count__c-olditem.Available_Tickets__c)+' tickets ';
                      return message;
                   }
                   
                    break; 
             }
            
             }//old item loop
             }
         }//group tickets loop
         
         }  
         
       }      
           
                        
      System.debug('tcinfo*** '+tcinfo);                  
      
       
     //create db objects
     List<Item_Pool__c> itpool=new List<Item_Pool__c>(); 
    //First Insert into Item Pool
    for(integer i=0;i<tcinfo.size();i++)
    {
        if(tcinfo[i].tname!=''){
        itpool.add(new Item_Pool__c());
        itpool[i].Item_Pool_Name__c=tcinfo[i].tname;
        itpool[i].Item_Count__c=Integer.valueOf(tcinfo[i].tqty);
        if(tcinfo[i].ispackage=='false'||tcinfo[i].ispackage=='')
        itpool[i].Package_Flag__c='I - Individual Item pool';
        else
        itpool[i].Package_Flag__c='P - Package item pool';
        itpool[i].Event__c=eventID;
        if(tcinfo[i].itemtype=='')
        {
        Item_Type__c itc;
        if(tcinfo[i].ispackage=='false'||tcinfo[i].ispackage=='')
        itc=[select id,Item_Type_Number__c from Item_Type__c where Item_Type_Number__c='IT-000001'];
        else
        itc=[select id,Item_Type_Number__c from Item_Type__c where Item_Type_Number__c='IT-000005'];
        
        itpool[i].Item_Type__c=itc.id;
        }
        else
        itpool[i].Item_Type__c=tcinfo[i].itemtype;
        itpool[i].Badge_Label__c=tcinfo[i].tbdglabel;
        System.debug('tcinfo[i].poolid '+tcinfo[i].poolid.length());
        if(tcinfo[i].poolid.length()!=0)
        itpool[i].id=tcinfo[i].poolid;
          }
    
    }
    
    upsert itpool;
    
    //Insertion of Package Line Items/Addon Into Pool
    List<Item_Pool__c> pklineitpool=new List<Item_Pool__c>(); 
     for(integer i=0,k=0;i<tcinfo.size();i++)
    {
        if(tcinfo[i].tname!=''){
        if(tcinfo[i].subpackagegroup.size()!=0){
         for(integer j=0;j<tcinfo[i].subpackagegroup.size();j++){
        pklineitpool.add(new Item_Pool__c());
        pklineitpool[k].Item_Pool_Name__c=tcinfo[i].subpackagegroup[j].pkgitemname;
        pklineitpool[k].Addon_Count__c=Integer.valueOf(tcinfo[i].subpackagegroup[j].pkgitemqty);
        pklineitpool[k].Item_Count__c=Integer.valueOf(tcinfo[i].subpackagegroup[j].pkgitemqty)*Integer.valueOf(itpool[i].Item_Count__c);
        pklineitpool[k].Package_Flag__c='A - Addon Item pool';
        pklineitpool[k].Event__c=eventID;
        pklineitpool[k].Item_Type__c=tcinfo[i].subpackagegroup[j].ttype;
        pklineitpool[k].Addon_Parent__c=itpool[i].id;
        pklineitpool[k].Badge_Label__c=tcinfo[i].subpackagegroup[j].badgelabel;
        if(tcinfo[i].subpackagegroup[j].addonid.length()!=0)
        pklineitpool[k].id=tcinfo[i].subpackagegroup[j].addonid;
      
        
        k++;
        }
        }
          }
    
    }
    
    upsert pklineitpool;
    String itemdefaultmaxqty=(String)BLN_Item__c.max_per_order__c.getDescribe().getDefaultValueFormula();
    String itemdefaultminqty=(String)BLN_Item__c.min_per_order__c.getDescribe().getDefaultValueFormula();
    
    
    
    //Second insert into item table the group tickets
     List<BLN_Item__c> item=new List<BLN_Item__c>(); 
    for(integer i=0,k=0;i<tcinfo.size();i++)
    {
        if(tcinfo[i].tname!=''){
        if(tcinfo[i].grouptickets.size()!=0){
             for(integer j=0;j<tcinfo[i].grouptickets.size();j++){
             
             if(tcinfo[i].grouptickets[j].tname!=''){
             item.add(new BLN_Item__c());
        item[k].item_name__c=tcinfo[i].grouptickets[j].tname;
        item[k].item_count__c=Integer.valueOf(tcinfo[i].grouptickets[j].qty);
        item[k].sale_start__c=DateTime.parse(tcinfo[i].grouptickets[j].sdate);
        item[k].sale_end__c=DateTime.parse(tcinfo[i].grouptickets[j].edate);
        item[k].price__c=tcinfo[i].grouptickets[j].tprice==''?0:Integer.valueOf(tcinfo[i].grouptickets[j].tprice);
         item[k].min_per_order__c=tcinfo[i].grouptickets[j].minqty==''?Integer.valueOf(itemdefaultminqty):Integer.valueOf(tcinfo[i].grouptickets[j].minqty);
        item[k].max_per_order__c=tcinfo[i].grouptickets[j].maxqty==''?Integer.valueOf(tcinfo[i].grouptickets[j].qty)>Integer.valueOf(itemdefaultmaxqty)?Integer.valueOf(itemdefaultmaxqty):Integer.valueOf(tcinfo[i].grouptickets[j].qty):Integer.valueOf(tcinfo[i].grouptickets[j].maxqty);
       item[k].Item_Pool__c=itpool[i].id;
        item[k].Event__c=eventID;
        if(tcinfo[i].itemtype=='')
        {
        Item_Type__c itc=[select id,Item_Type_Number__c from Item_Type__c where Item_Type_Number__c='IT-000001'];
        item[k].item_type__c=itc.id;
        }
        else
        item[k].item_type__c=tcinfo[i].itemtype;
        item[k].Payment__c=tcinfo[i].tpaytype;
        item[k].Visibility__c=Boolean.valueOf(tcinfo[i].tvisib);
        item[k].Description__c=tcinfo[i].tdesc;
        item[k].image_url__c=tcinfo[i].tcketlogo;
        if(tcinfo[i].grouptickets[j].itemid.length()!=0)
        item[k].id=tcinfo[i].grouptickets[j].itemid;
        k++;
        }
       
        }
          }
          else
          {
           item.add(new BLN_Item__c());
        item[k].item_name__c=tcinfo[i].tname;
        item[k].item_count__c=Integer.valueOf(tcinfo[i].tqty);
        item[k].sale_start__c=DateTime.parse(currentdate);
        item[k].sale_end__c=DateTime.parse(EventEDate);
        item[k].price__c=tcinfo[i].tprice==''?0:Integer.valueOf(tcinfo[i].tprice);
        item[k].min_per_order__c=Integer.valueOf(itemdefaultminqty);
        item[k].max_per_order__c=Integer.valueOf(tcinfo[i].tqty)>Integer.valueOf(itemdefaultmaxqty)?Integer.valueOf(itemdefaultmaxqty):Integer.valueOf(tcinfo[i].tqty);
        item[k].Item_Pool__c=itpool[i].id;
        item[k].Event__c=eventID;
        if(tcinfo[i].itemtype=='')
        {
        Item_Type__c itc=[select id,Item_Type_Number__c from Item_Type__c where Item_Type_Number__c='IT-000001'];
        item[k].item_type__c=itc.id;
        }
        else
        item[k].item_type__c=tcinfo[i].itemtype;
        if(tcinfo[i].tpaytype=='')
        item[k].Payment__c='Paid';
        else
        item[k].Payment__c=tcinfo[i].tpaytype;
        item[k].Visibility__c=true;
        k++;
          }
          
          
          }
    
    }
    
    upsert item;
    
     //insert tags into ItemPool_Tag_Junction Object
      List<ItemPool_Tag_Junction__c> htag=new List<ItemPool_Tag_Junction__c>();
       for(integer i=0,k=0;i<tcinfo.size();i++)
    {
        if(tcinfo[i].tname!=''){
         for(integer j=0;j<tcinfo[i].tags.size();j++){
           htag.add(new ItemPool_Tag_Junction__c());
           Item_Pool__c ipc=[select id,name from Item_Pool__c where id=:itpool[i].id];
           htag[k].Pool_Id__c=ipc.id;
           //htag[k].Table_Name__c='Item_Pool__c';
           htag[k].Tag_Id__c=tcinfo[i].tags[j].tagname;
           //htag[k].Event__c=eventID;
           k++;
         }
        
        }
     }   
     
     insert htag;
      return message; 
  
  }
  
     class ticket {
    public String tname{get;set;}
    public String tpaytype{get;set;}
    public String tqty{get;set;}
    public String tprice{get;set;}
    public String tvisib{get;set;}
    public String tdesc{get;set;}
    public String tcketlogo{get;set;}
    public String tbdglabel{get;set;}
    public String trowid{get;set;}
    public List<grouptickets> grouptickets{get;set;}
    public String ticketcount{get;set;}
    public List<tags> tags{get;set;}
    public List<subpackagegroup> subpackagegroup{get;set;}
    public String ispackage{get;set;}
    public String itemtype{get;set;}
    public String poolid{get;set;}
    
        
    
    public ticket(String poolid,String tname,String tpaytype,String tqty,String tprice,String tvisib,String tdesc,String tcketlogo,String tbdglabel,String trowid,List<grouptickets> grouptickets,String ticketcount,List<tags> tags,List<subpackagegroup> subpackagegroup,String ispackage,String itemtype) {
    this.poolid=poolid;
    this.tname=tname;
    this.tpaytype=tpaytype;
    this.tqty=tqty;
    this.tprice=tprice;
    this.tvisib=tvisib;
    this.tdesc=tdesc;
    this.tcketlogo=tcketlogo;
    this.tbdglabel=tbdglabel;
    this.trowid=trowid;
    this.grouptickets=grouptickets;
    this.ticketcount=ticketcount;
    this.tags=tags;
    this.subpackagegroup=subpackagegroup;
    this.ispackage=ispackage;
    this.itemtype=itemtype;
    }
}

class grouptickets {
    public String tname{get;set;}
    public String sdate{get;set;}
    public String edate{get;set;}
    public String qty{get;set;}
    public String minqty{get;set;}
    public String maxqty{get;set;}
    public String tprice{get;set;}
     public String itemid{get;set;}
     public String availabletickets{get;set;}   
    
    public grouptickets(String itemid,String tname,String sdate,String edate,String qty,String minqty,String maxqty,String tprice,String availabletickets) {
    this.itemid=itemid;
    this.tname=tname;
    this.sdate=sdate;
    this.edate=edate;
    this.qty=qty;
    this.minqty=minqty;
    this.maxqty=maxqty;
    this.tprice=tprice;
    this.availabletickets=availabletickets;
    }
} 

class subpackagegroup {
    public String pkgitemname{get;set;}
    public String pkgitemqty{get;set;}
    public String ttype{get;set;}
    public String badgelabel{get;set;}
      public String addonid{get;set;}   
    
    public subpackagegroup(String addonid,String pkgitemname,String pkgitemqty,String ttype,String badgelabel) {
    this.addonid=addonid;
    this.pkgitemname=pkgitemname;
    this.pkgitemqty=pkgitemqty;
    this.ttype=ttype;
    this.badgelabel=badgelabel;
    }
}  

class tags {
    public String tagname{get;set;}
    
    public tags(String tagname) {
    this.tagname=tagname;
    }
}



 @RemoteAction
    global static String savesFinalEvent(String regtemp,String evestat,String eventid,String totalblprice,String cardnumber,String cardmonth,String cardyear,String cardcvv,String tcktjsonInput,String currencyid,String companyName) {
    BLN_Event__c ble=new BLN_Event__c(id=eventid,Event_Status__c=evestat,Registration_Template__c=regtemp);
    try{
    if(evestat=='Live'&&totalblprice!='0'){
    BLN_Payments_BAL pbal=new BLN_Payments_BAL();
    String g=pbal.stripePayments(eventid,cardnumber,cardmonth,cardyear,cardcvv,Decimal.valueOf(totalblprice),0,true);
    if(g!='Error'){
      //parseblproduct
      List<TicketCreateInfo> tcinfo;
   
    // Parse entire JSON response for event mandatory fields.
    JSONParser parser = JSON.createParser(tcktjsonInput);
    while (parser.nextToken() != null) {
        
                    tcinfo= (List<TicketCreateInfo>)parser.readValueAs(List<TicketCreateInfo>.class);
                   

       } 
       
       //get gnuser
       BLN_Gnuser_DAO gndao = new BLN_Gnuser_DAO ();
              
                     string uid = userInfo.getUserId();
                     string gnuid=null;
                     Company__c companyId=null;
                     try{
                     GN_User__c  GN = gndao.gettinggnuser(uid);
                    gnuid =GN.id;
                    }catch(Exception e){}
                    
        //get companyname
        BLN_Company_DAO company = new BLN_Company_DAO();
           try{
        
        
        companyId = company.queryCompanyId(companyName);
        }catch(Exception e){}
        
        //Insert Order
         Order__c ord=new Order__c();
         ord.Order_Total__c=Decimal.valueOf(totalblprice);
         ord.Amount_Paid__c=Decimal.valueOf(totalblprice); 
         ord.Client_GN_User__c=gnuid ;
         ord.Client_Company__c=companyId.id ;
         ord.Currency_Code__c=currencyid;
         ord.Events__c=eventid;
         ord.Transaction_Status__c='Completed';
         ord.order_type__c='EVENT PRODUCER';
         ord.Order_Status__c='Fully Paid'; 
         insert ord;
         //Insert orderItem
         List<Order_Item__c> orditems=new List<Order_Item__c>();
         for(integer l=0;l<tcinfo.size();l++)
         {
            Order_Item__c orditem=new Order_Item__c();
            orditem.Order__c=ord.id;
            orditem.Currency__c=currencyid;
            orditem.Item_Quantity__c=Integer.valueOf(tcinfo[l].ticketQty);
            orditem.Item_Total__c=Decimal.valueOf(tcinfo[l].ticketPrice);
            orditem.Item_Price__c=Decimal.valueOf(tcinfo[l].ticketPrice);
            orditem.Item_Type__c=tcinfo[l].ticketId;
            orditem.Item__c=tcinfo[l].itemId;
            orditems.add(orditem);
         } 
         insert orditems;     
       
     upsert ble;
     return 'success';
     }
     else 
     return 'error';
     }
     else
     {
       upsert ble;
     return 'success'; 
     }
    
    }catch(Exception e){
    return 'error';
    }
    }
    
    
   
    public String eventlogourl{get;set;}
    public String imageData {get;set;}
    public Document file { get; set; }{ file = new Document(); }
     
    public PageReference saveEventLogo() {
    
    if(imageData!=''){
    document mydoc =new document();
                                 mydoc.body = EncodingUtil.base64Decode(imageData);
                                 mydoc.folderid =  '00lF0000001VI7Y';
                                 mydoc.IsPublic = True;
                                 mydoc.Name = 'eventlogo.png';
                                 mydoc.contentType='image/png';
                                 DataBase.saveResult docSaveResult;
                                 docSaveResult = DataBase.insert(mydoc, false);
                                 
                                 if(docSaveResult.isSuccess()){
                                        eventlogourl=docSaveResult.getId();
                                 }
                                else 
                                eventlogourl='';
                                }
                                else
                                {
                                 eventlogourl='';
                                }
                                return null;
    }
    
    @RemoteAction
    global static void savesPaymentOption(String payjsonInput,String eventID,String companyName,String cheque,String cash,String tckopt,String feeopt) {
    List<Event_Pay_Gateway__c> delepg=[select id,name,Events__c from Event_Pay_Gateway__c where Events__c=:eventID];
    delete delepg;
    
    //
    try{
    BLN_Event__c ble=[select id,name,Event_Ticket_Options__c,Service_Fee__c from BLN_Event__c where id=:eventID];
    ble.Event_Ticket_Options__c=tckopt;
    ble.Service_Fee__c=feeopt;
    update ble;
    }catch(Exception e){}
    
    
    //Ticket object
    PaymentOpt pinfo;
   
    // Parse entire JSON response for event mandatory fields.
    JSONParser parser = JSON.createParser(payjsonInput);
    while (parser.nextToken() != null) {
        
                    pinfo= (PaymentOpt)parser.readValueAs(PaymentOpt.class);
                   

       } 
       
       Pay_Gateway__c pg=new Pay_Gateway__c();
       BLN_Company_DAO company = new BLN_Company_DAO();
       Event_Pay_Gateway__c epg=new Event_Pay_Gateway__c();
       Company__c companyId ;
       PGateway_Type__c pgt;
       if(pinfo.pgopt!='None')
       {
       pgt=[select id,name from PGateway_Type__c where name=:pinfo.pgopt];
       pg.PGateway_Type__c=pgt.id;
       if(pinfo.pgopt=='PayPal')
       {
          pg.PG_Email_Id__c=pinfo.firstparam;
          pg.PP_Payment_Type__c='Chained';
          pg.PP_Fee_Payer__c='EACHRECEIVER';
       }
       if(pinfo.pgopt=='Stripe')
       {
          pg.PG_Signature__c=pinfo.firstparam;
          
          
       }
       if(pinfo.pgopt=='Authorize.Net')
       {
          pg.PG_User_Key__c=pinfo.firstparam;
          pg.PG_Signature__c=pinfo.secondparam;
          
       }
       
       
        
        companyId = company.queryCompanyId(companyName);
        pg.Company__c=companyId.Id ;
       insert pg;
      
      
      epg.Pay_Gateway__c=pg.id;
      epg.Events__c=eventID;
      insert epg;
       }
       if(cheque=='true')
       {
           pgt=[select id,name from PGateway_Type__c where name='Check'];
       pg=new Pay_Gateway__c();
       pg.PGateway_Type__c=pgt.id;
           companyId = company.queryCompanyId(companyName);
        pg.Company__c=companyId.Id ;
       insert pg;
      
      epg=new Event_Pay_Gateway__c();
      epg.Pay_Gateway__c=pg.id;
      epg.Events__c=eventID;
      insert epg;  
       }
       
        if(cash=='true')
       {
           pgt=[select id,name from PGateway_Type__c where name='Cash'];
       pg=new Pay_Gateway__c();
       pg.PGateway_Type__c=pgt.id;
           companyId = company.queryCompanyId(companyName);
        pg.Company__c=companyId.Id ;
       insert pg;
      
      epg=new Event_Pay_Gateway__c();
      epg.Pay_Gateway__c=pg.id;
      epg.Events__c=eventID;
      insert epg;  
       }
       }
       
       
       class PaymentOpt
       {
           public String pgopt{get;set;}
           public String firstparam{get;set;}
           public String secondparam{get;set;}
           
           public PaymentOpt(String pgopt,String firstparam,String secondparam)
           {
              this.pgopt=pgopt;
              this.firstparam=firstparam;
              this.secondparam=secondparam;
           }
       }
    
    
    
    public String authCode{get;set;}
    public String authorizationCodeURI{get;set;}
    public String body{get;set;}
    public JSONWrapper jsonWrapObj{get;set;}
     public class JSONWrapper{    
        public Integer expires_in;
        public String access_token;  
        public String refresh_token{get;set;}
    }
    
   //Get Event Data On Load
    @RemoteAction
    global static BLN_Event__c getEvents(String eventID) {
    return [select id,name,Registration_Template__c,Logo_URL__c,Event_Status__c,Event_Ticket_Options__c,Service_Fee__c,Start_Date__c,Start_Time__c,End_Date__c,End_Time__c,Venue_Name__c,Organizer_Email__c,BLN_State__c,BLN_Country__c,City__c,Language_Settings__c,BLN_Country__r.Currency__c,Time_Zone__c,organizer_id__r.name,(select Company__r.name from User_Company__r),(select Pay_Gateway__r.PGateway_Type__r.Name,Pay_Gateway__r.PG_Email_Id__c,Pay_Gateway__r.PG_Pass_Secret__c,Pay_Gateway__r.PG_Signature__c,Pay_Gateway__r.PG_User_Key__c from Event_Pay_Gateway__r),Event_Type__c,Description__c,Street1__c,Street2__c,Twitter_Hash_Tag__c,Twitter_URL__c,Facebook_URL__c,Website_Url__c,ZipCode__c,Phone_Number__c,PO_Box__c from BLN_Event__c where id=:eventID limit 1];
    }
    
    
    //Get Ticket Data On Load
    @RemoteAction
    global static List<Item_Pool__c> getSavedTickets(String eventID) {
    return [select Id,Name,Item_Pool_Name__c,Item_Count__c,Package_Flag__c,Item_Type__c,Badge_Label__c,Addon_Parent__c from  Item_Pool__c where Event__c=:eventID and Addon_Parent__c=null order by lastmodifieddate];
    }
    
    @RemoteAction
    global static List<BLN_Item__c> getItemsBasedOnPool(String poolId) {
    return [select Id,item_name__c,Payment__c,Visibility__c,Available_Tickets__c,Description__c,min_per_order__c,max_per_order__c,item_count__c,sale_start__c,sale_end__c,price__c,Item_Pool__c,item_type__c,image_url__c from  BLN_Item__c where Item_Pool__c=:poolId order by lastmodifieddate];
    }
   
    @RemoteAction
    global static List<Item_Pool__c> getAddonPool(String poolId) {
    return [select Id,Name,Item_Pool_Name__c,Addon_Count__c,Addon_Parent__c,Package_Flag__c,Item_Type__c,Badge_Label__c from  Item_Pool__c where Addon_Parent__c=:poolId order by lastmodifieddate];
    }
    
    //Get Tag Data On Load
    @RemoteAction
    global static List<ItemPool_Tag_Junction__c> getSavedTags(String eventID) {
    //return [select Id,Event__c,Tag_Text__c,Table_Name__c,RowId__c from  Hash_Tag__c where Event__c=:eventID];
    return [select Id,Pool_Id__c,Tag_Id__c,Tag_Id__r.Event__c from ItemPool_Tag_Junction__c where Tag_Id__r.Event__c=:eventID order by lastmodifieddate];
    
    }
    
    @RemoteAction
    global static Company_Ext__c getCompanyExtDetails(String eventID) {
    BLN_Event__c  e=[select id,name,organizer_id__c from BLN_Event__c where id=:eventID limit 1];
    
    return [select Id,Name,Business_Address1__c,Business_Address2__c,Business_City__c,BLN_Business_Country__c,BLN_Business_State__c,Business_Zipcode__c,Company__c from  Company_Ext__c where Company__c=:e.organizer_id__c limit 1];
    }
    
    @RemoteAction
    global static String createCompanyExtDetails(String companyName,String companyextid,String chqaddr1,String chqaddr2,String chqcity,String chqcountry,String chqstate,String chqZip) {
     BLN_Company_DAO company = new BLN_Company_DAO();
    Company__c companyId = company.queryCompanyId(companyName);
   
    Company_Ext__c cxt=new Company_Ext__c(Company__c =companyId.Id,Business_Address1__c=chqaddr1,Business_Address2__c=chqaddr2,Business_City__c=chqcity,Business_Zipcode__c=chqZip);
    if(chqcountry!='')
    cxt.BLN_Business_Country__c=chqcountry;
    if(chqstate!='')
    cxt.BLN_Business_State__c=chqstate;
    if(companyextid=='')
    {
    
     insert cxt;
     return cxt.id;
    }
     else
     {
      cxt.id=companyextid;
      update cxt;
      return cxt.id;
     }
    
    }
    
    @RemoteAction
    global static String createEventTag(String eventID,String tagText) {
    Hash_Tag__c htag;
    
    try{
    htag=[select id,Tag_Text__c,Event__c,Table_Name__c from Hash_Tag__c where Event__c=:eventID and Tag_Text__c=:tagText limit 1];
    return '';
    }catch(Exception e){
    //create if record not found
    htag=new Hash_Tag__c();
    htag.Tag_Text__c=tagText;
    htag.Table_Name__c='Item_Pool__c';
    htag.Event__c=eventID;
    insert htag;
    return htag.Id;
    
    }
    
    }
    
     @RemoteAction
    global static List<Hash_Tag__c> getEventTag(String eventID) {
    return  [select id,Tag_Text__c,Event__c from Hash_Tag__c where Event__c=:eventID];
    }
    
    @RemoteAction
     global static String updateEventTag(String eventID,String oldtagtext,String newtagtext) {
    Hash_Tag__c htag=[select id,Tag_Text__c,Event__c from Hash_Tag__c where Event__c=:eventID and Tag_Text__c=:oldtagtext limit 1];
    htag.Tag_Text__c=newtagtext;
    update htag;
    return htag.id;
    }
    
    @RemoteAction
    global static void deleteEventTag(String eventID,String tagtext) {
    Hash_Tag__c htag=[select id,Tag_Text__c,Event__c from Hash_Tag__c where Event__c=:eventID and Tag_Text__c=:tagtext limit 1];
    List<ItemPool_Tag_Junction__c> itjuns=[select id,Tag_Id__c,Tag_Id__r.Tag_Text__c from ItemPool_Tag_Junction__c where Tag_Id__c=:htag.Id];
    delete itjuns;
    List<Reg_Setting__c> tagregsetting=[select id,Tag_Id__c,Event__c,Tag_Id__r.Tag_Text__c from Reg_Setting__c where Tag_Id__c=:htag.Id and Event__c=:eventID];
    delete tagregsetting;
    
    
    delete htag;
    } 
    
    
    @RemoteAction
    global static void deleteItemPool(String poolid)
    {
   
     List<BLN_Item__c> delitems=[select id,name,Item_Pool__c,Available_Tickets__c,item_count__c from BLN_Item__c where Item_Pool__c=:poolid];
     
    delete delitems;
    List<Item_Pool__c> delchilditemspool=[select id,name,Addon_Parent__c from Item_Pool__c where Addon_Parent__c=:poolid];
    delete delchilditemspool;
    List<Item_Pool__c> delitemspool=[select id,name from Item_Pool__c where id=:poolid];
    delete delitemspool;  
   
    }
    
    
    
    @RemoteAction
    global static void deleteaddonItemPool(String poolid)
    {
    List<String> split= poolid.Split(',');
   
    
     List<Ticket__c> tc=[select id,name,Item_Pool__c from Ticket__c where Item_Pool__c in:split];
     delete tc;
    List<Item_Pool__c> delitemspool=[select id,name from Item_Pool__c where id in:split];
    delete delitemspool;   
    }
    
    
    
     //autocomplete search code for company----Arindam Sarkar
    
    public Object selectValue{get; set;}
    public Company__c comp{get;set;}
     public String searchValue {get; set;}
    public Integer maxHeights {get; set;}
    public Integer height {get; set;}
    public List<SelectOption> results {get; set;}
    public Boolean showList {get; set;}
    Map<String,String> resultsMap;
 
    //This is our seach method that is called every time a character is entered
    public void search(){
    comp=new Company__c();
        showList = true;
        results = new List<SelectOption>();
        resultsMap = new Map<String,String>();
 
        //Using dynamic SOQL we pass the object and the search value
        if(searchValue.length() > 0){
            String entry = '%' + searchValue + '%';
            String queryString = 'Select GN_User__c,Company__r.name,RoleId__r.name,event__c from ' + 'UC_Role__c '+ ' where Company__r.name like :entry and GN_User__r.email__c=\''+UserInfo.getUserEmail()+'\' and RoleId__r.name=\'Company Admin\' and Event__c=null order by Company__r.name limit 1000';
            
          List<UC_Role__c > listc=Database.query(queryString);
          Set<String> lists=new  Set<String>();
            for(UC_Role__c o : listc){
                   lists.add(o.Company__r.name);            
            }
            /*Next we add the results to our list of selectOptions. We also add the values to a map so that when a value
            is selected we can auto fill the search box with the selected value */
            for(String o : lists){
                results.add(new SelectOption(o,o));
                resultsMap.put(o,o);
            }
        }
 
        //Next we inspect the results to set the height and contents of the selectList
        if(searchValue.length() == 0){
            showList = false;
        }else if(results.size() == 0 && searchValue.length() != 0){
            results.add(new SelectOption('','No matches found'));
            height = 2;
        }else if(results.size() == 1){
            height = 2;
        }else if(results.size() > maxHeights){
            height = maxHeights;
        }else{
            height = results.size();
        }
    }
 
    //When a value is selected we will auto complete the searchValue
    public void selectValue(){
        showList = false;
        searchValue = resultsMap.get((string)comp.name);
        
    }
 
    //simply hides the list of results
    public void hideResults(){
        showList = false;
        
    }

    //end of autocomplete search code
}