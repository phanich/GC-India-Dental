public with sharing class BLN_EventsCon { 
/***********************************************************************************************
*   Controller Name : QRCode_DataImportCon
*   Date            : 30/04/2014
*   Author          : Naga Mallikarjuna Rao B
*   Purpose         : This class is for Import Attendee Information FROM CSV File
*   Change History  : 30/04/2014 
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*   30/04/2014          Naga Mallikarjuna Rao B           To Create Page
**************************************************************************************************/

 
    
    public ID eventID{get; set;}
    public LIST<Item_Type__c> ItemTypes{get; set;}
    public MAP<id, Item_Type__c> ItemTypesMap{get; set;}
    public Item_Type__c admissionItemType{get; set;}
    public Item_Type__c packageItemType{get; set;}
    public LIST<Item_Type__c> eventOptions{get; set;}
    public LIST<eventOptionsWrapper> eventSelectOptions{get; set;}
    public LIST<Selectoption> evTicOptions {get; set;}  
    public Company__c comp{get; set;}
    public Currency__c eventCurrency {get ; set ;}
    public LIST<Hash_Tag__c> hashTagsForItemsWise{get; set;}
    public MAP<String, LIST<Hash_Tag__c>> ticketWiseHashTags{get; set;}
    public LIST<Selectoption> eventHashTags {get; set;}  
    public Company_Ext__c companyExtenction{get; set;}
    //public Company__c comp{get; set;}
    public Blob eventImage{get; set;}
    public String eventImageName{get; set;}
    public String eventLogoErrorString{get; set;}
    public Company__c companyname{get ; set ;}
    public BLN_Event__c testingForEvent{get; set;}
   
    public MAP<String, Boolean> TicketsDisplayInEventsPageBasedOnItemTypes{get; set;}
    public MAP<ID, Event_Price__c> EventOptionsMAP{get; set;}
    
    public BLN_EventsCon(ApexPages.StandardController controller) {
         
         testingForEvent = new BLN_Event__c();
         testingForEvent = (BLN_Event__c)controller.getRecord();      
         
         
         finallToSaveGateWays = new LIST<Pay_Gateway__c>(); 
         eventID = Controller.getId();
         ItemTypes = new LIST<Item_Type__c>();
         companyname = new Company__c ();
         ItemTypesOptions = new LIST<SelectOption>();
        
         //Hash Tags....................................
         hashTagsForItemsWise = new LIST<Hash_Tag__c>();
         ticketWiseHashTags = new MAP<String, LIST<Hash_Tag__c>>();
         eventHashTags = new LIST<Selectoption>();
         
         EventOptionsMAP = new MAP<ID, Event_Price__c>();
         
         ItemTypes.addAll( BLN_ItemType_DAO.AllItemTypes(new LIST<String>()));
         
         eventOptions = new LIST<Item_Type__c>();
         eventOptions.addAll(BLN_ItemType_DAO.eventOptionItemTypes(BLN_Event_UtilityCon.displayEventOptions() )); 
         eventSelectOptions = new LIST<eventOptionsWrapper>();
         
         for(Item_Type__c itp: eventOptions){
                eventSelectOptions.add(new eventOptionsWrapper(FALSE, itp ));
         }
         
      //   ItemTypesOptions.addAll(BLN_ItemType_BAL.itemTypeSelectOptions(ItemTypes) );
      chageItemTypesBasedOnEventOptions();
         
         admissionItemType = new Item_Type__c ();
         admissionItemType = BLN_ItemType_DAO.AdmissionItemTypes(BLN_Event_UtilityCon.mainItemType());
                  
         packageItemType = new Item_Type__c ();
         packageItemType = BLN_ItemType_DAO.PackageItemTypes(BLN_Event_UtilityCon.packageItemType());
          
         
         system.debug('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF       '+admissionItemType );
         
         TicketsDisplayInEventsPageBasedOnItemTypes = BLN_Event_UtilityCon.itemTypesDisplayInEventsPage();
         
         companyExtenction = new Company_Ext__c();
         
         UC_Role__c userRoll = new UC_Role__c();
        
         BLN_UCRole_DAO userRollDAO = new BLN_UCRole_DAO();
         userRoll = userRollDAO.queryCompanyInformation();
         comp = new Company__c();
          
         if(userRoll.Company__c != null){
                BLN_Company_DAO companyDAO = new BLN_Company_DAO();
                  
                 comp = companyDAO.queryCompany(userRoll.Company__c);
                
                if(comp.Company_Ext__r.size() >0 ){
                        companyExtenction = comp.Company_Ext__r[0];
                }
                
         }
         
         eventCurrency = new Currency__c();
         
         //Get Event Options Pricings
         BLN_EventOptions_DAO evo = new BLN_EventOptions_DAO();
         EventOptionsMAP = evo.queryEventOptions();
         
         createEvent(); 
       //  Packages();
       
       if(selectedEvent.Organizer_Email__c == null){
                selectedEvent.Organizer_Email__c = userinfo.getUserName();
       }
         if(companyname.Name == null){
       string Uid = userinfo.getUserId();
       List<USER> comp=[SELECT id,CompanyName from User where ID =: Uid  ];
                companyname.Name = comp[0].CompanyName;
       }
      // Company__c  companies =[SELECT ID, NAME, (SELECT ID, NAME, Business_Address1__c, Business_Address2__c, Business_City__c, BLN_Business_Country__c, BLN_Business_State__c, Business_Zipcode__c, Work_Phone__c FROM Company_Ext__r) FROM Company__c WHERE NAME =: companyName LIMIT 1];
     if(selectedEvent.Street1__c == null){
        for(Company_Ext__c c: comp.Company_Ext__r){
                selectedEvent.Street1__c = c.Business_Address1__c;
        }
     }
     
     if(selectedEvent.Street2__c == null){
        for(Company_Ext__c c: comp.Company_Ext__r){
                selectedEvent.Street2__c = c.Business_Address2__c;
        }
     }
       
     if(selectedEvent.city__c == null){
        for(Company_Ext__c c: comp.Company_Ext__r){
                selectedEvent.City__c = c.Business_City__c;
        }
     }  
      
     if(selectedEvent.Country__c == null){
        for(Company_Ext__c c: comp.Company_Ext__r){
                selectedEvent.BLN_Country__c = c.BLN_Business_Country__c;
        }
     }   
     
     
     if(selectedEvent.BLN_State__c == null){
        for(Company_Ext__c c: comp.Company_Ext__r){
                selectedEvent.BLN_State__c = c.BLN_Business_State__c;
        }
     }   
     
      if(selectedEvent.ZipCode__c == null){
        for(Company_Ext__c c: comp.Company_Ext__r){
                selectedEvent.ZipCode__c = c.Business_Zipcode__c;
        }
     }  
     
       
     if(selectedEvent.ZipCode__c == null){
        for(Company_Ext__c c: comp.Company_Ext__r){
                selectedEvent.ZipCode__c = c.Business_Zipcode__c;
        }
     }  
         countryStates();
      //  LIST<EmailStatus> eas = [ Select e.WhoId, e.TimesOpened, e.TaskId, e.LastOpenDate, e.LastModifiedDate, e.LastModifiedById, e.Id, e.FirstOpenDate, e.EmailTemplateName, e.CreatedDate, e.CreatedById From EmailStatus e];
        packageLineItemsPools = new MAP<Integer, LIST<Item_Pool__c>>();
   
    }
    
    public BLN_Event__c selectedEvent{get; set;}
    public BLN_Event__c eventMoreOptionEvents{get; set;}
    public Boolean eventMoreOptionBool{get; set;}
    public LIST<Item_Pool__c> listOfTickets{get; set;}
    public LIST<SelectOption> ItemTypesOptions{get; set;}
    public MAP<String,  Item_Type__c> itemTypeMap{get; set;}  
    public LIST<BLN_ItemType_BAL.ticketsinnerClass> insertTickets{get; set;}
    public LIST<BLN_ItemType_BAL.ticketsinnerClass> togetTheCancelTickets{get; set;}
    
    public integer counteruniqueNo{get;set;}
  
    
    // Ticket More Options....................
    public LIST<SelectOption> ticketServiceFee{get; set;}
    public LIST<SelectOption> eventServiceFee{get; set;}
    public Boolean paymentOptionsBool{get; set;}
    
    // Payment GateWay Type..........................
    public Pay_Gateway__c payGateway{get; set;}
    public Pay_Gateway__c payPallpayGateway{get; set;} 
    public Pay_Gateway__c stripepayGateway{get; set;} 
    public Pay_Gateway__c authorizepayGateway{get; set;} 
    
   
    public LIST<PGateway_Type__c> pgateWayLists{get; set;}
    public MAP<String, PGateway_Type__c> pgateWayMap{get; set;}
     
    public void createEvent(){
         
        selectedEvent = new BLN_Event__c();
        listOfTickets = new LIST<Item_Pool__c>();
        itemTypeMap = new MAP<String,  Item_Type__c> ();
        pgateWayLists = new LIST<PGateway_Type__c>();
        pgateWayMap = new MAP<String, PGateway_Type__c> ();
        ItemTypesMap = new MAP<id, Item_Type__c>();
        
       insertTickets = new  LIST<BLN_ItemType_BAL.ticketsinnerClass>();
        
       forCan = new LIST<BLN_ItemType_BAL.ticketsinnerClass>();
       
         selectedEvent.Time_Zone__c  = 'EST';
         selectedEvent.Start_Time__c = '8:00 AM';
         selectedEvent.End_Time__c = '6:00 PM';
         Country__c coun = [SELECT id,Name,Currency__c,Currency__r.Currency_Name__c,Currency__r.Currency_Symbol__c from Country__c where Short_Name__c =: 'US'];
         selectedEvent.BLN_Country__c = coun.id;
         State__c s = [SELECT ID, NAME, Short_Name__c,Long_Name__c, Country__c FROM State__c WHERE Long_Name__c =: 'None' LIMIT 1];
          selectedEvent.BLN_State__c = s.id;
          Currency__c currencys = [SELECT id,Name,Currency_Name__c, Currency_Symbol__c FROM Currency__c WHERE id =: coun.Currency__c];
         eventCurrency =  currencys ;
         LIST<Currency__c> defailtCurrencies = new LIST<Currency__c>();
                BLN_CurrencyCodes currencyDAO = new BLN_CurrencyCodes();
                defailtCurrencies = currencyDAO.currencycodes();
                
                if(defailtCurrencies.size() >= 1)
                        eventCurrency = defailtCurrencies[0];
                
         defailtCurrencies = BLN_Event_UtilityCon.defaultCurrency();
         if(defailtCurrencies.size() > 0)
                selectedEvent.Country__c = defailtCurrencies[0].id;
         
    
        for(Item_Type__c itt : ItemTypes ){
            ItemTypesMap.put(itt.id,  itt);
            itemTypeMap.put(itt.Item_Type_Number__c, itt);
        }
     
         ticketServiceFee = new LIST<Selectoption>();
         eventServiceFee = new LIST<Selectoption>();
          
        for(Schema.PicklistEntry pic: BLN_Event__c.Service_Fee__c.getDescribe().getPicklistValues()){
                eventServiceFee.add(new Selectoption(pic.getValue(), pic.getLabel()));
                if(pic.isDefaultValue()){
                        selectedEvent.Service_Fee__c = pic.getValue();
                 }
        }
        
        for(Schema.PicklistEntry pic: BLN_Item__c.service_fee__c.getDescribe().getPicklistValues()){
                ticketServiceFee.add(new Selectoption(pic.getValue(), pic.getLabel()));
                if(pic.isDefaultValue()){
                        selectedEvent.Service_Fee__c = pic.getValue();
                 }
        } 
        
        evTicOptions = new LIST<Selectoption>();
         
        for(Schema.PicklistEntry picEntry: BLN_Event__c.Event_Ticket_Options__c.getDescribe().getPicklistValues() ){
            evTicOptions.add(new selectOption(picEntry.getValue() , picEntry.getLabel() ));
            
            if(picEntry.isDefaultValue() )
                selectedEvent.Event_Ticket_Options__c = picEntry.getValue();
        }
         
        
        
        
    /*    
        ticketServiceFee.add(new SelectOption('AddFee' , 'Add Booth Leads fee on top of the total ticket price' )); 
        ticketServiceFee.add(new SelectOption('IncludeFee' , 'Include the Booth Leads fee in to the total ticket price' )); 
     */ 
     
        //Gateher All Types of Payment gateways which are used in our portals(Ex:- paypal, Stripe, A.Net, Cash, Check)  
        BLN_PGateway_Type_DAO PGWay = new BLN_PGateway_Type_DAO();
        pgateWayLists = PGWay.pGateWayTypes();
        
        for(PGateway_Type__c p : pgateWayLists){
                pgateWayMap.put(p.Name, p);
        }
        
        
        counteruniqueNo=0;
        
        packageBool = FALSE;
        
         addOnemoreTicket();
         addOnemoreTicket();
         
          system.debug('HHHHHHHHHHHHHHHHHHHHHHHH      '+insertTickets);
         payPallpayGateway = new Pay_Gateway__c ();
         stripepayGateway = new Pay_Gateway__c ();
         authorizepayGateway = new Pay_Gateway__c ();
        
        paymentOptionsBool = FALSE;
         
          registrationTemplates();
         
    }
   
    public LIST<Registration_Template__c> regTemplates{get; set;}
    public LIST<SelectOption> registrationtemplatesOptions{get; set;}
    public void registrationTemplates(){
        
       regTemplates = new LIST<Registration_Template__c>();
       registrationtemplatesOptions = new LIST<SelectOption>();
       
       regTemplates = [SELECT ID, NAME, Template_Image_URL__c,Order__c   FROM Registration_Template__c ORDER BY Order__c ];
       
       for(Registration_Template__c rg: regTemplates){
            if(rg.Order__c == 1){
                selectedEvent.Registration_Template__c = rg.Id;
                 
            }
            registrationtemplatesOptions.add(new SelectOption(rg.id,  '<apex:image url="{!URLFOR(http://na1.salesforce.com/img/samples/stars_000.gif)}"' ));
            
         //  options.add(new SelectOption('https://ap1.salesforce.com/resource/1323960689000/asish','Lord Hanuman'));
            
       }
    
    }
    
    
    
    
    public void addOnemoreTicket(){
        packageBool = FALSE;
        
       Item_Pool__c itemPoolForInnerClass = new Item_Pool__c();
       itemPoolForInnerClass.Item_Type__c = admissionItemType.id;
       itemPoolForInnerClass.Badge_Label__c = admissionItemType.Badge_Label__c;
       
          
      BLN_ItemType_BAL.ticketsinnerClass localTicket = BLN_ItemType_BAL.addOnemoreTicket( itemPoolForInnerClass , new BLN_Item__c(service_fee__c=' Add Booth Leads fee on top of the total ticket price', Visibility__c = TRUE, Early_Bird_Pricing_Display_Flag__c = TRUE, price__c = null), counteruniqueNo, admissionItemType, new LIST<Item_Pool__c>(), new LIST<BLN_Item__c>(), new LIST<Hash_Tag__c>() );
       
       insertTickets.add(localTicket );
        
        ++counteruniqueNo;
    }
    
    public void eventmoreOptions(){
        
        system.debug('VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV        ');
         eventMoreOptionEvents = selectedEvent;
          statesBasedOnCountry();
        //eventMoreOptionEvents = selectedEvent.clone(true, true, true, false);
        eventMoreOptionBool = TRUE; 
    }
    
    public void savePartEvent(){
        
        eventMoreOptionBool = FALSE;
        selectedEvent = eventMoreOptionEvents;
        
        
    }
    
    public void cancel(){
          eventMoreOptionBool = FALSE;
          moreTicketBool = FALSE;
          
    }
    
    LIST<BLN_ItemType_BAL.ticketsinnerClass> forCan{get; set;}
    
    public void cancelindividualTicket(){
        moreTicketBool = FALSE;
        
        system.debug('cancelindividualTicket     cancelindividualTicket     cancelindividualTicket     '+ togetTheCancelTickets[0].itemsList );
        system.debug('Ticket More tic   Ticket More tic   Ticket More tic     Ticket More tic    Ticket More tic   '+ ticketmoreTic[0].itemsList );
        system.debug('insertTicketsindividualTicket     insertTicketsindividualTicket     insertTicketsindividualTicket     '+ insertTickets[0].itemsList );
        
        if(ticketmoreTic.size() >= 1){
                ticketmoreTic[0].itemsList = new LIST<BLN_Item__c>();
        }
        
        ticketmoreTic = new LIST<BLN_ItemType_BAL.ticketsinnerClass>();
         
        
        
        
    }
    
    public void Packagecancel(){
        packageBool = FALSE;
    }
    
    
    public LIST<BLN_ItemType_BAL.ticketsinnerClass> ticketmoreTic{get; set;}
    public Boolean moreTicketBool{get; set;}
    public integer ticMoreTicForPackage{get; set;}
    
    public void ticketMoreOptions(){
        
        //moreTic
        integer gotoMoreeTicketID = 0;
           if(apexpages.currentpage().getparameters().get('moreTic') != null){
               if(apexpages.currentpage().getparameters().get('moreTic').isNumeric () ){
                   gotoMoreeTicketID = integer.valueOf(apexpages.currentpage().getparameters().get('moreTic'));
               }  
           }
           
          ticketmoreTic = new LIST<BLN_ItemType_BAL.ticketsinnerClass>();
          togetTheCancelTickets = new LIST<BLN_ItemType_BAL.ticketsinnerClass>(); 
          
           integer ticMoreTic = 0;
           
        for(BLN_ItemType_BAL.ticketsinnerClass tc: insertTickets){
           
            if(gotoMoreeTicketID == tc.count){
                break;
            }else{
                ticMoreTic++;
            }
        }
         ticMoreTicForPackage = ticMoreTic;
         
         //If User clicks on more info of other than Packages then if ondition will fired
       if(insertTickets[ticMoreTic].itemTypes.Item_Type_Number__c != null){
                if( insertTickets[ticMoreTic].itemTypes.Item_Type_Number__c != packageItemType.Item_Type_Number__c){
                        
                        BLN_ItemType_BAL.ticketsinnerClass singleTic = new BLN_ItemType_BAL.ticketsinnerClass( insertTickets[ticMoreTic].itemPool, insertTickets[ticMoreTic].items , insertTickets[ticMoreTic].count , insertTickets[ticMoreTic].itemTypes ,  insertTickets[ticMoreTic].packageItemPools,  insertTickets[ticMoreTic].itemsList, insertTickets[ticMoreTic].hashTagsForPool );
                        processTicket(insertTickets[ticMoreTic]);
                        
                        
                        ticketmoreTic.add(singleTic);
        
                         system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@      '+  insertTickets[ticMoreTic].itemsList+'     '+ packageItemType.Item_Type_Number__c); 
                         system.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$      '+  ticketmoreTic);
                        
                        if( insertTickets[ticMoreTic].items.item_name__c == null  ){
                        
                            // ticketmoreTic[0].itemPool.Item_Count__c = 0 ;                                                                        
                            ticketmoreTic[0].items.item_name__c = ticketmoreTic[0].itemPool.Item_Pool_Name__c ;
                            
                            system.debug('######################       '+  ticketmoreTic[0].itemPool.Item_Count__c);
                            
                            ticketmoreTic[0].items.item_count__c = ticketmoreTic[0].itemPool.Item_Count__c ;
                           // ticketmoreTic[0].items.price__c = ticketmoreTic[0].itemPool.Item_Count__c;
                            ticketmoreTic[0].items.sale_start__c = system.Today();
                            ticketmoreTic[0].items.sale_end__c =  selectedEvent.End_Date__c;
                            ticketmoreTic[0].items.item_type__c = ticketmoreTic[0].itemPool.item_type__c;
                            ticketmoreTic[0].items.service_fee__c = selectedEvent.service_fee__c;
                             
                             if(ticketmoreTic[0].items.item_count__c != null && ticketmoreTic[0].items.item_count__c >= 0)
                                 ticketmoreTic[0].itemPool.Item_Count__c = ticketmoreTic[0].items.item_count__c;
                                 
                                 
                                 
                                 
                        }
                        
                        
                        
                        moreTicketBool = TRUE;   
                }else{
                        
                         LIST<PackageItemPoolTags> packageTagsConstruct = new LIST<PackageItemPoolTags>();
                        for(BLN_ItemType_BAL.ItemPoolTags ipt: insertTickets[ticMoreTic].itemPoolTags){
                             
                            PackageItemPoolTags PAK = new PackageItemPoolTags(ipt.itemPool, ipt.itemPoolTags);
                            packageTagsConstruct.add(PAK);
                        }
                        
                     system.debug('GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG      ');
                        newPackageItems = new packageWrapper( insertTickets[ticMoreTic].itemPool, insertTickets[ticMoreTic].items, insertTickets[ticMoreTic].packageItemPools , insertTickets[ticMoreTic].hashTagsForPool, packageTagsConstruct);
                      packageBool = TRUE;
                          newPackageItems.packageBirdItems = insertTickets[ticMoreTic].itemsList;
                          
                     system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@      '+  insertTickets[ticMoreTic].itemTypes.Item_Type_Number__c+'     '+ packageItemType.Item_Type_Number__c); 
                         
                
                 }
       } 
         
         
        
    }
    
    public void processTicket(BLN_ItemType_BAL.ticketsinnerClass tic){
        
        // togetTheCancelTickets = new LIST<BLN_ItemType_BAL.ticketsinnerClass>();
        Item_Pool__c itemPool = new Item_Pool__c();
        BLN_Item__c items =new BLN_Item__c();
        integer count =0;
        LIST<BLN_Item__c> itemsList = new LIST<BLN_Item__c>();
        LIST<Item_Pool__c> packageItemPools = new LIST<Item_Pool__c>();
        Item_Type__c itemTypes = new Item_Type__c();
        LIST<Hash_Tag__c> hashTagsForPool = new LIST<Hash_Tag__c>();
        LIST<String> hashTagsToshow =new LIST<String>();
        LIST<BLN_ItemType_BAL.ItemPoolTags> itemPoolTags = new LIST<BLN_ItemType_BAL.ItemPoolTags>();
        Boolean displayInPage = FALSE;
        Boolean displayWaterMark = FALSE;
        decimal waterMarkAmount = 0.0;
        
        itemPool = tic.itemPool;
        items = tic.items;
        count = tic.count; 
        itemsList = tic.itemsList;
        packageItemPools = tic.packageItemPools;
        itemTypes = tic.itemTypes;
        hashTagsForPool = tic.hashTagsForPool;
        hashTagsToshow = tic.hashTagsToshow;
        displayInPage = tic.displayInPage;
        displayWaterMark = tic.displayWaterMark;
        waterMarkAmount = tic.waterMarkAmount;
        
        
        
        for(BLN_ItemType_BAL.ItemPoolTags ti: tic.itemPoolTags){
                
                Item_Pool__c innerItemPool = new Item_Pool__c();
                LIST<String> innerPoolTags = new LIST<String>();
                
                innerItemPool = ti.itemPool;
                innerPoolTags = ti.itemPoolTags;
                
                
                BLN_ItemType_BAL.ItemPoolTags sing = new BLN_ItemType_BAL.ItemPoolTags(innerItemPool, innerPoolTags);
                
                itemPoolTags.add(sing);
                
        }
        
        BLN_ItemType_BAL.ticketsinnerClass singl = new BLN_ItemType_BAL.ticketsinnerClass( itemPool, items, count , itemTypes , packageItemPools, itemsList, hashTagsForPool );
        
        togetTheCancelTickets.add(singl); 
        
                
    }
    
    
    public void updateTicket(){
    
         moreTicketBool = FALSE;  
         integer ticMoreTic = 0;
         
         for(BLN_ItemType_BAL.ticketsinnerClass tt: ticketmoreTic){
                
            for( BLN_ItemType_BAL.ticketsinnerClass OriginalTickets: insertTickets){
                
                  
                                if(OriginalTickets.count == tt.count){
                                        system.debug('OOOOOOOOOOOOOOOOOOOOOOOOOOOOOooooooooooooooooooooo     packageItemType.id   '+tt.items.item_type__c+'       '+ packageItemType.id+'    '+ OriginalTickets.items.item_type__c);
                                        
                                         if(tt.items.item_type__c != packageItemType.id){
                                    OriginalTickets.itemPool = tt.itemPool;
                                    OriginalTickets.itemPool.Item_Count__c = 0;
                                    OriginalTickets.items = tt.items;
                                    OriginalTickets.itemsList = tt.itemsList;
                                   OriginalTickets.itemPool.Item_Count__c = 0;
                                   
                                    for(BLN_Item__c items : OriginalTickets.itemsList ){
                                         system.debug(' Line ITEMS   Line ITEMS    Line ITEMS   Line ITEMS    Line ITEMS   Line ITEMS   '+ OriginalTickets.itemPool.Item_Count__c);
                                       if(OriginalTickets.itemPool.Item_Count__c != null && items.item_count__c != null )
                                         OriginalTickets.itemPool.Item_Count__c += items.item_count__c;
                                    }
                                    
                                    break;
                                 }else if(tt.items.item_type__c == packageItemType.id){
                                        system.debug('PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPakage        '+newPackageItems);
                                                newPackageItems.packageBirdItems = tt.itemsList;
                                                newPackageItems.packageItemPool = tt.itemPool;
                                                newPackageItems.packageItems = tt.items;
                                                newPackageItems.packageLineItemPool = tt.packageItemPools ;
                                                
                                         }   
                        } 
            }   
         }
         system.debug('QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQqqqqqqqqqqqqqqqqqqq        '+newPackageItems); 
         
         ticMoreTicForPackage = null;
    }
    
    public void updatePackageTicket(){
        
        system.debug('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr        '+newPackageItems); 
         for(BLN_ItemType_BAL.ticketsinnerClass tt: ticketmoreTic){
                                                                
                                newPackageItems.packageBirdItems = tt.itemsList;
                                newPackageItems.packageItemPool = tt.itemPool;
                                newPackageItems.packageItems = tt.items;
                                newPackageItems.packageLineItemPool = tt.packageItemPools ;
                               
                               if(tt.itemsList.size() >= 1){
                                    newPackageItems.packageBirdItems = new LIST<BLN_Item__c>();
                                    newPackageItems.packageBirdItems.addAll(tt.itemsList);
                               }
                                
                                 
                                 moreTicketBool = FALSE;  
                                 
                                 integer ticketsCount = 0;
                                 
                                 
                                 for(BLN_Item__c calc: newPackageItems.packageBirdItems){
                                                if(calc.item_count__c != null)
                                                        ticketsCount += integer.valueOf(calc.item_count__c);
                                 }
                                 
                                 if(ticketsCount!= 0)
                                        newPackageItems.packageItemPool.Item_Count__c = ticketsCount;
                                        
         }              
        
        system.debug('RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR        '+newPackageItems); 
       // ticMoreTicForPackage = null;
    }
    
    
    
    public void deleteTicket(){
       
       integer gotoDeleteTicketID = 0;
       if(apexpages.currentpage().getparameters().get('delTic') != null){
           if(apexpages.currentpage().getparameters().get('delTic').isNumeric () ){
               gotoDeleteTicketID = integer.valueOf(apexpages.currentpage().getparameters().get('delTic'));
           }
       }
       
        integer deletedTic = 0;
        
        for(BLN_ItemType_BAL.ticketsinnerClass tc: insertTickets){
             
            if(gotoDeleteTicketID == tc.count){
                break;
            }else{
                deletedTic++;
            }
        }
        
        insertTickets.remove(deletedTic);
        
    }
    
    public void addAnotherItems(){
       
        
       //  ticketmoreTic[0].itemsList.add(new BLN_Item__c());
         
         for(BLN_ItemType_BAL.ticketsinnerClass tc: ticketmoreTic){
            tc.itemsList.add(new BLN_Item__c());
            
            
             
            tc.itemPool.Item_Count__c = 0;
            
            for(BLN_Item__c bln: tc.itemsList){
            
                if(bln.item_count__c != null){
                    if(bln.item_count__c > 0 ){
                        tc.itemPool.Item_Count__c += bln.item_count__c;
                    } 
                }
            } 
         }   
    }
    
     public   LIST<BLN_Item__c> blnItemsList {get ; set ;}
     public void addGroupTickets(){
       
        SYSTEM.DEBUG('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&       '+insertTickets[0].itemsList ); 
        
        SYSTEM.DEBUG('ticketmoreTic   ticketmoreTic  ticketmoreTic  ticketmoreTic       '+ticketmoreTic.size() ); 
        LIST<BLN_ItemType_BAL.ticketsinnerClass> innerListForTic = new LIST<BLN_ItemType_BAL.ticketsinnerClass>();
        innerListForTic.addAll(insertTickets);
        
      SYSTEM.DEBUG('innerListForTic     innerListForTic  innerListForTic    innerListForTic           '+innerListForTic[0].itemsList );   
       //  ticketmoreTic[0].itemsList.add(new BLN_Item__c());
          blnItemsList = new LIST<BLN_Item__c> ();
         for(BLN_ItemType_BAL.ticketsinnerClass tc: ticketmoreTic){
                 
               //blnItemsList = new LIST<BLN_Item__c> ();
                blnItemsList.add(new BLN_Item__c());
                
                if(tc.itemsList.size() > 0){
                        BLN_Item__c regulerTicket = new BLN_Item__c();
                                regulerTicket = tc.itemsList[0];
                                if(regulerTicket.item_name__c != null){
                                        regulerTicket.item_name__c = regulerTicket.item_name__c +' Regular';
                                        regulerTicket.Early_Bird_Pricing_Display_Flag__c = TRUE;
                                }else
                                  regulerTicket.item_name__c = 'Regular'; 
                        blnItemsList.add(regulerTicket);
                }
                
                blnItemsList.add(new BLN_Item__c());
                        
            tc.itemsList = new LIST<BLN_Item__c>();
            
            SYSTEM.DEBUG('Before Before Before Before       '+insertTickets[0].itemsList ); 
            
            tc.itemsList.addAll(blnItemsList);
            
            SYSTEM.DEBUG('After Aftere After After          '+insertTickets[0].itemsList ); 
            
            //To find Count of Tickets.......................
            tc.itemPool.Item_Count__c = 0;
            for(BLN_Item__c bln: tc.itemsList){
            
                if(bln.item_count__c != null){
                    if(bln.item_count__c > 0 ){
                        tc.itemPool.Item_Count__c += bln.item_count__c;
                    } 
                }
            } 
         }   
         
          SYSTEM.DEBUG('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&       '+insertTickets[0].itemsList ); 
          SYSTEM.DEBUG('innerListForTic     innerListForTic  innerListForTic    innerListForTic           '+innerListForTic[0].itemsList );  
    }
    
    
    public void deleteMoreTicketItems(){
        
        integer gotoDeleteItemID ;
       if(apexpages.currentpage().getparameters().get('delItem') != null){
           if(apexpages.currentpage().getparameters().get('delItem').isNumeric () ){
               gotoDeleteItemID = integer.valueOf(apexpages.currentpage().getparameters().get('delItem')); 
               ticketmoreTic[0].itemsList.remove(gotoDeleteItemID);
               ticketmoreTic[0].itemPool.Item_Count__c = 0;
               
               for(BLN_Item__c bln: ticketmoreTic[0].itemsList){
                    if(bln.item_count__c != null){
                        if(bln.item_count__c > 0 ){
                            ticketmoreTic[0].itemPool.Item_Count__c += bln.item_count__c;
                        } 
                    }
               }
               
               
           }
       }
       
        
    }
    
    
    public void addPackageToItemPool(){
        
       system.debug('**************************   %%%%%%%%  '+ insertTickets.size()+'     '+ ticMoreTicForPackage);
        boolean addedPackageItemsBool = TRUE;
        Boolean packageUpdated = TRUE;
                
                 
                        if(ticMoreTicForPackage != null){
                                if(insertTickets.size() >= (ticMoreTicForPackage+1)){
                                //      insertTickets[addPackageToItemPool].
                                        
                                        Item_Pool__c itemPoolForInnerClass = new Item_Pool__c();
                                               itemPoolForInnerClass.Item_Type__c = admissionItemType.id;
                                               itemPoolForInnerClass.Badge_Label__c = admissionItemType.Badge_Label__c;
                                               
                                        
                                     //    BLN_ItemType_BAL.ticketsinnerClass t = BLN_ItemType_BAL.addOnemoreTicket( itemPoolForInnerClass , new BLN_Item__c(service_fee__c=' Add Booth Leads fee on top of the total ticket price', Visibility__c = TRUE, Early_Bird_Pricing_Display_Flag__c = TRUE), counteruniqueNo, admissionItemType, new LIST<Item_Pool__c>(), new LIST<BLN_Item__c>(), new LIST<Hash_Tag__c>() );
                                            
                                            BLN_ItemType_BAL.ticketsinnerClass t = BLN_ItemType_BAL.addOnemoreTicket( itemPoolForInnerClass , new BLN_Item__c(service_fee__c=' Add Booth Leads fee on top of the total ticket price', Visibility__c = TRUE, Early_Bird_Pricing_Display_Flag__c = TRUE), ticMoreTicForPackage, admissionItemType, new LIST<Item_Pool__c>(), new LIST<BLN_Item__c>(), new LIST<Hash_Tag__c>() );
                     
                                        
                                        if(t.itemPool.Item_Pool_Name__c == null){
                                
                                        t.itemPool = newPackageItems.packageItemPool;
                                        t.items = newPackageItems.packageItems;
                                        t.packageItemPools = newPackageItems.packageLineItemPool;
                                        t.itemTypes = packageItemType;
                                        t.itemPool.Item_Type__c = packageItemType.id;
                                       
                                        if(newPackageItems.packageBirdItems.size() >= 1 ){
                                                t.itemsList = new LIST<BLN_Item__c>();
                                                t.itemsList.addAll(newPackageItems.packageBirdItems);
                                        } 
                                        
                                        LIST<BLN_ItemType_BAL.ItemPoolTags> packagePools = new LIST<BLN_ItemType_BAL.ItemPoolTags>();
                                        
                                        for(PackageItemPoolTags poolTags:  newPackageItems.packageItemPoolTags  ){
                                                system.debug('DDDDDDDDDDDDDDDDDDDDDDDDD     TTTTTTTTTTTTTTT     '+ poolTags);
                                            BLN_ItemType_BAL.ItemPoolTags itePool = new BLN_ItemType_BAL.ItemPoolTags(poolTags.itemPool, poolTags.itemPoolStrings);
                                                
                                            packagePools.add(itePool);
                                        }
                                        t.itemPoolTags = packagePools;
                                        
                                        system.debug(packagePools+'               YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY           '+ t.itemPoolTags);
                                        
                                        addedPackageItemsBool= FALSE;
                                        
                                        packageLineItemsPools.put(t.count , t.packageItemPools );
                                         
                                }
                                        
                                        insertTickets[ticMoreTicForPackage] = t;
                                                          
                                }
                                packageUpdated = FALSE;
                                ticMoreTicForPackage = null;
                                
                        }
                        
                 
        if(packageUpdated){
         //To Check if Any free Tickets are empty....................................
                for(BLN_ItemType_BAL.ticketsinnerClass t : insertTickets){
                    
                    if(t.itemPool.Item_Pool_Name__c == null){
                        
                        t.itemPool = newPackageItems.packageItemPool;
                        t.items = newPackageItems.packageItems;
                        t.packageItemPools = newPackageItems.packageLineItemPool;
                        t.itemTypes = packageItemType;
                        t.itemPool.Item_Type__c = packageItemType.id;
                       if(newPackageItems.packageBirdItems.size() >= 1 ){
                                t.itemsList = new LIST<BLN_Item__c>();
                                t.itemsList.addAll(newPackageItems.packageBirdItems);
                       }     
                        
                        LIST<BLN_ItemType_BAL.ItemPoolTags> packagePools = new LIST<BLN_ItemType_BAL.ItemPoolTags>();
                        
                        for(PackageItemPoolTags poolTags:  newPackageItems.packageItemPoolTags  ){
                                system.debug('DDDDDDDDDDDDDDDDDDDDDDDDD     TTTTTTTTTTTTTTT     '+ poolTags);
                            BLN_ItemType_BAL.ItemPoolTags itePool = new BLN_ItemType_BAL.ItemPoolTags(poolTags.itemPool, poolTags.itemPoolStrings);
                                
                            packagePools.add(itePool);
                        }
                        
                        t.itemPoolTags = packagePools;
                        
                        system.debug(packagePools+'               YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY           '+ t.itemPoolTags);
                        
                        addedPackageItemsBool= FALSE;
                        
                        packageLineItemsPools.put(t.count , t.packageItemPools );
                        ticMoreTicForPackage = null;
                        break;
                    }
                    
                }
                //This will Executre Fresh Tickets in Tickets Area....................................
                if(addedPackageItemsBool){
                     
                    system.debug('**************************     '+newPackageItems.packageItems);
                    
                    BLN_ItemType_BAL.ticketsinnerClass pakTicToMainTic = new BLN_ItemType_BAL.ticketsinnerClass( newPackageItems.packageItemPool , newPackageItems.packageItems, counteruniqueNo,  packageItemType, newPackageItems.packageLineItemPool, newPackageItems.packageBirdItems , newPackageItems.packageHashTagsForPool);
                    
                    LIST<BLN_ItemType_BAL.ItemPoolTags> packagePools = new LIST<BLN_ItemType_BAL.ItemPoolTags>();
                        
                    for(PackageItemPoolTags poolTags:  newPackageItems.packageItemPoolTags  ){
                        BLN_ItemType_BAL.ItemPoolTags itePool = new BLN_ItemType_BAL.ItemPoolTags(poolTags.itemPool,  poolTags.itemPoolStrings);
                        packagePools.add(itePool);
                    }
                    
                    pakTicToMainTic.itemPoolTags = packagePools;
                    
                    insertTickets.add(pakTicToMainTic);
                    
                    packageLineItemsPools.put(counteruniqueNo , newPackageItems.packageLineItemPool);
                    
                    ++counteruniqueNo;
                }
                
        }    
        packageBool = FALSE;
        
        for(BLN_ItemType_BAL.ticketsinnerClass t : insertTickets){
                 system.debug('  ###################$$$$$$$$$$$$$$$$$$%%%%%%%%%%%%%     '+t.itemsList);
        } 
        createPackage();
         
    }
    
    
  /*  
    public class ticketsinnerClass{
        
        public Item_Pool__c itemPool{get; set;}
        public BLN_Item__c items{get; set;}
        public integer count{get; set;}
        public LIST<BLN_Item__c> itemsList{get; set;}
        public LIST<Item_Pool__c> packageItemPools{get; set;}
        
        public ticketsinnerClass(Item_Pool__c itemPoolFromMain, BLN_Item__c BLNItems , integer counter, Item_Type__c itType, LIST<Item_Pool__c> pakItemPool ){
               itemPool = new Item_Pool__c();
               items = new BLN_Item__c ();
               itemsList = new LIST<BLN_Item__c>();
               packageItemPools = new LIST<Item_Pool__c>();
               
               
             system.debug('%%%%%%%%%%%%%%%%%%%%%%%      '+itemPool);  
               //admissionItemType
               
               itemsList.add(BLNItems );
               itemPool = itemPoolFromMain;
               if(itemPool.Item_Type__c == null){
                 itemPool.Item_Type__c = itType.id;
               }  
               
               if(BLNItems.Payment__c == null){
                    BLNItems.Payment__c = 'Paid';
               }
                        
               items  = BLNItems ;
               count = counter;
               packageItemPools = pakItemPool;
        
        }    
    
         
    }
    */
    
    public void paymentGateWaySettings(){
        
        paymentOptionsBool = TRUE;
    
    }
    
    
     
    public void saveEvent(){
        
        DataBase.saveResult docSaveResult;
        
        if(eventImage != null && ( eventImageName != '' || eventImageName != NULL )){
                if(eventImage.size()!= null){
                        if(eventImage.size() < 1048576 ){
                                
                                document mydoc =new document();
                                 mydoc.body = eventImage;
                                 mydoc.folderid =  '00lF0000001VI7Y';
                                 mydoc.IsPublic = True;
                                 mydoc.Name = eventImageName;
                                 
                                 docSaveResult = DataBase.insert(mydoc, false);
                                 
                                 if(docSaveResult.isSuccess()){
                                        selectedEvent.Logo_URL__c = docSaveResult.getId();
                                 }
                                 
                        }else{
                                eventLogoErrorString = 'Please make sure the  file is not more than 100 kb';
                        }
                }else{
                        eventLogoErrorString = 'Please Select Valid Image file.';
                }
        }
      
    //  if(eventLogoErrorString != null){
                        LIST<BLN_Event__c> eventsList = new LIST<BLN_Event__c>();
                        eventsList.add(selectedEvent);
                        
                        BLN_Events_BAL createEventBAL = new BLN_Events_BAL();
                         eventId = createEventBAL.createEvent(eventsList);
                        
                       // LIST<BLN_StatusMessage> res = ut.createEvent(eventsList);
                       //  system.debug('111111111111111111111111111     '+ res);
                        
                        LIST<Item_Pool__c> newItemPools = new LIST<Item_Pool__c>();
                        LIST<BLN_Item__c> newItemsToInsert = new LIST<BLN_Item__c>();
                        LIST<Item_Pool__c> packageLineItemPools = new LIST<Item_Pool__c>();
                        
                        MAP<integer , BLN_ItemType_BAL.ticketsinnerClass> ticketsMAP = new MAP<integer, BLN_ItemType_BAL.ticketsinnerClass>();
                        
                         
                         
                        system.debug('222222222222222222222222     '+ eventId );
                      
                         
                        BLN_ItemPool_BAL itemPoolBAL = new BLN_ItemPool_BAL();
                        BLN_ItemPool_DAO itempoolDAO = new BLN_ItemPool_DAO();
                        BLN_Item_BAL itemsBAL = new BLN_Item_BAL();
                        
                        
                        system.debug('222222222222222222222222  $$$$$$$$$$$$$$$$$$   '+ insertTickets );
                        
                        LIST<Database.UpsertResult> dbItemPoolRes = itemPoolBAL.createItemPool(insertTickets, eventId);
                        LIST<ID> savedItemPoolId = new LIST<ID>();
                         
                         system.debug('33333333333333333333333  @@@@@@@@@@@@@@@     '+ dbItemPoolRes );
                         
                        for(Database.UpsertResult rs : dbItemPoolRes){
                            savedItemPoolId.add(rs.getId());
                        } 
                        system.debug('44444444444444444444444444    '+ savedItemPoolId+'           '+ dbItemPoolRes);
                                                                         
                        
                        LIST<Item_Pool__c> itemPoolAfterUpdate = new LIST<Item_Pool__c>();
                        
                        itemPoolAfterUpdate.addAll(itempoolDAO.givesItemPools(savedItemPoolId) );
                        
                        
                     //   LIST<Item_Pool__c> itemPoolAfterUpdate = [SELECT ID, NAME, uniqueNumber__c,Item_Type__c, Event__c, Item_Pool_Name__c,Item_Count__c  FROM Item_Pool__c WHERE ID IN: savedItemPoolId];
                        MAP<Decimal, Item_Pool__c> itemPoolAfterUpdateMAP = new MAP<Decimal, Item_Pool__c>();
                        
                        for(Item_Pool__c ip: itemPoolAfterUpdate){
                            itemPoolAfterUpdateMAP.put(ip.uniqueNumber__c, ip);
                        }
                        
                         
                       //create Package Line ItemPool............................................... 
                     //  LIST<Database.UpsertResult> dbPackageItemPoolRes = itemPoolBAL.createPackageItemPool(insertTickets, eventId, admissionItemType, itemPoolAfterUpdateMAP);
                 //   LIST<Database.UpsertResult> abc = itemPoolBAL.createPackageItemPool(new LIST<BLN_ItemType_BAL.ticketsinnerClass>(),id.valueOf('pString'),  new Item_Type__c(), new MAP<Decimal, Item_Pool__c>());
                
                       LIST<Database.UpsertResult> dbPackageItemPoolRes = itemPoolBAL.createPackageItemPool(insertTickets, eventId, admissionItemType, itemPoolAfterUpdateMAP); 
                       LIST<Database.UpsertResult> dbItemRes = itemsBAL.processItemsList(insertTickets, itemPoolAfterUpdateMAP, selectedEvent);
                        
                       
                        LIST<Pay_Gateway__c> paymentGateWayTosave = new LIST<Pay_Gateway__c>(); 
                        
                         String companyName  ='';
                          BLN_User_DAO blnUserInfo = new BLN_User_DAO();
        
                                          User loginUser = blnUserInfo.CheckUser(userinfo.getUserName()  );  
                                          
                            if(loginUser.CompanyName != null){
                                                companyName = loginUser.CompanyName;
                                            }
                                            
                                           
                                        BLN_Company_DAO company = new BLN_Company_DAO();
                                        
                                        Company__c companyId = company.queryCompanyId(companyName);
                         
                          system.debug('5555555555555555555555555    TTTTTTTTTTTTTTTT    '+ companyId+'      '+finallToSaveGateWays);
                          
                            
                        for( Pay_Gateway__c p: finallToSaveGateWays){
                                p.Company__c = companyId.id;
                        }
                         
                         LIST<DataBase.saveResult> paymentGateWayRes = DataBase.insert(finallToSaveGateWays, FALSE);
    //  }                               
                                        system.debug('5555555555555555555555555    TTTTTTTTTTTTTTTT    '+ paymentGateWayRes+paymentGateWayRes);
    
                                        LIST<Event_Pay_Gateway__c> eventPayGateWay = new LIST<Event_Pay_Gateway__c>();
                                        for(DataBase.saveResult ds: paymentGateWayRes){
                                                if(ds.isSuccess()){
                                                        Event_Pay_Gateway__c epg = new Event_Pay_Gateway__c();
                                                        epg.Events__c = eventId;
                                                        epg.Pay_Gateway__c = ds.getId();
                                                        
                                                        eventPayGateWay.add(epg);
                                                }
                                        }
                                LIST<DataBase.Saveresult> epgSaveResult = DataBase.insert(eventPayGateWay, FALSE);
        
                                system.debug('6666666666666666666666    TTTTTTTTTTTTTTTT    '+ epgSaveResult);
                     /*           
                                LIST<Item_Type__c> eventAdminItemType = new LIST<Item_Type__c>();
                                
                                for(eventOptionsWrapper ev: eventSelectOptions){
                                        if(ev.eventOptionsBoolean){
                                                eventAdminItemType.add(ev.eventOptionItemType);
                                        }
                                }
                    */            
                           Currency__c eventAdminCurrency = new Currency__c();
                           LIST<Currency__c> curren = new LIST<Currency__c>();
                           
                           if(selectedEvent.Country__c == null){
                                curren = [SELECT id, Name, Currency_Name__c, Currency_Symbol__c FROM Currency__c WHERE Name ='USD'] ;                          
                           }
                            
                           if(curren.size() > 0){
                                eventAdminCurrency = curren[0];
                           }
                           
                           BLN_GNUser_BAL gnUserBAL = new BLN_GNUser_BAL();
                           GN_User__c gnUser = new GN_User__c();
                           gnUser = gnUserBAL.upsertGNUser(comp.Name);  
                            
                            
                            DataBase.insert(gnUser, false);
                            
                    //       system.debug('DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD     11111111111111111111  '+ eventAdminItemType);
                           system.debug('DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD     11111111111111111111  '+ selectedEvent);
                           system.debug('DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD     11111111111111111111  '+ gnUser);
                           system.debug('DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD     11111111111111111111  '+ comp);
                           system.debug('DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD     11111111111111111111  '+ eventadminCurrency);
                          
                          if(companyExtenction.Company__c == null)
                                 companyExtenction.Company__c = comp.id;
                         
                         BLN_Company_DAO companyExtenctiondao = new BLN_Company_DAO();  
                         DataBase.Upsertresult compExtRes =  companyExtenctiondao.upsertCompanyExt(companyExtenction);
                  /*                 
                           if(eventAdminItemType.size() > 0){
                                        BLN_ItemType_BAL   tosaveEventadminOrder = new BLN_ItemType_BAL();
                                   tosaveEventadminOrder.eventOptiuonsTosave(eventAdminItemType, selectedEvent, gnUser, comp, TRUE,  eventadminCurrency);
                           }   
                 */            
    }
    
   
  
    
    
    public Boolean packageBool{get; set;}
    public LIST<packageWrapper> createdPackages{get; set;}
    public packageWrapper newPackageItems{get; set;}
    public packageWrapper packageItemsForCancel{get; set;}
    public MAP<Integer, LIST<Item_Pool__c>> packageLineItemsPools{get; set;}
    
    public void Packages(){
         
        packageBool = TRUE;
        createdPackages = new LIST<packageWrapper>();
         
         system.debug('Package eeeeeeeeeeeeeeeeeeeeeeeeeeeee   ');
         
         createPackage();
         
         system.debug('2222222222222222222    '+newPackageItems );
    }
    
    public void createPackage(){ 
        
        LIST<Item_Pool__c> itemPools = new LIST<Item_Pool__c>();  
     /* itemPools.add(new Item_Pool__c(Package_Flag__c='I - Individual Item pool'));
        itemPools.add(new Item_Pool__c(Package_Flag__c='I - Individual Item pool'));    */
         
        LIST<PackageItemPoolTags> packageLineItemsTags = new LIST<PackageItemPoolTags>();
        
        newPackageItems = new packageWrapper(new Item_Pool__c(Item_Type__c = packageItemType.id, Package_Flag__c='P - Package item pool'), new BLN_Item__c( Payment__c = 'Paid', service_fee__c='Add Booth Leads fee on top of the total ticket price', Visibility__c = TRUE), itemPools, new LIST<Hash_Tag__c>(), packageLineItemsTags);
        
      //  packageItemsForCancel = new packageWrapper(new Item_Pool__c(Item_Type__c = packageItemType.id), new BLN_Item__c( Payment__c = 'Paid', service_fee__c='Add Booth Leads fee on top of the total ticket price', Visibility__c = TRUE), itemPools, new LIST<Hash_Tag__c>(), packageLineItemsTags);
       
        AddpackageLineItems();
        AddpackageLineItems();
        
    }
    
    public void AddpackageLineItems(){
            PackageItemPoolTags pg = new PackageItemPoolTags(new  Item_Pool__c(Package_Flag__c='I - Individual Item pool', Item_Type__c =  admissionItemType.id , Badge_Label__c = admissionItemType.Badge_Label__c ) , new LIST<String> () );
        newPackageItems.packageLineItemPool.add(new  Item_Pool__c(Package_Flag__c='I - Individual Item pool', Item_Type__c =  admissionItemType.id , Badge_Label__c = admissionItemType.Badge_Label__c ));
        newPackageItems.packageItemPoolTags.add(pg); 
        
     //   packageItemsForCancel.packageLineItemPool.add(new  Item_Pool__c(Package_Flag__c='I - Individual Item pool', Item_Type__c =  admissionItemType.id , Badge_Label__c = admissionItemType.Badge_Label__c ));
     //   packageItemsForCancel.packageItemPoolTags.add(pg);
        
    }
    
    public void packageMoreInfo(){
        
        BLN_ItemType_BAL.ticketsinnerClass packageInner  =new  BLN_ItemType_BAL.ticketsinnerClass( newPackageItems.packageItemPool , newPackageItems.packageItems, counteruniqueNo, packageItemType , newPackageItems.packageLineItemPool, newPackageItems.packageBirdItems , newPackageItems.packageHashTagsForPool );
        /*      
                if(newPackageItems.packageBirdItems.size() <= 0){
                        packageInner.itemsList.add(newPackageItems.packageItems);
                }else{
                        packageInner.itemsList = newPackageItems.packageBirdItems;
                }
                
        */      
        
        ticketmoreTic = new LIST<BLN_ItemType_BAL.ticketsinnerClass>();
        
        ticketmoreTic.add(packageInner);
        
        system.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$s       '+  ticketmoreTic);
        
        if( ticketmoreTic[0].items.item_name__c == null  ){
                        
                        // ticketmoreTic[0].itemPool.Item_Count__c = 0 ;                                                                        
                        ticketmoreTic[0].items.item_name__c = ticketmoreTic[0].itemPool.Item_Pool_Name__c ;
                        
                        system.debug('######################       '+  ticketmoreTic[0].itemPool.Item_Count__c);
                        
                        ticketmoreTic[0].items.item_count__c = ticketmoreTic[0].itemPool.Item_Count__c ;
                   // ticketmoreTic[0].items.price__c = ticketmoreTic[0].itemPool.Item_Count__c;
                        ticketmoreTic[0].items.sale_start__c = system.Today();
                        ticketmoreTic[0].items.sale_end__c =  selectedEvent.End_Date__c;
                        ticketmoreTic[0].items.item_type__c = ticketmoreTic[0].itemPool.item_type__c;
                        
                           
                         if(ticketmoreTic[0].items.item_count__c != null && ticketmoreTic[0].items.item_count__c >= 0)
                                 ticketmoreTic[0].itemPool.Item_Count__c = ticketmoreTic[0].items.item_count__c;
                                 
                }
                
                    moreTicketBool = TRUE;      
        
    }
    
    

    public void deletePackageLineItems(){
        
        integer toDeleteItems = 0;
         if(apexpages.currentpage().getparameters().get('pakDelTic') != null){
              toDeleteItems  = integer.valueOf(apexpages.currentpage().getparameters().get('pakDelTic'));
              newPackageItems.packageItemPoolTags.remove(toDeleteItems);
         }
    }
   /* 
    public void savePckage(){
        
       // newPackageItems
        Item_Pool__c packagePool = new Item_Pool__c();
        packagePool = newPackageItems.packageItemPool;
        
        
        
        DataBase.UpsertResult packageMainRecord = DataBase.upsert(packagePool, FALSE);
        
        system.debug('PACKAGE EEEEEEEEEEEEE       '+  packageMainRecord);
        
        LIST<Item_Pool__c> packageItemPools = new LIST<Item_Pool__c>();
        packageItemPools.addAll(newPackageItems.packageLineItemPool);
        
        if(packageMainRecord.isSuccess()){
            for(Item_Pool__c ip: packageItemPools){
               ip.Addon_Parent__c = packageMainRecord.getId();
               ip.Item_Count__c = (ip.Item_Count__c * packagePool.Item_Count__c );
            }
            
            LIST<DataBase.UpsertResult> packageLineRecords = DataBase.upsert(packageItemPools, FALSE);
            
            system.debug('PACKAGE 22222222222222222222222222222     '+  packageLineRecords);
        }
        
        BLN_Item__c PackageItems = new BLN_Item__c();
        
        PackageItems = newPackageItems.packageItems;
        PackageItems.Item_Pool__c = packageMainRecord.getId();
        if(PackageItems.sale_start__c != NULL){
            PackageItems.sale_start__c = system.Today();
            PackageItems.sale_end__c = selectedEvent.End_Date__c;
       } 
         
         DataBase.UpsertResult packageItemRecord = DataBase.upsert(PackageItems, FALSE);
         
         system.debug('PACKAGE 333333333333333333333    '+  packageItemRecord);
    }
    
    */
     
    public class packageWrapper{
       
        public Item_Pool__c packageItemPool{get; set;}
        public BLN_Item__c packageItems{get; set;}
        public LIST<Item_Pool__c> packageLineItemPool{get; set;}
        public LIST<BLN_Item__c> packageBirdItems{get; set;}
        public LIST<Hash_Tag__c> packageHashTagsForPool{get; set;}
        public LIST<PackageItemPoolTags> packageItemPoolTags{get; set;}
        
        public packageWrapper(Item_Pool__c ipl, BLN_Item__c ite , LIST<Item_Pool__c> pakLineItes, LIST<Hash_Tag__c> hashTagsForPak, LIST<PackageItemPoolTags> pakIItems){
             packageItems = new BLN_Item__c();
             packageItemPool = new Item_Pool__c();
             packageLineItemPool = new LIST<Item_Pool__c>();
             packageBirdItems = new LIST<BLN_Item__c>();
             packageHashTagsForPool = new LIST<Hash_Tag__c>();
             packageItemPoolTags = new LIST<PackageItemPoolTags>();
              
             packageItemPool.Package_Flag__c = 'P - Package item pool';
               
             
              packageItemPool = ipl;
              packageItems = ite;
              packageLineItemPool.addAll(pakLineItes);
              packageHashTagsForPool.addAll(hashTagsForPak);
              packageItemPoolTags = pakIItems;
        }
        
    }
    
     public class PackageItemPoolTags{
        
        public LIST<Hash_Tag__c> itemPoolTags{get; set;} //NOT Used At Present
        public Item_Pool__c itemPool{get; set;}
        public LIST<String> itemPoolStrings{get; set;}
        
        public PackageItemPoolTags(Item_Pool__c ipool, LIST<String> ipht){
            itemPoolTags = new LIST<Hash_Tag__c>();
            itemPool = new Item_Pool__c();
            itemPoolStrings = new LIST<String>();
            
            
           // itemPoolTags.addAll(ipht);
            itemPool = ipool;
            itemPoolStrings = ipht;
            
                        
        }
        
    }
    
    
    public string selectedCountry{get; set;}
    public String selectedState{get; set;}
    public LIST<Country__c> country{get; set;}
    public LIST<State__c> states{get; set;}
    public LIST<SelectOption> countryOptions{get; set;}
   
    public void countryStates(){
          
        country = new LIST<Country__c>();
        countryOptions= new LIST<SelectOption>();
      //  countryOptions.add(new SelectOption('none' ,'Choose Country'));
        for(Country__c c: [SELECT ID, NAME, Short_Name__c, Long_Name__c FROM Country__c ]){
            countryOptions.add(new SelectOption(c.id, c.Long_Name__c));
        }
         
        stateOptions= new LIST<SelectOption> ();
     //   stateOptions.add(new SelectOption('none' ,'Choose Country'));
      
    }
    
    
    
    public LIST<SelectOption> stateOptions{get; set;}
    
    public void statesBasedOnCountry(){
        
      system.debug('STATESSSSSSSSSSSSSSSSSSS       '+ selectedCountry  +'AA     '+eventMoreOptionEvents.BLN_Country__c);
            
        stateOptions= new LIST<SelectOption> ();   
      //  stateOptions.add(new SelectOption('none' ,'Choose State'));
        
        for(State__c s: [SELECT ID, NAME, Short_Name__c,Long_Name__c, Country__c FROM State__c WHERE Country__c =: eventMoreOptionEvents.BLN_Country__c]){
           stateOptions.add(new SelectOption(s.id,s.Long_Name__c));
        }
        
        Country__c coun = [SELECT id,Name,Currency__c,Currency__r.Currency_Name__c,Currency__r.Currency_Symbol__c from Country__c where id =: eventMoreOptionEvents.BLN_Country__c];
         Currency__c Currencies = [SELECT id,Name,Currency_Name__c, Currency_Symbol__c FROM Currency__c WHERE id =: coun.Currency__c];
         eventCurrency =  Currencies;
        system.debug('STATESSSSSSSSSSSSSSSSSSS       '+ stateOptions);
 
    }
    
    public void statesBasedOnCountryForPayment(){
        
        system.debug('STATESSSSSSSSSSSSSSSSSSS       '+ companyExtenction.BLN_Business_Country__c);
            
        stateOptions= new LIST<SelectOption> ();   
      //  stateOptions.add(new SelectOption('none' ,'Choose State'));
        
        for(State__c s: [SELECT ID, NAME, Short_Name__c,Long_Name__c, Country__c FROM State__c WHERE Country__c =: companyExtenction.BLN_Business_Country__c]){
           stateOptions.add(new SelectOption(s.id,s.Long_Name__c));
        }
        
        
        system.debug('STATESSSSSSSSSSSSSSSSSSS       '+ stateOptions);
    }
    
    /*----------------------------------------------------  Adding TAGS to INDIVIDUAL TICKETS  Start   --------------------------------------*/
    public Boolean hashTagsBool{get; set;}
    public String selectedTagsFromOptions{get; set;}
    
    public void addTagsToTickets(){
        
        hashTagsBool = TRUE;
        system.debug('STATESSSSSSSSSSSSSSSSSSS  hashTagsBool     '+ hashTagsBool);
 
         eventHashTags = new LIST<Selectoption>();
        
        for(BLN_ItemType_BAL.ticketsinnerClass tic : insertTickets){
            
            //LIST<String> itemWiseHashTags = new LIST<STring>();
            //  itemWiseHashTags = tic.hashTagsForPool;
            
            for(Hash_Tag__c h: tic.hashTagsForPool){
                eventHashTags.add(new Selectoption(h.Tag_Text__c, h.Tag_Text__c ));
            }
            
            if(tic.itemPoolTags.size() > 0){
                for(BLN_ItemType_BAL.ItemPoolTags pakLineItems : tic.itemPoolTags){
                    for(String s: pakLineItems.itemPoolTags){
                        eventHashTags.add(new Selectoption(s, s ));
                    }
                }
                
            }
                         
            // hashTagsForItemsWise.add(new Hash_Tag__c(Table_Name__c='BLN_Item__c',RowId__c = String.valueOf(ticketmoreTic[0].count) ));
        }
         
    }
    
    public string addNewTagItems{get; set;}
    public void addTagItems(){
        
        system.debug('DDDDDDDDDDDDDD         '+ addNewTagItems+'      ');
        
        if(addNewTagItems != null){
            for(BLN_ItemType_BAL.ticketsinnerClass selectedTicketEdit: ticketmoreTic){
                
                selectedTicketEdit.hashTagsForPool.add(new Hash_Tag__c(Table_Name__c='BLN_Item__c',RowId__c = String.valueOf(ticketmoreTic[0].count) , Tag_Text__c=addNewTagItems ));
                eventHashTags.add(new Selectoption(addNewTagItems, addNewTagItems ));
                addNewTagItems = null;
                selectedTagsFromOptions = null; 
            }
        }
        
        if(selectedTagsFromOptions != null){
            for(BLN_ItemType_BAL.ticketsinnerClass selectedTicketEdit: ticketmoreTic){
                
                
                selectedTicketEdit.hashTagsForPool.add(new Hash_Tag__c(Table_Name__c='BLN_Item__c',RowId__c = String.valueOf(ticketmoreTic[0].count) , Tag_Text__c=selectedTagsFromOptions ));
                eventHashTags.add(new Selectoption(selectedTagsFromOptions, selectedTagsFromOptions ));
                
                addNewTagItems = null;
                selectedTagsFromOptions = null;
            }
        }
        
        
     }
    
    
    public void saveTagsToTickets(){
        hashTagsBool = FALSE;
        addNewTagItems  = null;
        
        for(BLN_ItemType_BAL.ticketsinnerClass selectedTicketEdit: ticketmoreTic){
                  for(Hash_Tag__c ht: selectedTicketEdit.hashTagsForPool){
                    selectedTicketEdit.hashTagsToshow.add(ht.Tag_Text__c);
                  }
        }
     }
    
    public void deleteHashTags(){
        
    }
    
   /*----------------------------------------------------  Adding TAGS to INDIVIDUAL TICKETS END  --------------------------------------*/
   /*----------------------------------------------------  Adding TAGS to PAKAGE TICKETS START    --------------------------------------*/
    public string addNewTagForPackage{get; set;}
    public Boolean pakHashTagsBool{get; set;}
    public integer toaddTagsToPackageLineItems{get; set;}
    
    public void addTagToPackageLineItems(){
          
             //   selectedTicketEdit.hashTagsForPool.add(new Hash_Tag__c(Table_Name__c='BLN_Item__c',RowId__c = String.valueOf(ticketmoreTic[0].count) , Tag_Text__c=addNewTagItems ));
            //    eventHashTags.add(new Selectoption(addNewTagItems, addNewTagItems ));
           //    addNewTagItems = null;
           //     selectedTagsFromOptions = null; 
          //    newPackageItems
          
            toaddTagsToPackageLineItems = 0;
            
             system.debug('PACKAGE LINE ITEMS TAGSSSSSSSSSSSSSSSS ROWWWWWWWWWWWWWWW  '+ apexpages.currentpage().getparameters().get('pakDelTic'));
             if(apexpages.currentpage().getparameters().get('pakDelTic') != null){
                  toaddTagsToPackageLineItems  = integer.valueOf(apexpages.currentpage().getparameters().get('pakDelTic'));
             }
  
         pakHashTagsBool = TRUE;
         
         
         system.debug('PACKAGE LINE ITEMS TAGSSSSSSSSSSSSSSSS ROWWWWWWWWWWWWWWW  '+ toaddTagsToPackageLineItems);
        
    }
    
    public void addTagToPackageLineItem(){
        
        integer i = 0;
        
        system.debug('PACKAGE LINE ITEMS TAGSSSSSSSSSSSSSSSS   '+ toaddTagsToPackageLineItems+'   '+i);
        
        for(PackageItemPoolTags pakLine: newPackageItems.packageItemPoolTags){
                
                if(i == toaddTagsToPackageLineItems){
                                pakLine.itemPoolStrings.add(addNewTagForPackage);
                                eventHashTags.add(new Selectoption( addNewTagForPackage, addNewTagForPackage ));
                                
                                addNewTagForPackage = '';
                }
                i++;
                
                system.debug('PACKAGE LINE ITEMS 11111111111111111111111   '+ eventHashTags);
        }
        
   } 
   
   
   public void deleteTagFromPackageLineItem(){
                
                // toDeletePackageHashTags
                //apexpages.currentpage().getparameters().get('toDeletePackageHashTags')
                
                integer i = 0;
         integer gotoDeleteHashTags = 0;
         
         if(apexpages.currentpage().getparameters().get('toDeletePackageHashTags') != null){
                gotoDeleteHashTags = integer.valueOf(apexpages.currentpage().getparameters().get('toDeletePackageHashTags'));
         }
         
         system.debug('PACKAGE LINE ITEMSSSSSSSSSSSS   DELETEEEEEEEEEEE'+ toaddTagsToPackageLineItems +'      '+gotoDeleteHashTags);
         
        for(PackageItemPoolTags pakLine: newPackageItems.packageItemPoolTags){
                
                if(i == toaddTagsToPackageLineItems){
                                
                        system.debug('     '+i +'     '+ 'PACKAGE LINE ITEMSSSSSSSSSSSS   DELETEEEEEEEEEEE'+ pakLine.itemPoolStrings );
                                pakLine.itemPoolStrings.remove(gotoDeleteHashTags);
                                // eventHashTags.add(new Selectoption( addNewTagForPackage, addNewTagForPackage ));
                                // addNewTagForPackage = '';
                  system.debug('     '+i +'     '+ 'PACKAGE LINE ITEMSSSSSSSSSSSS   DELETEEEEEEEEEEE'+ pakLine.itemPoolStrings );
                                
                }
                i++;
        }
        
   }
    
   public void saveTagsToPackageLineItems(){
                
                pakHashTagsBool = FALSE;
        
   }
   
   
   
   /*----------------------------------------------------  Adding TAGS to Packages TICKETS  END   --------------------------------------*/
    public class eventOptionsWrapper{
        
        public Boolean eventOptionsBoolean{get; set;}
        public Item_Type__c eventOptionItemType{get; set;}
        
        public eventOptionsWrapper(Boolean b, Item_Type__c ite){
                eventOptionsBoolean = b;
                eventOptionItemType = new Item_Type__c();
                eventOptionItemType = ite;
                
        }
    }
    
    

    public LIST<dataBase.Saveresult> paymentCheckBoxResult{get; set;} 
    public LIST<Pay_Gateway__c> finallToSaveGateWays{get; set;} 
    
    public String radiopayGateWay{get; set;}
    public String checkBoxesGateWay{get; set;}
    
    public PageReference payGatewayFromJs(){
    
        system.debug('AAAAAAAAAAAAAAAAAAAAAAAAAAAA       '+ radiopayGateWay);
        system.debug('BBBBBBBBBBBBBBBBBBBBBBBBBBBB        '+ checkBoxesGateWay);
        system.debug('CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC       '+ selectedEvent.Event_Status__c );
        
        system.debug('88888888888888888888888888888888  RRRRRRRRRRRRRRRRRRRRRR           '+selectedEvent); 
        
      //  radiopayGateWay = '';
      //  checkBoxesGateWay = '';
        
        SET<String> multipleCheckBoxesTypes = new SET<String>();
        finallToSaveGateWays = new LIST<Pay_Gateway__c>();
        
     //   radiopayGateWay = apexpages.currentpage().getparameters().get('radioJs');
      //  checkBoxesGateWay = apexpages.currentpage().getparameters().get('checkBoxes');
        
         system.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$   TTTTTTTTTTTTTTTT           '+radiopayGateWay);   
         system.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$   TTTTTTTTTTTTTTTT           '+checkBoxesGateWay);  
         
        if(checkBoxesGateWay.contains(';')){
                multipleCheckBoxesTypes.addAll( checkBoxesGateWay.split(';'));
        }
        
        system.debug('888888888888888888888888888888888888   TTTTTTTTTTTTTTTT           '+multipleCheckBoxesTypes);   
        
       // selectedEvent.Event_Status__c = apexpages.currentpage().getparameters().get('eventStatus');
        
        if(radiopayGateWay != ''){
                
                if(radiopayGateWay == 'Authorize .Net'){
                         if(pgateWayMap.containsKey(radiopayGateWay)){
                                authorizepayGateway.PGateway_Type__c = pgateWayMap.get(radiopayGateWay).id;
                         }
                        finallToSaveGateWays.add(authorizepayGateway);
                         
                }else if( radiopayGateWay == 'PayPal'){
                        
                        if(pgateWayMap.containsKey(radiopayGateWay)){
                                payPallpayGateway.PGateway_Type__c = pgateWayMap.get(radiopayGateWay).id;
                         }
                        
                        finallToSaveGateWays.add(payPallpayGateway);
                        
                }else if( radiopayGateWay == 'Stripe'){
                        if(pgateWayMap.containsKey(radiopayGateWay)){
                                stripepayGateway.PGateway_Type__c = pgateWayMap.get(radiopayGateWay).id;
                         }
                        
                        finallToSaveGateWays.add(stripepayGateway);
                }
        }
        
         
        
        if(multipleCheckBoxesTypes.contains('Cash')){
                if(pgateWayMap.containsKey(radiopayGateWay)){
                                 Pay_Gateway__c cashPayGateWay = new Pay_Gateway__c();
                                 cashPayGateWay.PGateway_Type__c = pgateWayMap.get('Cash').id;
                                finallToSaveGateWays.add(cashPayGateWay);
                         }
                
                
        }
        
        if(multipleCheckBoxesTypes.contains('Check')){
                
                if(pgateWayMap.containsKey(radiopayGateWay)){
                                 Pay_Gateway__c checkPayGateWay = new Pay_Gateway__c();
                                 checkPayGateWay.PGateway_Type__c = pgateWayMap.get('Check').id;
                                finallToSaveGateWays.add(checkPayGateWay);
                                 
                         }
        }
        
        
         
          system.debug('88888888888888888888888888888888  RRRRRRRRRRRRRRRRRRRRRR           '+selectedEvent); 
          system.debug('88888888888888888888888888888888  RRRRRRRRRRRRRRRRRRRRRR           '+finallToSaveGateWays); 
           
          system.debug('88888888888888888888888888888888  RRRRRRRRRRRRRRRRRRRRRR           '+testingForEvent); 
           
          
           
          saveEvent();
          
           system.debug('88888888888888888888888888888888  RRRRRRRRRRRRRRRRRRRRRR           '+finallToSaveGateWays); 
       
         PageReference myPage = new PageReference('/BLN_userEvents');
        myPage.setRedirect(true);
        return myPage;
          
        
    }
    
    public PageReference returnToPreviousPage(){
        PageReference myPage = new PageReference('/BLN_userEvents');
        myPage.setRedirect(true);
        return myPage;
    }
    
    
    
    public void testEvent(){
        
        system.debug('88888888888888888888888888888888  RRRRRRRRRRRRRRRRRRRRRR           '+selectedEvent); 
    }
    
    
    public SET<String> selectedItemType{get; set;}
    public LIST<selectOption> itemTypesSelectOptions{get; set;}
    public LIST<selectOption> individualTicketsSelectOptions{get; set;}
    public MAP<id, Item_Type__c> checkSelectOptions{get; set;}
    
    public void chageItemTypesBasedOnEventOptions(){
        
        
        selectedItemType = new SET<String>();
        itemTypesSelectOptions = new LIST<selectOption>();
        individualTicketsSelectOptions = new LIST<selectOption>();
        checkSelectOptions = new MAP<id, Item_Type__c>();
        
        for(eventOptionsWrapper ew:  eventSelectOptions){
                system.debug('UUUUUUUUUUUUUUUUUUUUUUUUUUU   1111111   '+ ew);
                
                if(ew.eventOptionsBoolean){
                        selectedItemType.add(ew.eventOptionItemType.Item_Type_Number__c);
                }
        }
        
        SET<String> eventOptionsItemTypes = new SET<String>();
        BLN_Event_UtilityCon eventUtility = new BLN_Event_UtilityCon();
        
        eventOptionsItemTypes.addAll(eventUtility.itemTypeEventOptions(selectedItemType));
         
        //      eventOptionsItemTypes.add(BLN_Event_UtilityCon.mainItemType());
                eventOptionsItemTypes.addAll(eventUtility.allMainItemType());
        //      eventOptionsItemTypes.add(BLN_Event_UtilityCon.packageItemType());
                 
         
        
        LIST<Item_Type__c> itemTypess = new LIST<Item_Type__c>();
        itemTypess = BLN_ItemType_DAO.itemTypesforTickets(eventOptionsItemTypes);
        
        LIST<Item_Type__c> individualTicketsItemTypess = new LIST<Item_Type__c>();
        individualTicketsItemTypess = BLN_ItemType_DAO.itemTypesforIndividualTickets(eventOptionsItemTypes);
         
         for(Item_Type__c ite: individualTicketsItemTypess){
                checkSelectOptions.put(ite.id, ite);
         }
         
        // itemTypesSelectOptions = BLN_ItemType_BAL.itemTypeSelectOptions(itemTypess);
         ItemTypesOptions = BLN_ItemType_BAL.itemTypeSelectOptions(itemTypess);
         
         individualTicketsSelectOptions = BLN_ItemType_BAL.itemTypeSelectOptions(individualTicketsItemTypess);
         
    }
    
    public void ticketTypes(){
        
                system.debug('TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT       ');
    
    }
    
    public void changeBadgeLable(){
        
        system.debug('TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT       '+ apexpages.currentpage().getparameters().get('selectedItemTypeId')  );
        
        for(BLN_ItemType_BAL.ticketsinnerClass tic: ticketmoreTic){
                if(apexpages.currentpage().getparameters().get('selectedItemTypeId') != null){
                         if(tic.itemPool.Badge_Label__c == null ){
                                if(ItemTypesMap.containsKey(apexpages.currentpage().getparameters().get('selectedItemTypeId'))){
                                        if(ItemTypesMap.get(apexpages.currentpage().getparameters().get('selectedItemTypeId')).Badge_Label__c != null){
                                                        system.debug('RENAME BADGE LABLE  RENAME BADGE LABLE  RENAME BADGE LABLE     R' + tic.itemPool.Badge_Label__c +ItemTypesMap.get(apexpages.currentpage().getparameters().get('selectedItemTypeId'))); 
                                                        tic.itemPool.Badge_Label__c = ItemTypesMap.get(apexpages.currentpage().getparameters().get('selectedItemTypeId')).Badge_Label__c;
                                                    system.debug('RENAME BADGE LABLE RENAME BADGE LABLE RENAME BADGE LABLE     R' +tic.itemPool.Badge_Label__c );
                                        } else{
                                                tic.itemPool.Badge_Label__c = null;    
                                                
                                                  system.debug(' NULL RENAME BADGE LABLE NULL RENAME BADGE LABLE NULL RENAME BADGE LABLE     '+ tic.itemPool.Badge_Label__c );
                                        }
                                                                      
                                }else{
                                        system.debug('DOES NOT HAVE Item Type        '  );
                                }
                        }else{
                                system.debug('NOT NULL NOT NULL NOT NULL NOT NULL NOT NULL NOT NULL NOT NULL'  );
                        }
                }  else{
                        system.debug('NULL NULL NULL NULL NULL NULL NULL NULL'   );
                }     
        }       
    }
    
    
    // This Methode deside the badge Lable For Package Line Items.......................
    public void changeBadgeLabelForPackageLineItems(){
        
        //                      selectedPackageLineItemTypeId
        //         rowNumber
         
        system.debug('HELLOOOOOOOOOOOO    PAckage');
         system.debug('DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD     11111111111111111111  '+ newPackageItems);
        
        integer packagecounter = 0;
        
         if(apexpages.currentpage().getparameters().get('rowNumber') != null){
                if(apexpages.currentpage().getparameters().get('rowNumber').isNumeric())
                        packagecounter = integer.valueOf(apexpages.currentpage().getparameters().get('rowNumber'));
         }
        
        if(newPackageItems.packageItemPoolTags.size() > packagecounter){
                newPackageItems.packageItemPoolTags[packagecounter].itemPool.Item_Type__c = apexpages.currentpage().getparameters().get('selectedPackageLineItemTypeId') ;
                
                newPackageItems.packageItemPoolTags[packagecounter].itemPool.Badge_Label__c = ItemTypesMap.get(apexpages.currentpage().getparameters().get('selectedPackageLineItemTypeId')).Badge_Label__c;
        }
        
    }
    
    
 // Deprecated at 22/7/2014   
    //This method caluclate Total Tickets Quantity based on entry on Items in Ticket More Info area
    public void updateTotalTicketsQuantitytoItemPool(){
        
        system.debug('DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDddd      ');
        
        for(BLN_ItemType_BAL.ticketsinnerClass tic: ticketmoreTic){
                
                if(tic.itemsList.size() > 1){
                        tic.itemPool.Item_Count__c = 0;
                        
                        for(BLN_Item__c item: tic.itemsList){
                                if(item.item_count__c != null )
                                        tic.itemPool.Item_Count__c += item.item_count__c;
                        }
                        
                }
                
                
        }
        
    }
    
    
    public string selectedItemTypeFromTicketMore{get; set;}
    
    
   public void createEventOptionTickets(){
        
          system.debug('TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT       '+ apexpages.currentpage().getparameters().get('selectedId'));
         
         system.debug('TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT       '+  insertTickets.size()+'        '+insertTickets);
         
          for(BLN_ItemType_BAL.ticketsinnerClass t : insertTickets){
                         system.debug('Ticket Namemmmmmmmm       '+ t.itemPool.Item_Pool_Name__c);
          }
          //TicketsDisplayInEventsPageBasedOnItemTypes
         
        //ItemTypesMap
                if(apexpages.currentpage().getparameters().get('selectedId') != null){
                        
                         if(ItemTypesMap.containsKey(apexpages.currentpage().getparameters().get('selectedId'))){
                                if(! checkSelectOptions.containsKey(apexpages.currentpage().getparameters().get('selectedId'))){
                                        // Gather All related Item Types Form Event Options
                                        chageItemTypesBasedOnEventOptions();
                                
                                        LIST<Item_Type__c> itemTypesListFromEventUtility = new LIST<Item_Type__c>();
                                        SET<String> itemTypesStringsBefore = new SET<String>(); // we will store single Item Type AutoNumber here, 
                                        //withis we will send this list to Event Utility class and it will send  related all Options for Ex If EA selects Matchleads, we will insert Matchleads Buyer and MatchLeads Seller 
                                       
                                        SET<String> itemTypesStringsAfter = new SET<String>();  // We will store related Select Options ItemTypes Here
                                        
                                        itemTypesStringsBefore.add(ItemTypesMap.get(apexpages.currentpage().getparameters().get('selectedId')).Item_Type_Number__c);

                                        BLN_Event_UtilityCon euv = new BLN_Event_UtilityCon();
                                        itemTypesStringsAfter =  euv.itemTypeEventOptions(itemTypesStringsBefore);
                                        
                                        
                                        for(String ss: itemTypesStringsAfter){
                                          
                                          Item_Type__c  itemType = ItemTypeMap.get(ss);
                                                checkSelectOptions.put(itemType.id, itemType);
                                                
                                                if(TicketsDisplayInEventsPageBasedOnItemTypes.containsKey(ss)){
                                                        if(TicketsDisplayInEventsPageBasedOnItemTypes.get(ss)){
                                                                ItemTypesOptions.add(new SelectOption(itemType.id, itemType.Name));
                                                                individualTicketsSelectOptions.add(new SelectOption(itemType.id, itemType.Name));
                                                        }
                                                }
                                                
                                                
                                                 system.debug('**************************   %%%%%%%%  '+itemType +'     '+ ItemTypesOptions +'          '+individualTicketsSelectOptions);
                                                  
                                                
                                                //This will Executre Fresh Tickets in Tickets Area....................................
                                                
                                                LIST<BLN_ItemType_BAL.ticketsinnerClass> eventOptionsTickets = new LIST<BLN_ItemType_BAL.ticketsinnerClass>();
                                                
                                                  
                                                   Item_Pool__c itemPoolForInnerClass = new Item_Pool__c();
                                                       itemPoolForInnerClass.Item_Type__c = itemType.id;
                                                       itemPoolForInnerClass.Badge_Label__c = itemType.Badge_Label__c;
                                                       itemPoolForInnerClass.Item_Pool_Name__c = itemType.Name;
                                                          
                                                      BLN_ItemType_BAL.ticketsinnerClass localTicket = BLN_ItemType_BAL.addOnemoreTicket( itemPoolForInnerClass , new BLN_Item__c(service_fee__c=' Add Booth Leads fee on top of the total ticket price', Visibility__c = TRUE, Early_Bird_Pricing_Display_Flag__c = TRUE), counteruniqueNo, itemType, new LIST<Item_Pool__c>(), new LIST<BLN_Item__c>(), new LIST<Hash_Tag__c>() );
                                                       
                                                       if(TicketsDisplayInEventsPageBasedOnItemTypes.containsKey(itemType.Item_Type_Number__c)){
                                                               localTicket.displayInPage = TicketsDisplayInEventsPageBasedOnItemTypes.get(itemType.Item_Type_Number__c);
                                                               
                                                               
                                                               if(!TicketsDisplayInEventsPageBasedOnItemTypes.get(itemType.Item_Type_Number__c)){
                                                                        if(EventOptionsMAP.containsKey(itemType.id)){
                                                                                Event_Price__c ep = new Event_Price__c();
                                                                                localTicket.itemPool.Item_Count__c = ep.Item_Count__c;
                                                                                localTicket.items.price__c = ep.BL_Fee_Amount__c;
                                                                         }
                                                               }else{
                                                                    if(EventOptionsMAP.containsKey(itemType.id)){
                                                                            Event_Price__c ep = new Event_Price__c();
                                                                            ep = EventOptionsMAP.get(itemType.id);
                                                                            localTicket.waterMarkAmount = ep.BL_Fee_Amount__c;
                                                                            
                                                                     }
                                                               }
                                                               
                                                               
                                                               
                                                           }
                                                           
                                                       eventOptionsTickets.add(localTicket );
                                                       eventOptionsTickets.addAll(insertTickets);
                                                       
                                                        system.debug('**************************   %%%%%%%%  '+ localTicket.itemPool.Item_Type__c);
                                                
                                                      
                                                      insertTickets = new LIST<BLN_ItemType_BAL.ticketsinnerClass>();
                                                      insertTickets.addAll(eventOptionsTickets);
                                                       
                                                    ++counteruniqueNo;

                                        }
          
                                }           
                                                      
                         }
                }           
   }  
   
   
   public void deleteEventOptionTickets(){
        
        //  apexpages.currentpage().getparameters().get('deSelectedId')
                if(apexpages.currentpage().getparameters().get('deSelectedId') != null){
              if(ItemTypesMap.containsKey(apexpages.currentpage().getparameters().get('deSelectedId'))){
                        LIST<Item_Type__c> itemTypesListFromEventUtility = new LIST<Item_Type__c>();
                          
                          SET<String> itemTypesStringsBefore = new SET<String>(); // we will store single Item Type AutoNumber here, 
                          //withis we will send this list to Event Utility class and it will send  related all Options for Ex If EA selects Matchleads, we will insert Matchleads Buyer and MatchLeads Seller 
                                       
                          SET<String> itemTypesStringsAfter = new SET<String>();  // We will store related Select Options ItemTypes Here
                                        
                          itemTypesStringsBefore.add(ItemTypesMap.get(apexpages.currentpage().getparameters().get('deSelectedId')).Item_Type_Number__c);

                          BLN_Event_UtilityCon euv = new BLN_Event_UtilityCon();
                          itemTypesStringsAfter =  euv.itemTypeEventOptions(itemTypesStringsBefore);
                                        
                         system.debug('AAAAAAAAAAAAAAAAAAAAa          '+ itemTypesStringsAfter); 
                                       
                          for(String ss: itemTypesStringsAfter){
                                
                                Item_Type__c    itemType = ItemTypeMap.get(ss);
                                LIST<BLN_ItemType_BAL.ticketsinnerClass> beforeDeleteItemTypes = new LIST<BLN_ItemType_BAL.ticketsinnerClass>();
                                                        Item_Type__c removedItemType = checkSelectOptions.remove(itemType.id);  
                                                        
                                                        system.debug('BBBBBBBBBBBBBBBBBBBBBBBBBBB          '+ beforeDeleteItemTypes.size() +'      '+insertTickets.size()); 
                                                        
                                                        
                                        for(BLN_ItemType_BAL.ticketsinnerClass tt: insertTickets){
                                                
                                                system.debug('ZZZZZZZZZZZZZZZZZZ        '+ tt.items.Item_Type__c +'      '+itemType.id); 
                                                 
                                                if(tt.items.Item_Type__c == itemType.id || tt.itempool.Item_Type__c == itemType.id ){
                                                         
                                                }else{
                                                        beforeDeleteItemTypes.add(tt);
                                                }
                                                
                                        }
                                
                                system.debug('CCCCCCCCCCCCCCCCCCCCCCCCCC          '+ beforeDeleteItemTypes.size() +'      '+insertTickets.size()); 
                          
                                insertTickets = new LIST<BLN_ItemType_BAL.ticketsinnerClass>();
                                insertTickets.addAll(beforeDeleteItemTypes);
                                
                                //Removed related Item Type SelectOptions from Individual Tickets
                                for(SelectOption so: individualTicketsSelectOptions){
                                                                 
                                                                if(so.getValue() == itemType.id){
                                                                        so.setDisabled(True);
                                                                }
                                                        }
                                                        //Removed related Item Type SelectOptions from Package Tickets
                                                        for(SelectOption so: ItemTypesOptions){
                                                                 
                                                                if(so.getValue() == itemType.id){
                                                                        so.setDisabled(True);
                                                                }
                                                        }       
                                
                                
                          }
                          
                          system.debug('DDDDDDDDDDDDDDDDDDDDDDDDDDdddd         '+ insertTickets.size()); 
                
              }
                }      
                
                
   }
   
   
   
   
   
    
}