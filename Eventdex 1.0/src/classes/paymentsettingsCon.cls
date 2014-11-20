public with sharing class paymentsettingsCon {

    public String selectedState { get; set; }

    public BLN_UtillDisplayLinks mytickets { get; set; }
    public MAP<string ,id> pgateways{get;set;}
    
    public Pay_Gateway__c forpaypal{get;set;}
    public Pay_Gateway__c forStripe{get;set;}
    public Pay_Gateway__c forAuth{get;set;}
    public Pay_Gateway__c forcheck{get;set;}  
    public Pay_Gateway__c selectedgateWayold{get;set;}
    public List<Pay_Gateway__c> pgateWayListExisted{get;set;}
    public List<Event_Pay_Gateway__c> eventPaymentListExisted{get;set;}
   
    public string companyId {get;set;}
    
    public string eventId{get;set;}
    public BLN_Event__c event{get;set;}
    public BLN_Events_DAO  eventDao{get;set;}
    public string selectedPaymentType{get;set;}
    public List<Company_Ext__c> comext{get;set;}
  
    public boolean stripe{get;set;}
    public boolean paypal{get;set;}
    public boolean auth{get;set;}
    public boolean check{get;set;}
    public boolean none{get;set;}
    public string selectedCounrty{get;set;}
    public List<selectOption>  optionsStates {get;set;}
   public MAP<string,id> mapconIdWithName{get;set;}
   
   
   
    public paymentsettingsCon(){
      mapconIdWithName = new MAP<string,id>();
      selectedPaymentType= 'phani';
      mytickets = new BLN_UtillDisplayLinks(); 
      mytickets.isEventsettingsExpand = 'Expand';
      mytickets.isEventAdmin =true;
      mytickets.ispaymentSettingsPage=  'active';
      mytickets.tablabel ='Payment Settings';
       event = new BLN_Event__c();
      
      comext = new List<Company_Ext__c>();
       Cookie k = ApexPages.currentPage().getCookies().get('counter');
        if(k!=null){ 
            eventId= k.getValue();
        }
      
        BLN_Event_DAO evDAO = new BLN_Event_DAO();
        List<BLN_Event__C> eventsList = new List<BLN_Event__C>(); 
          eventsList =evDAO.getEventDetails(eventId);
          if(eventsList.size() > 0){
           event = eventsList[0];
          }
      
      
      
       Company__c com = new Company__c ();
      try{
        com = [select id from Company__c where id =:event.organizer_id__c  limit 1];
       companyId = com.id;
     }  catch(exception er){}
      
      comext  = [SELECT id,Business_Address1__c,Business_Address2__c,Business_City__c,BLN_Business_State__c,BLN_Business_Country__c,Business_Zipcode__c from Company_Ext__c  where Company__c = :companyId limit 1];
      
       if(comext.size()<=0){
          Company_Ext__c  comex = new Company_Ext__c();
          comext.add(comex);  
       }
      
      
      pgateways = new MAP<string ,id>();
      BLN_PGateway_Type_DAO pgateWaydao = new BLN_PGateway_Type_DAO();
      for(PGateway_Type__c dao : pgateWaydao.pGateWayTypes()){
        pgateways.put(dao.Name,dao.id);
      } 
      
        system.debug('paymentGatewayssssssssssssssssssssssssss  ' +pgateways);
      selectedCounrty ='';
      selectedState  = '';
         getoptionsCountry();
         
       getoptionsStates();
       
      for(Company_Ext__c  cd:comext){
          getoptionsCountry();
         if(cd.BLN_Business_Country__c!=null){
            selectedCounrty =cd.BLN_Business_Country__c;
            selectedCounrty =cd.BLN_Business_Country__c;
         }
         
         getoptionsStates();
         if(cd.BLN_Business_State__c!=null){
           selectedState = cd.BLN_Business_State__c;
           
         }
      }
      firstMethod();
   }
   
   
   
   public LIst<selectOption> options {get;set;}
   public void getoptionsCountry(){
    options = new LIst<selectOption>();
       for(Country__c c: [SELECT ID, NAME, Short_Name__c, Long_Name__c FROM Country__c ]){
             options.add(new SelectOption(c.id, c.Long_Name__c));
             mapconIdWithName.put(c.Long_Name__c,c.id); 
     }
     
     if(selectedCounrty=='' ){
        selectedCounrty = mapconIdWithName.get('United States of America');
         system.debug('11111111111111111111  '+selectedCounrty); 
         getoptionsStates();  
     }
     
   }
   
 
   public void  getoptionsStates(){
    system.debug('Statessssssssssssssssssssssssssss '+selectedCounrty);
     //  optionsStates = new LIst<selectOption>();
       optionsStates = new List<SelectOption>();
       for(State__c s: [SELECT ID, NAME, Short_Name__c,Long_Name__c, Country__c FROM State__c WHERE Country__c =:selectedCounrty order by Order__c]){
             optionsStates.add(new SelectOption(s.id, s.Long_Name__c));
     }
     
  }
   
   
   
   
     public void firstMethod(){
     
       forpaypal= new Pay_Gateway__c ();
       forStripe= new Pay_Gateway__c ();
       forAuth= new Pay_Gateway__c ();
       forcheck= new Pay_Gateway__c (); 
       event = new  BLN_Event__c();
       eventDao = new BLN_Events_DAO();
        pgateWayListExisted= new List<Pay_Gateway__c>();
         eventPaymentListExisted= new List<Event_Pay_Gateway__c>();
     
        stripe =false;
        paypal=false;
        auth=false;
        check=false;
        none = true;
        
       if(eventId !=null){
         event = eventDao.getEventDetails(eventId);
         mytickets.eventName=event.Name;
       }
       
       
      BLN_EventPayGateway_DAO eventPaygateWay = new BLN_EventPayGateway_DAO();
      
      
      SET<id> paymentGateways = new SET<id>(); 
       eventPaymentListExisted = eventPaygateWay.getEventPayGateWays(eventId);
           for(Event_Pay_Gateway__c mapevents : eventPaymentListExisted ){
             paymentGateways.add(mapevents.Pay_Gateway__c);
           }
         
     BLN_PayGateway_DAO payDao = new BLN_PayGateway_DAO();
     pgateWayListExisted = payDao.getPayGateWays(paymentGateways);
     
      for( Pay_Gateway__c pWay:pgateWayListExisted){
         
         if(pWay.PGateway_Type__r.Name=='paypal'){
            forpaypal = pWay;
            paypal=true;
         }else if(pWay.PGateway_Type__r.Name =='Stripe'){
            forStripe= pWay;
            stripe =true;
         }else if(pWay.PGateway_Type__r.Name =='Authorize.Net'){
             forAuth= pWay;
             auth = true;
         }
         
        if(pWay.PGateway_Type__r.Name =='Authorize.Net' || pWay.PGateway_Type__r.Name =='Stripe' || pWay.PGateway_Type__r.Name =='paypal' ){
            selectedgateWayold = pWay;
            none = false;
         } 
         
         if(pWay.PGateway_Type__r.Name =='check'){
           forcheck= pWay;
           check= true;
         }
      }
     
   } 
   
   
   
   
   public void save(){
       Pay_Gateway__c  forInsertPgateway = new Pay_Gateway__c();
     if(selectedPaymentType=='paypal'){
         forInsertPgateway =  forpaypal.clone(false,false,false,false);
         forInsertPgateway.PGateway_Type__c =  pgateways.get('PayPal');
         forInsertPgateway.id = null; 
         insertPway(forInsertPgateway);
     }else if(selectedPaymentType=='stripe'){
        forInsertPgateway =  forstripe.clone(false,false,false,false);
           forInsertPgateway.PGateway_Type__c  =  pgateways.get('Stripe');
           insertPway(forInsertPgateway);
       }else if(selectedPaymentType=='Authorize.Net'){
       system.debug('OOOOOOOOOOOOOOOOOOO' +selectedPaymentType);
           forInsertPgateway =  forAuth.clone(false,false,false,false);
           system.debug('VVVVVVVVVVVVVVVVVVV  ' +pgateways.get(selectedPaymentType));
           forInsertPgateway.PGateway_Type__c =  pgateways.get(selectedPaymentType);
         insertPway(forInsertPgateway);
     }else if(selectedPaymentType=='none'){
       
     }
   
    if(check){
       Pay_Gateway__c  pcheck  = new Pay_Gateway__c();
       pcheck.PGateway_Type__c =  pgateways.get('Check');
       
       insertPway(pcheck);
    }
      
   List<Company_Ext__c> comListForUpdate = new List<Company_Ext__c>(); 
   
   for(Company_Ext__c comp : comext){
     comp.BLN_Business_Country__c= selectedCounrty;
     comp.BLN_Business_State__c =selectedState ;
     comp.company__c = companyid;
     comListForUpdate.add(comp);
   }   
    DataBase.upsert(comListForUpdate,false);   
      
  
   DataBase.update(event,false);
   
     DataBase.delete(pgateWayListExisted);
     DataBase.delete(eventPaymentListExisted);
  
     firstMethod();
   }
   
   
   public void insertPway(Pay_Gateway__c  inPway){
    inPway.Company__c = companyId ;
    system.debug('ZZZZZZZZZZZZZZZZZZZZZZZZZZ   '+companyId ); 
     dataBase.saveResult  saveres =  DataBase.insert(inPway);
       system.debug('WWWWWWWWWWWWWWWWWWWWW '+saveres.getId()); 
        if(saveres.isSuccess()){
        system.debug('XXXXXXXXXXXXXXXXXXXXXXXXX '+saveres.getId());
           insertEventPay(saveres.getId());
        }
   }
   
   
   
  public void insertEventPay(id payId){
     Event_Pay_Gateway__c payGatewayInsert = new Event_Pay_Gateway__c();
     payGatewayInsert.Events__c = event.id;
     payGatewayInsert.Pay_Gateway__c = payId;
     DataBase.insert(payGatewayInsert,false);
  } 
   
   
    
}