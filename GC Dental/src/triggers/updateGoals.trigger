trigger updateGoals on SalesOrder__c(after update){ 
  
    LIST<ID> ownerIds = new LIST<Id>();
    LIST<ID> managerIds = new LIST<Id>();
    SET<Date> soCreatedDate = new SET<Date>();
    MAP<String, Goal_Line_Item__c> targetsGoal = new MAP<String, Goal_Line_Item__c>();
    MAP<String, Goal_Line_Item__c> targetsManagerGoal = new MAP<String, Goal_Line_Item__c>();
    LIST<Goal_Line_Item__c> updatedGoals = new LIST<Goal_Line_Item__c>();
    LIST<Goal_Line_Item__c> updatedManagerGoals = new LIST<Goal_Line_Item__c>();
    
   if(trigger.isAfter){
        if(trigger.isUpdate){
       
         MAP<Id, SalesOrder__c> salesOrderMAP = new MAP<ID, salesOrder__c>();
         salesOrderMAP = trigger.newMap;
         
         LIST<SalesOrder__c> salesOrder = [SELECT ID, NAME, Order_Type__c,Customer__r.Owner.Id,Customer__r.Owner.GC_Manager__r.Id,Customer__r.Owner.GC_User_Role__c, Close_Date__c,  
                                            (SELECT ID, NAME, Product__c, Product_Family__c, Product_From__c, Product_Type__c, Quantity_in__c, 
                                            Order_Quantity__c, Total_Product_Amount__c  FROM Sales_Order_Line_Items__r WHERE Product_From__c !='Demo Products' ) 
                                            FROM SalesOrder__c WHERE Id IN: salesOrderMAP.keyset() ];
       
 
          for(SalesOrder__c so: salesOrder){
             if(!string.isBlank(so.Customer__c)) 
               ownerIds.add(so.Customer__r.owner.Id);
               managerIds.add(so.Customer__r.Owner.GC_Manager__r.Id);
               soCreatedDate.add(so.Close_Date__c);
          }
         
          LIST<Goal__c> targettedGoals = new LIST<Goal__c>();
          
          targettedGoals = [SELECT ID, NAME, Sales_Executive__c,Start_Date__c, End_Date__c ,OwnerId,
                            (SELECT ID, NAME, Product__c, Achieved_Quantity_Goal__c, Achieved_Revenue__c, Product_Quantity_in__c, Quantity_Goal__c, 
                            Revenue_Goal__c,Aggregated_Achieved_Quantity__c,Aggregated_Achieved_Revenue__c FROM Goal_Line_Items__r)
                            FROM Goal__c WHERE Start_Date__c <=: soCreatedDate AND End_Date__c >=:soCreatedDate AND ( Sales_Executive__c IN: ownerIds )   ];

       for(Goal__c goal: targettedGoals){
            
          MAP<String, Goal_Line_Item__c> targetsGoalForSE = new MAP<String, Goal_Line_Item__c>();
        
          for(Goal_Line_Item__c goLine: goal.Goal_Line_Items__r ){
              targetsGoalForSE.put(goLine.Product__c, goLine);
          }
          
          LIST<AggregateResult> glanceProductsSalesOrder = [SELECT SUM(Order_Quantity__c), SUM(Total_Product_Amount__c), Product__c
                                                          FROM Sales_Order_Line_Items__c
                                                          WHERE SalesOrder__r.Close_Date__c >=: goal.Start_Date__c AND  SalesOrder__r.Close_Date__c <=: goal.End_Date__c
                                                          AND (SalesOrder__r.Customer__r.Owner.Id =: goal.ownerId)
                                                          GROUP BY Product__c];
          
          MAP<String, String> salesExecutiveAchived = new MAP<String, String>();
          
          
                 
          for(AggregateResult ag: glanceProductsSalesOrder){
              
               String productname =  String.valueOf(ag.get('Product__c'));
               Integer orderQty = Integer.Valueof(ag.get('expr0'));
               Integer orderAmt = Integer.Valueof(ag.get('expr1'));

               if(targetsGoalForSE.containsKey(productname)){
                   Goal_Line_Item__c gline = new Goal_Line_Item__c();
                   
                    gline = targetsGoalForSE.get(productname);
                    gline.Achieved_Quantity_Goal__c = orderQty  ;
                    gline.Achieved_Revenue__c = orderAmt;
                    
                    updatedGoals.add(gline);
               } 
          }        
                
        }

            LIST<Goal__c> targettedManagerGoals = new LIST<Goal__c>();
          
         
          
            targettedManagerGoals = [SELECT ID, NAME, Sales_Executive__c,Start_Date__c, End_Date__c , OwnerId, Owner.Name,
                                     (SELECT ID, NAME, Product__c, Achieved_Quantity_Goal__c, Achieved_Revenue__c, Product_Quantity_in__c, Quantity_Goal__c, 
                                     Revenue_Goal__c,Aggregated_Achieved_Quantity__c,Aggregated_Achieved_Revenue__c FROM Goal_Line_Items__r)
                                     FROM Goal__c WHERE Start_Date__c <=: soCreatedDate AND End_Date__c >=:soCreatedDate AND Sales_Executive__c IN: managerIds];
         
            for(Goal__c goal: targettedManagerGoals){
                for(Goal_Line_Item__c goLine1: goal.Goal_Line_Items__r ){
                    targetsManagerGoal.put(goLine1.Product__c, goLine1);
                }
  
              LIST<AggregateResult> glanceProductsManagerSalesOrder = [SELECT SUM(Order_Quantity__c), SUM(Total_Product_Amount__c), Product__c
                                                                       FROM Sales_Order_Line_Items__c
                                                                       WHERE SalesOrder__r.Close_Date__c >=: goal.Start_Date__c AND  SalesOrder__r.Close_Date__c <=: goal.End_Date__c
                                                                       AND(SalesOrder__r.Customer__r.Owner.Id =: goal.ownerId OR SalesOrder__r.Customer__r.Owner.GC_Manager__c =: goal.ownerId)
                                                                       GROUP BY Product__c];
          

              MAP<String, String> salesExecutiveAchived = new MAP<String, String>();
                 
              for(AggregateResult ag: glanceProductsManagerSalesOrder){
              
                   String productname =  String.valueOf(ag.get('Product__c'));
                   Integer orderQty = Integer.Valueof(ag.get('expr0'));
                   Integer orderAmt = Integer.Valueof(ag.get('expr1'));

                   if(targetsManagerGoal.containsKey(productname)){
                       Goal_Line_Item__c gline = new Goal_Line_Item__c();
                       
                        gline = targetsManagerGoal.get(productname);
                        gline.Aggregated_Achieved_Quantity__c  = orderQty  ;
                        gline.Aggregated_Achieved_Revenue__c = orderAmt;
                         
                        updatedGoals.add(gline);
                   }

               } //End Of Manager Entry       

            }
            
            DataBase.saveResult[] sav = DataBase.update(updatedGoals, false); 
            
            DataBase.update(updatedManagerGoals, false); 
        }// END Of IsInsert & isUpdate Trigger
   }// END Of AfterTrigger 
     
}