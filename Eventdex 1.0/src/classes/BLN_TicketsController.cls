global with sharing class BLN_TicketsController {



 public LIST<eventOptionsWrapper> eventSelectOptions{get; set;} 
public LIST<Item_Type__c> eventOptions{get; set;}
public class eventOptionsWrapper{
        
        public Boolean eventOptionsBoolean{get; set;}
        public Item_Type__c eventOptionItemType{get; set;}
        
        public eventOptionsWrapper(Boolean b, Item_Type__c ite){
                eventOptionsBoolean = b;
                eventOptionItemType = new Item_Type__c();
                eventOptionItemType = ite;
                
        }
    }

    public BLN_UtillDisplayLinks Ticket{get;set;}
    public static Id selectedEvent{get;set;}
public LIST<selectOption> paymentSelectOptions{get; set;}
 public String itemdefaultmaxqty{get;set;}
     public String itemdefaultminqty{get;set;}
     
    public BLN_TicketsController (){
         Cookie k = ApexPages.currentPage().getCookies().get('counter');
         if(k!=null){ 
             selectedEvent = k.getValue();
         }
         Ticket= new BLN_UtillDisplayLinks();
         Ticket.isTicketsPage='active';
         Ticket.isTicketsPageExpand='expand';
         Ticket.tablabel='Tickets';
         Ticket.eventId=selectedEvent;
          
          try{
    itemdefaultmaxqty=(String)BLN_Item__c.max_per_order__c.getDescribe().getDefaultValueFormula();
    itemdefaultminqty=(String)BLN_Item__c.min_per_order__c.getDescribe().getDefaultValueFormula();
    }catch(Exception e){}
    
         LIST<BLN_Event__c> eventsList = new LIST<BLN_Event__c>();
         BLN_Event_DAO evDAO = new BLN_Event_DAO();
         eventsList =  evDAO.getEventDetails(selectedEvent);
         
          if(eventsList.size() > 0){
          Ticket.EventName =eventsList[0].Name;
         
                
         }
         
         Ticket.userPermissions(userInfo.getUserId(),selectedEvent);
        
          eventOptions = new LIST<Item_Type__c>();
        
         eventOptions.addAll(BLN_ItemType_DAO.eventOptionItemTypes(BLN_Event_UtilityCon.displayEventOptions() )); 
         eventSelectOptions = new LIST<eventOptionsWrapper>();
         
         for(Item_Type__c itp: eventOptions){
                eventSelectOptions.add(new eventOptionsWrapper(FALSE, itp ));
         }
          //geting individual ticket standard item types
          individualTicketsSelectOptions = new LIST<selectOption>();
         SET<String> eventOptionsItemTypes = new SET<String>();
        BLN_Event_UtilityCon eventUtility = new BLN_Event_UtilityCon();
         eventOptionsItemTypes.addAll(eventUtility.allMainItemType());
        LIST<Item_Type__c> individualTicketsItemTypess = new LIST<Item_Type__c>();
        individualTicketsItemTypess = BLN_ItemType_DAO.itemTypesforIndividualTickets(eventOptionsItemTypes);
        
         individualTicketsSelectOptions = BLN_ItemType_BAL.itemTypeSelectOptions(individualTicketsItemTypess);
         //Adding event option types
         for(Item_Type__c itemtpe:[select id,name,Item_Type_Number__c from Item_Type__c where Item_Type_Number__c='IT-000010' or Item_Type_Number__c='IT-000004' or Item_Type_Number__c='IT-000003' order by Order__c])
         individualTicketsSelectOptions.add(new SelectOption(itemtpe.id,itemtpe.name));
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
        //System.debug('@@@@'+pick_list_values.size());
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            options.add(new selectOption(a.getLabel(), a.getValue()));  //add the value and label to our final list
        }
        return options; //return the List
    }
    
    public List<selectOption> getPaymentType() {
        return getPickValues(new BLN_Item__c(), 'Payment__c', null);
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
        public LIST<selectOption> individualTicketsSelectOptions{get; set;}
        //get package item type
     public List<SelectOption> itemtypespackage{get;set;}
    public void getPackageItemTypes(){
      
        itemtypespackage= new LIST<SelectOption>();
     
        for(Item_Type__c c: [SELECT ID, NAME FROM Item_Type__c where Item_Type_Number__c='IT-000005']){
            itemtypespackage.add(new SelectOption(c.id, c.name));
        }
         
     
      
    } 
    
    public String eventlogourl{get;set;}
    public String imageData {get;set;}
    public Document file { get; set; }{ file = new Document(); }
     
    public PageReference saveEventLogo() {
    
    if(imageData!=''){
    document mydoc =new document();
         mydoc.body = EncodingUtil.base64Decode(imageData);
         imageData='';
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
    global static String savesTicketInfo(String tcktjsonInput,String eventID,String currentdate,String defaultendtime) {
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
    System.debug('============>'+tcktjsonInput);
    System.debug('========date>'+currentdate);
    System.debug('========time>'+defaultendtime);
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
        item[k].sale_end__c=DateTime.parse(defaultendtime);
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
 //Get Ticket Data On Load
   //Get Ticket Data On Load
    @RemoteAction
    global static List<Item_Pool__c> getSavedTickets(String eventID) {
    return [select Id,Name,Item_Pool_Name__c,Event__r.End_Date__c,Event__r.End_time__c,Item_Count__c,Package_Flag__c,Item_Type__c,Badge_Label__c,Addon_Parent__c from  Item_Pool__c where Event__c=:eventID and Addon_Parent__c=null order by createddate];
    }
    
    @RemoteAction
    global static List<BLN_Item__c> getItemsBasedOnPool(String poolId) {
    return [select Id,item_name__c,Payment__c,Visibility__c,Available_Tickets__c,Description__c,min_per_order__c,max_per_order__c,item_count__c,sale_start__c,sale_end__c,price__c,Item_Pool__c,item_type__c,image_url__c from  BLN_Item__c where Item_Pool__c=:poolId order by createddate];
    }
   
    @RemoteAction
    global static List<Item_Pool__c> getAddonPool(String poolId) {
    return [select Id,Name,Item_Pool_Name__c,Addon_Count__c,Addon_Parent__c,Package_Flag__c,Item_Type__c,Badge_Label__c from  Item_Pool__c where Addon_Parent__c=:poolId order by createddate];
    }
 //Get Tag Data On Load
    @RemoteAction
    global static List<ItemPool_Tag_Junction__c> getSavedTags(String eventID) {
    //return [select Id,Event__c,Tag_Text__c,Table_Name__c,RowId__c from  Hash_Tag__c where Event__c=:eventID];
     return [select Id,Pool_Id__c,Tag_Id__c,Tag_Id__r.Event__c from ItemPool_Tag_Junction__c where Tag_Id__r.Event__c=:eventID order by createddate];
    
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
    global static BLN_Event__c getEvents(String eventID) {
    return [select id,name,Registration_Template__c,Event_Status__c,Event_Ticket_Options__c,Service_Fee__c,Start_Date__c,Start_Time__c,End_Date__c,End_Time__c,Venue_Name__c,Organizer_Email__c,BLN_State__c,BLN_Country__c,City__c,Language_Settings__c,BLN_Country__r.Currency__c,Time_Zone__c,(select Company__r.name from User_Company__r),(select Pay_Gateway__r.PGateway_Type__r.Name,Pay_Gateway__r.PG_Email_Id__c,Pay_Gateway__r.PG_Pass_Secret__c,Pay_Gateway__r.PG_Signature__c,Pay_Gateway__r.PG_User_Key__c from Event_Pay_Gateway__r),Event_Type__c,Description__c,Street1__c,Street2__c,Twitter_Hash_Tag__c,Twitter_URL__c,Facebook_URL__c,Website_Url__c,ZipCode__c,Phone_Number__c,PO_Box__c from BLN_Event__c where id=:eventID limit 1];
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
}