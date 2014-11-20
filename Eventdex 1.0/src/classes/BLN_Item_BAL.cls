public with sharing class BLN_Item_BAL {
	
	
	
	public LIST<DataBase.Upsertresult> processItemsList(LIST<BLN_ItemType_BAL.ticketsinnerClass> insertTickets, MAP<Decimal, Item_Pool__c> itemPoolAfterUpdateMAP, BLN_Event__c selectedEvent ){
		
		LIST<BLN_Item__c> newItemsToInsert = new LIST<BLN_Item__c>();
		
			 for(BLN_ItemType_BAL.ticketsinnerClass tic: insertTickets){
	           
			           if(itemPoolAfterUpdateMAP.containsKey(tic.count)){
			           	 
			            Item_Pool__c itp = itemPoolAfterUpdateMAP.get(tic.count);
			            system.debug('$$$$$$$$$$$$$$$$$$$$$$    '+ tic.itemsList.size()+'      '+tic.itemsList+'   PRICE    '+	tic.items.price__c);
			             
				        if(tic.itemsList.size() >=1 ){
				            
				            for(BLN_Item__c ite: tic.itemsList){
				            	
				            	 system.debug('*******************       '+  ite.price__c);
			           
				            	
				            	if(ite.price__c == null || ( ite.price__c == 0 && tic.items.price__c > 0 )){
				            		ite.price__c = tic.items.price__c;
				            	}
				            	
				               if(ite.Item_Pool__c == null){
				                   ite.Item_Pool__c = itp.ID;
				                   
				                   if(ite.Payment__c == 'Free'){
				                   		ite.price__c = 0.00;
				                   }else if(ite.Payment__c == 'Donation' && ite.price__c == null){
				                   		ite.price__c = 0.00;
				                   }
				                   
				                   
				                   if(ite.item_type__c == null)
				                     ite.item_type__c = itp.Item_Type__c;
				                  
				                   if(ite.Event__c == null)
				                     ite.Event__c = itp.Event__c;
				                   
				                   if(ite.item_name__c == null){
				                        // ticketmoreTic[0].itemPool.Item_Count__c = 0 ;                                                                        
				                        ite.item_name__c = itp.Item_Pool_Name__c ;
				                        
				                        system.debug('######################       '+  itp.Item_Count__c);
				                        
				                        ite.item_count__c = itp.Item_Count__c ;
				                        ite.sale_start__c = system.Today();
				                        ite.sale_end__c =  selectedEvent.End_Date__c;
				                        ite.Payment__c = tic.items.Payment__c; 
				                         
				                   }
				                   
				                 //  ite.Currency_Code__c = 
				                     newItemsToInsert.add(ite);
				               }else{
				               
				                 //  newItemsToInsert.add(ite);
				               }      
				           }
				        }    
		        }    
	            
	        }
	        
	        system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&    %%%%%%%%%%%%   '+ newItemsToInsert);
	        
	        BLN_Item_DAO blnItems = new BLN_Item_DAO();
		    LIST<DataBase.Upsertresult> itemsResult =  blnItems.upsertItems(newItemsToInsert);
		
		return itemsResult;
	}
	
	
	

}