/***********************************************************************************************
*   Controller Name : BLN_AttendeeReportCon_BAL
*   Date            : 10/28/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the PromoCode Report
*   Change History  : 10/28/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*    10/28/2014              Manasa Gandham                 To Create Page
*  
**************************************************************************************************/

public without sharing class BLN_AttendeeReportCon_BAL{

    public BLN_AttendeeReportCon_BAL(){
    
    }  
    public BLN_Ticket_DAO ticketsDAOClass{get; set;}
    
    public LIST<LIST<Ticket__c>> ticketsListForEvent(String EventId, Date FromDate, Date ToDate, String SearchString){
        
        ticketsDAOClass= new BLN_Ticket_DAO();

        String queryString= '';
        queryString= ' Event__c = \''+EventId+'\'';
        queryString += ' AND Ticket_Status__c = \''+'Booked'+'\'';
        system.debug('  000000000000  '+queryString);
        if(FromDate != NULL){
            system.debug('  FROM DATE00000000000 '+FromDate);
            FromDate= FromDate.addDays(1);            
            dateTime d1 = FromDate;
            system.debug('  FROM DATE1111111111 '+d1);
            string FromDateStr= d1.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            system.debug('  FROM DATE2222222222222 '+FromDateStr);
            queryString += ' AND CreatedDate >= '+FromDateStr;
        } 
        system.debug('  111111111  '+queryString);
        if(ToDate != NULL){
            ToDate= ToDate.addDays(1);            
            dateTime d1 = ToDate;
            string ToDateStr= d1.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');

            queryString += ' AND CreatedDate <='+ToDateStr;            
        }
        if(SearchString != NULL){
            queryString += ' AND (Client_GN_User__r.First_Name__c Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Last_Name__c Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Email__c Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Company_Name__c Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Title__c Like \'%'+SearchString+'%\''+' OR item__r.item_Name__c Like \'%'+SearchString+'%\''+' OR Badge_Label__c Like \'%'+SearchString+'%\''+')'; 
          
        }
        system.debug('  QUERY STRING '+queryString );
        LIST<LIST<Ticket__c>> ListOfTickets= new LIST<LIST<Ticket__c>>();
        LIST<Ticket__c> ticksList= new LIST<Ticket__c>();
        LIST<Ticket__c> ticksList999= new LIST<Ticket__c>();
        ticksList= ticketsDAOClass.ticketsListForEvent(queryString);
        for(Ticket__c tic: ticksList){
            ticksList999.add(tic);
            if(ticksList999.size() == 999){
                ListOfTickets.add(ticksList999);
                ticksList999= new LIST<Ticket__c>();
            }
        }
        if(ticksList999.size() != NULL){
            ListOfTickets.add(ticksList999);
        }
        return ListOfTickets;
        }
}