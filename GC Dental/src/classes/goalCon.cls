public with sharing class goalCon {
 
 /*   
    Author   : Naga Mallikarjuna Rao
    Date     : 18/09/2013
    Version  : 1.0 
 */
    
    public MAP<Id, String> findDupUser{get; set;}
    
    public goal__c goalRecord{get; set;}
    public LIST<Goal_Line_Item__c> goalsLineItems{get; set;}
    public MAP<Decimal , Goal_Line_Item__c> goalsLineItemsMAP{get; set;}
    
    public LIST<Product__c> allProducts{get; set;}
    public List<SelectOption> picklistValues{get; set;}  
    public MAP<String, String> findDupProducts{get; set;}
    
    public Id MasterId{get;set;}
    public Integer uniqueNo{get;set;}
    public String errorMessage{get;set;}
    public Decimal deletedId{get;set;}
    public LIST<ID> removeDup{get; set;} 
    
    public List<SelectOption> ChoosenUser{get;set;}
    public String SelectedUser{get;set;}
    public User LoggedinUser{get;set;}
    
    public goalCon(ApexPages.StandardController controller) {
        goalRecord = new goal__c();
        goalsLineItems = new LIST<Goal_Line_Item__c>();
        goalsLineItemsMAP = new MAP<Decimal , Goal_Line_Item__c>();
         
        allProducts = new LIST<Product__c>();
        picklistValues = new List<SelectOption>();
        findDupProducts = new MAP<String, String>();
        findDupUser  = new MAP<Id, String>();
        
        
        // Mahesh Edit start
        
        LoggedInuser = new User();
        LoggedInuser = [SELECT Id, Name, Username, Email, GC_User_Role__c,UserRoleId, State__c, Manager.Id FROM User WHERE Id =: UserInfo.getUserId() AND isActive =: TRUE];

        SET<ID> UserRolesUnderManager = new SET<ID>();    
        SET<ID> loginUserRollId = new SET<ID>();
        User ForUserRoleID = new User();
        
        ForUserRoleID = [SELECT Id,UserRoleId, Name, Email, UserName FROM User WHERE Id=: UserInfo.getUserId() AND isActive =: TRUE ORDER BY Name ];    
         
        loginUserRollId.add(ForUserRoleID.UserRoleId); 
        
        UserRolesUnderManager.add(ForUserRoleID.UserRoleId);
        UserRolesUnderManager.addAll(getAllSubRoleIds(loginUserRollId));
        
        MAP<Id,User> managerListMap = new MAP<Id,User>([SELECT ID, Name, Email, UserName FROM USER WHERE isActive =: TRUE AND (GC_User_Role__c = 'Manager' OR GC_User_Role__c = 'Executive') AND UserRoleID IN: UserRolesUnderManager ORDER BY Name]);
             
        deletedGoalLineItems = new LIST<Decimal>();
        uniqueNo = 1;
        
        this.goalRecord= (goal__c )Controller.getRecord();
        removeDup = new LIST<ID>();
        
        if(null != Controller.getId()){
        
             MasterId = Controller.getId();
             goalRecord = [SELECT ID, NAME,End_Date__c,Start_Date__c,Sales_Executive__c, isActive__c FROM Goal__c WHERE id=: Controller.getId() ];
            
                removeDup.add(goalRecord.id);
            
             for(Goal_Line_Item__c glp: [SELECT  g.Id, g.Revenue_Goal__c, g.Quantity_Goal__c, g.Product__c, g.Product_Quantity_in__c,g.Name, g.Goal__c, g.Achieved_Revenue__c, g.Achieved_Quantity_Goal__c,g.UniqueName__c From Goal_Line_Item__c g WHERE Goal__c=: Controller.getId()]){
                 glp.UniqueName__c =  uniqueNo;
                 
                 goalsLineItemsMAP.put(glp.UniqueName__c , glp);
                 
                 uniqueNo++;
             }
              
             goalsLineItems.addAll(goalsLineItemsMAP.values());
             // [SELECT  g.Id, g.Revenue_Goal__c, g.Quantity_Goal__c, g.Product__c, g.Product_Quantity_in__c, g.Name, g.Goal__c, g.Achieved_Revenue__c, g.Achieved_Quantity_Goal__c From Goal_Line_Item__c g WHERE Goal__c=: Controller.getId()]; 
        }
        
        LIST<User> userslist = new List<user>();
        userslist.addAll(managerListMap.values());
        userslist.sort();
        
        ChoosenUser = new LIST<SelectOption>(); 
        ChoosenUser.add(new SelectOption('None', '--None--')); 
        
        for(User u: userslist){
            ChoosenUser.add(new SelectOption(u.Id, U.Name));
            SelectedUser = goalRecord.Sales_Executive__c;
        }
        
        
        allProducts = [Select   p.Quantity_in_each_box__c, p.Product_Price__c, p.Product_Family__c, p.Product_Description__c, p.Product_Code__c, p.Name,  p.Id  From Product__c p ORDER BY p.Name];

        if(UserInfo.getOrganizationId() == '00DN00000003jpSMAQ'){
           picklistValues.add(new SelectOption('a06N0000000u123456', '--None--'));
        }
        else{
           picklistValues.add(new SelectOption('a089000000Mg123456', '--None--')); 
        }
        
        for(Product__c pr :allProducts ){
           picklistValues.add(new SelectOption(pr.id, pr.name));  
        }
       
       for(Goal__c gol: [SELECT ID, NAME, End_Date__c,Start_Date__c,Sales_Executive__c, Sales_Executive__r.LastName, isActive__c FROM Goal__c WHERE isActive__c =: TRUE AND ID NOT IN: removeDup  ]){
               findDupUser.put(gol.Sales_Executive__c , gol.Sales_Executive__r.LastName);
       }

    }
    
    
    public void addMore(){
        
        findDupProducts = new Map<String, String>();
        errorMessage = '';
         
        for(Goal_Line_Item__c glb: goalsLineItems){          
            if(glb.Product__c != null){
                if(findDupProducts.containsKey(glb.Product__c)){
                     errorMessage = 'Error: Duplicate product found, please change the product';
                }
                else{    
                     findDupProducts.put(glb.Product__c, glb.Product__c);
                }
            } 
           if(glb.Product__c == 'a06N0000000u123456' || glb.Product__c == 'a089000000Mg123456'){
               errorMessage = 'Error: Please select the product from picklist.';
           }           
        }

        if(errorMessage == ''){    
           
            Goal_Line_Item__c gl = new Goal_Line_Item__c();
            gl.Goal__c = MasterId;
            gl.UniqueName__c =  uniqueNo;
            uniqueNo++;
            gl.Product_Quantity_in__c = 'Each';
               
            goalsLineItems.add(gl);
            goalsLineItemsMAP.put(gl.UniqueName__c , gl);
        }
    }
  
   
    public LIST<Decimal> deletedGoalLineItems{get; set;}
   
    public void deleteGoalLine(){
        
      String  del = apexpages.currentpage().getparameters().get('deletedId');

      if( null != del){
          deletedId = Decimal.valueOf(del);
      }
      
      deletedGoalLineItems.add(deletedId);
      
      if(deletedId != null){ 
          goalsLineItemsMAP.remove(deletedId);
      
          goalsLineItems = new LIST<Goal_Line_Item__c>();
          goalsLineItems.addAll(goalsLineItemsMAP.values());
      }
      
    }
    
    public PageReference saveAllRecords(){
    
        PageReference reference;
        findDuplicate(); 
        
        if(goalRecord.Start_Date__c >= goalRecord.End_Date__c){
            errorMessage = 'Error: End date must be greater than Start date';            
        }
        
        if(goalsLineItems.size() <= 0){
            errorMessage = 'Error: Please add atleast one product to set the Goal.';
        }

       if(errorMessage =='' ){
       
           goalRecord.Sales_Executive__c = SelectedUser;
            if( goalRecord.OwnerId != null){
                 goalRecord.OwnerId = SelectedUser;
             }else If(goalRecord.OwnerId != SelectedUser ){
                 goalRecord.OwnerId = SelectedUser;
             }

           Database.upsertResult res =  DataBase.Upsert( goalRecord, false);
            
           if(res.isSuccess()){
            
               goal__c goal = [SELECT Id, Name FROM goal__c WHERE ID =: res.getId()];
                
              //  deletedGoalLineItems
                LIST<Goal_Line_Item__c> goTodeletGoalLineItems = [SELECT  g.Id, g.Revenue_Goal__c, g.Quantity_Goal__c, g.Product__c, g.Product_Quantity_in__c,g.Name, g.Goal__c, g.Achieved_Revenue__c, g.Achieved_Quantity_Goal__c,g.UniqueName__c From Goal_Line_Item__c g WHERE Goal__c=: res.getId()  AND UniqueName__c IN: deletedGoalLineItems];
                DataBase.delete(goTodeletGoalLineItems ,false);
                
                for(Goal_Line_Item__c gli: goalsLineItems){
                    
                    
                    if(gli.Product__c == 'a06N0000000u123456' || gli.Product__c == 'a089000000Mg123456'){
                        errorMessage = 'Error: Please select the product from picklist.';
                        
                    }
                    
                    if(gli.Name == null){
                        gli.Name = goal.Name +'-{'+ gli.UniqueName__c +'}';
                    }
                    
                    if(gli.Goal__c == null){
                        gli.Goal__c = res.getId();
                    }
                    
                }
                if(errorMessage == ''){ 
  
                    DataBase.Upsert( goalsLineItems , false);
                                                        
                    reference=new PageReference('/'+res.getId());
                    reference.setRedirect(true);
                }   

            }
        }
        else{
        }
        return reference;      
    }
    
    
    
    public void findDuplicate(){
        
          findDupProducts = new Map<String, String>();
          errorMessage ='';
          
         for(Goal_Line_Item__c gli: goalsLineItems ){
             
             if(findDupProducts.containsKey(gli.Product__c)){
                 errorMessage = 'Error: Duplicate product found, please change the product.';
             }else{    
                 findDupProducts.put(gli.Product__c, gli.Product__c);
                  
             }
         }
         
         findDupUser = new MAP<Id, String>();
   
         for(Goal__c gol: [SELECT ID, NAME, End_Date__c,Start_Date__c,Sales_Executive__c, Sales_Executive__r.LastName, isActive__c 
                                 FROM Goal__c WHERE isActive__c =: TRUE AND Sales_Executive__c =: goalRecord.Sales_Executive__c AND ID NOT IN: removeDup AND End_Date__c >: goalRecord.Start_Date__c ]){      
               findDupUser.put(gol.Sales_Executive__c , gol.Sales_Executive__r.LastName);
         }  
         if(findDupUser.containsKey(goalRecord.Sales_Executive__c)){
          //   errorMessage += '<br/> Sales Executive had the goal for this month Please contact Administrator';
         }
    }
    
    public SET<ID> getAllSubRoleIds(Set<ID> roleIds){
        SET<ID> currentRoleIds = new SET<ID>();
        
        for(UserRole userRole :[SELECT Id FROM UserRole WHERE ParentRoleId 
                                IN :roleIds AND ParentRoleID != null])
        currentRoleIds.add(userRole.Id); 
        if(currentRoleIds.size() > 0)
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds)); 
        return currentRoleIds;
    }  
    
}