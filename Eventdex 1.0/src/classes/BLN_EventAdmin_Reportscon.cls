public with sharing class BLN_EventAdmin_Reportscon {

   

/***********************************************************************************************
*   Controller Name : BLN_EventAdmin_Reportscon
*   Date            : 05/20/2014
*   Author          : Unni Krishna
*   Purpose         : This class is for all the Reports
*   Change History  : 05/21/2014 
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*   05/20/2014             Unni Krishna                  To Create Page/class & Report By Geography
*   08/05/2014             Unni krishna                  Export Functionality              
**************************************************************************************************/
    //<!------------------Variables Declaration------------------->
    Public LIST<Ticket__c> tick{get;set;}
    public LIST<Ticket__c> rep1{get;set;}
    public LIST<Ticket__c> exportgeo{get;set;}
    public string eventselected{get;set;}
    
    //<!----------- Constructor-------------->
    public BLN_EventAdmin_Reportscon() {
        geography();
       
    }
    
    //<!------Report By Attendee DemoGraphics Method---->
    Public void geography()
    {
        eventselected = ApexPages.CurrentPage().getParameters().get('id');       
        BLN_Reports_BAL BLNReports = new BLN_Reports_BAL();
        tick=BLNReports.getReports(eventselected,'client_GN_User__r.CreatedDate');
    }
    
    //<!--- Export Method Starts------------>
    public pagereference exportgeography()
    {
     eventselected = ApexPages.CurrentPage().getParameters().get('id');
     BLN_Reports_BAL BLNReports = new BLN_Reports_BAL();
     exportgeo=BLNReports.getReports(eventselected,'client_GN_User__r.CreatedDate');
     
         for(Ticket__c t:exportgeo)
         {
        // rep1.add(t);
         }
      pagereference pg =page.BLN_ExportReport;
      return pg;
     
    }
    
    public pagereference printgeography()
    {
     eventselected = ApexPages.CurrentPage().getParameters().get('id');
     BLN_Reports_BAL BLNReports = new BLN_Reports_BAL();
     exportgeo=BLNReports.getReports(eventselected,'client_GN_User__r.CreatedDate');
      
      for(Ticket__c t:exportgeo)
         {
        // rep1.add(t);
         }
    pagereference pg =page.BLN_PrintReport;
      return pg;
    }
}