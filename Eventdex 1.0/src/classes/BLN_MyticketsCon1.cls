public with sharing class BLN_MyticketsCon1 {
  
   public BLN_Mytickets_BAL blnMyticketsBal {get;set;}
   public List<List<BLN_Mytickets_BAL.inncls>> listOfListOrders{get;set;}
   public string loginUserId{get;set;}
   public string selectedEvent{get;set;} 
   public List<BLN_Mytickets_BAL.inncls> inncurrentTickets {get;set;} 
   public string urlCheck {get;set;}
   public integer ui {get;set;}
    public List<Account> acc{get;set;}
   public List<List<Account>> accList{get;set;}
   
   
  public BLN_MyticketsCon1(){
    blnMyticketsBal = new BLN_Mytickets_BAL();
    loginUserId ='005c00000014wf0';
    selectedEvent =ApexPages.currentPage().getParameters().get('counter'); 
    onchangeEvent(); // Calling this method for getting all the order,tickets and orderitems of events
 }
 
 
 
      public void onchangeEvent(){
        listOfListOrders = new List<List<BLN_Mytickets_BAL.inncls>>();
         inncurrentTickets= new List<BLN_Mytickets_BAL.inncls>();
       
        accList = new List<List<Account>> ();
         account a = [select id,Name,AccountNumber,number__c from account where id ='001c000000ZLnES'];
         acc = new List<Account>();
         
        urlCheck = 'BLN_Orders';
       
        for(BLN_Mytickets_BAL.inncls innTotal : blnMyticketsBal.userTickets(loginUserId,selectedEvent,urlCheck )){
         integer k=0;
            for(integer f=0;f<700;f++){
              acc.add(a);
             k++;   
          }
       system.debug('SSSSSSSSSSSSSSSSSSSSSSSSSSS '+k);     
              
          if(k==700){
              accList.add(acc); 
              acc = new List<Account>();
              k=0;
          }
      }
    
       accList.add(acc); 
      ui=accList.size();
    }
 
}