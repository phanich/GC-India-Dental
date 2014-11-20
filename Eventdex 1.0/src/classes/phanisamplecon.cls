global with sharing class phanisamplecon {

    public bLN_UtillDisplayLinks mytickets { get; set; }

    public PageReference Save() {
    update ticket;
      displyAddGuest =false;
        return null;
    }


    public boolean displyAddGuest { get; set; }
    public Ticket__c ticket{get;set;}
    public List<Ticket__c> listOfTickets{get;set;}
    public string stringSelected{get;set;}
    public MAP<string,Ticket__c> mapIdWithTic{get;set;}
    
    public PageReference edit() {
    system.debug('QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ '+stringSelected);
     displyAddGuest =  true;
     ticket = new Ticket__c();
     ticket = mapIdWithTic.get(stringSelected);
    
        return null;
    }

 
 
 
 public phanisamplecon(){
 mapIdWithTic = new MAP<string,Ticket__c>();
   for( Ticket__c tc :[Select  Item_Pool__r.Badge_Label__c,Item_Type__r.Name,Name,Client_GN_User__r.user__r.MobilePhone,Client_Company__r.Name,Client_Company__r.isPersonAccount__c,Order__r.NAme,order_item__c ,event__r.Name,event__c,item__r.event__r.Name,item__r.Ticket_Settings__c,id, order__c,t.Ticket_Status__c, t.Tag_No__c, t.RSVP__c, t.Parent_ID__c, t.Item_Type__c, t.Item_Pool__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_GN_User__r.user__r.Email,Client_GN_User__r.user__r.userName,Client_User__r.CompanyName, Client_GN_User__c, Client_Company__c From Ticket__c t where order__c!=null and Client_GN_User__c!=null]){
          mapIdWithTic.put(tc.Name,tc);
   }
 }    
    
    
    
    
    @RemoteAction
    global static List<Ticket__c> getAccount(string s) {
       List<Ticket__c> ListTickets = new List<Ticket__c>();
       List<Ticket__c> tickets = new List<Ticket__c>();
       tickets  = [Select  Item_Pool__r.Badge_Label__c,Item_Type__r.Name,Name,Client_GN_User__r.user__r.MobilePhone,Client_Company__r.Name,Client_Company__r.isPersonAccount__c,Order__r.NAme,order_item__c ,event__r.Name,event__c,item__r.event__r.Name,item__r.Ticket_Settings__c,id, order__c,t.Ticket_Status__c, t.Tag_No__c, t.RSVP__c, t.Parent_ID__c, t.Item_Type__c, t.Item_Pool__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_GN_User__r.user__r.Email,Client_GN_User__r.user__r.userName,Client_User__r.CompanyName, Client_GN_User__c, Client_Company__c From Ticket__c t where order__c!=null and Client_GN_User__c!=null];
        ListTickets.addAll(tickets); 
        
       /* for( Ticket__c tc :[Select  Item_Pool__r.Badge_Label__c,Item_Type__r.Name,Name,Client_GN_User__r.user__r.MobilePhone,Client_Company__r.Name,Client_Company__r.isPersonAccount__c,Order__r.NAme,order_item__c ,event__r.Name,event__c,item__r.event__r.Name,item__r.Ticket_Settings__c,id, order__c,t.Ticket_Status__c, t.Tag_No__c, t.RSVP__c, t.Parent_ID__c, t.Item_Type__c, t.Item_Pool__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_GN_User__r.user__r.Email,Client_GN_User__r.user__r.userName,Client_User__r.CompanyName, Client_GN_User__c, Client_Company__c From Ticket__c t where order__c!=null and Client_GN_User__c!=null]){
           for(integer i =0;i<999;i++){
            tickets.add(tc);
              if(tickets.size()==999){
                ListTickets.add(tickets);
                tickets = new List<Ticket__c>();
              }
        }
        
      }*/
      // ListTickets.add(tickets);
    return ListTickets;
  }

    
}