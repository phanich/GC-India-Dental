public with sharing class BLN_Gnuser_DAO {
/***********************************************************************************************
*   Controller Name : BLN_Gnuser_DAO
*   Date            : 07/01/2014
*   Author          : Phani Kumar Ch
*   Purpose         : This class has all queries and Dml oprations of GNuser Object
*   Change History  : 07/01/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
* 07/01/2014          Phani Kumar ch                    To Create Page
**************************************************************************************************/
   public List<GN_User__c > getGnuserList(SET<id> setOfgnusers){
      return [select id,First_Name__c,Last_Name__c,User__c,Address1__c,Address2__c,Age__c,City__c,Company_Name__c,Country__c,DOB__c,Eff_Date__c,Email__c,Gender__c,Home_Phone__c,Is_Active__c,Mobile__c,Zip_Code__c,User_Pic__c,User_Website__c,Title__c,State__c,Suffix__c,Prefix__c,Phone__c from GN_User__c where Id IN :setOfgnusers];
   }
   
   // This method is for updating gnuser
    public string updateGNUser(GN_User__c u,String Email,String ticketid,String sfuserid){
    
       //get gnuser of that ticket
       Ticket__c tc=[select id,name,Client_GN_User__c from Ticket__c where id=:ticketid];
       
        //Update user
        GN_User__c updateuser = [SELECT id,First_name__c,Last_name__c,Email__c,phone__c,title__c,User__c FROM GN_User__c 
                            WHERE id =: tc.Client_GN_User__c];
                            
        updateuser.First_Name__c=u.First_Name__c;
        updateuser.Last_Name__c=u.Last_Name__c ;
        updateuser.title__c=u.title__c;
        updateuser.phone__c=u.phone__c;
        updateuser.Email__c =u.email__c;
        if(sfuserid!=null)
        updateuser.User__c=u.user__c;
        
        database.update(updateuser);    
        
        return updateuser.id;
    }
    
      public string InsertGNUser(GN_User__c u){
       DataBase.saveREsult saveRes =  DataBase.Insert(u,false);
       system.debug('EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE '+saveRes );
        if(saveRes.isSuccess()){
            return saveRes.getId();
        }else{
           return '';
        }
      }
      
      public GN_User__c gettinggnuser(string uid){
      
      return [select id,First_Name__c,Last_Name__c,User__c,Email__c from GN_User__c where   User__c =: uid Limit 1];
      
      }
      
      public GN_User__c existingGnuser(string emailid){
      system.debug('ddddddddddddddddddddddddd'+emailid);
      return [SELECT id,First_Name__c,Last_Name__c,Prefix__c,Suffix__c,Email__c,
                        Company_Name__c,Phone__c,User_Pic__c,Mobile__c,Address1__c,Address2__c,
                            City__c,Country__c,Title__c,State__c,Zip_Code__c FROM GN_User__c WHERE Email__c =: emailid];
      
      }
      
    
}