trigger updateItemTypeBasedOnItemTypeFromItem on BLN_Item__c (after insert, after update) {

    if(trigger.isAfter){
         MAP<id, BLN_Item__c> blnItems = trigger.newMap;
         MAP<Id, Id> itemWisePool = new MAP<ID, ID>();
         LIST<id> itemPoolId = new LIST<id>();
         
         for(BLN_Item__c bi: trigger.new){
                itemPoolId.add(bi.Item_Pool__c);
                itemWisePool.put(bi.Item_Pool__c, bi.item_type__c);
         }
        
           system.debug('11111111111111111111111111111111111111  '+itemPoolId);
           
        LIST<Item_Pool__c> itemPools = new LIST<Item_Pool__c>();
        
         itemPools = [SELECT id, Name,Item_Type__c FROM Item_Pool__c WHERE ID IN: itemPoolId  ];
         
         for(Item_Pool__c ip: itemPools){
             if(itemWisePool.containsKey(ip.id)){
                 if(itemWisePool.get(ip.id) != null)
                     ip.Item_Type__c = itemWisePool.get(ip.id);
             }    
         }
        
        LIST<DataBase.saveResult> res = DataBase.update( itemPools, false);
        
        system.debug('DDDDDDDDDDDDDRRRRRRRRRRRR    YYYYYYYYYTTTTTTTT   '+res );
        
        
    }

}