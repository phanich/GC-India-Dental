public without sharing class BLN_User_SignUP_BAL{
 
  public string CheckUserEmailExists(string fn,string ln,string email,string com,string pass){
     boolean checKuserExistsbool =false;
     
      BLN_User_DAO blnuserDao = new BLN_User_DAO();
      user user = new user();
      user = blnuserDao.CheckUser(email);
      
    
      if(user.id!=null){
           if(user.isSignup__c==true){
            return 'Your username already exists in the system!';
             
           }else{
             try{
                 system.setPassword(user.id,pass);
                 updateUserStatus(user.id,pass); 
                 return 'Success';
               }catch(exception ex){
                  return 'Password should not contain your partial name or email address';
              }       
           }  
        }else{
        Savepoint sp = Database.setSavepoint();

            contact Con = new Contact();
            Con.Lastname = fn;
            Con.Firstname =ln; 
            con.email = email;
           
            string contactId = blnuserDao.account_Contact(con);
            
            Profile P = [SELECT Id,Name FROM Profile WHERE Name = 'Event Admin'];
            user u = new user();
            U.ContactID =contactId;    
            U.Username = email;  
            U.Email = email;
            U.LastName = ln;
            U.FirstName = fn;
            U.CompanyName = com;
            U.Alias = 'EAdmin';
            U.ProfileID = P.id;
            U.CommunityNickname = String.valueOf(math.random());
             U.Eff_Date__c=system.today();
           
            if(pass!=null && pass!=''){
            u.password__c =pass;
            }
            
            U.LocaleSidKey = 'en_US';
            U.LanguageLocaleKey = 'en_US';
            U.TimeZoneSidKey = 'America/New_york';
            U.EmailEncodingKey='UTF-8';
           // string msg = blnuserDao.createUser(u);
            BLN_StatusMessage userMsg = blnuserDAO.createUser(u);
               
             system.debug('KKKKKKKKKKKKKKKKKKKKKK '+userMsg );
               
              try{
                 system.setPassword(userMsg.successId ,pass);
                  updateUserStatus(userMsg.successId,pass); 
                }catch(exception ex){
                   Database.rollback(sp);

                return 'Password should not contains name and username';
              }  
             
              if(userMsg.successBool){
                  
                  Company__c comp = new Company__c();
                  
                  if(com !=null && com!=''){
                     comp.Name = com;
                  }       
                 
                 
               /*  BLN_Company_DAO blnCompanyDAO = new BLN_Company_DAO();
                 BLN_StatusMessage comId1 = blnCompanyDAO.insertCompany(comp);
                 string comId = comId1.successId;
                 */
                 BLN_UCRole_DAO companyRole = new BLN_UCRole_DAO();

                BLN_Gnuser_DAO gnDao = new BLN_Gnuser_DAO();
                
                GN_User__c gnUser = new GN_User__c();
                gnUser.first_Name__c = fn;
                gnUser.Last_Name__c = ln;
                gnUser.Email__c = email;
                gnUser.user__c = userMsg.successId;
                string gnid = gnDao.InsertGNUser(gnUser);
                
                system.debug('222222222Company CReated Successs       '+fn+'   '+ln+' '+email+' '+  userMsg.successId +' '+gnid );
                             
               /* UC_Role__c uRole = new UC_Role__c();
                uRole.Company__c = comId;
                uRole.GN_User__c =gnid;
                BLN_StatusMessage ucRoleId1 = companyRole.insertUCRole(uRole, 'Company Admin');
               String ucRoleId = ucRoleId1.successId;
               system.debug('222222222Company CReated Successs       '+ ucRoleId);
               */
                return 'success';
                    
              }else{
                  return userMsg.errors ;
              }
              
              
              // blnuserDao.createUser(u);
             
       }  
      
   }
   
     
   @future
     public static void updateUserStatus(string userId,string pass){
      system.debug('GGGGGGGGGGGGGGGGGGGGGG   '+userId);
        User user = [SELECT id,IsSignUp__c,isActive,password__c FROM User WHERE id=:userId];
        system.debug('AAAAAAAAAAAAAAAAA '+user );
        user.IsSignUp__c =true;
            if(pass!=null && pass!=''){
              user.password__c = pass;
            }
        user.isSignup__c =true;    
        user.isActive = true;
        update user;
     } 
  
   
}