public without sharing class BLN_ticketReportcon {


/***********************************************************************************************
*   Controller Name : BLN_ticketReportcon
*   Date            : 08/06/2014
*   Author          : Unni Krishna
*   Purpose         : This class is for showing what tickets were booked by the Attendees for an event
*   Change History  : 08/06/2014 
*       Date                 Programmer                     Reason
*   --------------      -------------------              -------------------------
*   08/06/2014             Unni Krishna                  To Create Page/class & Report By Ticket Types
             
**************************************************************************************************/


//Variables Declaration
public string selectedevent{get;set;}
Public LIST<Ticket__c> btic{get;set;}

//Constructor
public BLN_ticketReportcon()
{
bookedtickets();
}


public void bookedtickets()
{
 selectedevent = ApexPages.CurrentPage().getParameters().get('id');
 BLN_Reports_BAL BLNtickReports = new BLN_Reports_BAL();
 btic=BLNtickReports.getticks(selectedevent,'Ticket_Status__c','Client_GN_User__r.User__r.States__c');
 system.debug('uuuuuuuu'+btic);
}

}