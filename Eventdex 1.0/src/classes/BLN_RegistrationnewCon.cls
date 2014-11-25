public with sharing class BLN_RegistrationnewCon {

   

/***************************************************************************************************************************************************************************************************
*   Author                  : Mahesh Sakunala
*   Date                    : 02/06/2014 
*   Purpose                 : This class is for Registration i.e. User buys tickets through payment gateway, User can also apply promo codes and fill surveys based on the event organizer settings.
*   Last Modified           : Mahesh Sakunala - 10/09/2014
*   Last modified           : Phani 27/10/2014 - Reason : He has to check discount value in Promotion table, Actually he has to check on item promotion table 
*****************************************************************************************************************************************************************************************************/

//------------------------------------------------------------------------ Variables Declaration Start --------------------------------------------------------------------------------- 
public String itqnty{get;set;}
public String itoldqnty{get;set;}
public String itpoolid{get;set;}
public String itlabel{get;set;}
public Integer EventDaysRemaining{get; set;} // To Calculate Event Days Remaining
public BLN_Event__c registrationEvent{get; set;} // To fetch event details
public Registration_Template__c registrationTemplate{get; set;} // To fetch template details
public LIST<TicketInnerClass> TicketList{get;set;} // To display forms after selection of items
public LIST<BLN_Item__c> EventItems{get; set;} // To fetch list of items
public LIST<ItemInnerClass> ItemList{get; set;} // To display list of items
public LIST<ItemInnerClass> CalcItemList{get; set;}
public List<RegItemInnerClass> RegItemList{get; set;} // To display list of items
public List<RegItemInnerClass> CalcList{get;set;}

public MAP<String,LIST<ItemInnerClass>> RegistrationItemList{get; set;} // To display list of items based on Tab Settings
public Boolean ShowSecondPage{get; set;} // To Show & Hide forms
public Boolean HideLogin{get; set;} // To Show & Hide Login
public String Promocode{get;set;} //To input promo code
public String Result{get;set;} // To store result
public Decimal TotalAmount{get;set;} // To calculate total amount
public Decimal TotalAmountWithTaxes{get;set;} // To calculate total amount with taxes
public Decimal TaxAmount{get;set;} // To calculate tax amount
public Decimal FeeAmount{get;set;} // To calculate boothleads fee amount
public Decimal DiscountAmount{get;set;} // To calculate discount amount i.e. Promo Discount
public Decimal DiscountedAmount{get;set;} // To calculate differnce i.e. Sub total
public String EmailAddress{get;set;} // Boothleads User Email
public String Password{get;set;} // Boothleads User Password
public Company_Ext__c companydetails{get;set;} // Company_ext Details
public Company__c comp{get;set;} // Company Details
public GN_User__c IndUser{get;set;} // Each Individual User
public User LoggedInUser{get;set;} // Logged In Boothleads User
public GN_User__c LoggedInGNUser{get;set;} // Logged In Boothleads User
public MAP<Id,Id> PromotionIdMap{get;set;} // To Map Promotion & Item
public Integer PromotionCount{get;set;} // To Map Promotion & Item
public Pay_Address__c PayAddress{get;set;}// To store Payment address
public String OrderFirstname{get;set;} // For Buyer Info
public String OrderLastname{get;set;} // For Buyer Info
public String OrderEmail{get;set;} // For Buyer Info
public String PaymentAddress1{get;set;} // For Payment Address
public BLN_UtillDisplayLinks RegistrationLinks{get;set;} // Initialzing Utility class to display menu and side bar in the portal
public MAP<id,LIST<Reg_Setting__c>> RegSettingsMap{get;set;} // To store registration settings for tickets
public MAP<id,LIST<Question__c>> QuestionsMap{get;set;} // To store survey questions for each ticket selected
public LIST<Question__c> EventQuestions{get;set;} // To fetch all event questions
public LIST<UserAnswerInnerClass> UserEventAnswer{get;set;} // Inner Class Instance for Event Survey Questions & Answers
public SET<Id> ItemsSet{get;set;}
public LIST<Ticket__c> RegTickets{get;set;}
public LIST<Reg_Setting__c> DisplaySettings{get;set;}
public Integer SessionTime{get;set;}
public Company_Ext__c CheckAddress{get;set;}
public String PackageInfo{get;set;}
public string selectedCountry{get; set;}
public String selectedState{get; set;}
public LIST<Country__c> country{get; set;}
public LIST<State__c> states{get; set;}
public LIST<SelectOption> countryOptions{get; set;}
public LIST<SelectOption> stateOptions{get; set;}   
public String naics1 {get ; set ;}
public String naics2 {get ; set ;}
public LIST<NAICS_Code__c> naicscodeslist {get ; set ;}
public LIST<LIST<NAICS_Code__c>> listOfnaicscodes{get; set;}
public LIST<SelectOption> NaicsList { get ; set ;}//To collect all naics codes from naics object 
public LIST<LIST<SelectOption>> NaicsListOfList { get ; set ;}//To collect all naics codes from naics object
    
// Payment Related Fields
public LIST<SelectOption> PaymentGateways{get;set;} // To show payment gateways
public String SelectedPaymentGateway{get;set;} // To store selected payment gateway
public String CreditCardNumber{get; set;}
public String SelectedCardType{get; set;}
public String SelectedMonth{get; set;}
public String SelectedYear{get; set;}
public String CheckNumber{get; set;}
public String CVVNumber{get; set;}
public String ChargeId{get; set;}
public LIST<SelectOption> CreditCardType{get;set;}
public LIST<SelectOption> MonthsList{get;set;}
public LIST<SelectOption> YearsList{get;set;}
public Boolean ShowPaymentError{get; set;} // Represents boolean to show payment errors
public String PaymentErrorString{get; set;} // To Store the error in the payment
public Boolean HideLayout{get; set;} // Represents boolean to switch between registration pages
public String StripeSecret{get;set;} // To store Stripe Secret
public String StripeRefreshToken{get;set;} // To store Stripe Refresh Token
public String ANLoginId{get;set;} // To store Authorize .Net Login Id
public String ANTransactionKey{get;set;} // To store Authorize .Net Transaction Key
public String PayGatewayMode{get;set;} // To store pay gateway mode

//PayPal Parameters
public string ApiUserName{get;set;}
public string Apipassword{get;set;}
public string Apisignature{get;set;}
public string ApiapplicationId{get;set;}
public string Apiipaddress{get;set;}
public string paypalUrl{get;set;}
public String ActionType {get;set;}
public String PaymentType{get;set;}
public String FeesPayer{get;set;}
public String PayeeEmail{get;set;}
public String BoothLeadsEmail{get;set;}
public Boolean FundingTypeEcheck{get;set;}
public Boolean FundingTypeBalance{get;set;}
public Boolean FundingTypeCreditCard{get;set;}
public Boolean IsDisplay{get;set;}
public String APICredentialObjName{get;set;} 
public PPPayResponse PayResponse{get;set;} 
public PPResponseEnvelope RespEnvp{get;set;}
public string SuccessMessage{get;set;}
public String CommonParametersObjName{get;set;}
public string SenderEmail{get;set;} 
public string EventType{get;set;}
public boolean displayButton{get;set;}
public boolean istestmethod{get;set;}
public string Mainmessage{get;set;}
 public Decimal eventadminChangedAmount{get;set;}
 public string CommnetsByEventadmin{get;set;}
 public MAP<id,Event_Price__c> mapItemWithPrice {get;set;}
//------------------------------------------------------------------------ Variables Declaration End ------------------------------------------------------------------------------------- 

//---------------------------------------------------------------------------------- Constructor Start ----------------------------------------------------------------------------------- 
public BLN_RegistrationnewCon(){
    HideLogin = FALSE;
    ShowSecondPage = FALSE;
    ID EventId;
    TicketList = new LIST<TicketInnerClass>();
    ItemList = new List<ItemInnerClass>();
    CalcItemList = new List<ItemInnerClass>();
    RegItemList = new List<RegItemInnerClass>();
    CalcList = new List<RegItemInnerClass>();
   
    RegistrationItemList = new MAP<String,LIST<ItemInnerClass>>();
    EventItems = new LIST<BLN_Item__c>();
    comp = new Company__c();
    companydetails = new Company_Ext__c();
    PromotionIdMap = new MAP<Id,Id>();
    RegTickets = new LIST<Ticket__c>();
    CheckAddress = new Company_Ext__c();
    IndUser = new GN_User__c();
    TotalAmount = 0.00; 
    DiscountAmount = 0.00; 
    DiscountedAmount = 0.00; 
    TaxAmount = 0.00;
    TotalAmountWithTaxes = 0.00;
    PromotionCount = 0;
    istestmethod = TRUE;
    HideLayout = TRUE;
    // Fetching EventId from the page URL i.e. from regular registration  
    EventId = apexpages.currentpage().getparameters().get('id'); 
    
    // Fetching EventId from the cookie value i.e. from backdoor registration
    Cookie k = ApexPages.currentPage().getCookies().get('counter'); 
    if(k !=null && EventId == NULL){
        EventId = k.getValue();
        HideLayout = FALSE;
    }

    // Code to display the menu and side bar in the event admin portal
    RegistrationLinks = new BLN_UtillDisplayLinks();
    RegistrationLinks.isregistrationPage='active';
    RegistrationLinks.isregistrationPageExpand='expand';
    RegistrationLinks.tablabel='Registration iFrame Links';
    RegistrationLinks.eventId=EventId;
    RegistrationLinks.userPermissions(userInfo.getUserId(),EventId);

    // Initializing Quick Registration BAL to perform business logic
    BLN_Quick_Registration_BAL QuickRegBAL = new BLN_Quick_Registration_BAL();
                
    if(EventId != NULL){ 
        // Getting Event Details from Event DAO
        registrationEvent = QuickRegBAL.getEventDetails(EventId);   
        
        mapItemWithPrice = new MAP<id,Event_Price__c>();       
        List<Event_Price__c> listOfeventprices = [SELECT id,Active_Flag__c,BL_Fee_Amount__c,BL_Fee_Level__c,BL_Fee_Percentage__c,Item_Count__c,Item_type__c,Event__c from Event_Price__c where Event__c=:EventId ];
         for(Event_Price__c evp :listOfeventprices  ){
          mapItemWithPrice.put(evp.Item_type__c,evp); 
         }
        
        // Getting List of items selected from Item DAO  
        EventItems = QuickRegBAL.getEventItems(EventId); 
        EventDaysRemaining = date.today().daysBetween(registrationEvent.End_Date__c);   
    }
    
    // Getting Registration Template from Registration Template DAO
    if(registrationEvent.Registration_Template__c != NULL){
        registrationTemplate = QuickRegBAL.getRegTempDetails(registrationEvent.Registration_Template__c);
    }else{
        registrationTemplate = QuickRegBAL.getRegTempDetails('a1kc00000007FZM');
    }
    
    system.debug(' EVENT ITEMS '+EventItems);
    if(EventItems.size() > 0){
           
        //Fetching Display Settings
        DisplaySettings = new LIST<Reg_Setting__c>();
        BLN_DisplaySettings_BAL DisplaySettingsBAL = new BLN_DisplaySettings_BAL();
        system.debug('   EVENT ID '+RegistrationEvent.id);
        DisplaySettings = DisplaySettingsBAL.getregsettingslist(RegistrationEvent.id);
        system.debug(' DISPLAY SETTINGS '+DisplaySettings);
        for(Reg_Setting__c rs: DisplaySettings){
            if(rs.Column_Name__c == 'Time Out' && rs.Included__c == TRUE && rs.Order__c != NULL){
                SessionTime = Integer.ValueOf(rs.Order__c);
            }
        }
        
                    
                    
        // Looping through Event Items to filter them and limit maximum and minimum selection
        for(BLN_Item__c ite: EventItems){
            if((ite.Visibility__c == TRUE && ite.item_count__c >=1)){                       
                LIST<Selectoption> itemWiseCount = new LIST<Selectoption>();
                
                integer minSelection = 0;
                integer maxSelection = 0; 
                
                if(ite.max_per_order__c != null && ite.max_per_order__c != 0){
                    if( ite.Available_Tickets__c >  ite.max_per_order__c){
                        maxSelection = Integer.valueOf( ite.max_per_order__c);
                    }else{
                        maxSelection = Integer.valueOf( ite.Available_Tickets__c);
                    }
                }else{
                    maxSelection = Integer.valueOf( ite.Available_Tickets__c);
                }
                
                if(ite.min_per_order__c != null && ite.min_per_order__c != 0){
                        
                    if( ite.Available_Tickets__c >  ite.min_per_order__c){
                        minSelection = Integer.valueOf( ite.min_per_order__c);
                    }else{
                        minSelection = Integer.valueOf( ite.Available_Tickets__c);
                    }
                }else{
                    minSelection = 0;
                }
                
                if(minSelection !=0)
                    itemWiseCount.add(new Selectoption('0','0'));
                
                for(integer i= minSelection; i<= maxSelection ; i++ ){
                    itemWiseCount.add(new Selectoption(string.valueOf(i), string.valueOf(i) ));
                }
                
              
                //Calculating Package Fee
                Decimal FeeAmount = 0.0;
                if(ite.Item_Pool__r.Item_Type__r.Name == 'Package'){  
                            
                    //Fetching AddOnParent ItemPools
                    LIST<String> IPStrings = new LIST<String>();  
                    IPStrings.add(ite.Item_Pool__r.Id);
                    BLN_ItemPool_DAO ItemPoolDAO = new BLN_ItemPool_DAO();
                    LIST<Item_Pool__c> IPList = ItemPoolDAO.getPackageItemPools(IPStrings);
                    PackageInfo ='';
                    for(Item_Pool__c IP: IPList){
                        if(IP.Item_Type__r.BL_Fee_Amt_per_res__c!= NULL){
                           system.debug('Fee Amount For Item Type:'+ IP.Addon_Count__c * IP.Item_Type__r.BL_Fee_Amt_per_res__c);
                           FeeAmount += IP.Addon_Count__c * IP.Item_Type__r.BL_Fee_Amt_per_res__c;
                        }
                        PackageInfo += IP.Addon_Count__c + ' ' + IP.Item_Pool_Name__c + ',';
                        system.debug('Each Package Detail'+PackageInfo );
                    }
                     system.debug('Total Package Detail'+PackageInfo );
                    try{
                        PackageInfo = PackageInfo.substring(0,PackageInfo.length()-1);
                    }
                    catch(Exception e){}
                   
                }
                 system.debug('Package Fee: '+ FeeAmount);
                ItemList.add(new ItemInnerClass(ite,itemWiseCount,String.valueOf(0),FeeAmount,PackageInfo));   

            } 
            
        }


        //Fetching Event Tags & Registration Tabs
        BLN_Hash_Tag_BAL TagBAL = new BLN_Hash_Tag_BAL();
        LIST<Hash_Tag__c> TagList = TagBAL.getEventTags(registrationEvent.Id);

        //Fetching all Registration tabs enabled in display settings
        MAP<Id,Reg_Setting__c> TagSettingMap = new MAP<Id,Reg_Setting__c>([SELECT ID,Tag_Id__r.Tag_Text__c,Table_Name__c,Column_Name__c,Order__c,Included__c FROM Reg_Setting__c WHERE Event__c=:RegistrationEvent.id AND Setting_Type__c=:'Registration Tab' ORDER BY Order__c]);
        System.debug('Tag setting Map '+TagSettingMap);
        //If registration tabs are availble to this event,
        if(TagSettingMap.values().size()>0){
             MAP<String,LIST<String>> TabSettingMap = new MAP<String,LIST<String>>();
            MAP<Reg_Setting__c,LIST<String>> RegTabSettingMap = new MAP<Reg_Setting__c,LIST<String>>();
            MAP<String,Reg_Setting__c> RegistrationTabMap = new MAP<String,Reg_Setting__c>();
        
            for(Reg_Setting__c rs: TagSettingMap.values()){
            
                LIST<String> ItemPoolTags = new LIST<String>();
                if(rs.Included__c == TRUE){
                    if(TabSettingMap.containsKey(rs.Table_Name__c)){
                        ItemPoolTags = TabSettingMap.get(rs.Table_Name__c);     
                        //ItemPoolTags.add(rs.Column_Name__c);
                        ItemPoolTags.add(rs.Tag_Id__r.Tag_Text__c);
                        TabSettingMap.put(rs.Table_Name__c,ItemPoolTags); 
                    }else{
                        //ItemPoolTags.add(rs.Column_Name__c);
                        ItemPoolTags.add(rs.Tag_Id__r.Tag_Text__c);
                        TabSettingMap.put(rs.Table_Name__c,ItemPoolTags);  
                        RegTabSettingMap.put(rs,ItemPoolTags);
                    }
                    if(!RegistrationTabMap.containsKey(rs.Tag_Id__r.Tag_Text__c)){
                        RegistrationTabMap.put(rs.Tag_Id__r.Tag_Text__c,rs);   
                    }      
                }
            }
            system.debug('Registration Tab Map'+RegistrationTabMap);    
            
            
            MAP<String,LIST<String>> PoolTagMap = new MAP<String,LIST<String>>(); // To store multiple tags for each item pool
    
            for(Hash_Tag__c Tag: TagList){
            //try{
             List<ItemPool_Tag_Junction__c> itj=[select Pool_Id__c,Pool_Id__r.Name,Tag_Id__c,Tag_Id__r.Tag_Text__c from ItemPool_Tag_Junction__c where Tag_Id__c=:Tag.id];
             for(ItemPool_Tag_Junction__c itjn:itj){
                LIST<String> TagItemPools = new LIST<String>();
                if(PoolTagMap.containsKey(itjn.Pool_Id__r.Name)){
                    TagItemPools = PoolTagMap.get(itjn.Pool_Id__r.Name);     
                    TagItemPools.add(itjn.Tag_Id__r.Tag_Text__c);
                    PoolTagMap.put(itjn.Pool_Id__r.Name,TagItemPools); 
                }else{
                    TagItemPools.add(itjn.Tag_Id__r.Tag_Text__c);
                    PoolTagMap.put(itjn.Pool_Id__r.Name,TagItemPools);  
                } 
                //}catch(Exception e){}   
                }//end of inner for loop     
            }
            
            
    System.Debug('AMAR ITEM List '+ItemList);
    LIST<ItemInnerClass> otherList = new LIST<ItemInnerClass>();
    LIST<ItemInnerClass> allList = new LIST<ItemInnerClass>();
    Integer remainingFlag=0;
            //Dividing Items into different registration tabs
            for(ItemInnerClass iic: ItemList){
                LIST<ItemInnerClass> ItemInnerList = new LIST<ItemInnerClass>();
                
                // Checking if the item is having any event tags at all. Enters the loop if it have any.
                System.Debug('PoolTagMap '+PoolTagMap);
                System.debug('Hello '+iic.items.Item_Pool__r.Name);
                if(PoolTagMap.containsKey(iic.items.Item_Pool__r.Name)){
                
                    LIST<String> PoolTagList = new LIST<String>();
                    PoolTagList = PoolTagMap.get(iic.items.Item_Pool__r.Name);
                    system.debug('PoolTagList'+PoolTagList);
    
                    if(PoolTagList != NULL){
                        //Integer i = 0;
                        for(String pt: PoolTagList){
                            
                            Reg_Setting__c RegSetting = RegistrationTabMap.get(pt); 
                            system.debug('Item Tab:'+RegSetting);
                            System.debug('RegSetting '+RegSetting);
                            System.debug('RegistrationItemList '+RegistrationItemList);
                            // Checking if the tag of the item is mapped to any registration tab. Enters the loop if it have any.
                            if(RegSetting != NULL){

                                if(RegistrationItemList.containsKey(RegSetting.Table_Name__c)){
                                
                                    ItemInnerList =  RegistrationItemList.get(RegSetting.Table_Name__c);
                                    ItemInnerList.add(iic);
                                    RegistrationItemList.put(RegSetting.Table_Name__c,ItemInnerList);
                                    for(RegItemInnerClass ric: RegItemList){ 
                                        if(ric.TabLabel == RegSetting.Table_Name__c){
                                            ric.ItemsList = ItemInnerList;
                                        }
                                    }
                                }
                                else{
                                ItemInnerList=new List<ItemInnerClass>();
                                    ItemInnerList.add(iic);
                                    RegistrationItemList.put(RegSetting.Table_Name__c,ItemInnerList);
                                    RegItemList.add(new RegItemInnerClass(RegSetting.Table_Name__c,RegSetting.Order__c,ItemInnerList));
                                   }
                            }
                            // If there are no registration tabs available for the tag, it will be added to Other Tab.
                            else{
                            System.debug('Amar iic '+iic);
                           remainingFlag=1;
                               
                                Integer chkfrdup=0;
                                for(ItemInnerClass iicdup:allList)
                                {
                                    System.debug('iicdup '+iicdup);
                                    if(iicdup.items.item_name__c==iic.items.item_name__c)
                                    chkfrdup=1;
                                }
                                     if(chkfrdup==0){
                                     otherList.add(iic);
                              }    
                                    //RegItemList.add(new RegItemInnerClass('Other',1,ItemInnerList)); 
                               allList.add(iic);      
                            }  
                            //i++; 
                         } 
                        }
                    }
                // If there are no tags available for the item, it will be added to Other Tab.
                else{
                    ItemInnerList.add(iic);
                    RegItemList.add(new RegItemInnerClass('Other',RegItemList.size()+1,ItemInnerList)); 
                }
                 System.debug('RegItemList '+RegItemList);
               }
              if(remainingFlag==1&&otherList.size()!=0)
                  RegItemList.add(new RegItemInnerClass('Other',RegItemList.size()+1,otherList));
             }
        // If there are no registration tabs available for the event
        else{
            RegItemList.add(new RegItemInnerClass('All',0,ItemList)); 
        }
        
       //Sort RegItemInnerclass by Order column
       RegItemInnerClass temp;
       for(integer i=1;i<RegItemList.size();i++)
       {
         for(integer j=0;j<i;j++) 
         {
             if(RegItemList[j].TabOrder>RegItemList[i].TabOrder)
             {
                  temp=RegItemList[j];
                  RegItemList[j]=RegItemList[i];
                  RegItemList[i]=temp;
             }
             
         }  
       }
        
        //Fetching Default State and Country
        countryStates();
        statesBasedOnCountry();
        
        //Getting List of payment gateways available for an event
        PaymentGateways = new LIST<SelectOption>();
        LIST<Event_Pay_Gateway__c> EventPayGateWays = QuickRegBAL.getEventPayGateWays(EventId);
        if(EventPayGateWays.size() > 0){
            for(Event_Pay_Gateway__c epg: EventPayGateWays){
               system.debug('Payment Gateway type: '+epg.Pay_Gateway__r.PGateway_Type__r.Name);
               if(epg.Pay_Gateway__r.PGateway_Type__r.Name == 'Stripe' || epg.Pay_Gateway__r.PGateway_Type__r.Name == 'Authorize.Net'){
                   PaymentGateways.add(new SelectOption('CreditCard','CreditCard'));
               }else if(epg.Pay_Gateway__r.PGateway_Type__r.Name == 'Check'){
                  // if(TotalAmount > epg.Pay_Gateway__r.Min_amount_to_accept__c){
                       PaymentGateways.add(new SelectOption(epg.Pay_Gateway__r.PGateway_Type__r.Name,epg.Pay_Gateway__r.PGateway_Type__r.Name));    
                  // }
               }else{
                   PaymentGateways.add(new SelectOption(epg.Pay_Gateway__r.PGateway_Type__r.Name,epg.Pay_Gateway__r.PGateway_Type__r.Name));        
               }
               
               if(epg.Pay_Gateway__r.PGateway_Type__r.Name == 'PayPal'){
                   PaymentType = epg.Pay_Gateway__r.PP_Payment_Type__c;
                   feesPayer = epg.Pay_Gateway__r.PP_Fee_Payer__c;
                   PayeeEmail = epg.Pay_Gateway__r.PG_Email_Id__c;
                   BoothLeadsEmail = epg.Pay_Gateway__r.PGateway_Type__r.BoothLeads_Email__c;
                   PayGatewayMode = 'PayPal';
               }
               else if(epg.Pay_Gateway__r.PGateway_Type__r.Name == 'Stripe'){
                   StripeRefreshToken = epg.Pay_Gateway__r.PG_Signature__c;
                   StripeSecret = epg.Pay_Gateway__r.PGateway_Type__r.BoothLeads_Stripe_Secret__c;
                   PayGatewayMode = 'Stripe';
               }
               else if(epg.Pay_Gateway__r.PGateway_Type__r.Name == 'Authorize.Net'){
                   ANLoginId = epg.Pay_Gateway__r.PG_User_Key__c;
                   ANTransactionKey = epg.Pay_Gateway__r.PG_Signature__c;
                   PayGatewayMode = 'Authorize .Net';
               }
               else if(epg.Pay_Gateway__r.PGateway_Type__r.Name == 'Check'){
                   PayGatewayMode = 'Check';
               }
            }
        }
          
        //Fetching CheckAddress
        BLN_UCRole_DAO UCRDAO = new BLN_UCRole_DAO();
        BLN_Company_DAO ComDAO = new BLN_Company_DAO();
        
        
       // UC_Role__c EURole = new UC_Role__c ();
        try{
          // EURole  = UCRDAO.fetchEventAdmin(registrationEvent.Id);
        }catch(exception er){}
        
        if(registrationEvent.organizer_id__c!= NULL){
            Company__c CheckCompany = ComDAO.queryCompany(registrationEvent.organizer_id__c);   
            for(Company_Ext__c ce: CheckCompany.Company_Ext__r){
                CheckAddress = ce;
            }
        }
        
        
        //Getting Stripe Related Information
        MonthsList= new LIST<SelectOption>();
        YearsList= new LIST<SelectOption>();
        CreditCardType= new LIST<SelectOption>();
    
        LIST<String> monthstring = new LIST<String>{'01','02','03','04','05','06','07','08','09','10','11','12'};
        LIST<String> yearstring = new LIST<String>{'2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024','2025','2026','2027','2028','2029','2030'};
        LIST<String> cardtypestring = new LIST<String>{'Visa','MasterCard','American Express','Discover'};
        SelectedYear= String.valueOf(system.today().year());
        YearsList.add(new SelectOption(SelectedYear,SelectedYear));
        String y=SelectedYear;
        for(integer l=0; l<= 15; l++){
            y = String.valueof(integer.valueOf(y)+1); 
            YearsList.add(new SelectOption(y,y));           
        }
        
        for(String m: monthstring){
            MonthsList.add(new SelectOption(m,m));
        }
    
        for(String c: cardtypestring){
            CreditCardType.add(new SelectOption(c,c));
        }
    }
}
//------------------------------------------------------------------------------------ Constructor End ---------------------------------------------------------------------------------------- 

// -------------------------------------------------------------------------------- Reg Item Inner Class Start --------------------------------------------------------------------------------
public class RegItemInnerClass{

    public String TabLabel{get;set;}
    public Decimal TabOrder{get;set;}
    public LIST<ItemInnerClass> ItemsList{get;set;} 
    
    public RegItemInnerClass(String TabLabel1,Decimal TabOrder1,LIST<ItemInnerClass> ItemsList1){
        
        TabLabel = TabLabel1;
        TabOrder = TabOrder1;
        ItemsList = ItemsList1;
    }
}
// -------------------------------------------------------------------------------- Reg Item Inner Class End ----------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------- Item Inner Class Start ---------------------------------------------------------------------------------


// This Inner Class is used for displaying filtered items
    public class ItemInnerClass{
    
        public BLN_Item__c items{get; set;}
        public LIST<Selectoption> itemSelectOptions{get; set;}
        public String selectedItemQuantity{get; set;}
        public Decimal PackageFee{get;set;}
        public String PackageInfo{get; set;}
        
        public ItemInnerClass(BLN_Item__c ite, LIST<Selectoption> itemWiseOptions, String qty,Decimal PkgFee,String PkgInfo){
        
            items = new BLN_Item__c();
            itemSelectOptions = new LIST<Selectoption>();
            //selectedItemQuantity = '0';
            PackageFee = PkgFee;
            PackageInfo = PkgInfo;
            
            items = ite;
            itemSelectOptions = itemWiseOptions;
            selectedItemQuantity = qty;
            PackageFee = PkgFee;
            PackageInfo = PkgInfo;
        }   
    }
// ----------------------------------------------------------------------------------- Item Inner Class End ------------------------------------------------------------------------------------ 
public Set<Id> selectedTicketIds{get;set;} 
public MAP<id,integer> mapTicWithQuan{get;set;}
public MAP<id,integer> mapItemWithQuan{get;set;}
public MAP<id,ItemInnerClass> napIdwithObj{get;set;}
// ------------------------------------------------------------------------------- Apply Promo Code Method Start ---------------------------------------------------------------------------------- 
// This method is fired when user clicks on apply promo code / when user picks quantity for an item
    public PageReference applyPromocode(){
    
     System.debug('CalcItemList '+CalcItemList);
    System.debug('QQQQQQQQQQQQQQ   '+CalcItemList.size());
    napIdwithObj = new MAP<id,ItemInnerClass>();
    
    System.debug('***'+itqnty+';'+itpoolid+';'+itlabel+'itoldqnty '+itoldqnty);
    decimal TotalamountBefore =0.0;
    TotalamountBefore = TotalAmount-DiscountAmount;
    System.debug('AAAAAAAAAAAAAAAAAAAAA '+RegItemList.size());
    mapItemWithQuan = new MAP<id,integer>();
    for(Integer i=0;i<RegItemList.size();i++){
       if(RegItemList[i].TabLabel==itlabel){
        if(RegItemList[i].ItemsList.size()>0){ // iterate selected tickets
            for(Integer j=0;j<RegItemList[i].ItemsList.size();j++){
              if(RegItemList[i].ItemsList[j].items.id==itpoolid){ // Previous itpoolid has it pool id i(phani) changed it to item id if error comes change back to itempool id 
              
              integer flag=0;
               system.debug('SSSSSSSSSSSSS WWWWWWWWWWW '+CalcItemList.size());
                
              for(integer k=0;k<CalcItemList.size();k++)
              {
                 if(CalcItemList[k].items.id==itpoolid){
                  flag=1;
                  system.debug('SSSSSSSSSSSSS 11111'+CalcItemList[k].selectedItemQuantity);
                 CalcItemList[k].selectedItemQuantity=String.valueOf(Integer.valueOf(CalcItemList[k].selectedItemQuantity)+Integer.valueOf(itqnty)-Integer.valueOf(itoldqnty));
                 
                 //CalcItemList[k].selectedItemQuantity=String.valueOf(Integer.valueOf(CalcItemList[k].selectedItemQuantity)+Integer.valueOf(itqnty)-Integer.valueOf(itoldqnty))
                  system.debug('Selected Quantity '+CalcItemList[k].selectedItemQuantity);
                 break;
                 } 
              }
              if(flag==0){
              RegItemList[i].ItemsList[j].selectedItemQuantity=itqnty;
              CalcItemList.add(RegItemList[i].ItemsList[j]);
              
              }
              }
              
            }
       }// checking selected list End      
            
            }
            
         }   
         System.debug('CalcItemList '+CalcItemList);
        //SET<id> ticketIdsForActQuan =new set<id>();
        TotalAmount = 0.00; 
        DiscountAmount = 0.00; 
        DiscountedAmount = 0.00;
        eventadminChangedAmount =0.00; 
        FeeAmount = 0.00;
        TaxAmount = 0.00;
        TotalAmountwithTaxes = 0.00;
        // Intialising Promo code BAL
        BLN_PromoCode_BAL PromotionBAL = new BLN_PromoCode_BAL();
        mapTicWithQuan = new MAP<id,integer>();
        
        selectedTicketIds = new Set<id>();
        
        if(promocode != NULL || promocode !=''){
            
            // Checking Promo Code details in Promotions table
            LIST<Promotion__c> Promotion = PromotionBAL.getPromotionDetails(registrationEvent.Id,promocode);
            system.debug('Promotion Details are: '+Promotion);
            
            // Checking Item Promotions details in Item Promotions table
            MAP<Id,Item_Promotion__c> ItemMap = new MAP<Id,Item_Promotion__c >();
  
            if(Promotion!= NULL && Promotion[0].T_Used_Count__c < Promotion[0].T_Max_Count__c){
                LIST<Item_Promotion__c> ItemPromotions = PromotionBAL.getItemPromotions(Promotion[0].Id);
                system.debug('Item Promotions List: '+ItemPromotions);

                if(ItemPromotions.size()>0){
                    for(Item_Promotion__c IP: ItemPromotions){
                       ItemMap.put(IP.Buy_Item__c,IP);
                    }
                }
            }
            
          for(ItemInnerClass iic: CalcItemList){
              integer ih = 0;
               if(null != iic.selectedItemQuantity){
                 ih = Integer.valueOf(iic.selectedItemQuantity);
              }
             mapItemWithQuan.put(iic.items.id,ih);
             napIdwithObj.put(iic.items.id,iic);
           }  
            
           System.debug('mapItemWithQuan   22222222222222 '+mapItemWithQuan); 
             for(ItemInnerClass iic: CalcItemList){
            System.debug('iic item'+iic);
            System.debug('iic.selectedItemQuantity '+iic.selectedItemQuantity);
               if(iic.selectedItemQuantity != null){
                   if(Integer.valueOf(iic.selectedItemQuantity) >=1){
                     selectedTicketIds.add(iic.items.id);
                      mapTicWithQuan.put(iic.items.id,Integer.valueOf(iic.selectedItemQuantity));
                        if(ItemMap.get(iic.items.id)!=NULL && Integer.valueOf(iic.selectedItemQuantity) >= ItemMap.get(iic.items.id).Buy_Item_Quantity__c  && (ItemMap.get(iic.items.id).Promotion__r.Exp_TimeStamp__c).format() >= system.now().format()){
                        // && (ItemMap.get(iic.items.id).Promotion__r.Exp_TimeStamp__c).format() >= system.now().format() 
                          if(ItemMap.get(iic.items.id).Promotion__r.Status__c == 'Active and Enable for online registrations'){
                               system.debug('Promotion Id WWWWWWWWWWWWWW :' +ItemMap.get(iic.items.id).Promotion__r.Status__c);
                                // Basic Promo Codes Scenario 
                                   if(ItemMap.get(iic.items.id).Promotion__r.Promotion_Type__c=='Basic Promo codes'){
                                       system.debug('Promotion Id:' +ItemMap.get(iic.items.id).Promotion__c);
                                       PromotionIdMap.put(iic.items.id,ItemMap.get(iic.items.id).Promotion__c);
     
                                       //Checking the ticket quantity limit for promo code
                                       system.debug('Buy Item Quantity '+ItemMap.get(iic.items.id).Buy_Item_Quantity__c);

                                          // for(integer k=0;k<Integer.valueOf(iic.selectedItemQuantity);k++){
                                           
                                               if(ItemMap.get(iic.items.id).Item_Discount_Type__c =='Percent'){
                                                   DiscountAmount += (Integer.valueOf(iic.selectedItemQuantity)*iic.items.price__c) - ((Integer.valueOf(iic.selectedItemQuantity)*(iic.items.price__c))*(ItemMap.get(iic.items.id).Item_Discount_Value__c/100)); 
                                                   DiscountedAmount += ((Integer.valueOf(iic.selectedItemQuantity)*(iic.items.price__c))*(ItemMap.get(iic.items.id).Item_Discount_Value__c/100));
                                                   system.debug('DiscountAmount2 '+ DiscountAmount + 'DiscountedAmount2 ' +DiscountedAmount +'For Item '+iic.items.item_name__c);
                                                   PromotionCount += 1;
                                               }
                                               else if(ItemMap.get(iic.items.id).Item_Discount_Type__c =='Amount'){        
                                                   DiscountAmount += (Integer.valueOf(iic.selectedItemQuantity)*(iic.items.price__c)) - ItemMap.get(iic.items.id).Item_Discount_Value__c;
                                                   DiscountedAmount += ItemMap.get(iic.items.id).Item_Discount_Value__c;
                                                   system.debug('DiscountAmount2 '+ DiscountAmount + 'DiscountedAmount2 ' +DiscountedAmount +'For Item '+iic.items.item_name__c);
                                                   PromotionCount += 1;
                                               }
                                           //}

                                   }else if(ItemMap.get(iic.items.id).Promotion__r.Promotion_Type__c == 'Multi-Items Discount'){ // By Phani Multi-Items Discount
                                       system.debug('Buy Item Quantity '+ItemMap.get(iic.items.id).Buy_Item_Quantity__c);
                                       boolean isMultiItemcon = true;
                                       
                                       for(id itemids : ItemMap.keyset()){
                                            integer selectedQuan = 0; 
                                            if(null!=mapItemWithQuan.get(itemids)){
                                               selectedQuan = mapItemWithQuan.get(itemids);
                                           }
                                          integer promoQuan = integer.valueOf(ItemMap.get(itemids).Buy_Item_Quantity__c);
                                          system.debug('############ '+promoQuan +'@@@@@@@@@@@@@@@@@@@  '+selectedQuan );
                                          
                                          if(promoQuan > selectedQuan ){
                                               isMultiItemcon =false;                                        
                                           }else{
                                            
                                            }
                                       }
                                       
                                      if(isMultiItemcon ){
                                        integer buyQuan = integer.valueOf(ItemMap.get(iic.items.id).Buy_Item_Quantity__c);
                                        if(buyQuan <= Integer.valueOf(iic.selectedItemQuantity)){
                                            integer iterateValue = Integer.valueOf(iic.selectedItemQuantity)/buyQuan;
                                           
                                           
                                            for(integer d= 0 ; d < iterateValue  ;d++){
                                             if(ItemMap.get(iic.items.id).Item_Discount_Type__c =='Percent'){
                                                decimal tcPrice = (iic.items.price__c)*buyQuan;
                                               
                                                 DiscountAmount += (Integer.valueOf(iic.selectedItemQuantity)*iic.items.price__c) - ((Integer.valueOf(iic.selectedItemQuantity)*iic.items.price__c)*(ItemMap.get(iic.items.id).Item_Discount_Value__c/100));   
                                                 DiscountedAmount += (Integer.valueOf(iic.selectedItemQuantity)*iic.items.price__c)*(ItemMap.get(iic.items.id).Item_Discount_Value__c/100);
                                                 system.debug('DiscountAmount2 '+ DiscountAmount + 'DiscountedAmount2 ' +DiscountedAmount +'For Item '+iic.items.item_name__c);
                                               PromotionCount += 1;                                     
                                             }else if(ItemMap.get(iic.items.id).Item_Discount_Type__c =='Amount'){
                                                 decimal tcPrice = (iic.items.price__c)*Integer.valueOf(iic.selectedItemQuantity);
                                                   DiscountAmount +=(Integer.valueOf(iic.selectedItemQuantity)*iic.items.price__c )-ItemMap.get(iic.items.id).Item_Discount_Value__c;
                                                   DiscountedAmount +=ItemMap.get(iic.items.id).Item_Discount_Value__c;
                                                   system.debug('DiscountAmount2 '+ DiscountAmount + 'DiscountedAmount2 ' +DiscountedAmount +'For Item '+iic.items.item_name__c);
                                                   PromotionCount += 1;
                                               }
                                         }
                                       }
                                     }else{
                                        for(id itemids : ItemMap.keyset()){
                                        system.debug('ddddddddddd '+DiscountAmount +'WWWWWWWWWWWWWWW '+mapItemWithQuan.get(itemids) +'EEEEEEEEEEE '+napIdwithObj.get(itemids).items.price__c);
                                           DiscountAmount +=   (mapItemWithQuan.get(itemids)*napIdwithObj.get(itemids).items.price__c);                                   
                                          
                                           system.debug('ddddddddddd '+DiscountAmount +'WWWWWWWWWWWWWWW '+mapItemWithQuan.get(itemids) +'EEEEEEEEEEE '+napIdwithObj.get(itemids).items.price__c);
                                       
                                       }
                                     }
                                   }
                                   
                              }
                           system.debug('DiscountAmount '+DiscountAmount);
                           TotalAmount = DiscountAmount;
                           
                           if(iic.items.service_fee__c == 'Add Booth Leads fee on top of the total ticket price'){
                             if(mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Amount__c != NULL || mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Percentage__c!= NULL) {
                                if(iic.items.Item_Type__r.Name == 'Package'){
                                       FeeAmount += iic.PackageFee;
                                   }else{
                                     if(iic.items.Payment__c != 'Free'){
                                         FeeAmount += (Integer.ValueOf(iic.selectedItemQuantity) * mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Amount__c) + (Integer.ValueOf(iic.selectedItemQuantity) * (iic.items.price__c*(mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Percentage__c)));
                                      }
                                   }
                                   if(iic.items.Payment__c != 'Free'){
                                       TotalAmount += FeeAmount;
                                   }
                                   system.debug('Fee1 '+ TotalAmount + ' For Item'+iic.items.item_name__c);
                               }
                           }
                           system.debug('Total Amount with Promo Codes: '+TotalAmount );
                       }
                       else{
                             
                           if(mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Amount__c!= NULL || mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Percentage__c!= NULL){
                            
                                   if(iic.items.Payment__c != 'Free' && (iic.items.service_fee__c == 'Add Booth Leads fee on top of the total ticket price')){
                                        if(iic.items.Item_Type__r.Name == 'Package'){
                                            TotalAmount += Integer.ValueOf(iic.selectedItemQuantity) * (iic.items.price__c+iic.PackageFee); 
                                        }else{
                                            TotalAmount += (Integer.ValueOf(iic.selectedItemQuantity) * (iic.items.price__c+mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Amount__c))+(Integer.ValueOf(iic.selectedItemQuantity) * (iic.items.price__c*(mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Percentage__c/100)));  
                                        }
                                        system.debug('1st Looop');
                                   }
                                   else{
                                       TotalAmount += Integer.ValueOf(iic.selectedItemQuantity) * iic.items.price__c;
                                       system.debug('2nd Looop');
                                   } 
                                   
                                   if(iic.items.service_fee__c == 'Add Booth Leads fee on top of the total ticket price'){                            
                                       if(iic.items.Item_Type__r.Name == 'Package'){
                                           FeeAmount += iic.PackageFee;
                                       }else{
                                          if(iic.items.Payment__c != 'Free'){
                                            FeeAmount += (Integer.ValueOf(iic.selectedItemQuantity) * mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Amount__c)+(Integer.ValueOf(iic.selectedItemQuantity) * (iic.items.price__c*(mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Percentage__c/100))) ;
                                          }
                                       }
                                   }
                                   
                               }   
                             
                               system.debug('Total Amount without Promo Codes: '+FeeAmount );
                       }
                       if(registrationEvent.Accept_Tax_Rate__c == TRUE && registrationEvent.Tax_Rate__c != NULL){
                            TaxAmount = TotalAmount * (registrationEvent.Tax_Rate__c/100);
                            TotalAmountwithTaxes = TotalAmount + TaxAmount;
                            TaxAmount = TaxAmount.setscale(2);
                            TotalAmountwithTaxes = TotalAmountwithTaxes.setscale(2);
                       } 
                       TotalAmount = TotalAmount.setscale(2);
                       DiscountAmount = DiscountAmount.setscale(2);
                       DiscountedAmount = DiscountedAmount.setscale(2);
                   }
               }
               
            }
            
            if(Promotion!= NULL && Promotion[0].T_Used_Count__c < Promotion[0].T_Max_Count__c){
              if(Promotion[0].Promotion_Type__c =='Spend More Save More'){
                  if(TotalAmount >= Promotion[0].Condition_Min_No__c && TotalAmount<= Promotion[0].Condition_Max_No__c){
                    if(Promotion[0].Discount_Type__c=='Percent'){
                      DiscountedAmount =TotalAmount*((Promotion[0].Discount_Value__c)/100);
                      TotalAmount  =TotalAmount - TotalAmount*((Promotion[0].Discount_Value__c)/100);
                      TotalAmount = TotalAmount.setscale(2);
                       DiscountAmount = DiscountAmount.setscale(2);
                           DiscountedAmount = DiscountedAmount.setscale(2);
                      }else{
                          DiscountedAmount =Promotion[0].Discount_Value__c;
                          TotalAmount  =TotalAmount - Promotion[0].Discount_Value__c;
                         TotalAmount = TotalAmount.setscale(2);
                          DiscountAmount = DiscountAmount.setscale(2);
                           DiscountedAmount = DiscountedAmount.setscale(2);
                      }
                  }
                }
            }
        } 
        
        
        system.debug('Fee Values  '+FeeAmount);
        itqnty= '0';itlabel='';itoldqnty='0';
        //System.debug('***'+itqnty+';'+itpoolid+';'+itlabel+'itoldqnty '+itoldqnty);
        return null;
    }
// -------------------------------------------------------------------------------- Apply Promo Code Method End ----------------------------------------------------------------------------------- 

  
public List<Reg_Setting__c> RegistrationSettingsForBuyer{get;set;}
public  List<Reg_Setting__c> settingsForbuyer{get;set;} //To display buyer settings
public  SET<string> groupNames; // To check group is there or not      
public user GNUserforbuyer {get;set;}
public user_Ext__c GNUserextforbuyer {get;set;}
public Company__c GNbuyerCompany {get;set;}
public Company_Ext__c GNbuyerCompanyDetails{get;set;}
 public Pay_Address__c BillingAddressForbuyer{get;set;}


  
  
   
   
//----------------------------------------------------------------------------------- Order Now Method Start ----------------------------------------------------------------------------------- 
// This method is fired when user clicks on Order Now button

    public void orderNow(){
        ShowSecondPage = TRUE;
        HideLogin = FALSE;
        integer i = 1;
         BLN_Quick_Registration_BAL QuickRegBAL = new BLN_Quick_Registration_BAL();
        PayAddress = new Pay_Address__c();
        PayAddress.BLN_Country__c= selectedCountry;
        system.debug('Item list Size: '+ItemList.size());

        //For fetching Registration & Survey settings
        fetchSettings();
        fetchNAICSCodes();
        
        Integer ItemQuantity;
        RegistrationSettingsForBuyer = new List<Reg_Setting__c>();
        
        // Iterating through items seleceted
        for(ItemInnerClass iic: ItemList){
           
           system.debug('Item Id: ' + iic.items.id+'Item price: '+iic.items.price__c);
           system.debug('Selected Quantity: ' + iic.selectedItemQuantity);
           
           if(iic.selectedItemQuantity != null){
               if(Integer.valueOf(iic.selectedItemQuantity) >=1 ){ 
                   BLN_Item__c BLNItem = new BLN_Item__c();
                   BLNItem = iic.items;
                   if(iic.items.Ticket_Settings__c == 'Collect info from Buyers only'){
                       RegTickets = QuickRegBAL.getTicketDetail(iic.items, 1);
                       ItemQuantity = Integer.valueOf(iic.selectedItemQuantity);
                       RegistrationSettingsForBuyer.addAll(RegSettingsMap.get(iic.items.id));  
                   }
                   else if(iic.items.Ticket_Settings__c == 'Collect info from All Attendees'){
                       RegTickets = QuickRegBAL.getTicketDetail(iic.items, Integer.valueOf(iic.selectedItemQuantity));    
                       system.debug('Fetched Tickets:'+RegTickets);
                       ItemQuantity = 1;
                   }
                    
                   for(Ticket__c t: RegTickets){
                      system.debug('Fetched Each Ticket:'+t);
                      
                      if((t.Item_Pool__r.Ticket_Settings__c == 'Collect info from All Attendees' && t.Item_Type__r.name == 'Package') || (t.Item__r.Ticket_Settings__c == 'Collect info from All Attendees' && t.Item_Type__r.name != 'Package')){
                          TicketList.add(new TicketInnerClass(t,i++,new GN_User__c(),ItemQuantity,BLNItem,RegSettingsMap,QuestionsMap,SelectedCountry));
                      }else{
                          TicketList.add(new TicketInnerClass(t,0,new GN_User__c(),ItemQuantity,BLNItem,RegSettingsMap,QuestionsMap,SelectedCountry));
                      }
                   }
               }
           }
        }
        
      settingsForbuyer = new List<Reg_Setting__c>(); 
      groupNames = new SET<string>(); 
      GNUserforbuyer = new user();
      GNbuyerCompany = new Company__c();
      GNbuyerCompanyDetails= new Company_Ext__c();
      GNUserextforbuyer = new user_Ext__c ();
      BillingAddressForbuyer = new Pay_Address__c();
         
      SET<string>   regstable = new SET<string>(); 
      SET<string>   regscolumn = new SET<string>();
    // Written By Phani, This is for summarise the settings for buyer    
        for(Reg_Setting__c regBuyer :RegistrationSettingsForBuyer){
         Reg_Setting__c regSet = new Reg_Setting__c();
          if(regstable.contains(regBuyer.Table_Name__c) && regscolumn.contains(regBuyer.Column_Name__c)){
            
          }else{
               system.debug('XXXXXXXXXXXXXXXX '+regBuyer);
                regSet.Included__c = regBuyer.Included__c;
                regSet.Required__c = regBuyer.Required__c;
                regSet.Label_Name__c= regBuyer.Label_Name__c; 
                 regSet.Group_Name__c = regBuyer.Group_Name__c;
                 regSet.Table_Name__c = regBuyer.Table_Name__c;
                 regSet.Column_Name__c =regBuyer.Column_Name__c;
                 regstable.add(regSet.Table_Name__c); regscolumn.add(regSet.Column_Name__c);
          }
           
           if(regSet.Included__c!=false || regSet.Required__c!=false){ 
           
               groupNames.add(regBuyer.Group_Name__c);
                settingsForbuyer.add(regSet);
            }
        }
        
        //Fetching Event Level Survey Questions
        UserEventAnswer = new LIST<UserAnswerInnerClass>();
        LIST<SelectOption> Answers;
        
        system.debug('Event Level Questions'+EventQuestions);
        system.debug('UUUUUUUUUUU '+TicketList);
        
        for(Question__c q: EventQuestions){
            Boolean isRequired;
            Answers = new LIST<SelectOption>();
            if(q.Answer_Type__c=='Choose from a list' || q.Answer_Type__c=='Multiple choice' || q.Answer_Type__c=='Checkboxes' || q.Answer_Type__c=='Scale'){
                for(Answer__c a: q.Answers__r){
                    Answers.add(new SelectOption(a.id,a.Answer_Text__c));
                }
            }
            for(Item_Question__c iq: q.Item_Question__r){
                if(iq.isRequired__c == TRUE){
                    isRequired = TRUE;
                }
            }
            UserEventAnswer.add(new UserAnswerInnerClass(q,q.Answers__r,Answers,isRequired));        
        }
    }

//----------------------------------------------------------------------------------- Order Now Method End -------------------------------------------------------------------------------------- 


// ----------------------------------------------------------------------------------- Ticket Inner Class Start -------------------------------------------------------------------------------- 
// This Inner Class is used for Showing Input forms based on item selection

    public class TicketInnerClass{
    
        public Integer OrderNo{get;set;}
        public Ticket__c Ticket{get;set;}
        public GN_User__c EachUser{get;set;}
        public User_Ext__c EachUserExt{get;set;}
        public Company__c EachCompany{get;set;}
        public Company_ext__c EachCompanyExt{get;set;}
        public Pay_Address__c BillingAddress{get;set;}
        public Integer selectedQuantity{get;set;}
        public BLN_Item__c BLNItem{get;set;}
        public MAP<Id,LIST<Reg_Setting__c>> RegSettingMap{get;set;} // MAP containing Registration Settings i.e. Key as Item Id and Values are List of Registration Settings
        public MAP<Id,LIST<Question__c>> QuestionMap{get;set;} // MAP containing Survey Questions i.e. Key as Item Id and Values are List of Questions
        public LIST<UserAnswerInnerClass> UserAnswer{get;set;} // Inner Class Instance for Item Survey Questions & Answers

        public TicketInnerClass(Ticket__c Tkt, Integer ONo, GN_User__c U,Integer sQuantity,BLN_Item__c Item,MAP<Id,LIST<Reg_Setting__c>> RSMap,MAP<Id,LIST<Question__c>> QMap,String selectedCountry){
            Ticket = Tkt;
            OrderNo = ONo;
            EachUser = new GN_User__c();
            EachUserExt = new User_Ext__c();
            EachUserExt.Country__c = selectedCountry;
            EachCompany = new Company__c();
            EachCompanyExt = new Company_ext__c();
            EachCompanyExt.BLN_Business_Country__c = selectedCountry;
            BillingAddress = new Pay_Address__c();
            BillingAddress.BLN_Country__c = selectedCountry;
            selectedQuantity = sQuantity;
            BLNItem = Item;
            RegSettingMap = RSMap;
            QuestionMap = QMap;
            UserAnswer = new LIST<UserAnswerInnerClass>();
            LIST<SelectOption> AnswerOptions;
            for(Question__c q: QuestionMap.get(BLNItem.Id)){
                Boolean isRequired;
                AnswerOptions = new LIST<SelectOption>();
                if(q.Answer_Type__c=='Choose from a list' || q.Answer_Type__c=='Multiple choice' || q.Answer_Type__c=='Checkboxes' || q.Answer_Type__c=='Scale'){
                    for(Answer__c a: q.Answers__r){
                        AnswerOptions.add(new SelectOption(a.id,a.Answer_Text__c));
                    }
                }
                for(Item_Question__c iq: q.Item_Question__r){
                    if(iq.Item__r.Id == BLNItem.Id && iq.isRequired__c == TRUE){
                        isRequired = TRUE;
                    }
                }
                UserAnswer.add(new UserAnswerInnerClass(q,q.Answers__r,AnswerOptions,isRequired));        
            }

            Ticket = Tkt;
            OrderNo = ONo;
            EachUser = U;
            EachUserExt = new User_Ext__c();
            EachUserExt.Country__c = selectedCountry;
            EachCompany = new Company__c();
            EachCompanyExt = new Company_ext__c();
            EachCompanyExt.BLN_Business_Country__c = selectedCountry;
            BillingAddress = new Pay_Address__c();
            BillingAddress.BLN_Country__c = selectedCountry;
            selectedQuantity = sQuantity;
            BLNItem = Item;
            RegSettingMap = RSMap;
            QuestionMap = QMap;
            UserAnswer = new LIST<UserAnswerInnerClass>();
            LIST<SelectOption> AnswerOptions1;
            
            for(Question__c q: QuestionMap.get(BLNItem.Id)){
                Boolean isRequired;
                AnswerOptions1 = new LIST<SelectOption>();
                if(q.Answer_Type__c=='Choose from a list' || q.Answer_Type__c=='Multiple choice' || q.Answer_Type__c=='Checkboxes' || q.Answer_Type__c=='Scale'){
                    for(Answer__c a: q.Answers__r){
                        AnswerOptions1.add(new SelectOption(a.id,a.Answer_Text__c));
                    }
                }
                for(Item_Question__c iq: q.Item_Question__r){
                    if(iq.Item__r.Id == BLNItem.Id && iq.isRequired__c == TRUE){
                        isRequired = TRUE;
                    }
                }
                UserAnswer.add(new UserAnswerInnerClass(q,q.Answers__r,AnswerOptions1,isRequired));        
            }

        }
    }
// ----------------------------------------------------------------------------------- Ticket Inner Class End ---------------------------------------------------------------------------------- 

// ----------------------------------------------------------------------------------- Survey Questions Inner Class Start ----------------------------------------------------------------------
//This inner class is for showing survey questions along with tickets

public class UserAnswerInnerClass{
    public Question__c Question{get;set;}
    public LIST<Answer__c> ItemAnswer{get;set;}
    public LIST<SelectOption> Answers{get;set;}
    public Boolean isRequired{get;set;}
    public String SelectedAnswer{get;set;}
    String[] SelectedAnswerCheck = new String[]{};
    public String[] getSelectedAnswerCheck() {
        return SelectedAnswerCheck;
    }
    public void setSelectedAnswerCheck(String[] SelectedAnswerCheck) {
        this.SelectedAnswerCheck = SelectedAnswerCheck;
    }
    
    public UserAnswerInnerClass(Question__c Ques,LIST<Answer__c> IAnswer,LIST<SelectOption> Ans,Boolean RequiredBool){
        Question = Ques; 
        ItemAnswer = IAnswer; 
        Answers = Ans;  
        isRequired = RequiredBool;  
    }
}
// ----------------------------------------------------------------------------------- Survey Questions Inner Class End ----------------------------------------------------------------------

public string encodedCipherText{get;set;}
public string eventidAfterEncoding{get;set;}
//------------------------------------------------------------------------------- Validating Payment Method Start -------------------------------------------------------------------------------
    public pagereference validatePayment(){
         system.debug('ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ   ');
        ChargeId ='';
        pagereference pg;

        Decimal TotalAmountDue;
        if(registrationEvent.Accept_Tax_Rate__c == TRUE && registrationEvent.Tax_Rate__c != NULL){
            TotalAmountDue = TotalAmountwithTaxes;
        }
        else{
            TotalAmountDue = TotalAmount;
        }
        
        
        if(TotalAmount <= 0){
             pg = completeRegistration();
            return pg;
        }
        
        
        // Stripe Payment
        if(SelectedPaymentGateway == 'CreditCard' && StripeRefreshToken != NULL){
            system.debug('Stripe'+CreditCardNumber);
             if(string.isBlank(CreditCardNumber)){
                 PaymentErrorString='Please Enter Credit Card Number';
                 return null;
             }else if(!string.isBlank(CreditCardNumber) && ! CreditCardNumber.isNumeric()){
                 PaymentErrorString='Please Enter Numbers only';
                 return null;
             }else if(CreditCardNumber.length() != 16 && SelectedCardType != 'American Express'){
                 PaymentErrorString='Please Enter 16 digit Number';
                 return null;
             }
             else if(CreditCardNumber.length() != 15 && SelectedCardType == 'American Express'){
                 PaymentErrorString='Please Enter 15 digit Number';
                 return null;
             }
             else if(integer.valueof(selectedyear) == system.today().year() && integer.valueof(selectedMonth) < system.today().month()){
                 PaymentErrorString='Please Select Valid Expiry Date';
                 return null;
             }else if(string.isBlank(CVVNumber)){
                 PaymentErrorString='Please Enter CVV Number';
                 return null;
             }else if(!string.isBlank(CVVNumber) && ! CVVNumber.isNumeric()){
                 PaymentErrorString='Please Enter Numbers only';
                 return null;
             }else if((CVVNumber != NULL || CVVNumber != '') && CVVNumber.length() < 3 && SelectedCardType != 'American Express'){
                 PaymentErrorString='Please Enter 3 Digit Number';
                 return null; 
             }
             else if((CVVNumber != NULL || CVVNumber != '') && CVVNumber.length() != 4 && SelectedCardType == 'American Express'){
                 PaymentErrorString='Please Enter 4 Digit Number';
                 return null; 
             }
             else{
                 BLN_Payments_BAL PaymentsBAL = new BLN_Payments_BAL();
                 
                 String ResponseMessage = PaymentsBAL.stripePayments(registrationEvent.Id,CreditCardNumber,selectedMonth,selectedyear,CVVNumber,TotalAmountDue-FeeAmount,FeeAmount,False);
                 system.debug('Stripe Response 1:'+ResponseMessage);
                 if(ResponseMessage!='Error'){
                    system.debug('Stripe Response 2:'+ResponseMessage);
                    showPaymentError= FALSE;
                    ChargeId = ResponseMessage;
                    pg = completeRegistration();
                 }
                 else{
                    ShowPaymentError= TRUE;
                    PaymentErrorString=ResponseMessage;
                    return null;
                 }      
             } 

         } 
         
         // Authorize .Net Payment
         if(SelectedPaymentGateway == 'CreditCard' && ANLoginId != NULL && ANTransactionKey != NULL){
            system.debug('Authorize .Net'+CreditCardNumber);
            AuthorizeDotNet ath = new AuthorizeDotNet(true,ANLoginId,ANTransactionKey);
            ath.transaction(CreditCardNumber, selectedMonth+selectedyear, String.valueOf(TotalAmountDue), CVVNumber,'','');  
            ath.setParameter('x_device_type','1');  
            ath.setParameter('x_first_name',OrderFirstName);  
            ath.setParameter('x_last_name',OrderLastName);  
            ath.setParameter('x_address',PayAddress.Street1_Address__c);  
            ath.setParameter('x_state',PayAddress.BLN_State__c);  
            ath.setParameter('x_response_format','1');  
            ath.setParameter('x_zip',PayAddress.Zip__c);
            try{
                ath.process(3);
            }catch(Exception ex){

            }
            
            if(ath.isApproved()){
                String responsetext = ath.getResponseText();
                String transactionid = ath.getTransactionID();
                showPaymentError= FALSE;
                ChargeId = transactionid;
                pg = completeRegistration();
            }
            else if(ath.isDeclined()){
                ShowPaymentError = TRUE;
                PaymentErrorString = ath.getResponseText();
                return null; 
            }
            else{
                ShowPaymentError = TRUE;
                PaymentErrorString = ath.getResponseText();
                return null; 
            }
         }
         // Check Payment
         else if(SelectedPaymentGateway == 'Check'){ 

                 system.debug('Check Number: '+CheckNumber);
                 if(string.isBlank(CheckNumber)){
                     ShowPaymentError=TRUE;
                     PaymentErrorString='Please Enter Check Number'; 
                     return null;
                 }else if(!string.isBlank(CheckNumber) && ! CheckNumber.isNumeric()){
                     ShowPaymentError=TRUE;
                     PaymentErrorString='Please Enter Numbers Only';    
                     return null;
                 }else if(CheckNumber.length() < 4 || CheckNumber.length() > 10){
                     ShowPaymentError=TRUE;
                     PaymentErrorString='Please Enter Valid Number';    
                     return null;
                 }else{
                     ShowPaymentError=FALSE;
                     SelectedCardType = 'Check';
                     ChargeId = CheckNumber;
                     pg= completeRegistration();
                 }

         }
         else if(SelectedPaymentGateway == 'Cash'){
            ShowPaymentError=FALSE;
            SelectedCardType = 'Cash';
            pg = completeRegistration();
            return pg;
         }
         // PayPal Payment
         else if(SelectedPaymentGateway == 'PayPal'){
        
            CommonParametersObjName='MyRequestParams';
            APICredentialObjName ='SandboxCert';
            
            ActionType='PAY';
            
            FundingTypeEcheck = false;
            FundingTypeBalance = false;
            FundingTypeCreditCard = false;
            PPPayRequest request;
            try{
                // create request envelope and set the common request parameters
                
                request = new PPPayRequest(CommonParametersObjName, SenderEmail);   
                
                // set actionType
                request.ActionType = ActionType;  
            }catch(exception ed){
                request = new PPPayRequest();
            }
            
            // Set success and cancel urls
         //   Savepoint sp = Database.setSavepoint();
           //   completeRegistration();   
           
            String host = ApexPages.currentPage().getHeaders().get('Host');
             blob eveuyE = Blob.valueOf(registrationEvent.Id);
             eventidAfterEncoding = EncodingUtil.base64Encode(eveuyE );
              
            
            
            
            request.CancelUrl = 'http://' + host + '/apex/BLN_Registration?MainMessage=cancel&id='+registrationEvent.Id;
            request.ReturnUrl = 'http://' + host + '/apex/BLN_Success?id='+eventidAfterEncoding ;
            
            // Set a note associated with the payment        
            request.Memo = RegistrationEvent.Name;  
            // set receiver info in the request
            List<PPReceiver> receiverList = new List<PPReceiver>();
            
            try{

                PPReceiver rv = new PPReceiver();
                
                rv.Email =PayeeEmail;
                
                if(PaymentType!='Simple'){
                    rv.Amount = TotalAmountDue;
                    rv.primary = TRUE;
                }else{
                    rv.Amount = TotalAmountDue;
                }

                ActionType ='PAY';
                receiverList.add(rv); 
                
                if(PaymentType!='Simple'){
                    PPReceiver rv1 = new PPReceiver();
                    rv1.Email = BoothLeadsEmail;
                    ActionType ='PAY'; 
                    rv1.Amount = FeeAmount;
                    receiverList.add(rv1);
                }
            
            }catch(exception e){}
            
            
            request.receiverList = receiverList;
            // set FeesPayer
            request.FeesPayer = FeesPayer;
            if (FundingTypeEcheck) {
                PPFundingTypeInfo info = new PPFundingTypeInfo();
                info.FundingType = 'ECHECK';
                request.FundingTypeList.add(info);
            }
            if (FundingTypeBalance) {
                PPFundingTypeInfo info = new PPFundingTypeInfo();
                info.FundingType = 'BALANCE';
                request.FundingTypeList.add(info);
            }
            
            if (FundingTypeCreditCard) {
                PPFundingTypeInfo info = new PPFundingTypeInfo();
                info.FundingType = 'CREDITCARD';
                request.FundingTypeList.add(info);
            }
            
            IsDisplay = false;
            
            // create the Adaptive Toolkit object instance w/ API Credentials
            
            PPAdaptiveToolkit toolkit;
            if(istestmethod){
                toolkit = new PPAdaptiveToolkit(APICredentialObjName);
            }
            
            try {
                System.Debug(Logginglevel.INFO, '==>Request' + request);
                
                
                if(istestmethod){
                    PayResponse = toolkit.Pay(request);
                }else{
                
                }
                
                System.debug(PayResponse);          
                IsDisplay = true;
                RespEnvp = PayResponse.ResponseEnvelope;

                
                if(PayResponse.PaymentExecStatus.equalsIgnoreCase('Created')){
                
                    ApiUserName= toolkit.BaseAPIProfile.APIUsername;
                    Apipassword =toolkit.BaseAPIProfile.APIPassword;
                    Apisignature =toolkit.BaseAPIProfile.APISignature;
                    ApiapplicationId = toolkit.BaseAPIProfile.ApplicationID;
                    Apiipaddress =request.ClientDetails.IpAddress;
                    paypalUrl= toolkit.BaseAPIProfile.getPayPalLoginPage(); 

                    try{
                        setPaymentOptions(PayResponse.payKey);
                    }catch(exception ex){
                    
                    }
                    ChargeId = PayResponse.payKey;
                    ShowPaymentError = FALSE;
                    SelectedCardType = 'PayPal';
                    completeRegistration();  
                        
                     if(encodedCipherText   !='' && encodedCipherText != null){   
                       Cookie orderIdvalue= ApexPages.currentPage().getCookies().get('OrderId');
                       if (orderIdvalue == null) {
                            orderIdvalue = new Cookie('OrderId',encodedCipherText,null,-1,false);
                        }
                        
                       ApexPages.currentPage().setCookies(new Cookie[]{orderIdvalue });  
                     }               
                        
                         
                      
                      
                      
                    pg = new pageReference(toolkit.BaseAPIProfile.getPayPalLoginPage()+'_ap-payment&paykey='+PayResponse.payKey);
                    return pg;

                }
                else if(PayResponse.PaymentExecStatus.equalsIgnoreCase('Completed')){
                    SuccessMessage = 'Payment Completed - payKey - ' + PayResponse.payKey; 
                }
                else{
                    IsDisplay = true;
                    RespEnvp = PayResponse.getResponseEnvelope();
                    MainMessage = 'Payment Execution Status returned from server is - ' + PayResponse.PaymentExecStatus;
                }
            
            }
            catch(PPFaultMessageException ex) {
           // Database.rollback( sp );
                System.debug('PPFaultMessageException =>' + ex);
                IsDisplay = true;
                
                RespEnvp = ex.ResponseEnvelope;
                List<PPErrorData> errList = ex.ErrorList;
                for(PPErrorData err: errList ){
                    MainMessage += err.ErrorId + ' : ' + err.Message ;
                }
            
            }
            catch(System.Exception e){
                System.debug('System.Exception =>' + e);
                MainMessage = e.getMessage();
            } 

         }
         return pg;
    }
//-------------------------------------------------------------------------------- Validating Payment Method End ---------------------------------------------------------------------------------

// --------------------------------------------------------------------------- For Setting PayPal Company Name Method Start ----------------------------------------------------------------------
public void setPaymentOptions(string payval){
    try{
        Http h = new Http();
        HttpRequest req = new HttpRequest();   

        string NameofCompany  = RegistrationEvent.Name;


        if(string.isNotEmpty(NameofCompany)){ 
            NameofCompany = NameofCompany.ReplaceAll(' ','+');
        }

        req.setHeader('X-PAYPAL-SECURITY-USERID',ApiUserName);
        req.setHeader('X-PAYPAL-SECURITY-PASSWORD',Apipassword );      
        req.setHeader('X-PAYPAL-SECURITY-SIGNATURE',Apisignature );      
        req.setHeader('X-PAYPAL-DEVICE-IPADDRESS',Apiipaddress);
        req.setHeader('X-PAYPAL-REQUEST-DATA-FORMAT','NV');
        req.setHeader('X-PAYPAL-RESPONSE-DATA-FORMAT','NV');
        req.setHeader('X-PAYPAL-APPLICATION-ID',ApiapplicationId );
        string sandboxvalue='';
        if(paypalUrl.contains('sandbox')){
            sandboxvalue='sandbox.';
        }

        string endpoint = 'https://svcs.'+sandboxvalue+'paypal.com/AdaptivePayments/SetPaymentOptions?method=SetPaymentOptions&requestEnvelope.errorLanguage=en_US&payKey='+payval+'&displayOptions.businessName='+NameofCompany;

        req.setEndpoint(endpoint);
        req.setMethod('GET'); 
        if(istestmethod){
            HTTPResponse res = h.send(req);
            system.debug('Name on PayPal Login '+ res.getBody());
        }
    }catch(exception ex){

    }        
}

// --------------------------------------------------------------------------- For Setting PayPal Company Name Method End ----------------------------------------------------------------------

public void toalDiscountAfterallApp(){
 //selectedTicketIds 
 eventadminChangedAmount =0.00;
  BLN_Quick_Registration_BAL QuickRegBAL1 = new BLN_Quick_Registration_BAL();  
 for(BLN_Item__c blntc : QuickRegBAL1.getEventItems(registrationEvent.id)){
   if(mapTicWithQuan.keySET().contains(blntc.id)){
     eventadminChangedAmount += mapTicWithQuan.get(blntc.id)*(blntc.price__c);
    }
 }
 eventadminChangedAmount=eventadminChangedAmount+FeeAmount;
 system.debug('PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP '+eventadminChangedAmount);
 
}


//------------------------------------------------------------------------------ Complete Registration Method Start ----------------------------------------------------------------------------- 
// This method is fired when complete registration button is clicked
 
     public PageReference completeRegistration(){
        system.debug('Tickets Info: '+TicketList);
        LIST<String> UserIds = new LIST<String>();
        LIST<String> CompanyIds = new LIST<String>();
        LIST<String> TicketIds = new LIST<String>();

     
        BLN_Quick_Registration_BAL RegistrationBAL = new BLN_Quick_Registration_BAL();
        BLN_User_DAO UserDAO = new BLN_User_DAO();
        system.debug('Event Level Answers:'+UserEventAnswer);
        system.debug('Buyer Information '+OrderFirstName+OrderLastName+OrderEmail);
        boolean isCompanyProvide =false;
        
        
        
         // --------------------------------------------------------------------- For Inserting Buyer Information ---------------------------------------------------------
        //Inserting Order User
        BLN_StatusMessage OrderUserMsg = new BLN_StatusMessage();
        String OrderUserId;
        
        GN_User__c GNUser = new GN_User__c();
        Company__c GNCompany = new Company__c ();
        Company_Ext__c GNCompanyDetails = new Company_Ext__c();

        if(LoggedinUser != NULL){
            GNUser.First_Name__c = LoggedinUser.FirstName;
            GNUser.Last_Name__c = LoggedinUser.LastName;
            GNUser.Email__c = LoggedinUser.Email;
       
            if(LoggedinUser.CompanyName !=null && LoggedinUser.CompanyName !=''){
                GNCompany.Name = LoggedinUser.CompanyName;
                GNCompany.isPersonAccount__c = FALSE;
                GNUser.Company_name__c = LoggedinUser.CompanyName;
            }else{
             GNCompany.Name = LoggedinUser.FirstName + LoggedinUser.LastName;
                GNCompany.isPersonAccount__c = TRUE;
                GNUser.Company_name__c = LoggedinUser.FirstName + LoggedinUser.LastName;
            }  
        }
        else{
             GNUser.First_Name__c = GNUserforbuyer.firstName;
             GNUser.Last_Name__c = GNUserforbuyer.lastName;
             GNUser.Email__c = GNUserforbuyer.email;
            if(GNUserforbuyer.companyName!='' && GNUserforbuyer.companyName!=null){
                GNUser.Company_name__c =GNUserforbuyer.companyName;
                GNCompany.Name = GNUserforbuyer.CompanyName;
                isCompanyProvide =true;
           }
        }
         string uid;

        //OrderUserMsg = RegistrationBAL.insertGNUser(GNUser);
             if(RegistrationBAL.checkUserEmail(GNUser.Email__c)!=null){
               // OrderUserId = [select id,email__c,First_Name__c,Last_Name__c from GN_User__c where user__c =:RegistrationBAL.checkUserEmail(GNUser.Email__c) limit 1].id;
                   for(GN_User__c gnup : [select id,First_Name__c,Last_Name__c,Email__c,Company_Name__c from GN_User__c where user__c =:RegistrationBAL.checkUserEmail(GNUser.Email__c) limit 1]){
                         OrderUserId = gnup.id;
                          if(GNUserextforbuyer.Address1__c!=null){
                             gnup.Address1__c = GNUserextforbuyer.Address1__c;
                            }
                            if(GNUserextforbuyer.Address2__c!=null){ 
                             gnup.Address2__c =  GNUserextforbuyer.Address2__c;
                            } 
                            if(GNUserextforbuyer.City__c!=null){
                             gnup.City__c = GNUserextforbuyer.City__c;
                            }
                            if(GNUserextforbuyer.State__c!=null){
                             gnup.State__c =GNUserextforbuyer.State__c;
                            }
                            if(GNUserextforbuyer.Country__c!=null){
                                gnup.Country__c  = GNUserextforbuyer.Country__c;
                            } 
                             if(GNUserextforbuyer.Zip_Code__c!=null){ 
                              gnup.Zip_Code__c = GNUserextforbuyer.Zip_Code__c;
                             }   
                       dataBase.update(gnup,false);
                      }      
             
               }else{
                          if(GNUserextforbuyer.Address1__c!=null){
                             GNUser.Address1__c = GNUserextforbuyer.Address1__c;
                            }
                            if(GNUserextforbuyer.Address2__c!=null){ 
                             GNUser.Address2__c =  GNUserextforbuyer.Address2__c;
                            } 
                            if(GNUserextforbuyer.City__c!=null){
                             GNUser.City__c = GNUserextforbuyer.City__c;
                            }
                            if(GNUserextforbuyer.State__c!=null){
                             GNUser.State__c =GNUserextforbuyer.State__c;
                            }
                            if(GNUserextforbuyer.Country__c!=null){
                                GNUser.Country__c  = GNUserextforbuyer.Country__c;
                            } 
                             if(GNUserextforbuyer.Zip_Code__c!=null){ 
                              GNUser.Zip_Code__c = GNUserextforbuyer.Zip_Code__c;
                             }   
                
                 OrderUserMsg = RegistrationBAL.insertGNUser(GNUser);
              if(OrderUserMsg.successBool){
                 OrderUserId = OrderUserMsg.successId; 
              try{
                 uid = [select id,User__c from GN_User__c where id =:OrderUserId limit 1].User__c ;
              }catch(exception er){} 
          }
             
       }
         
          
       /* // inserting user extension
        LIST<User_Ext__c> userExtsList= new LIST<User_Ext__c>();
        userExtsList= [SELECT ID, User__c, Address1__c, Address2__c, City__c, State__r.Long_Name__c, Country__r.Long_Name__c, Zip_Code__c FROM  User_Ext__c WHERE User__c =:uid];
        if(userExtsList.size()>0){
        
        }else{
            GNUserextforbuyer.User__c = uid; 
           database.saveresult dsve =   database.insert(GNUserextforbuyer,false);
           system.debug('YYYYYYYYYYYYYYYYYYYYYY '+dsve );
        }
         
     */   
     
       // If company Name is null this part will not work    
        if(GNbuyerCompany.Website_URL__c!=null ){
           GNCompany.Website_URL__c =GNbuyerCompany.Website_URL__c;
        } 
        if(GNbuyerCompany.Description__c!=null){
            GNCompany.Description__c=GNbuyerCompany.Description__c;
        }
            
            
         BLN_StatusMessage OrderCompanyMsg = new BLN_StatusMessage ();
         BLN_StatusMessage  OrderUCRoleMsg = new BLN_StatusMessage ();  
         String OrderCompanyId =''; 
         BLN_StatusMessage PayAddressMessage = new BLN_StatusMessage ();
            
     //if(GNUserforbuyer.companyName!=null && GNUserforbuyer.companyName!=''){          
        //Inserting Company for OrderUser  
        
       if(GNUserforbuyer.companyName!=null && GNUserforbuyer.companyName!=''){ 
            OrderCompanyId =  checkCompany(GNCompany.Name,GNUserforbuyer.email);
           if(OrderCompanyId != null && OrderCompanyId !='' ){      
            OrderUCRoleMsg = RegistrationBAL.insertUCRole(OrderUserId,OrderCompanyId,registrationEvent.Id,'Guest Attendee');   
           }   
       }else{
          OrderCompanyId = checkPersonalAccount(GNUserforbuyer.email);
          if(OrderCompanyId != null && OrderCompanyId !=''){
              OrderUCRoleMsg = RegistrationBAL.insertUCRole(OrderUserId,OrderCompanyId,registrationEvent.Id,'Company Admin');
          }
       }
       
       
       if(OrderCompanyId != null && OrderCompanyId !=''){
           
        }else{
            GNCompany.Name = GNUserforbuyer.CompanyName;
            if(!isCompanyProvide){
                GNCompany.isPersonAccount__c = TRUE;
            }
            OrderCompanyMsg = RegistrationBAL.insertCompany(GNCompany,GNbuyerCompanyDetails);
              if(OrderCompanyMsg.successBool){
                OrderCompanyId = OrderCompanyMsg.successId;
            }
             OrderUCRoleMsg = RegistrationBAL.insertUCRole(OrderUserId,OrderCompanyId,registrationEvent.Id,'Company Admin');
             // account type need to put
        }
        
     /*   //Inserting UCRole by mapping User, Company and Event
        BLN_StatusMessage OrderUCRoleMsg = RegistrationBAL.insertUCRole(OrderUserId,OrderCompanyId,registrationEvent.Id,'Company Admin');
        String OrderUCRoleId;
        if(OrderUCRoleMsg.successBool){
            OrderUCRoleId= OrderUCRoleMsg.successId;
        }
    */
         //Insert Pay Address
        BLN_Pay_Address_DAO PayAddressDAO = new BLN_Pay_Address_DAO();
        PayAddress.Event__c = registrationEvent.Id;
        PayAddress.Company__c = OrderCompanyId;
        PayAddress.GN_User__c = OrderUserId;
        PayAddressMessage = PayAddressDAO.insertPayAddress(PayAddress);
        
     // }  
        
        // --------------------------------------------------------------------- For Inserting Buyer Information End---------------------------------------------------------
        SET<Ticket__c> tickesListForupdate = new SET<Ticket__c>();
        SEt<id> setOftcids = new SEt<id>();


        //-------------- Inserting User, Company, UCRole and Update Tickets ------------------------------
        for(TicketInnerClass tic: TicketList){
            system.debug('Ticket Id: ' + tic.Ticket.id + 'Item Id: '+tic.Ticket.Item__r.id);
            system.debug('User Details: ' + tic.EachUser);
            system.debug('Survey Answer: '+ tic.UserAnswer); 

            String UserId;
            BLN_StatusMessage userMsg;  
            String CompanyId='';
            BLN_StatusMessage CompanyMsg;
            String ucRoleId;
            BLN_StatusMessage UCRoleMsg; 
            BLN_SurveyQuestions_BAL SQBal = new BLN_SurveyQuestions_BAL();
            
            //Applying Registration Settings                           
            if((tic.Ticket.Item__r.Ticket_Settings__c != 'Collect info from All Attendees' && tic.Ticket.Item_Type__r.name != 'Package') || (tic.Ticket.Item_Pool__r.Ticket_Settings__c != 'Collect info from All Attendees' && tic.Ticket.Item_Type__r.name == 'Package')){
                
                GN_User__c BuyerUser = new GN_User__c();
                Company__c BuyerCompany = new Company__c ();
                Company_Ext__c BuyerCompanyDetails = new Company_Ext__c();
                
                //Fetching Buyer Information  
                if(LoggedinUser != NULL){
                    BuyerUser.First_Name__c = LoggedinUser.FirstName;
                    BuyerUser.Last_Name__c = LoggedinUser.LastName;
                    BuyerUser.Email__c = LoggedinUser.Email;
               
                    if(LoggedinUser.CompanyName !=null && LoggedinUser.CompanyName !=''){
                        BuyerCompany.Name = LoggedinUser.CompanyName;
                        BuyerCompany.isPersonAccount__c = FALSE;
                        BuyerUser.Company_name__c = LoggedinUser.CompanyName;
                    }else{
                        BuyerCompany.Name = LoggedinUser.FirstName + LoggedinUser.LastName;
                        BuyerCompany.isPersonAccount__c = TRUE;
                        BuyerUser.Company_name__c = LoggedinUser.FirstName + LoggedinUser.LastName;
                    }  
                }
                else{
                  system.debug('Ticket loop iterate times    '+tic);
                    if(tic.selectedQuantity >= 1){
                    
                      for(Ticket__c t: RegistrationBAL.getTicketDetail(tic.BLNItem,tic.selectedQuantity)){
                           if(tic.EachUser.First_Name__c!=null && tic.EachUser.First_Name__c!=''){
                            t.First_Name__c =  GNUserforbuyer.firstName;
                           } 
                           if(tic.EachUser.Last_Name__c!=null && tic.EachUser.Last_Name__c!=''){
                            t.Last_Name__c =  GNUserforbuyer.lastName;
                            }
                            if(tic.EachUser.Email__c !=null && tic.EachUser.Email__c !=''){
                            t.Email__c =  GNUserforbuyer.email;
                            }
                            
                            if(isCompanyProvide){
                              t.Company__c = GNUserforbuyer.companyname;
                            }
                            t.Ticket_Status__c='Booked';
                              system.debug('========>STATUS:'+t.id);  
                               UserIds.add(OrderUserId);// Updating User Ids
                              if(OrderCompanyId!=''){
                               CompanyIds.add(OrderCompanyId); // Updating Company Ids
                              }
                               TicketIds.add(t.id); // Updating Ticket Ids
                               if(!setOftcids.contains(t.id)){
                                 tickesListForupdate.add(t); 
                                 setOftcids.add(t.id);
                              } 
                         }
                 
                     } 
                 }   
            }
            else{
            
                // ---------------------------- Adding values to Ticket ------------------------------------- 
                tic.Ticket.First_Name__c = tic.EachUser.First_Name__c;
                tic.Ticket.Last_Name__c = tic.EachUser.Last_Name__c;
                tic.Ticket.Email__c = tic.EachUser.email__c;
                tic.Ticket.Company__c = tic.EachUser.Company_Name__c;
                Company__c  comforEchuser  = new Company__c ();
                
                
                
                if(tic.EachUserExt.Address1__c!=null){
                 tic.EachUser.Address1__c = tic.EachUserExt.Address1__c;
                }
                if(tic.EachUserExt.Address2__c!=null){ 
                 tic.EachUser.Address2__c =  tic.EachUserExt.Address2__c;
                } 
                if(tic.EachUserExt.City__c!=null){
                 tic.EachUser.City__c = tic.EachUserExt.City__c;
                }
                if(tic.EachUserExt.State__c!=null){
                 tic.EachUser.State__c =tic.EachUserExt.State__c;
                }
                if(tic.EachUserExt.Country__c!=null){
                    tic.EachUser.Country__c  = tic.EachUserExt.Country__c;
                } 
                 if(tic.EachUserExt.Zip_Code__c!=null){ 
                   tic.EachUser.Zip_Code__c = tic.EachUserExt.Zip_Code__c;
                 }   
                // Address1__c, Address2__c, City__c, State__r.Long_Name__c, Country__r.Long_Name__c, Zip_Code__c 
                
                //Assigning Inner Class Company to Company Object Instance
                if(tic.EachUser.Company_Name__c !=null && tic.EachUser.Company_Name__c !=''){
                  comforEchuser.Name = tic.EachUser.Company_Name__c ;
                  comforEchuser.isPersonAccount__c = FALSE;
                }  
               // Assigning Inner Class User to User Object Instance
                IndUser = tic.EachUser;
               //Inserting User
               // userMsg = RegistrationBAL.insertGNUser(IndUser);
                 if(tic.EachUser.email__c!=GNUserforbuyer.email ){
                   if(RegistrationBAL.checkUserEmail(tic.EachUser.email__c)!=null){
                       // UserId =[select id from GN_User__c where user__c =:RegistrationBAL.checkUserEmail(GNUser.Email__c) limit 1].id;
                       for(GN_User__c gnup : [select id,First_Name__c,Last_Name__c,Email__c,Company_Name__c from GN_User__c where user__c =:RegistrationBAL.checkUserEmail(GNUser.Email__c) limit 1]){
                         UserId = gnup.id;
                         if(tic.EachUserExt.Address1__c!=null){
                             gnup.Address1__c = tic.EachUserExt.Address1__c;
                            }
                            if(tic.EachUserExt.Address2__c!=null){ 
                             gnup.Address2__c =  tic.EachUserExt.Address2__c;
                            } 
                            if(tic.EachUserExt.City__c!=null){
                             gnup.City__c = tic.EachUserExt.City__c;
                            }
                            if(tic.EachUserExt.State__c!=null){
                             gnup.State__c =tic.EachUserExt.State__c;
                            }
                            if(tic.EachUserExt.Country__c!=null){
                                gnup.Country__c  = tic.EachUserExt.Country__c;
                            } 
                             if(tic.EachUserExt.Zip_Code__c!=null){ 
                              gnup.Zip_Code__c = tic.EachUserExt.Zip_Code__c;
                             }   
                       dataBase.update(gnup,false);
                      }
                 
                   }else{
                       userMsg = RegistrationBAL.insertGNUser(tic.EachUser);
                      if(userMsg.successBool){
                         UserId = userMsg.successId; 
                     }  
                 }
              }else{
                 UserId =OrderUserId ;
              } 
                
                
            system.debug('WWWWWWWWWWWWWW '+tic.EachUser.Company_Name__c); 
                
           if(tic.EachUser.Company_Name__c!='' && tic.EachUser.Company_Name__c!=null){
              // If attendee chooses buyer company 
              //Inserting Company for User  
                 CompanyId = checkCompany(tic.EachUser.Company_Name__c,tic.EachUser.Email__c);
                 if(CompanyId != null && CompanyId != ''){
                     //Inserting UCRole by mapping User, Company and Event
                    UCRoleMsg = RegistrationBAL.insertUCRolewithUtype(UserId,CompanyId,registrationEvent.Id,'Company Admin','Business');

                        }else{
                             
                            CompanyMsg = RegistrationBAL.insertCompany(comforEchuser,tic.EachCompanyExt);
                             if(CompanyMsg.successBool){
                                CompanyId = CompanyMsg.successId;
                             }
                         
                              system.debug('PPPPPPPPPPPP '+CompanyId +'QQQQQQQQQQQQ  '+CompanyMsg);
                            if(CompanyId !=null && CompanyId !=''){
                               //Inserting UCRole by mapping User, Company and Event
                               UCRoleMsg = RegistrationBAL.insertUCRolewithUtype(UserId,CompanyId,registrationEvent.Id,'Company Admin','Business');
                              }
                           }
                        
                       }else{
                          if(gnuser.Company_Name__c!=null && gnuser.Company_Name__c!=''){
                              CompanyId = checkCompany(gnuser.Company_Name__c,gnuser.Email__c);
                              UCRoleMsg = RegistrationBAL.insertUCRolewithUtype(UserId,CompanyId,registrationEvent.Id,'Guest Attendee','Business');
                          }else{
                             CompanyId = checkPersonalAccount(tic.EachUser.email__c);    
                             if(CompanyId!=''){
                                  UCRoleMsg = RegistrationBAL.insertUCRolewithUtype(UserId,CompanyId,registrationEvent.Id,'Company Admin','Personal');                              
                             }else{
                                comforEchuser.name = tic.EachUser.First_Name__c+tic.EachUser.Last_Name__c;
                                //CompanyMsg = RegistrationBAL.insertCompany(comforEchuser,companydetails);
                                CompanyMsg = RegistrationBAL.insertCompany(comforEchuser,tic.EachCompanyExt);
                                CompanyId = CompanyMsg.successId;
                                 system.debug('@@@@@@@ '+UserId+'  @############ '+CompanyId+'   %%%%%%%%%% '+registrationEvent.Id);
                                if( CompanyId  != '' ){
                                  system.debug('@@@@@@@ '+UserId+'  @############ '+CompanyId+'   %%%%%%%%%% '+registrationEvent.Id);
                                   UCRoleMsg = RegistrationBAL.insertUCRolewithUtype(UserId,CompanyId,registrationEvent.Id,'Company Admin','Personal');
                               } 
                             }                                      
                           }
                        }    
                    if(UCRoleMsg.successBool){
                        ucRoleId = UCRoleMsg.successId;
                        system.debug('Inserted UC Role Id: '+ucRoleId);
                    }
                
                // Inserting Survey Questions  
                for(UserAnswerInnerClass UAnswer : tic.UserAnswer){
                    Id ItemQuestionId = SQBal.getItemQuestion(tic.BLNItem.Id,UAnswer.Question.id);
                    if(UAnswer.Question.Answer_Type__c=='Checkboxes'){
                         for(String s: UAnswer.SelectedAnswerCheck){
                           BLN_StatusMessage UAMsg = SQBal.insertUserAnswer(UserId,s,ItemQuestionId );    
                         }    
                    }else{
                      BLN_StatusMessage UAMsg = SQBal.insertUserAnswer(UserId,UAnswer.SelectedAnswer,ItemQuestionId );        
                    }
                }

                UserIds.add(UserId);// Updating User Ids
                if(CompanyId!=''){
                  CompanyIds.add(CompanyId); // Updating Company Ids
                } 
                TicketIds.add(tic.Ticket.id); // Updating Ticket Ids  
                  if(!setOftcids.contains(tic.Ticket.id)){
                    tickesListForupdate.add(tic.Ticket);
                  setOftcids.add(tic.Ticket.id);
                } 
            }    
        }
        

       
        // Sending Update Request for multiple tickets
        system.debug('User Ids are :'+UserIds+ ' Company Ids are :'+CompanyIds+' Ticket Ids are :'+TicketIds+'Total Amount: '+TotalAmount+'Order User Id'+OrderUserId);
        BLN_StatusMessage Response;

        Decimal TotalAmountDue;
        if(userInfo.getUserName()==registrationEvent.owner.userName){
           toalDiscountAfterallApp();
           DiscountedAmount = eventadminChangedAmount-TotalAmount;
           system.debug('@@@@@@@@@@@@@@@@ '+DiscountedAmount);
       }
        
        if(registrationEvent.Accept_Tax_Rate__c == TRUE && registrationEvent.Tax_Rate__c != NULL){
            TotalAmountDue = TotalAmountwithTaxes;
        }
        else{
            TotalAmountDue = TotalAmount;
        }
         system.debug('EWWWWWWWWWWWWWWWWWWWWWWWWWWW '+TicketIds.size());
        if(promocode != NULL || promocode!=''){
          Response = RegistrationBAL.updateTickets(UserIds,CompanyIds,TicketIds,registrationEvent.Id,OrderUserId,TotalAmountDue + DiscountedAmount,DiscountedAmount,FeeAmount,TaxAmount,TotalAmountDue,PromotionIdMap,PromotionCount,promocode,PayAddressMessage.SuccessId,SelectedCardType,SelectedPaymentGateway,ChargeId,PayGatewayMode);
        }
        else{
          Response = RegistrationBAL.updateTickets(UserIds,CompanyIds,TicketIds,registrationEvent.Id,OrderUserId,TotalAmountDue + DiscountedAmount,DiscountedAmount,FeeAmount,TaxAmount,TotalAmountDue,PromotionIdMap,PromotionCount,'',PayAddressMessage.SuccessId,SelectedCardType,SelectedPaymentGateway,ChargeId,PayGatewayMode);
        }
        
        List<ticket__c> tlistUpdate = new List<Ticket__c>();
        for(ticket__c tr :tickesListForupdate){
           system.debug('QQQQQQQQQQQQQ QQQQQQQ'+tr);
           tr.Ticket_Status__c='Booked';
        }
        tlistUpdate.addAll(tickesListForupdate);
        dataBase.update(tlistUpdate,false); 
        List<ticket__c> tlist = new List<Ticket__c>();
        
        tlist.addAll(RegistrationBAL.ticketsForupdatePkg);
         for(Ticket__c tic :tlist ){
            tic.First_Name__c  =GNUserforbuyer.firstName;
            tic.Last_Name__c  =GNUserforbuyer.lastName;
            tic.Email__c =GNUserforbuyer.email;
           if(!isCompanyProvide){   
            tic.company__c=GNUserforbuyer.companyName;
           }
         }  
        dataBase.update(tlist,false);   
            
            
            
        system.debug('11111111111111111111 '+RegistrationBAL.orderId);
        if(CommnetsByEventadmin !=''){
           BLN_Order_DAO ord = new BLN_Order_DAO();
           List<order__c> ordL = new List<order__c>();
            for(order__c od:ord.orderQuery(' Where id=\''+RegistrationBAL.orderId+'\'')){
               od.EVent_Admin_Comments__c =CommnetsByEventadmin ;
               ordL.add(od);
            }
           dataBase.saveresult[] svr = database.update(ordL ,false);
          system.debug('2222222222222222222 '+svr ); 
        }    


        if(Response.successBool == TRUE){ 
            system.debug('Success Response : '+Response);
            PageReference pg;
            
            if(LoggedInUser != NULL){
                EmailAddress = EmailAddress.trim();
                Password = Password.trim();
                pg = Site.login(EmailAddress,Password,'/apex/BLN_MyTickets');   
            }
            else{
               Blob key = Blob.valueOf(RegistrationBAL.orderId);
               encodedCipherText = EncodingUtil.base64Encode(key);
               blob eveuy = Blob.valueOf(registrationEvent.Id);
                string sty = EncodingUtil.base64Encode(eveuy );
                
               pg = new PageReference('/apex/BLN_Success?id='+sty +'&OrdId='+encodedCipherText );
            }
            return pg;   
        }else{
            system.debug('Error Response : '+Response);  
        }
        return null;
    }
//------------------------------------------------------------------------------- Complete Registration Method End ------------------------------------------------------------------------------


// ---------------------------------------------------------------------------------- Login User Method Start ----------------------------------------------------------------------------------- 
    public void login(){

        // Getting User Details from User DAO
        BLN_User_DAO UserDAO = new BLN_User_DAO();
        LoggedInUser = new User();
        LoggedInUser = UserDAO.checkLoggedInUser(EmailAddress,Password);
        
        if(LoggedInUser != NULL){

            HideLogin = TRUE;
            TicketList= new LIST<TicketInnerClass>();
            ShowSecondPage = TRUE;
            integer i = 1;
            BLN_Quick_Registration_BAL QuickRegBAL = new BLN_Quick_Registration_BAL();
            Integer ItemQuantity;
            for(ItemInnerClass iic: ItemList){
               if(iic.selectedItemQuantity != null){
                   if(Integer.valueOf(iic.selectedItemQuantity) >=1){
                       BLN_Item__c BLNItem = new BLN_Item__c();
                       BLNItem = iic.items;
                       if(iic.items.Ticket_Settings__c == 'Collect info from Buyers only'){
                           RegTickets = QuickRegBAL.getTicketDetail(iic.items, 1);
                           ItemQuantity = Integer.valueOf(iic.selectedItemQuantity);
                       }
                       else if(iic.items.Ticket_Settings__c == 'Collect info from All Attendees'){
                           RegTickets = QuickRegBAL.getTicketDetail(iic.items, Integer.valueOf(iic.selectedItemQuantity));    
                           ItemQuantity = 1;
                       }
                       
                       for(Ticket__c t: RegTickets){
                          LoggedInGNUser = new GN_User__c();
                          LoggedInGNUser.First_Name__c = LoggedInUser.FirstName;
                          LoggedInGNUser.Last_Name__c = LoggedInUser.LastName;
                          LoggedInGNUser.Email__c = LoggedInUser.Email;
                          LoggedInGNUser.Phone__c = LoggedInUser.Phone;
                          LoggedInGNUser.Company_Name__c = LoggedInUser.CompanyName;
                          TicketList.add(new TicketInnerClass(t,i++,LoggedInGNUser,ItemQuantity,BLNItem,RegSettingsMap,QuestionsMap,SelectedCountry));
                       }
                   }
               }
            }
            system.debug('Ticket List: '+TicketList);
        }
    }
// ------------------------------------------------------------------------------------ Login User Method End -------------------------------------------------------------------------------------- 


// ------------------------------------------------------------------------------------ Logout User Method Start ----------------------------------------------------------------------------------- 
    public void logout(){
        TicketList = new LIST<TicketInnerClass>();
        LoggedInGNUser = new GN_User__c();
        LoggedInUser = new User();
        HideLogin = FALSE;
        EmailAddress='';
        orderNow();

    }
// ------------------------------------------------------------------------------------ Logout User Method End ------------------------------------------------------------------------------------- 

// ------------------------------------------------------------------------------------ Fetch NAICS Codes Method Start ----------------------------------------------------------------------------
    public void fetchNAICSCodes(){
        NaicsList = new LIST<SelectOption> ();
        NaicsListOfList = new LIST<LIST<SelectOption>> ();
        listOfnaicscodes= new LIST<LIST<NAICS_Code__c>>();
        naicscodeslist = new List<NAICS_Code__c>();
        for(NAICS_Code__c naics : [SELECT id,Name FROM NAICS_Code__c]){
            naicscodeslist.add(naics); 
            if(naicscodeslist.size() == 999){
                listOfnaicscodes.add(naicscodeslist);
                naicscodeslist= new LIST<NAICS_Code__c>();
            }
        }
        if(naicscodeslist.size() != 0){
            listOfnaicscodes.add(naicscodeslist);
        } 
        for(LIST<NAICS_Code__c> na : listOfnaicscodes){
            for(NAICS_Code__c na1 : na){
                NaicsList.add(new selectoption(na1.Name , na1.Name));
                if(NaicsList.size() == 999){
                    NaicsListOfList.add(NaicsList);
                    NaicsList  = new LIST<selectoption> ();
                }
            }
        }
        if(NaicsList.size() != 0){
            NaicsListOfList.add(NaicsList);
        }
    }
// ------------------------------------------------------------------------------------ Fetch NAICS Codes Method End ------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------- States & Countries Start ----------------------------------------------------------------------------------    
    public void countryStates(){ 
        country = new LIST<Country__c>();
        countryOptions= new LIST<SelectOption>();
        
        for(Country__c c: [SELECT ID, NAME, Short_Name__c, Long_Name__c, Order__c FROM Country__c ORDER BY Order__c]){
            countryOptions.add(new SelectOption(c.id, c.Long_Name__c));
            if(c.Short_Name__c == 'US'){
                selectedCountry = c.id;
            }
        }
        stateOptions = new LIST<SelectOption> ();   
    }

    public void statesBasedOnCountry(){
        system.debug('Selected Country '+selectedCountry);
        stateOptions= new LIST<SelectOption> ();   
    
        for(State__c s: [SELECT ID, NAME, Short_Name__c,Long_Name__c, Country__c, Order__c FROM State__c WHERE Country__c =: selectedCountry]){
            stateOptions.add(new SelectOption(s.id,s.Long_Name__c));
        }
    }
// --------------------------------------------------------------------------------------- States & Countries End ----------------------------------------------------------------------------------
    
    
// ----------------------------------------------------------------------------------------- Registration Settings Start ---------------------------------------------------------------------------
    public void fetchSettings(){
        LIST<Id> Itemslist = new LIST<Id>();
        ItemsSet = new SET<Id>();
        
        for(ItemInnerClass iic: ItemList){  
            if(iic.selectedItemQuantity != null){     
                if(Integer.valueOf(iic.selectedItemQuantity) >=1){  
                    Itemslist.add(iic.items.id);
                    if(iic.items.Item_Type__r.name == 'Package'){
                        Itemslist.add(iic.items.Item_Pool__c);
                    }
                }
            }
        }
        ItemsSet.addAll(Itemslist);
        
        // Getting Registration Settings
        BLN_RegistrationSettings_BAL RegSettingsBAL = new BLN_RegistrationSettings_BAL();
        RegSettingsMap = RegSettingsBAL.getTicketSettings(ItemsSet,RegistrationEvent.id);
        for(Id ItemReg: Itemslist){
            LIST<Reg_Setting__c> RSList = RegSettingsMap.get(ItemReg);
        }
        
        // Getting Survey Questions
        BLN_SurveyQuestions_BAL SurveyBAL = new BLN_SurveyQuestions_BAL();
        
        // Getting Item Level Survey Questions
        QuestionsMap = SurveyBAL.getItemQuestions(ItemsSet,RegistrationEvent.id);
        
        // Getting Event Level Survey Questions
        EventQuestions = SurveyBAL.getEventQuestions(RegistrationEvent.id);
    }
// ----------------------------------------------------------------------------------------- Registration Settings End ----------------------------------------------------------------------------   

 // Get Company Names
  @RemoteAction
    public static List<Company__c> getCompanies(string searchstr,string emailid){
     SET<id> comids = new SEt<id>();
       for(UC_Role__c uc : [select id,Company__r.name,Company__c,name from UC_Role__c where GN_User__r.email__c =:emailid]){
            comids.add(uc.Company__c);
            system.debug('WWWWWWWWWWW '+uc.Company__c);
       }
      string v =  searchstr   + '%';  
      return [select id,name,isPersonAccount__c from Company__c where id In :comids and name like :v ] ;
   }
   
    public string checkCompany(string cname,string uEmail){
              LIST<UC_Role__c> UCRoleList = [SELECT id,Company__c,Company__r.id FROM UC_Role__c WHERE GN_User__r.Email__c =:uEmail and Company__r.Name=:cname and RoleId__r.Name='Company Name'];
              system.debug('PPPPPPPPPPPPPp '+UCRoleList +'PPPPPPPPPPPP '+cname+'PPPPPPPPPPP '+uEmail );
              if(UCRoleList.size()>0){
                return UCRoleList[0].Company__r.id;
              }else{
                 return '';
              }
        
            }
      public string checkPersonalAccount(string uEmail){
            LIST<UC_Role__c> UCRoleList = [SELECT id,Company__c,Company__r.id FROM UC_Role__c WHERE GN_User__r.Email__c =:uEmail and User_Type__c='Personal'];
            if(UCRoleList.size()>0){
                return UCRoleList[0].Company__r.id;
              }else{
                 return '';
              }
          }      
    
   }