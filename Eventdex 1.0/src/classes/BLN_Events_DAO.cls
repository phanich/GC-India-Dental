public with sharing class BLN_Events_DAO {
    
    
    //Getting EventDetails By Id
    public BLN_Event__c getEventDetails(String eventId){
        BLN_Event__c eventdetails= [SELECT Event_Ticket_Options__c,is_Corporate__c, ZipCode__c, Website_Url__c, Waitlist__c, Venue_Name__c, User_Company__c,
                                        Service_Fee__c,Twitter_URL__c, Twitter_Hash_Tag__c, Time_Zone__c, SystemModstamp, Street2__c, Street1__c, State__c, 
                                        Start_Time__c, Start_Date__c, Social_Hashtag__c, Show_Map__c, Phone_Number__c, Password__c, 
                                        PO_Box__c, OwnerId, Organizer_Email__c, Name, Logo_URL__c, LastModifiedById, IsDeleted, Id, Hosting_Location__c, 
                                        Facebook_URL__c, Event_Type__c, Event_Topic__c, Event_Status__c, Event_Privacy__c, End_Time__c, End_Date__c, Registration_Template__c,
                                         Description__c,Country__c, City__c ,CreatedBy.Name ,BLN_State__c,BLN_State__r.Long_Name__c,BLN_State__r.Short_Name__c,
                                        BLN_State__r.Country__c,BLN_State__r.Country__r.Long_Name__c,BLN_State__r.Country__r.Short_Name__c,BLN_Country__r.Short_Name__c,BLN_Country__r.Long_Name__c,Show_Terms_Checkbox__c,
                                        Tax_Rate__c,Accept_Tax_Rate__c,Terms_Conditions__c,Accept_Terms_Conditions__c,Accept_Refund_Policy__c,Refund_Policy__c, LinkedIn_URL__c, Language_Settings__c,Event_Blog_URL__c,owner.userName 
                                    FROM BLN_Event__c 
                                    WHERE ID =: eventId];
        return eventdetails;
    }
    
    public LIST<Database.UpsertResult> createEvent(LIST<BLN_Event__c> events){
        
          
        LIST<Database.UpsertResult> dbr = DataBase.upsert(events , false);
        
        system.debug('EVENTS CREATIONNNNNNNNNNnnnnnnn  111111111111111  '+ dbr);
        
        
        return dbr;
        
    }
    public list<BLN_Event__c> gettingAllEvents(id uid){
    system.debug('-------------dao2222222222'+uid);
    list<UC_Role__c> ucroles = [select id,Event__c,Company__c,Company__r.name,Role__c,RoleId__c from UC_Role__c
                                        WHERE GN_User__r.User__c =: uid];
      system.debug('-------------dao2222222222'+ucroles);                                   
    list<id> eveids = new list<id> ();
    
     for(UC_Role__c USR : UCRoles){
        eveids.add(USR.Company__c);
        
        }
        
      list<BLN_Event__c> events = [SELECT is_Corporate__c, ZipCode__c, Website_Url__c, Waitlist__c, Venue_Name__c, User_Company__c,
                                        Twitter_URL__c, Twitter_Hash_Tag__c, Time_Zone__c, SystemModstamp, Street2__c, Street1__c,  
                                        Start_Time__c, Start_Date__c, Social_Hashtag__c, Show_Map__c, Phone_Number__c, Password__c, 
                                        PO_Box__c, OwnerId, Organizer_Email__c, Name, Logo_URL__c, LastModifiedById, IsDeleted, Id, Hosting_Location__c, 
                                        Facebook_URL__c, Event_Type__c, Event_Topic__c, Event_Status__c, Event_Privacy__c, End_Time__c, End_Date__c, 
                                         Description__c,BLN_Country__r.Short_Name__c,BLN_Country__r.Long_Name__c,City__c ,CreatedBy.Name ,
                                        BLN_State__c,BLN_State__r.Long_Name__c,BLN_State__r.Short_Name__c,BLN_State__r.Country__c,BLN_State__r.Country__r.Long_Name__c,BLN_State__r.Country__r.Short_Name__c,Show_Terms_Checkbox__c, 
                                        Tax_Rate__c,Accept_Tax_Rate__c,organizer_id__c,Terms_Conditions__c,Accept_Terms_Conditions__c,Accept_Refund_Policy__c,Refund_Policy__c, LinkedIn_URL__c, Language_Settings__c,Event_Blog_URL__c 
                                   FROM BLN_Event__c 
                                   WHERE organizer_id__r.id IN: eveids and Event_Status__c!='Deleted'];
       system.debug('-------------dao2222222222'+events);
       
     
       
     
       
       
    return events ;
    }
    public list<UC_Role__c> TogetRoleofanEvent(id UID){
    list<UC_Role__c> ucroles = [select id,Event__c,Company__c,Company__r.name,RoleId__r.Name,RoleId__c from UC_Role__c
                                        WHERE GN_User__r.User__c =: uid];
      system.debug('-------------dao2222222222'+ucroles); 
      return ucroles ;
    
    }

}