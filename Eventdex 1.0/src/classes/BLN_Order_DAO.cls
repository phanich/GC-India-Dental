public without sharing class BLN_Order_DAO{
 /**
* @author :Arindam Sarkar
* @date 05/12/2014
* @ This class is used for DML operations on Order object
*/   
   //Insering Order  
   public BLN_StatusMessage insertOrder(Order__c  ord){
       dataBase.saveResult saveRes = dataBase.insert(ord,false); 
       return new BLN_StatusMessage(saveRes);
    }
    
 
    
    
     //updating Order  
   public BLN_StatusMessage updateOrder(Order__c  ord){
       dataBase.saveResult saveRes = dataBase.update(ord,false); 
       system.debug('RRRRRRRRRRRR '+saveRes);
       return new BLN_StatusMessage(saveRes);
    }
    
   
   //get values form ids of order
   public List<order__c> orderQuery(string str){
       
    string st = 'Select EVent_Admin_Comments__c,createdDate,Events__r.Name,Events__r.Start_Date__c,Events__r.Venue_Name__c,Events__r.End_Date__c,Events__c, o.Fee_Amount__c, o.Order_Total__c, o.Order_Taxes__c, o.Order_Sub_Total__c, o.Order_Status__c, o.Order_Discount__c, o.Name, o.Id, o.Currency_Code__c, o.Client_User__c, o.Client_Company__c, o.Amount_Paid__c,Client_GN_User__r.User__r.userName,Client_GN_User__r.User__r.MobilePhone,Client_GN_User__r.Email__c,Client_Company__r.Name,Client_Company__r.isPersonAccount__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c From Order__c o '+str;
    return DataBAse.query(st);
   } 
    
    //get values form ids of order
   public List<order__c> orderQuery(SET<ID> idval){
    return  [Select createdDate,Events__r.Name,Events__r.Start_Date__c,Events__r.Venue_Name__c,Events__r.End_Date__c,Events__c,o.Fee_Amount__c, o.Order_Total__c, o.Order_Taxes__c, o.Order_Sub_Total__c, o.Order_Status__c, o.Order_Discount__c, o.Name, o.Id, o.Currency_Code__c, o.Client_User__c, o.Client_Company__c, o.Amount_Paid__c,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.MobilePhone,Client_Company__r.Name,Client_Company__r.isPersonAccount__c,Client_GN_User__r.Email__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c From Order__c o where id IN :idval and Transaction_Status__c='Completed'];
    
   } 
   
   //Getting child records of order 
   public List<order__c> orderQueryChildTicket(SET<id> orderIds){
     return [select createdDate,Events__r.Name,Events__r.Start_Date__c,Events__r.End_Date__c,Events__c,o.Fee_Amount__c,o.Order_Total__c, o.Order_Taxes__c, o.Order_Sub_Total__c, o.Order_Status__c, o.Order_Discount__c, o.Name, o.Id, o.Currency_Code__c, o.Client_User__c, o.Client_Company__c, o.Amount_Paid__c,(Select Order_Item__r.Each_Ticket_Price__c,Item_Pool__c,Item_Type__c,item__r.item_name__c,id,Client_Company__c,Client_Company__r.Name,Client_Company__r.isPersonAccount__c,Client_GN_User__r.Email__c,Client_GN_User__r.user__c,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.email,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_User__r.companyName,Event__c,Order__c,Order_Item__c,Ticket_Status__c,Badge_Label__c,NAme,Item_Type__r.Name,Client_GN_User__r.user__r.MobilePhone,lastmodifiedDate,Item__r.item_type__r.Name,item__r.Item_Pool__r.Item_Pool_Name__c,Item_Pool__r.Item_Pool_Name__c,Parent_ID__c,Item_Pool__r.Item_Type__r.Name,Last_Name__c,first_Name__c,Email__c,company__c   from Tickets__r where Order_Item__r.Status__c!='Cancelled'),Client_User__r.Name,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.MobilePhone,Client_Company__r.Name,Client_GN_User__r.First_Name__c,
Client_GN_User__r.Email__c, Client_GN_User__r.Last_Name__c From Order__c o where id IN :orderIds and Transaction_Status__c='Completed'];
   }
   
   //Getting child records of order 
   public List<order__c> orderQueryChild(string str,string eveId){
    if(eveId=='All'){
        return [select Events__r.Name,Events__r.Start_Date__c,Events__r.Venue_Name__c,Events__r.End_Date__c,Events__c,createdDate,o.Fee_Amount__c,o.Order_Total__c, o.Order_Taxes__c, o.Order_Sub_Total__c, o.Order_Status__c, o.Order_Discount__c, o.Name, o.Id, o.Currency_Code__c, o.Client_User__c, o.Client_Company__c, o.Amount_Paid__c,(Select Each_Ticket_Price__c,item__r.event__r.Name ,Promotion__c,Promotion__r.Name, Order__c, Name, Item__c, Item_Total__c,order__r.Client_GN_User__r.Email__c,order__r.Client_GN_User__r.user__c, Item_Quantity__c, Item_Price__c, Item_Discount__c, Id,Item__r.Event__r.End_Date__c,item__r.item_name__c,Status__c,Promotion__r.Promo_Code__c,Currency__c,Item__r.Item_Pool__r.Item_Pool_Name__c,Item__r.item_type__r.Name  From Order_Items__r ),Client_GN_User__r.user__r.Name,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.MobilePhone,Client_Company__r.Name,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c From Order__c o where Client_GN_User__r.user__c  = :str and Transaction_Status__c='Completed'];
    }else{
        return [select createdDate,Events__r.Name,Events__r.Start_Date__c,Events__r.Venue_Name__c,Events__r.End_Date__c,Events__c,o.Fee_Amount__c,o.Order_Total__c, o.Order_Taxes__c, o.Order_Sub_Total__c, o.Order_Status__c, o.Order_Discount__c, o.Name, o.Id, o.Currency_Code__c, o.Client_User__c, o.Client_Company__c, o.Amount_Paid__c,(Select Each_Ticket_Price__c,item__r.event__r.Name ,Promotion__c,Promotion__r.Name, Order__c, Name, Item__c, Item_Total__c,order__r.Client_GN_User__r.Email__c,order__r.Client_GN_User__c, Item_Quantity__c, Item_Price__c, Item_Discount__c, Id,Item__r.Event__r.End_Date__c,item__r.item_name__c,Status__c,Promotion__r.Promo_Code__c,Currency__c,Item__r.Item_Pool__r.Item_Pool_Name__c,Item__r.item_type__r.Name From Order_Items__r where Item__r.Event__c=:eveId ),Client_GN_User__r.Name,Client_User__r.userName,Client_User__r.MobilePhone,Client_Company__r.Name,Client_Company__r.isPersonAccount__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c From Order__c o where Client_GN_User__r.user__c  = :str and Transaction_Status__c='Completed'];
    }
     
   }
   
   
    //Getting child records of order 
   public List<order__c> orderQueryChildOrditem(SET<id> orderIds){
        return [select createdDate,Events__r.Name,Events__r.Start_Date__c,Events__r.Venue_Name__c,Events__r.End_Date__c,Events__c,o.Fee_Amount__c,o.Order_Total__c, o.Order_Taxes__c, o.Order_Sub_Total__c, o.Order_Status__c, o.Order_Discount__c, o.Name, o.Id, o.Currency_Code__c, o.Client_GN_User__c, o.Client_Company__c, o.Amount_Paid__c,(Select Each_Ticket_Price__c,item__r.event__r.Name ,Promotion__c,Promotion__r.Name, Order__c, Name, Item__c, Item_Total__c,order__r.Client_GN_User__c, order__r.Client_GN_User__r.Email__c,Item_Quantity__c, Item_Price__c, Item_Discount__c, Id,Item__r.Event__r.End_Date__c,item__r.item_name__c,Status__c,Promotion__r.Promo_Code__c,Currency__c  From Order_Items__r ),Client_GN_User__r.user__r.Name,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.MobilePhone,Client_Company__r.Name,Client_Company__r.isPersonAccount__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Email__c,EVent_Admin_Comments__c,owner.userName From Order__c o where Id In :orderIds and Transaction_Status__c='Completed' ];
    }
    
    
    // Getting all values for order and its line items By Phani
    
    public List<order__c> order(SET<id> orderIds){
        return [select createdDate,Events__r.Name,Events__r.Start_Date__c,Events__r.Venue_Name__c,Events__r.End_Date__c,Events__c,o.Fee_Amount__c,o.Order_Total__c, o.Order_Taxes__c, o.Order_Sub_Total__c, o.Order_Status__c, o.Order_Discount__c, o.Name, o.Id, o.Currency_Code__c, o.Client_GN_User__c, o.Client_Company__c, o.Amount_Paid__c,(Select Each_Ticket_Price__c,item__r.event__r.Name ,Promotion__c,Promotion__r.Name, Order__c, Name, Item__c, Item_Total__c,order__r.Client_GN_User__c, order__r.Client_GN_User__r.Email__c,Item_Quantity__c, Item_Price__c, Item_Discount__c, Id,Item__r.Event__r.End_Date__c,item__r.item_name__c,Status__c,Promotion__r.Promo_Code__c,Currency__c  From Order_Items__r ),(Select Order_Item__r.Each_Ticket_Price__c,Item_Pool__c,Item_Type__c,item__r.item_name__c,id,Client_Company__c,Client_Company__r.Name,Client_Company__r.isPersonAccount__c,Client_GN_User__r.Email__c,Client_GN_User__r.user__c,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.email,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_User__r.companyName,Event__c,Order__c,Order_Item__c,Ticket_Status__c,Badge_Label__c,NAme,Item_Type__r.Name,Client_GN_User__r.user__r.MobilePhone,lastmodifiedDate,Parent_ID__c,Item_Pool__r.Item_Type__r.Name,Last_Name__c,first_Name__c,Email__c,company__c  from Tickets__r),(select Currency_Code__c,Pay_Address__c,PGateway_Type__c,Payment_Ref_Number__c,Payment_Mode__c,Payment_Amount__c from Payments__r),Client_GN_User__r.user__r.Name,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.MobilePhone,Client_Company__r.Name,Client_GN_User__r.Last_Name__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Email__c From Order__c o where Id In :orderIds and Transaction_Status__c='Completed' ];
    } 
    
    // Getting Orders List based on Event written by Manasa Gandham
    
    public List<order__c> orderListForEvent(String str){
        LIST<order__c> ordersList= new LIST<order__c>();
        string queryString= 'select createdDate,Events__r.Name,Events__r.Start_Date__c,Events__r.Venue_Name__c,Events__r.End_Date__c,Events__c,o.Fee_Amount__c,o.Order_Total__c, o.Order_Taxes__c, o.Order_Sub_Total__c, o.Order_Status__c, o.Order_Discount__c, o.Name, o.Id, o.Currency_Code__c, o.Client_GN_User__c, o.Client_Company__c, o.Amount_Paid__c,(Select Each_Ticket_Price__c,item__r.event__r.Name ,Promotion__c,Promotion__r.Name, Order__c, Name, Item__c, Item_Total__c,order__r.Client_GN_User__c, order__r.Client_GN_User__r.Email__c,Item_Quantity__c, Item_Price__c, Item_Discount__c, Id,Item__r.Event__r.End_Date__c,item__r.item_name__c,Status__c,Promotion__r.Promo_Code__c,Currency__c  From Order_Items__r ),(Select Order_Item__r.Each_Ticket_Price__c,Item_Pool__c,Item_Type__c,item__r.item_name__c,id,Client_Company__c,Client_Company__r.Name,Client_Company__r.isPersonAccount__c,Client_GN_User__r.Email__c,Client_GN_User__r.user__c,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.email,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_User__r.companyName,Event__c,Order__c,Order_Item__c,Ticket_Status__c,Badge_Label__c,NAme,Item_Type__r.Name,Client_GN_User__r.user__r.MobilePhone,lastmodifiedDate, Client_GN_User__r.Company_Name__c,Parent_ID__c,Item_Pool__r.Item_Type__r.Name  from Tickets__r),(select Currency_Code__c,Pay_Address__c,PGateway_Type__c,Payment_Ref_Number__c,Payment_Mode__c,Payment_Amount__c from Payments__r),Client_GN_User__r.user__r.Name,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.MobilePhone,Client_Company__r.Name,Client_GN_User__r.Last_Name__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Email__c From Order__c o '+ str;
        system.debug('   QUERY STRING '+queryString);
        ordersList= dataBase.query(queryString);
        return ordersList;
    } 
    
    public List<order__c> orderListForEventSearch(String Str, SET<Id> OrderIds){
        LIST<order__c> ordersList= new LIST<order__c>();
        string queryString= 'select createdDate,Events__r.Name,Events__r.Start_Date__c,Events__r.Venue_Name__c,Events__r.End_Date__c,Events__c,o.Fee_Amount__c,o.Order_Total__c, o.Order_Taxes__c, o.Order_Sub_Total__c, o.Order_Status__c, o.Order_Discount__c, o.Name, o.Id, o.Currency_Code__c, o.Client_GN_User__c, o.Client_Company__c, o.Amount_Paid__c,(Select Each_Ticket_Price__c,item__r.event__r.Name ,Promotion__c,Promotion__r.Name, Order__c, Name, Item__c, Item_Total__c,order__r.Client_GN_User__c, order__r.Client_GN_User__r.Email__c,Item_Quantity__c, Item_Price__c, Item_Discount__c, Id,Item__r.Event__r.End_Date__c,item__r.item_name__c,Status__c,Promotion__r.Promo_Code__c,Currency__c  From Order_Items__r ),(Select Order_Item__r.Each_Ticket_Price__c,Item_Pool__c,Item_Type__c,item__r.item_name__c,id,Client_Company__c,Client_Company__r.Name,Client_Company__r.isPersonAccount__c,Client_GN_User__r.Email__c,Client_GN_User__r.user__c,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.email,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_User__r.companyName,Event__c,Order__c,Order_Item__c,Ticket_Status__c,Badge_Label__c,NAme,Item_Type__r.Name,Client_GN_User__r.user__r.MobilePhone,lastmodifiedDate, Client_GN_User__r.Company_Name__c,Parent_ID__c,Item_Pool__r.Item_Type__r.Name,Last_Name__c,first_Name__c,Email__c,company__c  from Tickets__r),(select Currency_Code__c,Pay_Address__c,PGateway_Type__c,Payment_Ref_Number__c,Payment_Mode__c,Payment_Amount__c from Payments__r),Client_GN_User__r.user__r.Name,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.MobilePhone,Client_Company__r.Name,Client_GN_User__r.Last_Name__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Email__c From Order__c o '+ str;       
        system.debug('   QUERY STRING '+queryString);
        if(OrderIds.size()>0){
            queryString += 'OR ID IN :'+OrderIds;
        }
        ordersList= dataBase.query(queryString);
        return ordersList;
    } 
    
    
    
}