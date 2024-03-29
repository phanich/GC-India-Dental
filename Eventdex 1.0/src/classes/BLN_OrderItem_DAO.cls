public without sharing class BLN_OrderItem_DAO{
/**
* @author :Arindam Sarkar
* @date 05/15/2014
* @ This class is used for DML operations on OrderItem object
*/    
   //Inserting OrderItems  
   public BLN_StatusMessage insertOrder(Order_Item__c orditem)
   {
       dataBase.saveResult saveRes = dataBase.insert(orditem,false); 
       return new BLN_StatusMessage(saveRes);
        
   }
   
   //insert bulk orderItems OrderItems   // By Phani 
   public BLN_StatusMessage updateOrder(List<Order_Item__c> orditem)
   {
       dataBase.saveResult[] saveRes = dataBase.update(orditem,false); 
       system.debug('ZZZZZZZZZZZZZZZZZZz '+saveRes );
       return new BLN_StatusMessage(saveRes);
        
   }
   
   
   //insert bulk orderItems OrderItems   // By Phani 
   public BLN_StatusMessage insertOrderitem1(List<Order_Item__c> orditem)
   {
       dataBase.saveResult[] saveRes = dataBase.insert(orditem,false); 
       system.debug('ZZZZZZZZZZZZZZZZZZz '+saveRes );
       return new BLN_StatusMessage(saveRes);
        
   }
   
 // this will return iteams of orders   
  public List<Order_Item__c> ordeIteam(string uid){
    return [Select Currency__c,Each_Ticket_Price__c,item__r.event__r.Name ,o.Promotion__c, o.Order__c, o.Name, o.Item__c, o.Item_Total__c, o.Item_Quantity__c, o.Item_Price__c, o.Item_Discount__c, o.Id,Item__r.Event__r.End_Date__c,item__r.item_name__c,order__r.Client_GN_User__r.user__c,Status__c From Order_Item__c o where order__r.Client_GN_User__r.user__c =:uid and status__c!='Cancelled'];
  }  
  
   // To return Order Item based on the order and item 
  public Order_Item__c getOrderItem(string orderid, string itemid){
    return [SELECT Currency__c,Each_Ticket_Price__c,item__r.event__r.Name ,o.Promotion__c,o.item__r.Id,o.Item__r.price__c, o.Order__c, o.Name, o.Item__c, o.Item_Total__c, o.Item_Quantity__c, o.Item_Price__c, o.Item_Discount__c, o.Id,Item__r.Event__r.End_Date__c,item__r.item_name__c,order__r.Client_GN_User__r.user__c,Status__c FROM Order_Item__c o WHERE order__c =:orderid AND item__c =: itemid  and  status__c!='Cancelled' LIMIT 1];
  }    
    
 //Getting tickets of orders 
   public List<Order_Item__c> orderQueryTicketCh(SET<id> orids){
     return [SELECT Currency__c,Each_Ticket_Price__c,id,Item__c,Item_Discount__c,Item_Price__c,Item_Quantity__c,Item_Total__c,Order__c,Promotion__c,order__r.Client_GN_User__r.user__c,(select id,Client_User__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.CompanyName,Ticket_Status__c,order__r.Client_GN_User__r.user__c, Client_Company__r.Name,Client_Company__r.isPersonAccount__c,Client_Company__c,Event__c,Hide_Desc__c,Item__c,Item_Pool__c,Item_Type__c,Order__c,Order_Item__c,Parent_ID__c,RSVP__c,Tag_No__c,item__r.item_type__r.Name,last_Name__c,first_Name__c,Email__c,company__c from Tickets__r where Ticket_Status__c!='Cancelled'),Status__c,item__r.Item_Pool__r.Item_Pool_Name__c,item__r.item_type__r.Name From Order_Item__c where order__c In :orids and status__c!='Cancelled'];
   }
   
   
   //Getting tickets of orders 
   public List<Order_Item__c> getTicketsOfperticularOItem(string orids){
     return [SELECT Currency__c,Each_Ticket_Price__c,id,Item__c,Item_Discount__c,Item_Price__c,Item_Quantity__c,Item_Total__c,Order__c,Promotion__c,order__r.Client_GN_User__r.user__c,(select id,Client_User__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.CompanyName,Ticket_Status__c,order__r.Client_GN_User__r.user__c, Client_Company__r.Name,Client_Company__r.isPersonAccount__c,Client_Company__c,Event__c,Hide_Desc__c,Item__c,Item_Pool__c,Item_Type__c,Order__c,Order_Item__c,Parent_ID__c,RSVP__c,Tag_No__c,item__r.item_type__r.Name,first_Name__c,Email__c,company__c,last_Name__c from Tickets__r where Ticket_Status__c!='Cancelled'),Status__c,item__r.Item_Pool__r.Item_Pool_Name__c,item__r.item_type__r.Name From Order_Item__c where id  = :orids and status__c!='Cancelled'];
  
    // return [SELECT Each_Ticket_Price__c,id,Item__c,Item_Discount__c,Item_Price__c,Item_Quantity__c,Item_Total__c,Order__c,Promotion__c,order__r.Client_User__c,(select id,Client_User__c,Client_User__r.FirstName,Client_User__r.LastNAme,Client_User__r.Email,Client_User__r.userName,Client_User__r.CompanyName,Ticket_Status__c,order__r.Client_User__c, Client_Company__r.Name,Client_Company__r.isPersonAccount__c from Tickets__r ) From Order_Item__c where Id = :orids];
   }
   
  
   //Getting tickets of orders 
   public List<Order_Item__c> getTicketsOfperticularOItemList(SET<id> orids){
     return [SELECT Currency__c,Each_Ticket_Price__c,id,Item__c,Item_Discount__c,Item_Price__c,Item_Quantity__c,Item_Total__c,Order__c,Promotion__c,order__r.Client_GN_User__r.user__c,(select id,Client_User__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.CompanyName,Ticket_Status__c,order__r.Client_GN_User__r.user__c, Client_Company__r.Name,Client_Company__r.isPersonAccount__c,Client_Company__c,Event__c,Hide_Desc__c,Item__c,Item_Pool__c,Item_Type__c,Order__c,Order_Item__c,Parent_ID__c,RSVP__c,Tag_No__c,item__r.item_type__r.Name,Last_Name__c,first_Name__c,Email__c,company__c from Tickets__r where Ticket_Status__c!='Cancelled'),Status__c,item__r.Item_Pool__r.Item_Pool_Name__c,item__r.item_type__r.Name From Order_Item__c where id In :orids and status__c!='Cancelled'];
  
    // return [SELECT Each_Ticket_Price__c,id,Item__c,Item_Discount__c,Item_Price__c,Item_Quantity__c,Item_Total__c,Order__c,Promotion__c,order__r.Client_User__c,(select id,Client_User__c,Client_User__r.FirstName,Client_User__r.LastNAme,Client_User__r.Email,Client_User__r.userName,Client_User__r.CompanyName,Ticket_Status__c,order__r.Client_User__c, Client_Company__r.Name,Client_Company__r.isPersonAccount__c from Tickets__r ) From Order_Item__c where Id = :orids];
   }
    
}