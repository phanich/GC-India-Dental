public with sharing class salesOrderCon {

    public salesOrderCon(ApexPages.StandardSetController controller) {

    }


 /*   
    Author   : Naga Mallikarjuna Rao
    Date     : 24/09/2013
    Version  : 1.0 
 */
    public Date lastweekDate{get; set;}
    public SalesOrder__c so{get; set;}
    public List<SalesOrder__c> soList{get; set;}
    public LIST<Sales_Order_Line_Items__c> soLine{get; set;}
    public Decimal lastLineItem{get; set;}
    public LIST<Product__c> allProducts{get; set;}
    public List<SelectOption> productpicklistValues{get; set;}  
    public LIST<Decimal> deletedSalesOrderLineItems{get; set;}
    public Boolean AddFreeItemsBool{get; set;}
    public LIST<Demo_Product__c> demoProducts{get; set;}
    public Demo_Product__c selectedDemo{get; set;}
    public MAP<ID, Demo_Product__c> demoProductMAP{get; set;}
    public List<SelectOption> DemoproductpicklistValues{get; set;}  
    public Integer campaignItems{get; set;}
    
    public String errorMessage{get;set;}
    public String errorMessage1{get;set;}
    public String errorMessage2{get;set;}
    public String errorMessage3{get;set;}
    public String errorMessage4{get;set;}
    
    
    public Boolean Logdetailsbool{get; set;}
    public TASK ta{get; set;}
    public LIST<TASK> SOLogDetails{get;set;}
    public LIST<Sales_Order_Line_Items__c> SODemoLine{get;set;}
    public Decimal deletedId{get;set;}

              
    public MAP<Decimal, Sales_Order_Line_Items__c> salesOrderLineItemsMAP{get; set;}
    public MAP<Decimal, Sales_Order_Line_Items__c> salesOrderOtherFreeLineItemsMAP{get; set;}
    public MAP<String, Sales_Order_Line_Items__c> toFindCampaignDuplicate{get; set;}  
    
    public salesOrderCon(ApexPages.StandardController controller){
        so = new SalesOrder__c();
        ta = new TASK();
        soList = new LIST<SalesOrder__c>();
        soLine = new LIST<Sales_Order_Line_Items__c>();
        campaignSOLine = new LIST<Sales_Order_Line_Items__c>();
        SODemoLine = new LIST<Sales_Order_Line_Items__c>();
        SOLogDetails = new LIST<TASK>();
        lastweekDate = Date.today().addDays(-7);
        
        allProducts = new LIST<Product__c>();
        productpicklistValues  = new List<SelectOption>();
        deletedSalesOrderLineItems = new LIST<Decimal>();
        salesOrderLineItemsMAP = new MAP<Decimal, Sales_Order_Line_Items__c>();
        salesOrderOtherFreeLineItemsMAP = new MAP<Decimal, Sales_Order_Line_Items__c>();
        AddFreeItemsBool = TRUE;
        demoProducts = new LIST<Demo_Product__c>();
        demoProductMAP = new MAP<ID, Demo_Product__c>();
        DemoproductpicklistValues = new List<SelectOption>();
        toFindCampaignDuplicate = new MAP<String, Sales_Order_Line_Items__c>();
        
        
        lastLineItem = 0;

        Logdetailsbool = true;
        
        Id AccountId;        
        ta.Outcome_of_Meeting__c = 'Placed an order';
        ta.Status = 'Completed'; 
        
        if(null != Controller.getId()){
        
            soList = [SELECT Campaign__c, Customer__c, Dealer__c, Demo_Product__c, Close_Date__c, Order_Type__c, Working_with__c, Name 
                  FROM SalesOrder__c 
                  WHERE ID =: Controller.getId()];  
            
            system.debug(soList.size()+'###########################     '+Controller.getId() +'    '+apexpages.currentpage().getparameters().get('CF00NN0000000a28i_lkid') +'     '+so.Name);
            
            if(soList.size() > 0){
                so = soList[0];
            } 
            
            SOLogDetails = [SELECT id,WhatId,WhoId,Sales_Order_No__c,ActivityDate,Status,Subject,Meeting_Type__c,Priority,Outcome_of_Meeting__c,Outcome_of_Meeting_Other__c,Next_Visit_date__c,Next_Visit_Time__c 
                            FROM TASK 
                            WHERE WhatId =: so.Customer__c 
                            AND Sales_Order_No__c =: so.Name];
            
            if(SOLogDetails.size() > 0){
                ta = SOLogDetails[0];
            }         
        }
        else{
        try{

                if(UserInfo.getOrganizationId()== '00DN00000003jpSMAQ'){
                    system.debug('test**** '+apexpages.currentpage().getparameters().get('CF00NN0000000a28i_lkid'));
                    system.debug('prod**** '+apexpages.currentpage().getparameters().get('CF00N90000007rYBM_lkid'));
                    if(apexpages.currentpage().getparameters().get('CF00NN0000000a28i_lkid').length() > 10){    
                        so.Customer__c = apexpages.currentpage().getparameters().get('CF00NN0000000a28i_lkid');
                        AccountId = apexpages.currentpage().getparameters().get('CF00NN0000000a28i_lkid');
                    }
                }
                else{
                    system.debug('test1**** '+apexpages.currentpage().getparameters().get('CF00NN0000000a28i_lkid'));
                    system.debug('prod1**** '+apexpages.currentpage().getparameters().get('CF00N90000007rYBM_lkid'));
                    if(apexpages.currentpage().getparameters().get('CF00N90000007rYBM_lkid').length() > 10){    
                        so.Customer__c = apexpages.currentpage().getparameters().get('CF00N90000007rYBM_lkid');
                        AccountId = apexpages.currentpage().getparameters().get('CF00N90000007rYBM_lkid');
                    }
                }
          }
          catch(Exception e){}    
        }    
        
   
        soLine = [SELECT ID, NAME, Name_of_the_Product__c, Order_Quantity__c, Price__c, Product__c, Quantity_in__c, SalesOrder__c, UniqueNumber__c ,Product_Type__c, customer_Product__c
                  FROM Sales_Order_Line_Items__c 
                  WHERE SalesOrder__c =: so.Id 
                  AND Product_From__c ='Sales Order' 
                  ORDER BY UniqueNumber__c ASC ];
        
        for(Sales_Order_Line_Items__c sol: soLine){
            salesOrderLineItemsMAP.put(sol.UniqueNumber__c , sol);
            salesOrderOtherFreeLineItemsMAP.put(sol.UniqueNumber__c , sol);
            lastLineItem = sol.UniqueNumber__c;
        }
        
        SODemoLine = [SELECT ID, NAME, Name_of_the_Product__c, Order_Quantity__c, Price__c, Product__c, Quantity_in__c, SalesOrder__c, UniqueNumber__c ,Product_Type__c, customer_Product__c
                      FROM Sales_Order_Line_Items__c 
                      WHERE SalesOrder__c =: so.Id 
                      AND Product_From__c ='Demo Products' 
                      ORDER BY UniqueNumber__c ASC ];
        
        for(Sales_Order_Line_Items__c sol: SODemoLine){
            salesOrderLineItemsMAP.put(sol.UniqueNumber__c , sol);
            if(lastLineItem < sol.UniqueNumber__c)
                lastLineItem = sol.UniqueNumber__c ;
        }
        
        campaignSOLine = [SELECT ID, NAME, Name_of_the_Product__c, Order_Quantity__c, Price__c, Product__c, Quantity_in__c, SalesOrder__c, UniqueNumber__c, Product_Type__c, customer_Product__c
                          FROM Sales_Order_Line_Items__c 
                          WHERE SalesOrder__c =: so.Id 
                          AND Product_From__c ='Campaign Products' 
                          ORDER BY UniqueNumber__c ASC ];
        
        for(Sales_Order_Line_Items__c sol: campaignSOLine){
            salesOrderLineItemsMAP.put(sol.UniqueNumber__c , sol);
            toFindCampaignDuplicate.put(sol.Product__c+sol.Product_Type__c , sol);
            if(lastLineItem < sol.UniqueNumber__c)
                lastLineItem = sol.UniqueNumber__c ;
        }
        
        /*
        LIST<Demo_Product__c> demoLIst = [SELECT ID, NAME, is_active__c,(SELECT ID, NAME, Product__c,Product__r.Name ,Quantity__c, Quantity_in__c, Product_Family__c FROM Demo_Product_Line_Items__r )
        FROM Demo_Product__c WHERE is_active__c =: TRUE ];
        */
        
        demoProductMAP = new MAP<ID, Demo_Product__c>([SELECT ID, NAME, is_active__c,(SELECT ID, NAME, Product__c,Product__r.Name ,Quantity__c, Quantity_in__c, Product_Family__c FROM Demo_Product_Line_Items__r )
                                                       FROM Demo_Product__c ]); 
        
        selectedDemo = new Demo_Product__c();
        
        selectedDemo = demoProductMAP.get(so.Demo_Product__c);
        
        if(selectedDemo != null){
            DemoproductpicklistValues = new List<SelectOption>();
            for(Demo_Product_Line_Item__c dl: selectedDemo.Demo_Product_Line_Items__r ){
                DemoproductpicklistValues.add(new SelectOption(dl.Product__c, dl.Product__r.Name));
            }
        }
        
        allProducts = [SELECT p.Quantity_in_each_box__c, p.Product_Price__c, p.Product_Family__c, p.Product_Description__c, p.Product_Code__c, p.Name, p.Id  
                       FROM Product__c p ];
        
        productpicklistValues.add(new SelectOption('None', '--None--'));
        for(Product__c pr :allProducts ){
        
            productpicklistValues.add(new SelectOption(pr.id, pr.name));   
        }
        
        lastLineItem ++; 
      
    }
   
   public void AddLineItems(){
        
       Sales_Order_Line_Items__c sl = new Sales_Order_Line_Items__c();
       sl.UniqueNumber__c = lastLineItem ;
       sl.SalesOrder__c = so.id;
       sl.Product_From__c = 'Sales Order';
       sl.Quantity_in__c = 'Each';
       
       ++lastLineItem;
       soLine.add(sl);
       salesOrderLineItemsMAP.put(sl.UniqueNumber__c , sl);
       salesOrderOtherFreeLineItemsMAP.put(sl.UniqueNumber__c , sl);
   }
    
   public void deleteSalesOrderLine(){
   
          String  del = apexpages.currentpage().getparameters().get('deletedId');

          
          if(null != del){
              deletedId = Decimal.valueOf(del);
          }
          deletedSalesOrderLineItems.add(deletedId);
          
          if(deletedId != null){ 
              salesOrderLineItemsMAP.remove(deletedId);
              salesOrderOtherFreeLineItemsMAP.remove(deletedId);
              
              soLine = new LIST<Sales_Order_Line_Items__c>();
              soLine.addAll(salesOrderOtherFreeLineItemsMAP.values()); 
            
          } 
   }
   
    public void demoProductRefine(){
         system.debug('IIIIIIII '+ AddFreeItemsBool );
         
        if(AddFreeItemsBool){
        
            Demo_Product__c selectedDemo = new Demo_Product__c();    
            selectedDemo = demoProductMAP.get(so.Demo_Product__c);
            MAP<ID,Boolean> dupcheckMap = new MAP<ID,Boolean>();
            system.debug('UUUUUUUU '+selectedDemo );
            if(selectedDemo != null){
                if(!dupcheckMap.containsKey(selectedDemo.Id)){
                DemoproductpicklistValues = new List<SelectOption>();
                
                for(Demo_Product_Line_Item__c dl: selectedDemo.Demo_Product_Line_Items__r ){
                    DemoproductpicklistValues.add(new SelectOption(dl.Product__c, dl.Product__r.Name));
                }
               
                AddFreeItemsBool = FALSE;
                dupcheckMap.put(selectedDemo.Id, AddFreeItemsBool);
                system.debug('KKKKK '+dupcheckMap);
                Sales_Order_Line_Items__c soDemoL = new Sales_Order_Line_Items__c();
                soDemoL.UniqueNumber__c = lastLineItem;
                soDemoL.SalesOrder__c = so.id;
                soDemoL.Price__c = 0.0;
                soDemoL.Quantity_in__c = 'Each';
                soDemoL.Product_From__c = 'Demo Products';
                
                ++lastLineItem;  
                SODemoLine.add(soDemoL);
                salesOrderLineItemsMAP.put(soDemoL.UniqueNumber__c , soDemoL); 
                }
            }
            else{
                system.debug('333333333334444444444 '+so.Demo_Product__c);
                if(so.Demo_Product__c == null){
                   SODemoLine = new LIST<Sales_Order_Line_Items__c>();
                   
                   system.debug('OOOOOOOOOOOOO '+SODemoLine);
                    if(SODemoLine.size() > 0){
                        DataBase.deleteResult[] res =  DataBase.delete(SODemoLine, FALSE);
                        system.debug('555555566666666 '+res);
                    }    
                }
            } 
        }
        
        if(so.Demo_Product__c == null){
            
            system.debug('777777888888 '+so.Demo_Product__c);
            system.debug('TTTTTTTTTTTT '+so.Id);
           
            if(so.Id != null){ 
                SODemoLine = [SELECT ID, NAME, Name_of_the_Product__c, Order_Quantity__c, Price__c, Product__c, Quantity_in__c, SalesOrder__c, UniqueNumber__c , Product_Type__c, customer_Product__c
                              FROM Sales_Order_Line_Items__c 
                              WHERE SalesOrder__c =: so.Id 
                              AND Product_From__c ='Demo Products' 
                              ORDER BY UniqueNumber__c ASC];
                system.debug('YYYYYYYYY '+SODemoLine );
                if(SODemoLine.size() >0){
                    DataBase.deleteResult[] res =  DataBase.delete(SODemoLine, FALSE);
                } 
                
               
            }
            else{
                system.debug('&&**(( '+SODemoLine);
                SODemoLine = new LIST<Sales_Order_Line_Items__c>();
            }
            
             AddFreeItemsBool = TRUE;
        }         

    }
   
   
    public LIST<Campaign__c> campaignItemsList{get; set;}
    public LIST<Sales_Order_Line_Items__c> campaignSOLine{get; set;}
    // public List<SelectOption> DemoproductpicklistValues{get; set;}  
   
    public void campaignRefine(){
    
        LIST<Sales_Order_Line_Items__c> toDeletecampaignSOLine = new LIST<Sales_Order_Line_Items__c>();
        toDeletecampaignSOLine.addAll(campaignSOLine);
        
        campaignSOLine = new LIST<Sales_Order_Line_Items__c>();
        campaignItemsList = new LIST<Campaign__c>();
        
        //DemoproductpicklistValues = new List<SelectOption>();
        
        if(campaignItems == null){
            campaignItems = 1;
        }
        
        campaignItemsList = [SELECT ID, NAME, 
                             (SELECT ID, NAME, Product__c,Product__r.Name, Product_Family__c, Product_Type__c, Quantity__c, Quantity_in__c,Product_Price__c, Name_of_the_Product__c FROM Campaign_Line_Items__r ORDER BY Product_Type__c )
                             FROM Campaign__c 
                             WHERE ID=: so.Campaign__c];
        
        for(Campaign__c c: campaignItemsList){
        
            for(Campaign_Line_Item__c cl: c.Campaign_Line_Items__r){
            
                // DemoproductpicklistValues.add(new SelectOption(cl.Product__c, cl.Product__r.Name));
                
                Sales_Order_Line_Items__c sl = new Sales_Order_Line_Items__c();
                
                if(!toFindCampaignDuplicate.containsKey(cl.Product__c+cl.Product_Type__c)){
                
                    // sl.SalesOrder__c = so.Id; lastLineItem
                    sl.Quantity_in__c = cl.Quantity_in__c;
                    sl.Product__c = cl.Product__c;
                    sl.Product_Type__c = cl.Product_Type__c;
                    sl.Product_From__c = 'Campaign Products';
                    sl.UniqueNumber__c = lastLineItem;
                    
                    if(campaignItems != 0){
                        sl.Order_Quantity__c = cl.Quantity__c *  campaignItems;
                    }else{
                        sl.Order_Quantity__c = cl.Quantity__c;
                    }
                    
                    if(cl.Product_Price__c != 0.00){
                        sl.Price__c = cl.Product_Price__c ;
                    }
                        sl.Name_of_the_Product__c = cl.Name_of_the_Product__c;
                    
                    if(cl.Product_Type__c == 'Free'){
                        sl.price__c = 0.0;
                    }
                    
                    ++lastLineItem;          
                    
                    campaignSOLine.add(sl);  
                }
                else if(toFindCampaignDuplicate.containsKey(cl.Product__c+cl.Product_Type__c)){
                    
                    sl = toFindCampaignDuplicate.get(cl.Product__c+cl.Product_Type__c);        
                    if(campaignItems != 0){
                        sl.Order_Quantity__c = cl.Quantity__c *  campaignItems;
                    }
                    else{
                        sl.Order_Quantity__c = cl.Quantity__c;
                    }
                    campaignSOLine.add(sl);  
                } 
            }
        }
        if(so.Campaign__c == null){
            if(so.Id != null){ 
                campaignSOLine = [SELECT ID, NAME, Name_of_the_Product__c, Order_Quantity__c, Price__c, Product__c, Quantity_in__c, SalesOrder__c, UniqueNumber__c, Product_Type__c, customer_Product__c 
                                  FROM Sales_Order_Line_Items__c 
                                  WHERE SalesOrder__c =: so.Id 
                                  AND Product_From__c ='Campaign Products' 
                                  ORDER BY UniqueNumber__c ASC ];
                
                if(campaignSOLine.size() >0){
                    DataBase.deleteResult[] res =  DataBase.delete(campaignSOLine, FALSE);
                }  
            }
            else{
                campaignSOLine = new LIST<Sales_Order_Line_Items__c>();
            }
        } 
                     
    }
    

   
        public PageReference save(){
            system.debug('111222333 '+ so);
            PageReference reference;
            LIST<Sales_Order_Line_Items__c> successList = new LIST<Sales_Order_Line_Items__c>();
            LIST<Sales_Order_Line_Items__c> failsList = new LIST<Sales_Order_Line_Items__c>();
           
         
         system.debug('XXXXXXXXXXXXXXXXXXXXXX' + soLine.size() );
         system.debug('VVVVVVVVVVVVVVVVVVVVVVVVV' + SODemoLine.size());
         system.debug('QWEEEEEEEEEEEEEEEEEEE' + campaignSOLine.size());
         
         
        
        if(so.Close_Date__c < system.today()-7)
           {
               //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Order Date cannot be less than last 7 days'));
               errormessage = 'Error: Order Date cannot be less than last 7 days';     
           }    
        else{
            errormessage ='';
            }
            
          if(soLine.size()<= 0 && SODemoLine.size()<= 0 && campaignSOLine.size()<=0 )
         {
            errorMessage1 = 'Error: Please enter atleast one product';  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter atleast one product'));
         }
         else{
         errorMessage1 = '';
         }
         
       if(ta.Outcome_of_Meeting__c == 'Other' && (ta.Outcome_of_Meeting_Other__c == ''|| ta.Outcome_of_Meeting_Other__c == NULL))
            {
                errormessage2 = 'Error: Please Specify Outcome of Meeting (Other)';
            }else{
                   errormessage2 ='';
            }
            
       if(ta.Outcome_of_Meeting__c == 'Asked me to visit again' && (ta.Next_Visit_date__c == NULL|| ta.Next_Visit_Time__c == '' || ta.Next_Visit_Time__c == NULL)){
             errormessage3 = 'Error: Please Specify Next Visit Date And Time';
            }
            else{
             errormessage3 ='';
            }
         if(ta.Next_Visit_Date__c < Date.Today()){
         errormessage4 = 'Error: Next Visit Date cannot be less than today.';
        }else{
             errormessage4 = '';
            }
     
       if(errorMessage == '' && errorMessage1 == '' && errorMessage2 == '' && errormessage3 =='' && errormessage4 == '')
      
      {
            Database.upsertResult res =  DataBase.Upsert(so, false); 
            if(res.isSuccess()){
            
                so = [SELECT Campaign__c, Customer__c, Dealer__c, Demo_Product__c, Close_Date__c, Order_Type__c, Working_with__c, Name 
                      FROM SalesOrder__c WHERE ID =: res.getId()];
                system.debug('11223344 '+ so.Customer__c);  
                system.debug('112233445566 '+ so.Name); 
                ta.Subject = ta.Meeting_Type__c;  
                ta.WhatId = so.Customer__c;
                ta.ActivityDate = so.Close_Date__c; 
                ta.Sales_Order_No__c = so.Name;
                upsert ta;
                
                LIST<Sales_Order_Line_Items__c> goTodeletSalesOrderLineItems = [SELECT Id FROM Sales_Order_Line_Items__c WHERE SalesOrder__c=: res.getId() AND UniqueNumber__c IN: deletedSalesOrderLineItems];
                system.debug('BBBBBBBBBBB '+goTodeletSalesOrderLineItems );
                DataBase.delete(goTodeletSalesOrderLineItems ,false);
                
                
                
                system.debug('BBBBBBBBBBB '+goTodeletSalesOrderLineItems );
                LIST<Sales_Order_Line_Items__c> allRecordLineItems = new LIST<Sales_Order_Line_Items__c>();
       
                //SalesOrder__c
                
                allRecordLineItems.addAll(soLine);
                allRecordLineItems.addAll(SODemoLine);
                allRecordLineItems.addAll(campaignSOLine);
                
                for(Sales_Order_Line_Items__c sl: allRecordLineItems){
                    if(sl.SalesOrder__c == null){
                        sl.SalesOrder__c = res.getId();
                    }    
                    if(sl.Name == null){
                        sl.Name = so.Name +'-{'+ sl.UniqueNumber__c +'}';
                    }
                }
                
                LIST<Database.upsertResult> lineItemsResult =  DataBase.Upsert(allRecordLineItems, false);
                
                integer num = 0;
                
                for(Database.upsertResult re:lineItemsResult){
                    if(re.isSuccess()){
                        successList.add(allRecordLineItems[num]);
                        num++;
                    }else{
                        failsList.add(allRecordLineItems[num]);
                        num++;
                    }
                }
            
            }

            
            if(failsList.isEmpty()){
                reference=new PageReference('/'+res.getId());
                reference.setRedirect(true);
            }
            }
 // }
            return reference;
        }
     
   
}