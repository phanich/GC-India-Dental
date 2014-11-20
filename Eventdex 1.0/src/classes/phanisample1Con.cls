public with sharing class phanisample1Con {

    public BLN_UtillDisplayLinks myticket { get; set; }

  public List<BLN_Event__c> accList{get;set;}
 public phanisample1Con(){
   
   accList =new List<BLN_Event__c>();
   accList =[select id,NAme from BLN_Event__c];
   
 }
 
  

}