public with sharing class PrimaryOrdergoalscon {

    /*   
        Author   : G.Shruthi Reddy
        Date     : 04/11/2013
        Version  : 1.0 
    */
       public User LoggedInuser{get;set;}
       public Primary_Order_Goals_for_manager__c primarygoalRecord{get; set;}
       public LIST<Primary_Order_Goals_Line_Items__c> PrimarygoalsLineItems{get; set;}
       public MAP<Decimal , Primary_Order_Goals_Line_Items__c> PrimarygoalsLineItemsMAP{get; set;}
       public LIST<Decimal> deletedgoalLineItems{get; set;}
       
       public String SelectedUser{get;set;}
       public List<SelectOption> ChoosenUser{get;set;} 
       public LIST<Dealer__c> allDealers{get; set;}
       public List<SelectOption> picklistValues{get; set;} 

       public LIST<User> usersList{get;set;}
       public String errorMessage{get; set;}
       public boolean Showerror{get;set;}
       
       public Id MasterId{get; set;}
       public Decimal uniqueNo{get; set;}
      
public PrimaryOrdergoalscon(ApexPages.StandardController controller) {
      
      primarygoalRecord = new Primary_Order_Goals_for_manager__c();
      PrimarygoalsLineItems = new LIST<Primary_Order_Goals_Line_Items__c>();
      PrimarygoalsLineItemsMAP = new MAP<Decimal , Primary_Order_Goals_Line_Items__c>();
      
      allDealers = new LIST<Dealer__c>();
      picklistValues = new List<SelectOption>();
      deletedgoalLineItems = new LIST<Decimal>();
      
      LoggedInuser = new User();
      LoggedInuser = [SELECT id, Name, Username, Email, GC_User_Role__c,UserRoleId, State__c, Manager.Id from User where id =: UserInfo.getUserId()];
 
      
      uniqueNo = 1;
            
            this.primarygoalRecord = (Primary_Order_Goals_for_manager__c )Controller.getRecord();
            if(null != Controller.getId()){
            MasterId = Controller.getId();
           system.debug('######################' + MasterId );
            primarygoalRecord = [SELECT ID, NAME,End_Date__c,Start_Date__c,Sales_Manager__c,Target_Revenue1__c,Target_Revenue__c, Total_Revnue__c FROM Primary_Order_Goals_for_manager__c WHERE id=: MasterId   ];
           
            }
             
             PrimarygoalsLineItems =  [SELECT  Id,Dealer__c,Issued_Date__c,UniqueName__c,Name, Primary_Order_Goals_for_manager__c,Target_Revenue__c,Revenue_Generated__c From Primary_Order_Goals_Line_Items__c  WHERE Primary_Order_Goals_for_manager__c =:  primarygoalRecord.Id];
             for(Primary_Order_Goals_Line_Items__c dpl:PrimarygoalsLineItems){
             dpl.UniqueName__c = uniqueNo ;
             PrimarygoalsLineItemsMAP .put(dpl.UniqueName__c, dpl);
             uniqueNo++;
                  //uniqueNo = dpl.UniqueName__c ;
            }

      LIST<User> usersList = new LIST<User>();
      usersList = [SELECT ID,NAME FROM User where GC_User_Role__c =: 'Manager' AND isActive=: True ORDER BY Name];
      
      ChoosenUser = new LIST<SelectOption>(); 
       ChoosenUser.add(new SelectOption('None', '--None--'));
        for(User u: usersList){
            ChoosenUser.add(new SelectOption(u.Id, U.Name));
            System.debug('AAAAAAAAAAAAAAAAAAA' + ChoosenUser);
            SelectedUser = primarygoalRecord.Sales_Manager__c;
        }
            
            allDealers = [Select    p.Name,  p.Id  From Dealer__c p ];
            picklistValues.add(new SelectOption('None', '--None--'));
           for(Dealer__c pr :allDealers ){
               picklistValues.add(new SelectOption(pr.id, pr.name));
            }
    //uniqueNo++;
    }
    
    
    public void addMore(){
    errorMessage = '';
    /*
    for(Primary_Order_Goals_Line_Items__c dli: PrimarygoalsLineItems){
   if(dli.Revenue_Generated__c == null)
            {
                 errorMessage += '<br/>'+ 'Revenue Generated is empty';
            }
         
            if(dli.Issued_Date__c== null)
            {
                 errorMessage += '<br/>'+ 'Issued Date is empty';
            }
      }      
  */        
       
 
 if(errormessage == ''){
            Primary_Order_Goals_Line_Items__c gl = new Primary_Order_Goals_Line_Items__c();
            gl.Primary_Order_Goals_for_manager__c = MasterId;
            gl.UniqueName__c =  uniqueNo;
            uniqueNo++;
            
            PrimarygoalsLineItems.add(gl);
            PrimarygoalsLineItemsMAP.put(gl.UniqueName__c , gl);
}
    //   }
     }
     
     public void deletegoalLine(){  
        String  del = apexpages.currentpage().getparameters().get('deletedId');
        Decimal deletedId;
        if( null != del){
            deletedId = Decimal.valueOf(del);
        } 
        deletedgoalLineItems.add(deletedId);
        if(deletedId != null){ 
            PrimarygoalsLineItemsMAP.remove(deletedId);         
            PrimarygoalsLineItems = new LIST<Primary_Order_Goals_Line_Items__c >();
            PrimarygoalsLineItems.addAll(PrimarygoalsLineItemsMAP.values());
        }
        }
     
     
    public PageReference saveall(){
       PageReference pageRef;
      errormessage = '';
        if(primarygoalRecord.Start_Date__c >= primarygoalRecord.End_Date__c){
            errormessage =  'Error: Start Date cannot be greater than Or equal to End Date';
        }
       /* for(Primary_Order_Goals_Line_Items__c pli: PrimarygoalsLineItems){
            if(pli.Issued_Date__c < primarygoalRecord.Start_Date__c  || pli.Issued_Date__c > primarygoalRecord.End_Date__c){
               errormessage =  'Error: Issued Date must be between Start And End Date';
            }
        
        }
        */
        
   if(errorMessage =='' ){
         primarygoalRecord.Sales_Manager__c= SelectedUser;
         
             if( primarygoalRecord.OwnerId != null){
                 primarygoalRecord.OwnerId = SelectedUser;
             }else If(primarygoalRecord.OwnerId != SelectedUser ){
                 primarygoalRecord.OwnerId = SelectedUser;
             }
         
            DataBase.Upsertresult res = DataBase.Upsert(primarygoalRecord, false);
            if(res.isSuccess())
            {  
            primarygoalRecord =   [SELECT ID, Name,Start_Date__c,End_Date__c,Sales_Manager__c,Target_Revenue__c,Total_Revnue__c FROM Primary_Order_Goals_for_manager__c WHERE Id=: res.getId()]; 
             LIST<Primary_Order_Goals_Line_Items__c > goTodeletedgoalLineItems = [SELECT  Id,Dealer__c,Issued_Date__c,Target_Revenue__c,UniqueName__c,Name, Primary_Order_Goals_for_manager__c,Revenue_Generated__c From Primary_Order_Goals_Line_Items__c
                                                                           where Primary_Order_Goals_for_manager__c  =: res.getId() 
                                                                            AND UniqueName__c IN: deletedgoalLineItems];
                DataBase.delete(goTodeletedgoalLineItems,false); 
                
            LIST<Primary_Order_Goals_Line_Items__c > allLineItems = new LIST<Primary_Order_Goals_Line_Items__c >();
              allLineItems.addAll(PrimarygoalsLineItems);
                for(Primary_Order_Goals_Line_Items__c d1: allLineItems){
                    if(d1.Primary_Order_Goals_for_manager__c == null){
                   d1.Primary_Order_Goals_for_manager__c = res.getId();
                }  
                if(d1.Name == null){
                         d1.Name = primarygoalRecord.Name+'-{'+ d1.UniqueName__c +'}';
                     }  
                 }
                 
                 DataBase.Upsert(allLineItems, false);
                 pageRef = new PageReference('/'+res.getId());
               
                pageRef.setredirect(true);  
    
         }
          }
         else{
         }
    
        return pageRef;
    }

}