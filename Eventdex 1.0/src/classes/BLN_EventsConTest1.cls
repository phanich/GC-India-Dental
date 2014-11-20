global with sharing class BLN_EventsConTest1 { 
public LIST<eventOptionsWrapper> eventSelectOptions{get; set;}
 public LIST<Item_Type__c> eventOptions{get; set;}
  private final BLN_Event__c event_object; 

public class eventOptionsWrapper{
        
        public Boolean eventOptionsBoolean{get; set;}
        public Item_Type__c eventOptionItemType{get; set;}
        
        public eventOptionsWrapper(Boolean b, Item_Type__c ite){
                eventOptionsBoolean = b;
                eventOptionItemType = new Item_Type__c();
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
    
    //return the picklist options for event type
    public List<selectOption> getEventTypes() {
        return getPickValues(event_object, 'Event_Type__c', null);
    }
    
    //return the picklist options for event type
    public List<selectOption> getEventStatus() {
        return getPickValues(event_object, 'Event_Status__c', null);
    }
    
    
    public List<selectOption> getLanguageSetting() {
        return getPickValues(event_object, 'Language_Settings__c', null);
    }
    
    
   
   
    public List<selectOption> getCountry(){
      
        LIST<SelectOption> countryOptions= new LIST<SelectOption>();
     
        for(Country__c c: [SELECT ID, NAME, Short_Name__c, Long_Name__c FROM Country__c ]){
            countryOptions.add(new SelectOption(c.id, c.Long_Name__c));
        }
         
       return countryOptions;
      
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
    
    
    
    public BLN_EventsConTest1(ApexPages.StandardController controller) {
    this.event_object = (BLN_Event__c)controller.getRecord();
        eventOptions = new LIST<Item_Type__c>();
         eventOptions.addAll(BLN_ItemType_DAO.eventOptionItemTypes(BLN_Event_UtilityCon.displayEventOptions() )); 
         eventSelectOptions = new LIST<eventOptionsWrapper>();
         
         for(Item_Type__c itp: eventOptions){
                eventSelectOptions.add(new eventOptionsWrapper(FALSE, itp ));
         }
    }


   
    @RemoteAction
    global static String savesEventInfo(String eventjsonInput,String binaryeventlogo) {
    BLN_Event__c ble=new BLN_Event__c();
    System.debug('image data '+binaryeventlogo);
    
    //Event object
    EventInfo eveinfo;
   
    // Parse entire JSON response for event mandatory fields.
    JSONParser parser = JSON.createParser(eventjsonInput);
    while (parser.nextToken() != null) {
        
                    eveinfo= (EventInfo)parser.readValueAs(EventInfo.class);
                   

       } 
       
       
     System.debug('Hi '+eveinfo);
       
       //if(eveinfo.EventID==null)
       //put your insert code
       //else
       //put your update code
       
       //return the eventId
    return '';
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
    public String PoBox{get;set;}
    public String TwitterUrl{get;set;}
    public String WebUrl{get;set;}
    public String ZipCode{get;set;}
    
    
    
    public EventInfo(String EventName,String EventSDate,String EventEDate,String EventLocation,String EventOrgEmail,String EventID,String AttendeeReg,String CurrencySetting,String EventCategory,String EventCity,String EventCountry,String EventDesc,String EventHashTag,
    String EventState,String EventStatus,String FacebookUrl,String HostingAddress1,String HostingAddress2,String HostingTimeZone,
    String LanguageSetting,String OrgName,String PhoneNo,String PoBox,String TwitterUrl,String WebUrl,String ZipCode) {
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
    this.PoBox=PoBox;
    this.TwitterUrl=TwitterUrl;
    this.WebUrl=WebUrl;
    this.ZipCode=ZipCode;
    
    }
}  
    
    
    
    
    
}