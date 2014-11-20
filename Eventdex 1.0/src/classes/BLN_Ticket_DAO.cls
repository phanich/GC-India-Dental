public without sharing class BLN_Ticket_DAO{
  /**
* @author :Arindam Sarkar
* @date 05/12/2014
* @ This class is used for DML operations on Ticket object
*/ 
     
    //Updating the tickets  
    public BLN_StatusMessage insertTicket(List<Ticket__c> tckt){
        dataBase.saveResult[] saveRes = dataBase.insert(tckt,false); 
        return new BLN_StatusMessage(saveRes);
    }
    
    //Updating the tickets  
    public BLN_StatusMessage updateTicket(List<Ticket__c> tckt){
        dataBase.saveResult[] saveRes = dataBase.update(tckt,false); 
        return new BLN_StatusMessage(saveRes);
    }
    
    //Updating the tickets  
    public BLN_StatusMessage updateTicket(Ticket__c tckt){
        dataBase.saveResult saveRes = dataBase.update(tckt,false); 
        return new BLN_StatusMessage(saveRes);
    }

    // This method return user booked tickets
    public List<Ticket__c> userOrderAndTickets(string str){
        string query1 = 'Select item_pool__c,badgeparentid__c,(select id,name,item__r.item_Name__c from badgeparentids__r),order__r.id,item__r.item_Name__c,Badge_Label__c,Badge_ID__c,Badge_ID__r.name,(select id,name,Badge_Label__c from badges__r where cancel_time__c=null and Exp_time__c=null limit 1),order__r.Name,Client_Company__r.Name,Name,Item_Type__r.Name ,Client_GN_User__c,Client_GN_User__r.user__r.MobilePhone,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Order_Item__c,event__c,Parent_ID__c   From Ticket__c t '+ str;
       
      //List<Ticket__c> ticketsbooked1 = [Select order__r.id,order__r.Name,Client_Company__r.Name,Name,Item_Type__r.Name,Client_GN_User__r.user__r.MobilePhone,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_GN_User__c,event__c,Parent_ID__c   From Ticket__c t ]; 
       
       //Item_Pool__r.Badge_Label__c,Item_Type__r.Name,Name,Client_GN_User__r.user__r.MobilePhone,Ticket__c.Client_Company__r.Name,Client_Company__r.isPersonAccount__c,Order__r.NAme,order_item__c ,event__r.Name,event__c,item__r.event__r.Name,item__r.Ticket_Settings__c,id, order__c,t.Ticket_Status__c, t.Tag_No__c, t.RSVP__c, t.Parent_ID__c, t.Item_Type__c, t.Item_Pool__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_GN_User__r.user__r.Email,Client_GN_User__r.user__r.userName,Client_User__r.CompanyName, Client_GN_User__c, Client_Company__c 
        system.debug('PPPPPPPPPPPP '+query1);
        List<Ticket__c> ticketsbooked = dataBase.query(query1);
        return ticketsbooked; 
    }

    //for getting available tickets for an item
    public List<Ticket__c> userOrderAndTickets(set<id> idvalues,String userId,string eveId) {
        List<Ticket__c> tckt = new List<Ticket__c>();
        if(eveId=='All'){
            tckt=[select  id,name,order__c,item__r.event__r.Name,item__r.item_Name__c ,Event__r.End_Date__c,Event__c,Item_Type__r.name,Ticket_Status__c,Parent_ID__c,Item_Pool__r.Badge__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.user__r.Email,Client_GN_User__r.Email__c,Client_GN_User__r.user__r.userName,Client_User__r.CompanyName,item__r.Ticket_Settings__c,Client_Company__r.isPersonAccount__c,item__r.Item_Pool__r.Item_Pool_Name__c,item__r.item_type__r.Name from Ticket__c where order__c NOT IN :idvalues and  Client_GN_User__r.user__c=:userId];
        }else{
            tckt=[select  id,name,order__c,item__r.event__r.Name,item__r.item_Name__c ,Event__r.End_Date__c,Event__c,Item_Type__r.name,Ticket_Status__c,Parent_ID__c,Item_Pool__r.Badge__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.user__r.Email,Client_GN_User__r.Email__c,Client_GN_User__r.user__r.userName,Client_User__r.CompanyName,item__r.Ticket_Settings__c,Client_Company__r.isPersonAccount__c,item__r.Item_Pool__r.Item_Pool_Name__c,item__r.item_type__r.Name  from Ticket__c where order__c NOT IN :idvalues and  Client_GN_User__r.user__c=:userId and event__c=:eveId];
        }   
        return tckt;
    }  

    //Common Method For Get Ticket Information based on fields and condition
    public List<Ticket__c> getTickets(String fields,String whereCondition){
        List<Ticket__c> tc;
        String sql='select '+fields+' from Ticket__c  where '+whereCondition;
        tc=Database.query(sql);
        return tc;    
    }
    
    //Get Tickets Based on selected Items
    public LIST<Ticket__c> getSelectedTickets(LIST<Id> itemIds){
        LIST<Ticket__c> ticketsList = new LIST<Ticket__c>();
        
        ticketsList = [SELECT ID, NAME,Event__c,Parent_ID__c FROM Ticket__c  WHERE item__c IN: itemIds];
        return ticketsList;
    }

   //for reports written by unni
   public List<Ticket__c> getbookedTickets(String fields,String ticstatus,String whereCondition){
        List<Ticket__c> tc1;
        String sql='select '+fields+' from Ticket__c  where '+whereCondition+ticstatus;
        tc1=Database.query(sql);
        return tc1;    
    }
    
    
    // This Method is used to get all tickets along with GN User Information belongs to a particular Event written by Manasa Gandham
    
    public LIST<Ticket__c> ticketsListForEvent(String Condition){
        
        LIST<Ticket__c> ticketsList= new LIST<Ticket__c>();
        ticketsList= database.query('SELECT ID, Name, order__c, item__r.item_Name__c , Item_Type__r.name, Ticket_Status__c, Parent_ID__c, Item_Pool__r.Badge__c, Badge_Label__c, Client_GN_User__r.First_Name__c, Client_GN_User__r.Last_Name__c, Client_GN_User__r.Email__c, Client_GN_User__r.Company_Name__c, Client_GN_User__r.Title__c, Client_GN_User__r.Phone__c, Client_GN_User__r.Address1__c, Client_GN_User__r.Address2__c, Client_GN_User__r.City__c, Client_GN_User__r.State__r.Long_Name__c, Client_GN_User__r.Country__r.Long_Name__c, Client_GN_User__r.Zip_Code__c, Client_GN_User__r.DOB__c, Client_GN_User__r.User_Type__c , Client_GN_User__r.User_Website__c,Client_GN_User__r.user__r.Prefix__c, Client_GN_User__r.user__r.Suffix__c, Client_GN_User__r.user__r.Id, Client_GN_User__r.user__r.Email, item__r.Ticket_Settings__c, Client_Company__r.isPersonAccount__c, item__r.Item_Pool__r.Item_Pool_Name__c, item__r.item_type__r.Name, Client_Company__r.Id,First_Name__c,Last_Name__c,Email__c FROM Ticket__c WHERE '+Condition);
        
        return ticketsList;
    }
}