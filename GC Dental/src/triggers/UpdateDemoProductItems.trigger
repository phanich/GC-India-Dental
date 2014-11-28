trigger UpdateDemoProductItems on Sales_Order_Line_Items__c (before delete, after insert, after update, after delete) {

 /*   
    Author   : Naga Mallikarjuna Rao
    Date     : 11/07/2013
    Version  : 1.0 
 */
     
    LIST<SalesOrder__c> demoSalesOrder = new LIST<SalesOrder__c>();

    if(trigger.isAfter){
        if(!trigger.isdelete){
        
        LIST<Sales_Order_Line_Items__c>  salesOrderLineQuery = new LIST<Sales_Order_Line_Items__c>();
        
        MAP<Id, Sales_Order_Line_Items__c> salesOrderLineMAP = new MAP<ID, Sales_Order_Line_Items__c>();
        salesOrderLineMAP = trigger.newMap ;
        
        LIST<ID> salesOrderLineItems = new LIST<ID>();
        
        MAP<ID,ID> salesOrderOldMAP = new MAP<Id,ID>();
        Decimal OldQuantity;
        
        for(Sales_Order_Line_Items__c sl: trigger.new){
            salesOrderLineItems.add(sl.Id);
        }
        
        if(trigger.isUpdate){
            for(Sales_Order_Line_Items__c slo: trigger.old){
                salesOrderOldMAP.put(slo.id,slo.Product__c);
                if(slo.Product_From__c =='Demo Products'){
                    OldQuantity = slo.Order_Quantity__c;
                }
            }
        }
        
        salesOrderLineQuery = [SELECT ID, NAME, Product__c, Product_Family__c, Product_From__c, Product_Type__c, Quantity_in__c, SalesOrder__c, 
                               SalesOrder__r.Demo_Product__c, Order_Quantity__c, Total_Product_Amount__c  
                               FROM Sales_Order_Line_Items__c WHERE Product_From__c ='Demo Products' AND ID IN: salesOrderLineItems];
        
        LIST<Id> DemoProducts = new LIST<ID>();
        MAP<ID, ID> productDemoProducts = new MAP<ID, ID>();
        MAP<ID, ID> productDemoProductsOld = new MAP<ID, ID>();
        
        for(Sales_Order_Line_Items__c sl: salesOrderLineQuery){
            if(sl.Product_From__c =='Demo Products'){
                DemoProducts.add(sl.SalesOrder__r.Demo_Product__c);
                productDemoProducts.put(sl.SalesOrder__r.Demo_Product__c , sl.Product__c);
                productDemoProductsOld.put(sl.SalesOrder__r.Demo_Product__c , salesOrderOldMAP.get(sl.id));
            }
        }
        
        LIST<Demo_Product_Line_Item__c> demoProductLineItems = new LIST<Demo_Product_Line_Item__c>();
        demoProductLineItems = [SELECT Distributed_Quantity__c, Product__c, Quantity__c, Demo_Product__r.OwnerId, Demo_Product__c, 
                                Demo_Product__r.From__c, Demo_Product__r.To__c FROM Demo_Product_Line_Item__c WHERE Product__c IN: productDemoProducts.values() AND Demo_Product__c IN: DemoProducts];
        
        LIST<Demo_Product_Line_Item__c> demoProductLineItemsOld = new LIST<Demo_Product_Line_Item__c>();
        demoProductLineItemsOld = [SELECT Distributed_Quantity__c, Product__c, Quantity__c, Demo_Product__r.OwnerId, Demo_Product__c, 
                                   Demo_Product__r.From__c, Demo_Product__r.To__c FROM Demo_Product_Line_Item__c WHERE Product__c IN: productDemoProductsOld.values() AND Demo_Product__c IN: DemoProducts];
        
        for(Demo_Product_Line_Item__c dp: demoProductLineItemsOld){
                        dp.Distributed_Quantity__c =  dp.Distributed_Quantity__c - OldQuantity ;
                        system.debug('!!!!!!! '+ dp.Distributed_Quantity__c);
        }
        
        for(Demo_Product_Line_Item__c dp: demoProductLineItems){
        
            LIST<Sales_Order_Line_Items__c> sol = new LIST<Sales_Order_Line_Items__c>();           
            
            if(null != productDemoProducts.get(dp.Demo_Product__c)){  
                LIST<AggregateResult> glanceProductsSalesOrder = [SELECT SUM(Order_Quantity__c), Product__c
                                                                  FROM Sales_Order_Line_Items__c
                                                                  WHERE SalesOrder__r.Close_Date__c >=: dp.Demo_Product__r.From__c AND  SalesOrder__r.Close_Date__c <=: dp.Demo_Product__r.To__c
                                                                  AND (SalesOrder__r.Customer__r.Owner.Id =: dp.Demo_Product__r.OwnerId )
                                                                  AND Product__c =: productDemoProducts.get(dp.Demo_Product__c) 
                                                                  GROUP BY Product__c];
   
                for(AggregateResult dag: glanceProductsSalesOrder){
                    if(null != dag.get('expr0')){
                        dp.Distributed_Quantity__c =  Integer.valueOf(dag.get('expr0'));
                    }    
                }  
            }
            
            // productDemoProducts
        }
        DataBase.update( demoProductLineItems, FALSE);
        DataBase.update( demoProductLineItemsOld, FALSE);
        }  
    } 
        
    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            LIST<Sales_Order_Line_Items__c>  salesOrderLineQuery1 = new LIST<Sales_Order_Line_Items__c>();
            LIST<ID> salesOrderLineItems1 = new LIST<ID>();
            
            MAP<ID,ID> salesOrderOldMAP1 = new MAP<Id,ID>();
            Decimal OldQuantity1;
        
            for(Sales_Order_Line_Items__c slo: trigger.old){
                salesOrderLineItems1.add(slo.id);
                salesOrderOldMAP1.put(slo.id,slo.Product__c);
                    if(slo.Product_From__c =='Demo Products'){
                        OldQuantity1 = slo.Order_Quantity__c;
                    }
            }
            
            salesOrderLineQuery1 = [SELECT ID, NAME, Product__c, Product_Family__c, Product_From__c, Product_Type__c, Quantity_in__c, SalesOrder__c, SalesOrder__r.Demo_Product__c, Order_Quantity__c, Total_Product_Amount__c  
                                  FROM Sales_Order_Line_Items__c 
                                  WHERE Product_From__c ='Demo Products' 
                                  AND ID IN: salesOrderLineItems1];
           
            LIST<Id> DemoProducts1 = new LIST<ID>();
            MAP<ID, ID> productDemoProductsOld1 = new MAP<ID, ID>();
            
            for(Sales_Order_Line_Items__c sl1: salesOrderLineQuery1){
                DemoProducts1.add(sl1.SalesOrder__r.Demo_Product__c);
                productDemoProductsOld1.put(sl1.SalesOrder__r.Demo_Product__c , salesOrderOldMAP1.get(sl1.id));
            }

            LIST<Demo_Product_Line_Item__c> demoProductLineItemsOld1 = new LIST<Demo_Product_Line_Item__c>();
            demoProductLineItemsOld1 = [SELECT Distributed_Quantity__c, Product__c, Quantity__c, Demo_Product__r.OwnerId, Demo_Product__c, 
                                       Demo_Product__r.From__c, Demo_Product__r.To__c FROM Demo_Product_Line_Item__c WHERE Product__c IN: productDemoProductsOld1.values() AND Demo_Product__c IN: DemoProducts1];
            
            for(Demo_Product_Line_Item__c dp1: demoProductLineItemsOld1){
                dp1.Distributed_Quantity__c =  dp1.Distributed_Quantity__c - OldQuantity1 ;
            }
            DataBase.update( demoProductLineItemsOld1, FALSE);
        }
    }

}