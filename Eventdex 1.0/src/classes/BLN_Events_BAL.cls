public with sharing class BLN_Events_BAL {
    
    
     
    
     public String createEvent(LIST<BLN_Event__c> events,String companyName){
        // We are Upserted 2 objects 
        //    1) Event
        //    2) UC_Role
        
          BLN_Events_DAO eventsDAO = new BLN_Events_DAO();
          String successEventId='';
          
            LIST<Database.UpsertResult> dbr  = eventsDAO.createEvent(events);
         
          system.debug('EVENTS CREATIONNNNNNNNNNnnnnnnn  222222222222222222222  '+ dbr);
          
        MAP<Id, Database.UpsertResult> eventSaveResult = new MAP<Id, Database.UpsertResult>();
        
        for(Database.UpsertResult r: dbr){
            if(r.isSuccess()){
                eventSaveResult.put(r.getId(), r);   
                successEventId = r.getId();
            }
        }
        
        //system.debug('EVENTS CREATIONNNNNNNNNNnnnnnnn  222222222222222222222  '+ successEventId);
        
        //BLN_User_DAO blnUserInfo = new BLN_User_DAO();
        
        //User loginUser = blnUserInfo.CheckUser(userinfo.getUserName()  );
        
         //system.debug('ROLEEEEEEEEEEEEEE          11111111111111     '+ loginUser);
         
       // LIST<USER> users = [SELECT ID, NAME, CompanyName FROM USER WHERE ID =: userinfo.getUserId()];
       
        String companyIDs='';
       
            /*if(loginUser.CompanyName != null){
                companyName = loginUser.CompanyName;
            }*/
            Company__c companyId=new Company__c();
            BLN_Company_DAO company = new BLN_Company_DAO();
           try{
        
        
        companyId = company.queryCompanyId(companyName);
        companyIDs=companyId.id;
        }catch(Exception e)
        {
          //if company not found create new one
          if(companyName=='')
          companyName=userinfo.getFirstName() +' '+userinfo.getLastName() ;
          companyId.Name=companyName;
          BLN_StatusMessage compmsg=company.insertCompany(companyId);
           if(compmsg.successBool){
            companyIDs= compmsg.successId;
        }
       
          
        }
       
      
       
         system.debug('ROLEEEEEEEEEEEEEE          22222222222222222222222222222     '+ companyId);
        
        LIST<UC_Role__c> usercompanyRole = new LIST<UC_Role__c>();
       BLN_UCRole_DAO blnUserDAO = new BLN_UCRole_DAO();
       BLN_StatusMessage ucRoleMessage = new BLN_StatusMessage();
       
       for(Database.UpsertResult rs :dbr){
           
           if(rs.isSuccess() && rs.isCreated()){
           BLN_Gnuser_DAO gndao = new BLN_Gnuser_DAO ();
               if(companyId.id != null ){
                   
                    UC_Role__c ucr = new UC_Role__c();
                    
                    ucr.Company__c = companyIDs;
                    //ucr.Event__c = rs.getId();
                    //ucr.Invited_date__c = system.Today(); 
                     string uid = userInfo.getUserId();
                     try{
                     GN_User__c  GNUID = gndao.gettinggnuser(uid);
                    ucr.GN_User__c =GNUID.id;
                    }catch(Exception e){}
                    
                    usercompanyRole.add(ucr);
                    
                    //Insert User Role here,.............
                    ucRoleMessage = blnUserDAO.insertUCRole(ucr, 'Company Admin'); 
                } 
           }
       
       } 
       system.debug('ROLEEEEEEEEEEEEEE         3333333333333333333333   '+ ucRoleMessage);
       
       if(ucRoleMessage.successBool != null){
            if(ucRoleMessage.successBool){
            Bln_event__c ble=[select id,name from bln_event__c where id=:successEventId];
            ble.User_Company__c=ucRoleMessage.successId;
            ble.organizer_id__c=companyIDs;
            update ble;
              return successEventId;
              }
            else    
               return 'Error'; 
               
           
               
       } 
       
        
 
        return successEventId;
    }

    public LIST<dataBase.Upsertresult> paymentGateWays(LIST<Pay_Gateway__c> gateWays){
        
        BLN_PGateway_Type_DAO pgate = new BLN_PGateway_Type_DAO();
        return pgate.pgateWaySaves(gateWays);
        
    }
   // for gettig all events based on login User//written by mythily
    public list<BLN_Event__c> listOfEvents( id uid){
    system.debug('-----------------BAL------------------'+uid);
    BLN_Events_DAO eventsDao = new BLN_Events_DAO ();
    list<BLN_Event__c> ListOfEvents= eventsDao.gettingAllEvents(uid);
    system.debug('-----------------BAL1111111111-------------'+ListOfEvents);
    return ListOfEvents;
    
    }
    public list<UC_Role__c> roles(id uid){
    BLN_Events_DAO eventsDao = new BLN_Events_DAO ();
    list<UC_Role__c> URoles = eventsDao.TogetRoleofanEvent(uid);
    return URoles ;
    }

}