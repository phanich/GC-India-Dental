/***********************************************************************************************
*   Controller Name : BLN_TicketSalesReportCon
*   Date            : 10/30/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the Ticket Sales Report
*   Change History  : 10/28/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*  10/30/2014            Manasa Gandham                  To Create Page
*  
**************************************************************************************************/

public with sharing class BLN_TicketSalesReportCon { 

    public BLN_TicketSalesReportCon(){
        EventDates= new BLN_Event__c();
        Cookie k = ApexPages.currentPage().getCookies().get('counter');
        if(k!=null){ 
            selectedEvent= k.getValue();
            ticketSalesReport(); 
            
        }  
        //selectedEvent ='a0sc0000002rKZD';
        //ticketSalesReport(); 
    }
     
    public BLN_Event__c EventDates{get; set;}
    public String selectedEvent {get; set;}
    public BLN_TicketSalesReportCon_BAL balToGetTickets{get; set;}
    public LIST<BLN_TicketSalesReportCon_BAL.ticketsInner> TicketsInnerList{get; set;}
    public String SearchString{get; set;}
    public void ticketSalesReport(){
        
        balToGetTickets= new BLN_TicketSalesReportCon_BAL();
        TicketsInnerList= new LIST<BLN_TicketSalesReportCon_BAL.ticketsInner>();
        TicketsInnerList= balToGetTickets.ticketsSalesForEvent(selectedEvent, EventDates.Start_Date__c, EventDates.End_Date__c, SearchString);
        
        system.debug(TicketsInnerList.size()+'  LIST OF TICKETS '+TicketsInnerList);
    }
    
     // Exporting PromoCodes
    public pageReference exportTicketSales(){
       
        pageReference pg = page.BLN_ExportTicketSales;
        return pg;
    }
    
    public PageReference printTicketSales() {
        pageReference pg = page.BLN_PrintTicketSales;
        return pg;
    }


    
    public LIST<BLN_PromoCodeReportCon_BAL.promoCodeInner> promoCodeInnerList{get; set;}
    
    
    public BLN_UtillDisplayLinks   myticket { get; set; }
    

    public boolean isEventAdmin{get;set;}
    public boolean isBoothadmin{get;set;}
  
    public PageReference hideEventsTab() {
      Cookie k = ApexPages.currentPage().getCookies().get('counter');
     if(k!=null){ 
      selectedEvent = k.getValue();
       }
   
     BLN_PromoCode_BAL blneventdetailbal = New BLN_PromoCode_BAL();
     BLN_Event__c  se = new BLN_Event__c  ();
      try{
    se = blneventdetailbal.eventdetails(selectedEvent );
     }catch(exception e){}
      
     myticket = new BLN_UtillDisplayLinks();


    myticket.isReportsPageExpand='expand';
    myticket.isTicketReportPage='active';
    myticket.tablabel='Ticket Sales report';
    myticket.EventId = selectedEvent ;
    
   try{
     myticket.eventName=se.NAme;
    }catch(exception e){}
     myticket.userPermissions(userInfo.getUserId(),selectedEvent);
     
        return null;
    }
    
    }