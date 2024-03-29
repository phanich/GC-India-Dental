@isTest
public class Test_insertTicketsFromItems{
    static testmethod void Testmethod_insertTicketsFromItems(){
        system.debug('EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE ');
       // User U= new User();
        globalForTestClass globalTest= new globalForTestClass();
       // U= globalTest.createUser();
        
       // system.runas(U){
        
            User u= new User();
            u= globalTest.createUserForGNUser();
           
           
           
             Currency__c currenyInfo= new Currency__c();
            currenyInfo= globalTest.createCurrency();             
            
            Country__c countryInfo= new Country__c();
            countryInfo= globalTest.createCountry(currenyInfo.Id);  
            
            State__c stateInfo= new State__c ();
            stateInfo= globalTest.createState(countryInfo.Id);     
           
            GN_User__c  gnUser= new GN_User__c();
            gnUser= globalTest.createGNUser(u, countryInfo.Id, stateInfo.Id);
          
            NAICS_Code__c naicsCodeInfo1= new NAICS_Code__c();
            naicsCodeInfo1= globalTest.createNaicsCode();
            
            NAICS_Code__c naicsCodeInfo2= new NAICS_Code__c();
            naicsCodeInfo2= globalTest.createNaicsCode();
            
            Company__c companyInfo= new Company__c();
            companyInfo= globalTest.createCompany(u.Companyname);
            
            Company_Ext__c companyExtInfo= new Company_Ext__c();
            companyExtInfo= globalTest.createCompanyExt(companyInfo.Id, naicsCodeInfo1.Id, naicsCodeInfo2.Id, countryInfo.Id, stateInfo.Id);
            
                 
            
            BLN_Event__c eventInfo= new  BLN_Event__c();
            eventInfo= globalTest.createEvent(countryInfo.Id, Stateinfo.Id ,CompanyInfo.id);               
            
                        
            Item_Type__c itemType= new Item_Type__c();
            itemType= globalTest.createItemType();
            
           BLN_Track__c trackInfo= new BLN_Track__c();
            trackInfo= globalTest.createTrack(eventInfo.Id);
            
           
           
            Item_Pool__c ItemPool= new Item_Pool__c();
            ItemPool= globalTest.createItemPool(eventInfo.id, itemType.Id, NULL, trackInfo.Id);
            
             
            Item_Pool__c ItemPool1= new Item_Pool__c();
            ItemPool1= globalTest.createItemPool(eventInfo.id, itemType.Id, ItemPool.Id, trackInfo.Id);
            
          
            BLN_Item__c item= new BLN_Item__c();
            item= globalTest.createItem(ItemPool.Id, itemType.Id, eventInfo.id);
            
           
            Reg_Setting__c regSettingsInfo1= new Reg_Setting__c();
            regSettingsInfo1= globalTest.createRegSettings(eventInfo.Id, ItemPool.Id, item.id, NULL, NULL, 'Registration Tab', 'GN_Fist_name__c');
                        
            Reg_Setting__c regSettingsInfo2= new Reg_Setting__c();
            regSettingsInfo2= globalTest.createRegSettings(eventInfo.Id, ItemPool.Id, item.id, NULL, NULL, 'Registration Tab','GN_Last_name__c');
            
            Reg_Setting__c regSettingsInfo3= new Reg_Setting__c();
            regSettingsInfo3= globalTest.createRegSettings(eventInfo.Id, NULL, NULL, NULL, NULL, 'Regular','GN_Last_name__c');
            
            LIST<BLN_Item__c> insertItems= new LIST<BLN_Item__c>();
            
           // Item_Type__c itemType2= new Item_Type__c();
            //itemType2= [SELECT ID, Item_Type_Number__c FROM Item_Type__c WHERE name =: 'Package' LIMIT 1];
           Test.startTest(); 
            BLN_Item__c insertItem2= new BLN_Item__c();
            insertItem2.item_name__c= 'testItem';
            insertItem2.Item_Pool__c= ItemPool.Id;
            insertItem2.item_type__c= itemType.Id;
            insertItem2.Event__c= eventinfo.id;
            insertItem2.price__c= 22.50;
            insertItem2.Payment__c= 'Paid';
            insertItem2.item_count__c= 10;
            
            BLN_Item__c insertItem= new BLN_Item__c();
            insertItem.item_name__c= 'testItem';
            insertItem.Item_Pool__c= ItemPool1.Id;
            insertItem.item_type__c= itemType.Id;
            insertItem.Event__c= eventinfo.id;
            insertItem.price__c= 22.50;
            insertItem.Payment__c= 'Paid';
            insertItem.item_count__c= 10;
            insertItem.addon_parent_id__c= item.Id;
            
            insertItems.add(insertItem);
            insertItems.add(insertItem2);
            
           dataBase.saveResult[] res =  Database.insert(insertItems, True);
           SET<id> ids  = new SEt<id>();
             system.debug('QQQQQQQQQQQQQQ  '+insertItems);
            for(dataBase.saveResult re :res ){
              if(re.isSuccess()){
                ids.add(re.getId());
              }
            }
            
            
           List<BLN_Item__c > itemList = new List<BLN_Item__c >(); 
           for(BLN_Item__c ite : [select id,item_count__c from BLN_Item__c where id In :ids ] ){
           ite.item_count__c= 20;
            itemList.add(ite);
           } 
            
            //MAP<ID, BLN_Item__c> newitemsMAP = new MAP<ID, BLN_Item__c>();
            system.debug('EEEEEEEEEEE '+itemList);
            BLN_EventsConTest.firstRun =true;
             Database.update(itemList, FALSE);
             Test.stopTest();
            }
       //}
}