public with sharing class DemoproductsCon {
    
    /*   
        Author   : G.Shruthi Reddy
        Date     : 18/09/2013
        Version  : 1.0 
    */
   
    public Demo_Product__c demoRecord{get; set;}
    public LIST<Demo_Product_Line_Item__c> demoLineItems{get; set;}
    
    public MAP<Decimal , Demo_Product_Line_Item__c> demoLineItemsMAP{get; set;}
    public LIST<Decimal> deleteddemoLineItems{get; set;}
    public boolean Showerror{get;set;}
    
    public Id MasterId{get; set;}
    public Decimal uniqueNo{get; set;}
    public String errorMessage{get; set;}
    
    public LIST<Product__c> allProducts{get; set;}
    public List<SelectOption> picklistValues{get; set;} 
    public MAP<String, String> findDupProducts{get; set;} 
    
    public List<SelectOption> ChoosenUser{get;set;}
    public String SelectedUser{get;set;}
    public User LoggedinUser{get;set;}
 
public DemoproductsCon(ApexPages.StandardController controller) {

       demoRecord = new Demo_Product__c ();
       demoLineItems = new LIST<Demo_Product_Line_Item__c>();
       demoLineItemsMAP = new MAP<Decimal , Demo_Product_Line_Item__c>();
       
       allProducts = new LIST<Product__c>();
       picklistValues = new List<SelectOption>();
       findDupProducts = new Map<String, String>();
       deleteddemoLineItems = new LIST<Decimal>();
       
        LoggedInuser = new User();
        LoggedInuser = [SELECT id, Name, Username, Email, GC_User_Role__c,UserRoleId, State__c, Manager.Id from User where id =: UserInfo.getUserId()];

        SET<ID> UserRolesUnderManager = new SET<ID>();    
        SET<ID> loginUserRollId = new SET<ID>();
        User ForUserRoleID = new User();
        
        ForUserRoleID = [SELECT id,UserRoleId, Name, Email, UserName from User where id=: UserInfo.getUserId()];     
        loginUserRollId.add(ForUserRoleID.UserRoleId);   
        
        UserRolesUnderManager.add(ForUserRoleID.UserRoleId);
        UserRolesUnderManager.addAll(getAllSubRoleIds(loginUserRollId));
        
        MAP<Id,User> managerListMap = new MAP<Id,User>([SELECT ID, Name, Email, UserName FROM USER WHERE isActive =: TRUE AND (GC_User_Role__c = 'Manager' OR GC_User_Role__c = 'Executive') AND  UserRoleID IN: UserRolesUnderManager ORDER BY Name]);
       
       
       uniqueNo = 1;

       
  
       this.demoRecord= (Demo_Product__c )Controller.getRecord();
       if(null != Controller.getId()){
        
             MasterId = Controller.getId();
             demoRecord = [SELECT ID, Name,From__c,To__c,is_active__c,Sales_Executive__c FROM Demo_Product__c WHERE Id=: MasterId  ];
           }
           demoLineItems =  [SELECT  Id, Quantity__c, Quantity_in__c,UniqueName__c,Name, Demo_Product__c,Product__c From Demo_Product_Line_Item__c  WHERE Demo_Product__c =: demoRecord.Id];
             for(Demo_Product_Line_Item__c dpl:demoLineItems){
                 dpl.UniqueName__c =  uniqueNo ;  
                 demoLineItemsMAP.put(dpl.UniqueName__c, dpl);
                 uniqueNo++;
                 //uniqueNo = dpl.UniqueName__c ;
             }
             
             LIST<User> userslist = new List<user>();
             userslist.addAll(managerListMap.values());
             userslist.sort();
             
             ChoosenUser = new LIST<SelectOption>();
             ChoosenUser.add(new SelectOption('None', '--None--')); 
             for(User u: userslist){
                 ChoosenUser.add(new SelectOption(u.Id, U.Name));
                 SelectedUser = demoRecord .Sales_Executive__c;
             }
 
       allProducts = [Select   p.Quantity_in_each_box__c, p.Product_Price__c, p.Product_Family__c, p.Product_Description__c, p.Product_Code__c, p.Name,  p.Id  From Product__c p ];
       if(UserInfo.getOrganizationId() == '00DN00000003jpSMAQ'){
          picklistValues.add(new SelectOption('a06N0000000u123456', '--None--'));
       }
       else{
          picklistValues.add(new SelectOption('a089000000Mg123456', '--None--')); 
       }
        
       for(Product__c pr :allProducts ){
           picklistValues.add(new SelectOption(pr.id, pr.name));
       }
      //uniqueNo++;
    
}
      public void addMore(){
         findDupProducts = new Map<String, String>();   
         errorMessage = '';

         for(Demo_Product_Line_Item__c dli: demoLineItems){
             if(dli.Product__c != null)
             {     
                    if(findDupProducts.containsKey(dli.Product__c)){
                         errorMessage = 'Error: Duplicate product found, please change the product';                  
                    }
                    else{    
                         findDupProducts.put(dli.Product__c, dli.Product__c);
                    }
             }
             if(dli.Product__c == 'a06N0000000u123456' || dli.Product__c == 'a089000000Mg123456'){
                 errorMessage = 'Error: Please select the product from picklist.';
             }   
         }
  
         if(errorMessage == ''){              
            Demo_Product_Line_Item__c dl = new Demo_Product_Line_Item__c ();
            dl.Demo_Product__c = MasterId;
            dl.UniqueName__c =  uniqueNo;
            dl.Quantity_in__c = 'Each';
            
            uniqueNo++;
            
            demoLineItems.add(dl);
            demoLineItemsMAP.put(dl.UniqueName__c , dl);
         }
  }

     public void deletedemoLine(){
        
      String  del = apexpages.currentpage().getparameters().get('deletedId');
      Decimal deletedId;
      if( null != del){
          deletedId = Decimal.valueOf(del);
      }
      
      deleteddemoLineItems.add(deletedId);
      
      if(deletedId != null){ 
          demoLineItemsMAP.remove(deletedId);
      
          demoLineItems = new LIST<Demo_Product_Line_Item__c>();
          demoLineItems.addAll(demoLineItemsMAP.values());
      }
    }

    public  PageReference saveAllRecords(){

        PageReference pageRef;
        findDuplicate();
        
        
        if(demoRecord.From__c >= demoRecord.To__c){
            errormessage = 'Error: From Date cannot be greater than Or equal to To Date';
        }
        
        if(demoLineItems.size() <= 0){
            errormessage = 'Error: Please add atleast one product to save the Demo Product information.';
        }
       
       if(errorMessage == ''){
           demoRecord.Sales_Executive__c= SelectedUser;
           
        
            if( demoRecord.OwnerId != null){
                 demoRecord.OwnerId = SelectedUser;
            }
            else If(demoRecord.OwnerId != SelectedUser ){
                 demoRecord.OwnerId = SelectedUser;
            }
            DataBase.Upsertresult res = DataBase.Upsert(demoRecord, false);
            if(res.isSuccess())
            {   
               demoRecord =   [SELECT ID, Name,From__c,To__c,is_active__c,Sales_Executive__c FROM Demo_Product__c WHERE Id=: res.getId()];  
                    
                LIST<Demo_Product_Line_Item__c> goTodeletdemoLineItems = [SELECT  d.Id, d.Quantity__c, d.Quantity_in__c,d.UniqueName__c,d.Name, d.Demo_Product__c,d.Product__c From Demo_Product_Line_Item__c d WHERE Demo_Product__c =: res.getId()  AND UniqueName__c IN: deleteddemoLineItems];
                DataBase.delete(goTodeletdemoLineItems ,false);
                
                LIST<Demo_Product_Line_Item__c> allLineItems = new LIST<Demo_Product_Line_Item__c>();
                allLineItems.addAll(demoLineItems);
                
                for(Demo_Product_Line_Item__c d1: allLineItems){
                    if(d1.Product__c == 'a06N0000000u123456' || d1.Product__c == 'a089000000Mg123456'){
                        errorMessage = 'Error: Please select the Product from picklist.';
                    }
                    
                    if(d1.Demo_Product__c == null){
                        d1.Demo_Product__c  = res.getId();
                    }  
                    if(d1.Name == null){
                        d1.Name = demoRecord.Name+'-{'+ d1.UniqueName__c +'}';
                    } 
                }  
                  
                if(errorMessage == ''){ 
                    DataBase.Upsert(allLineItems, false);
                    pageRef = new PageReference('/'+res.getId());
                    pageRef.setredirect(true); 
                }     
            }
        }
        else{
        }
        return pageRef;
    }
   
    public void findDuplicate(){    
        findDupProducts = new Map<String, String>();
        errorMessage ='';
          
        for(Demo_Product_Line_Item__c dli: demoLineItems ){            
             if(findDupProducts.containsKey(dli.Product__c)){
                 errorMessage = 'Error: Duplicate product found, please change the product';
             }
             else{    
                 findDupProducts.put(dli.Product__c, dli.Product__c);      
             }
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