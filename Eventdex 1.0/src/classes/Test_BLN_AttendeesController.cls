@istest
public class Test_BLN_AttendeesController{
    static testmethod void Testmethod_BLN_AttendeesController(){
    
    User U= new User();
        globalForTestClass globalTest= new globalForTestClass();
        U= globalTest.createUser();        
        
        system.runas(U){
            
            NAICS_Code__c naicsCodeInfo1= new NAICS_Code__c();
            naicsCodeInfo1= globalTest.createNaicsCode();
            
            NAICS_Code__c naicsCodeInfo2= new NAICS_Code__c();
            naicsCodeInfo2= globalTest.createNaicsCode();
            
            Currency__c currenyInfo= new Currency__c();
            currenyInfo= globalTest.createCurrency();      
            
            Country__c countryInfo= new Country__c();
            countryInfo= globalTest.createCountry(currenyInfo.Id);  
            
            State__c stateInfo= new State__c ();
            stateInfo= globalTest.createState(countryInfo.Id);     
            
            Company__c companyInfo= new Company__c();
            companyInfo= globalTest.createCompany(u.Companyname);
            
            Company_Ext__c companyExtInfo= new Company_Ext__c();
            companyExtInfo= globalTest.createCompanyExt(companyInfo.Id, naicsCodeInfo1.Id, naicsCodeInfo2.Id, countryInfo.Id, stateInfo.Id); 
                     
            BLN_Event__c eventInfo= new  BLN_Event__c();
            eventInfo= globalTest.createEvent(countryInfo.Id, Stateinfo.Id ,CompanyInfo.id);   
            
            //insert badge style
     BadgeTemplate_Styles__c btstyle=new BadgeTemplate_Styles__c();
     btstyle.name='badge1';
     btstyle.BadgeName__c='{"name":"badge1","width":360,"height":288,"backgroundColor":"rgb(255, 255, 255)","savedImageDataUrl":"data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAFA3PEY8MlBGQUZaVVBfeMiCeG5uePWvuZHI////////////////////////////////////////////////////2wBDAVVaWnhpeOuCguv/////////////////////////////////////////////////////////////////////////wAARCAEqAXIDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwC1LIsSbmzj2qH7bF/tflS33/HufqKgtbeOWIs2c5xwaAJvtsX+1+VH22L/AGvyo+xw+/50fY4ff86AD7bF/tflUsUyzAlM8etVri1jjhZlzke9O0//AFb/AFoAsu4jQs3QU2KZZgSmePWm3R/0d/pVCGd4gQmOfUUAXmu4lYqd2QcdKfFMk2dmePWs6MebcDf/ABHnFaEMKRZ2Z59TQA17uJHKnOR7U37bF/tflVV1D3pU9C2KtfYof9r86AD7bF/tflR9ti/2vyo+xw+/50fYof8Aa/OgBReRMwA3ZPHSrFZboI7ravQMK1KACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAoo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C7ccetWKKAIVjYW3l8Z24plrbvCzFiOR2qzRQBTktXa58wEYyDVyiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigCs/32+tFD/fb60UAWaKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigCs/wB9vrRQ/wB9vrRQBZooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAGPKkZ+YkfgaQzIBk7gB/sH/CmXf+qH+8Kf5sZIUMrE8YBzQA8HIzS1EzlJETaNrcA5pTIRMqFRhhwc0AAmQy+WDlh19qBMhl8sHLDr7Uw/8AH6v+5/Wg/wDH6v8Auf1oAmJwM01JUdiqn5h1BGKfVaWNjI0kf31xj39qAJ3dUGWzj2BNKrBhkZx7jFReaJbZmHocj0p8kmwDjJY4AoAfRUSykyFHXDAZ4Ocimi4LhtkTEg4weKAJ6Kg+0ExB0jLDvzjH+NSeYCqsOd3QUAPoqISnzPLdQpIyMHIP8qloAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAKz/fb60UP99vrRQBZooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAILs4iX/AHhUxAOPbmkaNGOWRSfUilVQowoAHoBQBDcELJCzHADdfwpskqfaYiDkcjI5qwyhhhgCPQ0BQMYA44FAEJ/4/V/3P60H/j9X/c/rUhjQtuKLn1xQY0Lbii59cUAPpin94/4U+mCONTlUUH1AoAr3CNEWkjHysMMP61LM2GjUAZY8MR0/+vUpGRg9KGVWGGAI9CKAKwKre4LZOzHJ70+D/WTf79ShFGMKOBgcUgijHSNRn2oAig/49W/4FUZwIIHYbkH3hjNWfKjwRsXB7YpVRVBCqAD2AoAjTySw8tUJ9VA4qamqqoMKoUewp1ABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQBWf77fWih/vt9aKALNFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUU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"},';
     btstyle.Event__c=eventInfo.id;
     btstyle.FirstRowElement__c='[{"id":"cqrcd","height":125,"width":125,"positionTop":0,"positionLeft":0,"marginTop":"0px","marginRight":"0px","marginBottom":"0px","marginLeft":"0px","paddingTop":"0px","paddingRight":"0px","paddingBottom":"0px","paddingLeft":"1px","qrUrlResult":"url(https://boothleads-boothleads.cs11.force.com/resource/1403783597000/qrcodelogoimage)"}]';
     btstyle.SecondElement__c='[{"id":"cfulln","height":31,"width":349,"line-height":31,"position":"absolute","positionTop":144,"positionLeft":13,"marginTop":"0px","marginRight":"0px","marginBottom":"0px","marginLeft":"0px","paddingTop":"0px","paddingRight":"0px","paddingBottom":"0px","paddingLeft":"1px","textAlign":"center","fontSize":"28px","fontFamily":"\'Times New Roman\'","textTransform":"none","contentText":"Full Name","backgroundColor":"rgb(255,255,255)","opacity":"1","textColor":"rgb(0,0,0)","white-space":"nowrap"}]';
     btstyle.ThirdElement__c='[{"id":"cticketn","height":40,"width":224,"line-height":40,"position":"absolute","positionTop":36,"positionLeft":138,"marginTop":"0px","marginRight":"0px","marginBottom":"0px","marginLeft":"0px","paddingTop":"0px","paddingRight":"0px","paddingBottom":"0px","paddingLeft":"1px","textAlign":"center","fontSize":"37px","fontFamily":"\'Times New Roman\'","textTransform":"none","contentText":"Ticket Name","backgroundColor":"rgb(255,255,255)","opacity":"1","textColor":"rgb(0,0,0)","white-space":"nowrap"}]';
     btstyle.FourthElement__c='[{"id":"cticketCategory","height":42,"width":352,"line-height":42,"position":"absolute","positionTop":192,"positionLeft":5,"marginTop":"0px","marginRight":"0px","marginBottom":"0px","marginLeft":"0px","paddingTop":"0px","paddingRight":"0px","paddingBottom":"0px","paddingLeft":"1px","textAlign":"center","fontSize":"26px","fontFamily":"\'Times New Roman\'","textTransform":"none","contentText":"Ticket Category","backgroundColor":"rgb(255,255,255)","opacity":"1","textColor":"rgb(0,0,0)","white-space":"nowrap"}]';
     btstyle.FifthElement__c='[{"id":"cjobTitle","height":42,"width":352,"line-height":42,"position":"absolute","positionTop":245,"positionLeft":5,"marginTop":"0px","marginRight":"0px","marginBottom":"0px","marginLeft":"0px","paddingTop":"0px","paddingRight":"0px","paddingBottom":"0px","paddingLeft":"1px","textAlign":"center","fontSize":"26px","fontFamily":"\'Times New Roman\'","textTransform":"none","contentText":"Job Title","backgroundColor":"rgb(255,255,255)","opacity":"1","textColor":"rgb(0,0,0)","white-space":"nowrap"}]';
     insert btstyle; 
             
            
            Reg_Setting__c regSettingsInfo1= new Reg_Setting__c();
            regSettingsInfo1= globalTest.createRegSettings(eventInfo.Id, NULL, NULL, NULL, NULL,'Regular', 'AS_Last_Name__c');
            
             User userForGN= new User();
            userForGN= globalTest.createUserForGNUser();
            
            GN_User__c  gnUser= new GN_User__c();
            gnUser= globalTest.createGNUser(userForGN, countryInfo.Id, stateInfo.Id);
            
            Order__c insertOrder1= new Order__c();
            insertOrder1= globalTest.createOrder(gnUser.Id, userForGN.id, companyInfo.Id, eventInfo.Id, currenyInfo.Id);
            
            Item_Type__c itemType= new Item_Type__c();
            itemType= globalTest.createItemType();
            
            BLN_Track__c trackInfo= new BLN_Track__c();
            trackInfo= globalTest.createTrack(eventInfo.id);
            
            Item_Pool__c ItemPool= new Item_Pool__c();
            ItemPool= globalTest.createItemPool(eventInfo.id, itemType.Id, NULL, trackInfo.Id);
            
            Item_Pool__c ItemPool2= new Item_Pool__c();
            ItemPool2= globalTest.createItemPool(eventInfo.id, itemType.Id, ItemPool.Id, trackInfo.Id);
           
            BLN_Item__c item= new BLN_Item__c();
            item= globalTest.createItem(ItemPool.Id, itemType.Id, eventInfo.id);
                       
            Order_Item__c orderItem= new Order_Item__c();
            orderItem= globalTest.createOrderItem(item.Id, insertOrder1.Id, null, currenyInfo.Id);
                       
            
            Ticket__c ticket= new Ticket__c();
            ticket= globalTest.createTicket(eventInfo.id, item.Id, itemPool.Id, itemType.Id, insertOrder1.Id, gnUser.Id);
            
            Badge__c bdg= new Badge__c(ticket_id__c=ticket.id);
            insert bdg;
            
            Reg_Setting__c regSettingsInfo2= new Reg_Setting__c();
            regSettingsInfo2= globalTest.createRegSettings(eventInfo.Id, ItemPool2.Id, item.Id, companyInfo.Id, NULL, 'Regular', 'AS_Last_Name__c');
            
            PageReference pageRef = Page.BLN_Mytickets;
            Test.setCurrentPage(pageRef);
            
            cookie  counter = new Cookie('counter',eventInfo.id,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{counter});
            
            BLN_AttendeesController blnattcon=new BLN_AttendeesController();
           // blnattcon.createbadgelabel();
            blnattcon.displayPermissions();
            blnattcon.mainMethod();
           // blnattcon.SaveGuests();
           // blnattcon.deleteAttendee();
            blnattcon.orderDetails();
            blnattcon.cancelOrdDetail();
            String currdate=string.valueOf(System.today());
            Datetime myTime = datetime.newInstance(2014, 10, 1, 12, 30, 2);
            String myCurTime=string.valueOf(myTime);
            
             blnattcon.selectedbdtemname='badge1';
            blnattcon.genpdf();
            blnattcon.findtemplate();
            blnattcon.getPrinterlist();
            blnattcon.getTicketToMergeList();
           // blnattcon.mergeBadge();
           // blnattcon.cancelBadge();
            blnattcon.getMergeList();
            blnattcon.getPackageList();
           // blnattcon.splitpackage() ;
            
            
     }       
    
    }
}