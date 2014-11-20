public class BLNUtility{

/***********************************************************************************************
*   Controller Name : BLNUtility
*   Date            : 05/05/2014
*   Author          : Naga Mallikarjuna Rao B
*   Purpose         : This class acts as util class for entire application, here we will maintain All DML operations.
*   Change History  : 05/05/2014 
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*   05/05/2014          Naga Mallikarjuna Rao B           To Create Page
**************************************************************************************************/

    public LIST<BLN_StatusMessage> successMsg{get; set;}
    
    
    public LIST<BLN_StatusMessage> createEvent(LIST<BLN_Event__c> events){
        // We are Upserted 2 objects 
        //    1) Event
        //    2) UC_Role
         
         
         successMsg = new LIST<BLN_StatusMessage>();
        
        LIST<Database.UpsertResult> dbr = DataBase.upsert(events , false);
        MAP<Id, Database.UpsertResult> eventSaveResult = new MAP<Id, Database.UpsertResult>();
        
        for(Database.UpsertResult r: dbr){
            if(r.isSuccess()){
                eventSaveResult.put(r.getId(), r);   
            }
        }
        
        LIST<USER> users = [SELECT ID, NAME, CompanyName FROM USER WHERE ID =: userinfo.getUserId()];
        String companyName = '';
        
        for(User u: users){
            if(u.CompanyName != null){
                companyName = u.CompanyName;
                break;
            } 
        }
        
        LIST<Company__c> companies =[SELECT ID, NAME FROM Company__c WHERE NAME =: companyName];
        LIST<Role__c> roles = [SELECT ID, NAME FROM Role__c WHERE Role_ShortName__c = 'EAD'];
        
        
        LIST<UC_Role__c> usercompanyRole = new LIST<UC_Role__c>();
       
       for(Database.UpsertResult rs :dbr){
           
           if(rs.isSuccess() && rs.isCreated()){
               if(companies.size() > 0 && roles.size() > 0 && users.size() > 0 ){
                   
                    UC_Role__c ucr = new UC_Role__c();
                    ucr.Company__c = companies[0].id ;
                    ucr.Event__c = rs.getId();
                    ucr.Invited_date__c = system.Today();
                    ucr.RoleId__c = roles[0].id ;
                    ucr.User__c = users[0].id;
                    
                    usercompanyRole.add(ucr);
                } 
           
           }
       
       }
        
      List<Database.SaveResult> roleRes = DataBase.insert(usercompanyRole, FALSE);
       
      for(Database.UpsertResult r: dbr){
             successMsg.add(new BLN_StatusMessage(r)); 
      }
        
        
        return successMsg;
    }

    /*
    //This is Class for access records are created Successfully or Not.
    public class successMessage{
    
        public ID successId{get; set;}
        public Boolean successBool{get; set;}
        public Boolean iscreated{get; set;}
        public String errors{get; set;}
        
        public successMessage(Database.UpsertResult r){
            iscreated = FALSE;
            successBool = FALSE;
            errors = '';
            
            successId = r.getId();
            successBool = r.isSuccess();
            iscreated = r.isCreated();
            if(r.getErrors() != null){
                errors = String.valueOf(r.getErrors());
            }   
        }
    }
    */
    
    
    public LIST<Country__c> countries(){
    	
    	LIST<Country__c> country =  new LIST<Country__c>();
    	
    	country = [SELECT ID, NAME, Short_Name__c, Long_Name__c FROM Country__c ];
    	
    	return country;
    } 
    
    public LIST<State__c> stateOfCountry(id countryId){
    	LIST<State__c> states = new LIST<State__c>();
    	states = [SELECT ID, NAME, Short_Name__c,Long_Name__c, Country__c FROM State__c WHERE Country__c =: countryId];
    	
    	return states;
    }
    
    
    
}