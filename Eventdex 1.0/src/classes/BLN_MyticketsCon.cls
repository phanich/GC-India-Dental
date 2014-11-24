/***********************************************************************************************
*   Controller Name : BLN_MyticketsCon
*   Date            : 05/19/2014
*   Author          : Phani Kumar Ch
*   Purpose         : This class is for show and edit tickets
*   Change History  : 05/19/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*  05/19/2014          Phani Kumar ch                   To Create Page
*   06/30/2014          Phani Kumar ch                  Allowing Duplicates in GN user Table
**************************************************************************************************/

public without sharing class BLN_MyticketsCon {

    public BLN_UtillDisplayLinks  myticket { get; set; }
    
    public boolean displyAddGuest{get;set;}
    public Boolean ShowCurrentTickets{get; set;} 
    public boolean displayTicForCancel{get;set;}
    public boolean isOrderEdit{get;set;} 
    public boolean orddetailbool{get;set;}
    
    public string selectedEvent{get;set;}
    public string loginUserId{get;set;}
    public string companyName {get;set;}
    public integer rowNum{get;set;}
    public string selectedOrder {get;set;}
    public  string isAttendeesPAge{get;set;}
    public List<Ticket__c> currentEventTickets{get;set;}
    public List<BLN_Mytickets_BAL.inncls> inncurrentTickets {get;set;} 
    public List<BLN_Mytickets_BAL.Bondbetweenchkandobj> innLineItems {get;set;}
    public List<Order_Item__c> ordIt{get;set;}
    public set<Id> displayandhideIdes {get;set;} // to display orderdetails again
    public  SET<id>  orid{get;set;}
    public List<BLN_Mytickets_BAL.inncls>  exportOrders{get;set;}
    public List<BLN_Mytickets_BAL.inncls>  ValuesOfseletedorder{get;set;}
    
    public BLN_Debug blndebug {get;set;}
    public BLN_Mytickets_BAL blnMyticketsBal {get;set;}
    public BLN_Mytickets_BAL.inncls editOrdRec{get;set;}   
    public Ticket__c addGuest{get;set;}  
    public BLN_Event__c   se{get;set;}
    public MAP<id,ticket__c> mapticWithId {get;set;}
    public MAP<id,order_item__c> mapitemWithId {get;set;}
    public MAP<id,BLN_Mytickets_BAL.inncls> mapOrdIsWithInner{get;set;}
    public MAP<id,GN_User__c> mapguIdWithGNU {get;set;}
    public string urlCheck {get;set;}
    public string RecordsForExport;
  
  
    public void displayPermissions(){
        Cookie k = ApexPages.currentPage().getCookies().get('counter');
        if(k!=null){ 
            selectedEvent = k.getValue();
        }
        myticket = new BLN_UtillDisplayLinks();
        
        BLN_PromoCode_BAL blneventdetailbal = New BLN_PromoCode_BAL();
        se = new BLN_Event__c();
        try{
            se = blneventdetailbal.eventdetails(selectedEvent );
             myticket.EventName=se.Name;
         }catch(exception e){}
        myticket.isTicketsPageExpand='expand';
        myticket.isOrdersPage='active';
        myticket.tablabel='Orders';
        myticket.EventId = selectedEvent ;
        myticket.userPermissions(userInfo.getUserId(),selectedEvent);
        
    }
  
   public String getRecordsForExport() {
        return RecordsForExport;
    }
                        
    public void setRecordsForExport(String s) {
        this.RecordsForExport = s;
    }
  
  
    // This is constructor for this class in this i am getting event
    public BLN_MyticketsCon(){
        isOrderEdit = false; displayandhideIdes = new SET<id>();
        ShowCurrentTickets = true;
        displayTicForCancel = false;
        blnMyticketsBal = new BLN_Mytickets_BAL();
        loginUserId = userInfo.getUserId();  // To know login user Id
        //loginUserId = '005c00000013uMx';
        blndebug = new BLN_Debug();
        urlCheck =  ApexPages.currentPage().getUrl();
        if(urlCheck !=''){  // checking url for knowing about currentpage
            if((urlCheck.toLowerCase()).contains('BLN_Mytickets'.toLowerCase())){
                urlCheck ='BLN_Mytickets';
            }else{
                urlCheck ='BLN_Orders';
            }
        }
        
        
        Cookie k = ApexPages.currentPage().getCookies().get('counter');
        if(k!=null){ 
            selectedEvent = k.getValue();
        }
        
        try{
        
            if(selectedEvent ==null){
                selectedEvent ='All'; 
            }
        }catch(exception er){
            selectedEvent ='All'; // default selected event
        }
        
        // selectedEvent  = Apexpages.CurrentPage().GetParameters().get('id');
        
        
        try{  
            onchangeEvent(); // Calling this method for getting all the order,tickets and orderitems of events
        }catch(exception es){}
    }
 
 

 // this method is getting all the order,orderItem and tickets of user respect to event.
 // This controller is same for BLN_MyTickets and BLN_orders so i am checking the page in this method.
 // according to that page we will get order and all
 
 public List<List<BLN_Mytickets_BAL.inncls>> listOfListOrders{get;set;}
 
 
 
      public void onchangeEvent(){
        mapticWithId  = new MAP<id,ticket__c>(); 
        mapitemWithId = new MAP<id,order_item__c>();
        mapguIdWithGNU = new MAP<id,GN_User__c>();
        inncurrentTickets= new List<BLN_Mytickets_BAL.inncls>();
        List<Ticket__c> ticketsList = new List<Ticket__c>();
        BLN_Gnuser_DAO guDAO = new BLN_Gnuser_DAO();
       listOfListOrders = new List<List<BLN_Mytickets_BAL.inncls>>();
       
        mapOrdIsWithInner = new MAP<id,BLN_Mytickets_BAL.inncls>();
     
          SET<id> GnuserList = new  SET<id>();
        //Getting all tickets and orders of perticular user
        
        system.debug('PPPPPPPPPPPPPPPPP ');
        integer k =0;
       
        for(BLN_Mytickets_BAL.inncls innTotal : blnMyticketsBal.userTickets(loginUserId,selectedEvent,urlCheck )){
            mapOrdIsWithInner.put(innTotal.orderInn.id,innTotal);
            GnuserList.add(innTotal.orderInn.Client_GN_User__c); 
              if(displayandhideIdes.size()>0){ 
               if(displayandhideIdes.contains(innTotal.orderInn.id)){
                   innTotal.displayOrderItems =true;
               }  
             }  
            
          k++;
            inncurrentTickets.add(innTotal);
            if(k==1000){
              listOfListOrders.add(inncurrentTickets);
              inncurrentTickets= new List<BLN_Mytickets_BAL.inncls>();
              k=0;
            }
           
            
            ticketsList.addAll(innTotal.ticketsInn);
             for(order_item__c orditem : innTotal.orderItemInn){
                 mapitemWithId.put(orditem.id,orditem ); // map orderItem with its id
              }
        } 
        
       listOfListOrders.add(inncurrentTickets);
               
         for(Ticket__c tc :ticketsList){
           mapticWithId.put(tc.id,tc); // Map tickets with its id  
           GnuserList.add(tc.Client_GN_User__c);
         } 
         
         for(GN_User__c gnu : guDAO.getGnuserList(GnuserList)){
            mapguIdWithGNU.put(gnu.id,gnu); 
         }
       system.debug('EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE '+listOfListOrders);
     }
 
    //  This method is to diplay selected order details popup in Mytickets Page
    public PageReference renderDetails() {
        rowNum= Integer.valueOf(apexpages.currentpage().getparameters().get('guestindex'));
        if(inncurrentTickets[rowNum].displayOrderItems ==true){
            inncurrentTickets[rowNum].displayOrderItems =false;
            displayandhideIdes.remove(inncurrentTickets[rowNum].orderInn.id);
        }else{
            inncurrentTickets[rowNum].displayOrderItems=true;
            selectedOrder =inncurrentTickets[rowNum].orderInn.id;
            displayandhideIdes.add(inncurrentTickets[rowNum].orderInn.id);
        }
        try{
        
        } catch(exception re){}
        
        return null;
    }
 
 
   // -------------------------------------------  Actions on orders page  ----------------------------------- --> 
 
    // Open edit popup with selected record values
    public void displayorderEditform(){
        editOrdRec =new  BLN_Mytickets_BAL.inncls();
        gnUser  = new GN_User__c();
        
        string editableOrder = Apexpages.currentPage().getParameters().get('edform');
        try{
            editOrdRec = mapOrdIsWithInner.get(editableOrder);
            gnUser = mapguIdWithGNU.get(editOrdRec.orderInn.Client_GN_User__c);
        }catch(exception ex){}
        companyName = editOrdRec.orderInn.Client_Company__r.Name;
        isOrderEdit = true;
    }
     
    // saving user info after editing record
    public PageReference Saveord() {
        user newu = new user();
        newu.firstName = gnUser.First_Name__c;
        newu.lastName = gnUser.Last_Name__c ;
        newu.Email = gnUser.Email__c;
        newu.userName = gnUser.Email__c;
        
        if(companyName !=null){
            newu.companyName = companyName ;
        }else{
            newu.companyName = gnUser.First_Name__c+''+gnUser.Last_Name__c;
        }
        saveLogic(newu,new Ticket__c(),editOrdRec.orderInn,gnUser);// In this method user Insertion,company insertion and user role will be done
        isOrderEdit = false; // close order edit popup
        onchangeEvent();
        return null;
    }
 
    // This is method is for closing edit popup of both tickets and orders
    public PageReference CloseGuests() {
        displyAddGuest = false; //close add guest popup
        if(isOrderEdit){
            isOrderEdit =false; // close order edit popup
        }
        return null;
    } 
    
    
    // cancel total order 
    public PageReference cancelTotalorder() {
        BLN_Mytickets_BAL bal = new BLN_Mytickets_BAL();
        orid = new SET<id>();
        orid.add(Apexpages.currentPage().getPArameters().get('guestindex12'));
        
        
        for(order__c od : bal.getOrdersOrdItems(orid)){
            SET<id>  oridItemsuniq = new SET<id>();
            for(Order_Item__c orditem: od.Order_Items__r){
                bal.cancelOrderItemValues(bal.orderItemWithlineItem(orditem.id));
            } 
        }
          
      /*     
           for(order__c odw : bal.getOrderstickets(orid)){
           List<Ticket__c> ty = new List<Ticket__c>();
            ty.addAll(odw.Tickets__r);
            bal.cancelTickets(ty); // canceling the tickets
            bal.cloneTickets(ty); // Cloning tickets for release tickets
         }    
       */  
        bal.uypdateOrderStatus(orid); // updating order Status
        onchangeEvent(); // To refresh the grid
        return null;
    }
 
   
    // Exporting All pages orders
    public pageReference exportOrders(){
       // RecordsForExport='All';
        //exportOrders = new List<BLN_Mytickets_BAL.inncls>();
       // exportOrders.addAll(inncurrentTickets);
        pageReference pg = page.BLN_ExportordersAll;
        return pg;
    }
    
    // export only Selected orders
    public pageReference  userSelectPerticularToExport(){
        exportOrders = new List<BLN_Mytickets_BAL.inncls>();
        for(BLN_Mytickets_BAL.inncls od :inncurrentTickets){
            if(od.selectCheckBox){
                exportOrders.add(od);
            }
        }
        pageReference pg = page.BLN_Exportorders;
        return pg; 
    } 
    
  
   
   
    
    // Display order details pop up in orders page
    // This will fire when we click on order name
    public void renderDetailsfororder() {
        ValuesOfseletedorder = new List<BLN_Mytickets_BAL.inncls>();
        string selectedOrd = apexpages.currentpage().getparameters().get('selectedordId');
        try{
          ValuesOfseletedorder.add(mapOrdIsWithInner.get(selectedOrd ));
        }catch(exception e){}
        orddetailbool = true;
    }
    
    // Closing order detail popup
    public void cancelOrdDetail(){
        orddetailbool = false;
    }
 
  // -------------------------------------------  Actions on orders page  End -----------------------------------  
 
  
 // ----------------------------------------- Actions on order details popup --------------------------------------   
  public GN_User__c gnUser{get;set;}
   
    // disply edit guest  pop up
    public PageReference editTicket(){
    gnUser = new GN_User__c();
      addGuest = new Ticket__c ();
      addGuest=  mapticWithId.get(Apexpages.currentPage().getParameters().get('TicketIdparam'));
      gnUser = mapguIdWithGNU.get(addGuest.Client_GN_User__c);
      companyName = addGuest.Client_company__r.Name;    
      displyAddGuest= true;
      return null;
    }
   
    // saving guest info after editing record
    public PageReference SaveGuests() {
       user newu = new user();
        newu.firstName = gnUser.First_Name__c;
        newu.lastName = gnUser.Last_Name__c ;
        newu.Email = gnUser.Email__c;
        newu.userName = gnUser.Email__c;
            if(companyName !=null){
               newu.companyName = companyName ;
            }else{
              newu.companyName = gnUser.First_Name__c+''+gnUser.Last_Name__c;
            }
       
        system.debug(newu+'    YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY '+addGuest);
         saveLogic(newu,addGuest,new order__c(),gnUser); // In this method user Insertion,company insertion and user role will be done
          
         if(isAttendeesPAge!='Attendee'){
          onchangeEvent();
           ValuesOfseletedorder= new List<BLN_Mytickets_BAL.inncls>();
          ValuesOfseletedorder.add(mapOrdIsWithInner.get(selectedOrder)); 
        } 
       displyAddGuest= false; // closing pop up
       return null;
    }


   // This function is for canceling tikcets in the order item level   
    public PageReference cancelDirectTicket() {
        BLN_Mytickets_BAL bal = new BLN_Mytickets_BAL();
        orid = new SET<id>();
        string orderIdTogetBack ='';
        List<Order_Item__c> ordIt = bal.orderItemWithlineItem(ApexPages.currentPage().getParameters().get('canordItemId'));
        bal.cancelOrderItemValues(ordIt);
      id orderIdforRefreshpop=ordIt[0].order__c;
        if(ordIt.size()>0 ){
        orderIdTogetBack =ordIt[0].order__r.id;
        orid.add(ordIt[0].order__c);
          
           bal.uypdateOrderStatus(orid);
        }
        onchangeEvent();
     
         ValuesOfseletedorder= new List<BLN_Mytickets_BAL.inncls>();
         ValuesOfseletedorder.add(mapOrdIsWithInner.get(orderIdforRefreshpop));
        return null;
    }
 
    
    
   // This function is for canceling tikcet  
     public PageReference  cancelPerticularGuestsTic(){
        List<ticket__c> tickets = new List<ticket__c> ();
        BLN_Mytickets_BAL bal = new BLN_Mytickets_BAL();
        innLineItems = new List<BLN_Mytickets_BAL.Bondbetweenchkandobj>();
        orid = new SET<id>();
        Order_Item__c ordItin = new Order_Item__c();
         string tid = ApexPages.currentPage().getParameters().get('canticId');
         system.debug('XXXXXXXXXXXXXXXQQQQQQQQQQQQ '+tid );
         Ticket__c tc = new ticket__c();
         tc = mapticWithId.get(tid);
         tickets.add(tc);
         id orderIdforRefreshpop= tc.order__c;
         orid.add(tc.order__c);
         ordItin = mapitemWithId.get(tc.order_item__c);
         bal.chengeItemOrderCount(ordItin ,tickets); // decresing amount and quantity of order Item
         bal.cancelTickets(tickets); // cancel selected Tickets
         bal.cloneTickets(tickets); // create new tickets
         bal.uypdateOrderStatus(orid);
         
        if(isAttendeesPAge!='Attendee'){
         onchangeEvent();
         ValuesOfseletedorder= new List<BLN_Mytickets_BAL.inncls>();
         ValuesOfseletedorder.add(mapOrdIsWithInner.get(orderIdforRefreshpop));
        }
      return null;
   } 
    
    // hide cancel popup
    public void closeCan(){
     displayTicForCancel = false;
    }
    
    
 // ----------------------------------------------- popup actions End --------------------------------------------
  
  // This is utill for order edit and ticket edit
  // inserting user,company and uc role and update ticket or update order 
     public void saveLogic(user newu,Ticket__c addGuest,order__c saveord,GN_User__c gnUserEdit){
      
       BLN_Quick_Registration_BAL quickbal= new BLN_Quick_Registration_BAL();
       String userid=quickbal.checkUser(newu); // Checking user already exists
       string compId ;
       BLN_StatusMessage userMsg;
           if(userid==null){ // if not exists calling insert user method
              userMsg=quickbal.insertUser(newu); // inserting user
              if(userMsg.successBool){
                  userid=userMsg.successId;
              }
           }
          gnUserEdit.User__c = userid; 
           DataBase.update(gnUserEdit,false);
           
           
       if(userid!=null){
         company__c comp = new company__c();
         comp.Name = companyName;      
         compId  = quickbal.checkCompany(comp); // checking company existed or not
           if(compId!=null){
           
           }else{
               BLN_StatusMessage CompanyMsg=quickbal.insertCompany(comp ,null); // insert company
                if(CompanyMsg.Successbool){
                   compId = CompanyMsg.successId;
                }
              } 
        } 
        BLN_Mytickets_BAL mybal = new BLN_Mytickets_BAL(); 
        string EventIdvalue  = '';
          if(isOrderEdit){
             EventIdvalue = saveord.events__c;
           }else{
              EventIdvalue = addGuest.event__c;
            }
        if(compId !=null && userId !=null && EventIdvalue!=null){
        BLN_UCRole_DAO ucRoleDao = new BLN_UCRole_DAO();
         // BLN_StatusMessage UCRoleMsg = quickbal.insertUCRole(userId,compId ,EventIdvalue ,'Company Admin'); // insert user company Role
           string UCRoleMsg = ucRoleDao.updateUCRole1(gnUserEdit.id,compId);
         
           if(UCRoleMsg=='Success'){
              if(isOrderEdit){
                BLN_StatusMessage uptcktmsg = mybal.updateorder(userid,compId,saveord); // updating order 
               }else{
                 BLN_StatusMessage uptcktmsg=mybal.updateTickets(userid,compId,addGuest); // updating ticket
                 System.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX '+uptcktmsg);
             }
          }
        } 
    }
}