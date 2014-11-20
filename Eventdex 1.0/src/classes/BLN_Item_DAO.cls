public without sharing class BLN_Item_DAO{
   
     
    //Getting Items for an Event
   public List<BLN_Item__c> getEventItems(String eventId){
     List<BLN_Item__c> items=[select id,item_name__c,Item_Type__r.name,Item_Pool__c,Item_Pool__r.Name,Item_Pool__r.Item_Pool_Name__c,Item_Pool__r.Package_Flag__c,Item_Pool__r.Item_Count__c,Item_Pool__r.Item_Type__r.Id,Item_Pool__r.Item_Type__r.Name,Item_Pool__r.Item_Type__r.BL_Fee_Amt_per_res__c,Item_Pool__r.Item_Type__r.BL_Fee_Pct_per_res__c, max_per_order__c, min_per_order__c,sale_start__c,sale_end__c,Early_Bird_Pricing_Display_Flag__c,Visibility__c,
                                    service_fee__c ,item_count__c ,image_url__c,item_type__c,Payment__c,Description__c,Event__c,price__c,Item_Type__r.BL_Fee_Amt_per_res__c,Item_Type__r.BL_Fee_Pct_per_res__c,Available_Tickets__c,Currency_Code__c,Ticket_Settings__c,(Select Id,item__c,Question__c,Question__r.Event__c,IQ_Order__c,Question__r.Id  FROM Item_Question__r),(select id,Name,Item_Type__c,Ticket_Settings__c from Items__r)  FROM BLN_Item__c where Event__c=:eventId and Item_Pool__r.Item_Count__c>0 ];
     if(items.size() > 0){
          return items;
     }else{
         return new LIST<BLN_Item__c>();
     }
   }

  
     
    //Insert Items................................
    public LIST<Database.Upsertresult> upsertItems(LIST<BLN_Item__c> items){
        
        LIST<Database.Upsertresult> itemsResult = Database.upsert(items, false);
        
        return itemsResult;
    }


  
    //update Items................................
    public void  updateItems(LIST<BLN_Item__c> items){
        
        LIST<Database.saveResult> itemsResult = Database.update(items, false);
        
    }
    
    //Getting Items belongs to an Event Written by Manasa Gandham
    public List<BLN_Item__c> itemsListForEvent(String QueryStr){
     
     List<BLN_Item__c> items=new LIST<BLN_Item__c>();
     string queryString= 'select id,item_name__c,Item_Type__r.name,Item_Pool__c,Item_Pool__r.Name,Item_Pool__r.Item_Pool_Name__c,Item_Pool__r.Package_Flag__c,Item_Pool__r.Item_Count__c,Item_Pool__r.Item_Type__r.Id,Item_Pool__r.Item_Type__r.Name,Item_Pool__r.Item_Type__r.BL_Fee_Amt_per_res__c,Item_Pool__r.Item_Type__r.BL_Fee_Pct_per_res__c, max_per_order__c, min_per_order__c,sale_start__c,sale_end__c,Early_Bird_Pricing_Display_Flag__c,Visibility__c, service_fee__c ,item_count__c ,image_url__c,item_type__c,Payment__c,Description__c,Event__c,price__c,Item_Type__r.BL_Fee_Amt_per_res__c,Item_Type__r.BL_Fee_Pct_per_res__c,Available_Tickets__c,Currency_Code__c,Ticket_Settings__c,(Select Id,item__c,Question__c,Question__r.Event__c,IQ_Order__c,Question__r.Id  FROM Item_Question__r),(select id,Name,Item_Type__c,Ticket_Settings__c from Items__r)  FROM BLN_Item__c'+ QueryStr;
        system.debug('   QUERY STRING '+queryString);
        items= dataBase.query(queryString);
        return items;
   }
}