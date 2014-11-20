public with sharing class phanisample {

    public PageReference save() {
    update promo;
        return null;
    }


   public Promotion__c promo{get;set;}
    public  phanisample(){
      promo = new Promotion__c();
      promo = [select id,Exp_TimeStamp__c,eff_TimeStamp__c from Promotion__c where id ='a1Mc0000003NuWv'];
      }

}