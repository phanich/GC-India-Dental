public with sharing class campaignCon{

/*   
    Author   : Mahesh Sakunala
    Version  : 1.0 
    Created Date     : 21/09/2013
    Last Modified Date : 15/10/2013
    Last Modified By: Mahesh Sakunala
 */
 
// -------------------------------------- Variable Declaration Start ---------------------------------------
    public Campaign__c campaignRecord{get; set;}
    public LIST<Campaign_Line_Item__c> campaignLineItems{get; set;}
    public MAP<Decimal ,Campaign_Line_Item__c> campaignLineItemsMAP{get; set;}
    public LIST<Decimal> deletedCampaignLineItems{get; set;}
    
    public LIST<Product__c> allProducts{get; set;}
    public List<SelectOption> picklistValues{get; set;}  
    public MAP<String, String> findDupProducts{get; set;}
    
    public ID MasterId{get;set;}
    public Integer uniqueNo{get;set;}
    public String errorMessage{get;set;} 
    public Decimal deletedId{get;set;}
// -------------------------------------- Variable Declaration End ------------------------------------------
  
// ---------------------------------------- Constructor Start ------------------------------------------------    
    public campaignCon(ApexPages.StandardController controller){
        campaignRecord = new Campaign__c();
        campaignLineItems = new LIST<Campaign_Line_Item__c>();
        campaignLineItemsMAP = new MAP<Decimal , Campaign_Line_Item__c>();
         
        allProducts = new LIST<Product__c>();
        picklistValues = new List<SelectOption>();
        findDupProducts = new MAP<String, String>();
       
        deletedCampaignLineItems = new LIST<Decimal>();
        uniqueNo = 1;
        
        this.campaignRecord = (Campaign__c)Controller.getRecord();
        LIST<ID> removeDup = new LIST<ID>();
        
        if(null != Controller.getId()){
                   
            MasterId = Controller.getId();
            campaignRecord = [SELECT Id, Name, Activation_Date__c, Deactivation_Date__c, Campaign_Description__c 
                              FROM Campaign__c 
                              WHERE id=: Controller.getId()];               
            removeDup.add(campaignRecord.id);
            
            for(Campaign_Line_Item__c cli : [SELECT c.Id, c.Name, c.Campaign__c, c.Product_Price__c, c.Product__c, c.Product_Family__c, c.Product_Type__c, c.Quantity__c, c.Quantity_in__c, c.UniqueNo__c 
                                             FROM Campaign_Line_Item__c c 
                                             WHERE Campaign__c =: Controller.getId()]){
                 cli.UniqueNo__c =  uniqueNo;               
                 campaignLineItemsMAP.put(cli.UniqueNo__c, cli);                
                 uniqueNo++;
            }             
            campaignLineItems.addAll(campaignLineItemsMAP.values());
        }
        
        allProducts = [SELECT p.Quantity_in_each_box__c, p.Product_Price__c, p.Product_Family__c, p.Product_Description__c, p.Product_Code__c, p.Name,  p.Id  
                       FROM Product__c p 
                       ORDER BY p.Name];
        if(UserInfo.getOrganizationId() == '00DN00000003jpSMAQ'){
           picklistValues.add(new SelectOption('a06N0000000u123456', '--None--'));
        }
        else{
           picklistValues.add(new SelectOption('a089000000Mg123456', '--None--')); 
        }
        for(Product__c pr: allProducts){
            picklistValues.add(new SelectOption(pr.id, pr.name));
        }        
   }
// ----------------------------------------- Constructor End -------------------------------------------------

// --------------------------------------- Add More Method Start ---------------------------------------------
    public void addMore(){
        
        findDupProducts = new Map<String, String>();
        errorMessage = '';
                
        for(Campaign_Line_Item__c clk : campaignLineItems){ 
            if(clk.Product__c != null){
                if(findDupProducts.containsKey(clk.Product__c + clk.Product_Type__c + clk.Quantity_in__c)){
                     errorMessage = 'Error: Duplicate product found, please change the product';
                 }else{    
                     findDupProducts.put(clk.Product__c + clk.Product_Type__c + clk.Quantity_in__c, clk.Product__c + clk.Product_Type__c + clk.Quantity_in__c);
                 }
            }  
            if(clk.Product__c == 'a06N0000000u123456' || clk.Product__c == 'a089000000Mg123456'){
               errorMessage = 'Error: Please select the product from picklist.';
           }         
        }
 
        if(errorMessage == ''){    
           
            Campaign_Line_Item__c cl = new Campaign_Line_Item__c();
            cl.Campaign__c = MasterId;
            cl.UniqueNo__c =  uniqueNo;
            cl.Quantity_in__c = 'Each';
            cl.Product_Type__c = 'Paid';
            cl.Name = campaignRecord.Name +'-{'+ uniqueNo +'}';
            uniqueNo++;

            campaignLineItems.add(cl);
            campaignLineItemsMAP.put(cl.UniqueNo__c, cl);
        }
  }
// ---------------------------------------- Add More Method End ----------------------------------------------

// ------------------------------------ Delete Line Item Method Start ----------------------------------------
    
    public void deleteCampaignLine(){   
        String  del = apexpages.currentpage().getparameters().get('deletedId');

        if( null != del){
            deletedId = Decimal.valueOf(del);
        }       
        deletedcampaignLineItems.add(deletedId);
        
        if(deletedId != null){ 
            campaignLineItemsMAP.remove(deletedId);         
            campaignLineItems = new LIST<Campaign_Line_Item__c>();
            campaignLineItems.addAll(campaignLineItemsMAP.values());
        }
    }
    
// ------------------------------------ Delete Line Item Method Start ----------------------------------------

// ------------------------------------- Find Duplicates Method Start -----------------------------------------

    public void findDuplicate(){   
        findDupProducts = new Map<String, String>();
        errorMessage ='';
        
        for(Campaign_Line_Item__c clit : campaignLineItems){    
            if(findDupProducts.containsKey(clit.Product__c + clit.Product_Type__c + clit.Quantity_in__c)){
                errorMessage = 'Error: Duplicate product found, please change the product';
            }
            else{    
                findDupProducts.put(clit.Product__c + clit.Product_Type__c + clit.Quantity_in__c, clit.Product__c + clit.Product_Type__c + clit.Quantity_in__c);        
            }
        }
    }

// -------------------------------------- Find Duplicates Method End ------------------------------------------

// ------------------------------------- Save All Records Method Start -----------------------------------------

    public PageReference saveAllRecords(){
        
        PageReference reference;
        findDuplicate();
               
        if(campaignRecord.Activation_Date__c > campaignRecord.Deactivation_Date__c){
            errormessage = 'Error: Deactivation date must be greater than Activation date';            
        }
        
        if(campaignLineItems.size() <= 0){
            errormessage = 'Error: Please add atleast one product to save the Campaign.';
        }
 
        if(errorMessage == ''){
            Database.upsertResult res =  DataBase.Upsert(campaignRecord, false); 
            
            if(res.isSuccess()){           
                LIST<Campaign_Line_Item__c> goTodeletedcampaignLineItems = [SELECT  c.Id, c.Name, c.Campaign__c, c.Product__c, c.Product_Family__c, c.Product_Type__c, c.Quantity__c, c.Quantity_in__c, c.UniqueNo__c 
                                                                            FROM Campaign_Line_Item__c c 
                                                                            WHERE Campaign__c =: res.getId() 
                                                                            AND UniqueNo__c IN: deletedCampaignLineItems];
                DataBase.delete(goTodeletedcampaignLineItems,false);

                for(Campaign_Line_Item__c clit : campaignLineItems){
                    clit.Campaign__c = res.getId();
                    
                    if(clit.Product__c == 'a06N0000000u123456' || clit.Product__c == 'a089000000Mg123456'){
                        errorMessage = 'Error: Please select the product from picklist.';
                    }

                } 
                if(errorMessage == ''){ 
                    DataBase.Upsert(campaignLineItems, false);
                    
                    reference=new PageReference('/'+res.getId());
                    reference.setRedirect(true);
                }
            }
        }
        else{  
        }  
        return reference;  
    }

// -------------------------------------- Save All Records Method End ------------------------------------------

}