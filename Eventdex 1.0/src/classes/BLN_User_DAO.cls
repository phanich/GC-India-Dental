public without sharing class BLN_User_DAO{
   
    //Inserting contact when inserting an User
    public string account_Contact(contact con){
        Account acc = [select id from account where owner.userRoleId !=null limit 1];
        con.AccountID = acc.id;
        dataBase.saveresult savereq = DataBase.insert(con,false);
        system.debug('cccccccccccccccccccccccccccccccccccccc'+savereq );
        if(savereq.isSuccess()){
        system.debug('111111111111111111111111');
            return savereq.getId();
        }else{
        system.debug('2222222222222222222222222222222');
            return null;
        }
    
    }
    
    
    // To know users Exists Or Not 
    public List<user>  checkUsersWExists(SET<string> emails){
        return [select id,username,firstname,lastname,email,companyName,MobilePhone,Title from user where userName In :emails];
    }
    
    
    //Inserting User
    public BLN_StatusMessage createUser(user u){
        dataBase.saveResult saveRes = dataBase.insert(u,false); 
        return new BLN_StatusMessage(saveRes);
    
    }
    
    
    // This method is used for fetching User Details, Input Parameter is Email
    public user checkUser(String Email){
        LIST<User> Users = [SELECT id,Username,CompanyName,Firstname,Lastname,Email,isActive,IsSignUp__c,Password__c
                            FROM User 
                            WHERE Username =: Email 
                             ];
        if(users.size()>0){
            return users[0];
        }else{
            return new user();
        }
    }
    
    // This method is used for fetching User Details, Input Parameter is Email
    public user checkLoggedInUser(String Email,String Password){
        LIST<User> Users = [SELECT id,Username,Firstname,Lastname,Email,isActive,IsSignUp__c,Password__c
                            FROM User 
                            WHERE Username =: Email 
                            AND Password__c =: Password 
                            AND isActive = TRUE 
                            AND IsSignUp__c = TRUE];
        if(users.size()>0){
            return users[0];
        }else{
            return new user();
        }
    }
    
    // This method is used for fetching User Details, Input Parameter is userId
    public user getUser(String UserId){
        LIST<User> Users = [SELECT id,Username,Firstname,Lastname,Email,isActive,IsSignUp__c,CompanyName,Title,Phone,Prefix__c,Suffix__c,Home_Phone__c,User_Type__c,User_Pic__c,User_Website__c,MobilePhone,
                                   Address1__c,Address2__c,City__c,Zipcode__c,FaceBookId__c,TwitterId__c,FourSqareId__c,LinkedInId__c, (SELECT id ,NAME,Address1__c,Address2__c,City__c,Country__c,State__c,User__c,Zip_Code__c from User_Ext__r where User__c = : UserId)
                            FROM User 
                            WHERE Id =: UserId
                            AND isActive = TRUE];
        if(users.size()>0){
            return users[0];
        }else{
            return new user();
        }
    }
    
    
    // This method is for updating user
    public string updateUser(user u){
    
        //Update user
        user updateuser = [SELECT id,Username,Firstname,Lastname,Email,isActive,IsSignUp__c,CompanyName,Title,Phone,Prefix__c,Suffix__c,Home_Phone__c,User_Type__c,User_Pic__c,User_Website__c,MobilePhone,
                                   Address1__c,Address2__c,City__c,Zipcode__c,FaceBookId__c,TwitterId__c,FourSqareId__c,LinkedInId__c 
                            FROM User 
                            WHERE Username =: u.Email 
                            AND isActive = TRUE];
                            
        updateuser.FirstName=u.FirstName;
        updateuser.LastName=u.LastName ;
        updateuser.title=u.title;
        updateuser.phone=u.phone;
        updateuser.Prefix__c=u.Prefix__c;
        updateuser.Suffix__c=u.Suffix__c;
        updateuser.Home_Phone__c=u.Home_Phone__c;
        updateuser.User_Type__c=u.User_Type__c;
        updateuser.User_Pic__c=u.User_Pic__c;
        updateuser.User_Website__c=u.User_Website__c;
        updateuser.Address1__c=u.Address1__c;
        updateuser.Address2__c=u.Address2__c;
        updateuser.City__c=u.City__c;
        updateuser.Zipcode__c=u.Zipcode__c;
        updateuser.FaceBookId__c=u.FaceBookId__c;
        updateuser.TwitterId__c=u.TwitterId__c;
        updateuser.FourSqareId__c=u.FourSqareId__c;
        updateuser.LinkedInId__c =u.LinkedInId__c ;
        database.update(updateuser);    
        
        return updateuser.id;
    }

    public BLN_StatusMessage insertUserBulk(List<user> users){
        DataBase.Saveresult[] savedRes = database.insert(users,false);
        return new BLN_StatusMessage(savedRes);
    }
    
    public BLN_StatusMessage  updateuserBulk(List<user> ulistforupdate){
        dataBase.saveResult[] userUpresult = DataBase.update(ulistforupdate,false);
        return new BLN_StatusMessage(userUpresult);
    }
    
    public BLN_StatusMessage insertGNUser(GN_User__c GNUser){
        DataBase.Saveresult Response = database.insert(GNUser,false);
        return new BLN_StatusMessage(Response);
    }
    
    public BLN_StatusMessage cloneGNUser(String UserId){
        GN_User__c User = [SELECT id,First_name__c,Last_name__c,Email__c,Company_Name__c,Title__c,Phone__c,User__c
                                   FROM GN_User__c 
                                   WHERE Id =: UserId];
        GN_User__c GN_User = User.clone(false, true);                          
        DataBase.Saveresult Response = database.insert(GN_User,false);
        return new BLN_StatusMessage(Response);
    }
    
    // This method is used for fetching User Details, Input Parameter is userId
    public GN_User__c getGNUser(String UserId){
        LIST<GN_User__c> Users = [SELECT id,First_name__c,Last_name__c,Email__c,Company_Name__c,Title__c,Phone__c,User__c
                                   FROM GN_User__c 
                                   WHERE Id =: UserId];
        if(users.size()>0){
            return users[0];
        }else{
            return new GN_User__c();
        }
    }

}