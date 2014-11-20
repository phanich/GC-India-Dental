public class BLN_Reports_BAL
{

/**************************************************
* @author :Unni krishna
* @date 05/11/2014
* @ This class is used for reports module
****************************************************/ 
//Creating the method for reports& fetching the parameters form DAO
   public List<Ticket__c> getReports(Id EventId,String FilteredString)
    {     
       BLN_Ticket_DAO tcdao=new BLN_Ticket_DAO();
      List<Ticket__c> tckts= tcdao.getTickets('id,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_User__r.States__c,Event__r.Name,Client_Company__r.Name,Client_GN_User__r.User__r.States__c,Client_GN_User__r.CreatedDate,Client_GN_User__r.Name,Client_GN_User__r.Phone__c,Client_GN_User__r.Email__c','Event__r.id=\''+EventId+'\' AND Order__c!= NULL ORDER BY '+FilteredString);
                
             
           return tckts;
    }
  
  
   public List<Ticket__c> getticks(Id EventId,string ticstatus,String FilteredString)
    {     
       BLN_Ticket_DAO tickdao=new BLN_Ticket_DAO();
      List<Ticket__c> bookedtckts= tickdao.getTickets('id,Item__r.item_name__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_User__r.States__c,Event__r.Name,Client_Company__r.Name,Client_GN_User__r.User__r.States__c,Client_GN_User__r.CreatedDate,Client_GN_User__r.Name,Client_GN_User__r.Phone__c,Client_GN_User__r.Email__c','Event__r.id=\''+EventId+'\' AND Ticket_Status__c=\''+ticstatus+'\' ORDER BY '+FilteredString);
                
             
           return bookedtckts;
    }
  
  
}