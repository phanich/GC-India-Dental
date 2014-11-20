trigger copyEventPricing on BLN_Event__c (after insert) {
    List<Event_Price__c>  evpricedefault = new List<Event_Price__c>();
    List<Event_Price__c>  evpricenewnew = new List<Event_Price__c>();
    evpricedefault =[select Active_Flag__c,Event__c,BL_Fee_Amount__c,BL_Fee_Level__c,BL_Fee_Percentage__c,Item_Count__c,Item_type__c from Event_Price__c where Event__r.Name='Default Event(Boothleads)'];
    for(BLN_Event__c eve : trigger.new){
        for(Event_Price__c ep:evpricedefault){
            Event_Price__c eps= new Event_Price__c();
            eps= ep.clone();
            eps.event__c = eve.id;
            evpricenewnew.add(eps);
        }
    }
    DataBase.insert(evpricenewnew,false);
}