/***********************************************************************************************
*   Controller Name : BLN_ReportsCon_BAL
*   Date            : 10/14/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the Reports
*   Change History  : 10/14/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*    10/14/2014              Manasa Gandham                 To Create Page
*  
**************************************************************************************************/

public without sharing class BLN_ReportsCon_BAL{

    public BLN_ReportsCon_BAL(){
    
    }  
    
    public BLN_Order_DAO  ordersDAOClass{get; set;}
    public BLN_Ticket_DAO  ticketsDAOClass{get; set;}
    
    public LIST<Order__c> ordersListForSta(String EventId){
        String queryString='';
        queryString= ' where Events__c = \''+EventId+'\'';
        queryString += ' AND Transaction_Status__c = \''+'Completed'+'\'';
        system.debug('  000000000000  '+queryString);
        LIST<Order__c> orderList= new LIST<Order__c>();
        orderList= ordersDAOClass.orderListForEvent(queryString);
        system.debug(orderList.size()+' ORDERS LIST '+orderList);
        return orderList;
     }
    public LIST<Order__c> ordersListForEvent(String EventId, Date FromDate, Date ToDate, String SearchString){
        
        ordersDAOClass= new BLN_Order_DAO();
        ticketsDAOClass= new BLN_Ticket_DAO();
        LIST<Order__c> orderList= new LIST<Order__c>();
        system.debug(FromDate+'  FROM DATE TO DATE '+ToDate);
        system.debug('  SEARCH STRING '+SearchString);
        SET<Id> OrderIds= new SET<Id>();
        String queryString= '';
        
        
        if(SearchString == null){
        }else{
            queryString= ' Event__c = \''+EventId+'\'';
            queryString += ' AND Ticket_Status__c = \''+'Booked'+'\'';
            system.debug('  000000000000  '+queryString);
        
            if(FromDate != null){
                system.debug('  FROM DATE00000000000 '+FromDate);
                FromDate= FromDate.addDays(1);            
                dateTime d1 = FromDate;
                system.debug('  FROM DATE1111111111 '+d1);
                string FromDateStr= d1.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                system.debug('  FROM DATE2222222222222 '+FromDateStr);
                queryString += ' AND Order__r.CreatedDate >= '+FromDateStr;
            } 
            system.debug('  111111111  '+queryString);
            if(ToDate != null){
                ToDate= ToDate.addDays(1);            
                dateTime d1 = ToDate;
                string ToDateStr= d1.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
    
                queryString += ' AND Order__r.CreatedDate <='+ToDateStr;            
            }
            
                queryString += ' AND (Client_GN_User__r.First_Name__c Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Last_Name__c Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Email__c Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Company_Name__c Like \'%'+SearchString+'%\''+' OR item__r.item_Name__c Like \'%'+SearchString+'%\''+' )'; 
              
        
            system.debug('  QUERY STRING11111111 '+queryString );
            LIST<LIST<Ticket__c>> ListOfTickets= new LIST<LIST<Ticket__c>>();
            LIST<Ticket__c> ticksList= new LIST<Ticket__c>();
            LIST<Ticket__c> ticksList999= new LIST<Ticket__c>();
            ticksList= ticketsDAOClass.ticketsListForEvent(queryString);

            for(Ticket__c ticket: ticksList){
                OrderIds.add(ticket.Order__c);
            }
        }
        
        queryString='';
        queryString= ' where Events__c = \''+EventId+'\'';
        queryString += ' AND Transaction_Status__c = \''+'Completed'+'\'';
        system.debug('  000000000000  '+queryString);
        if(FromDate != null){
            FromDate= FromDate.addDays(-1);            
            dateTime d1 = FromDate;
            string FromDateStr= d1.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            queryString += ' and CreatedDate >= '+FromDateStr;
        } 
        system.debug('  111111111  '+queryString);
        if(ToDate != null){
            ToDate= ToDate.addDays(1);
            dateTime d1 = ToDate;
            string ToDateStr= d1.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');

            queryString += ' and CreatedDate <='+ToDateStr;            
        }
         if(SearchString == null){
         }else{
             //if(OrderIds.size() >0){
               //  queryString += '  AND (Name Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Email__c Like \'%'+SearchString+'%\')'+ +' )  OR Id IN :OrderIds';
                
            // queryString +=  '  AND (Name Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Email__c Like \'%'+SearchString+'%\''+' OR Id IN :'+OrderIds+' )'; 
             //}else{
                 queryString += '  AND (Name Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Email__c Like \'%'+SearchString+'%\''+' )';              
            // }

          
        }
        
        system.debug('  3333333333  '+queryString);
        orderList= ordersDAOClass.orderListForEvent(queryString);
        //orderList= ordersDAOClass.orderListForEventSearch(queryString, OrderIds);
        system.debug(orderList.size()+' ORDERS LIST '+orderList);
        return orderList;
    }
    
        
    public LIST<Ticket__c> attendeesListForEvent(String EventId){
        
        ticketsDAOClass= new BLN_Ticket_DAO();
        String queryString= '';
        queryString= ' Event__c = \''+EventId+'\'';
        queryString += ' AND Ticket_Status__c = \''+'Booked'+'\'';
        LIST<Ticket__c> ticksList= new LIST<Ticket__c>();
        ticksList= ticketsDAOClass.ticketsListForEvent(queryString);
        
        return ticksList;
    }
    
    public BLN_Payment_DAO paymentDAOClass{get; set;}
    
    public LIST<AggregateResult> PaymentForEvent(String EventId){
    
        paymentDAOClass= new BLN_Payment_DAO();
        LIST<AggregateResult> PaymentAggregateList= new LIST<AggregateResult>(); 
        PaymentAggregateList= paymentDAOClass.paymentsForEvent(EventId);
        return PaymentAggregateList;
    }
}