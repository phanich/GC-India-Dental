public without sharing class BLN_Company_DAO{

/**
* @author :Phani Chimata
* @date 05/11/2014
* @ This class is used for DML operations on Company object
*/ 

  // ----------------------------- Variable Declaration ----------------------------------------
  public String CompanyId {get;set;}
  public string compextid {get ;set ;}
  
  //Checking Company Exists or Not
    public Company__c checkCompany(string cmpname){
       LIST<Company__c> CompanyLIST = [SELECT ID,Name,Company_Logo__c FROM Company__c WHERE Name =: cmpname LIMIT 1];
       if(CompanyLIST .size()>0){
          return CompanyLIST [0];
       }else{
          return new Company__c();
       }
    }
  
  
  // ------------------------------ Insert Company Method --------------------------------------
  public BLN_StatusMessage insertCompany(Company__c comp){
      dataBase.saveResult saveRes = dataBase.insert(comp,false); 
       return new BLN_StatusMessage(saveRes);
  }
  
  // ------------------------------ update Company Method --------------------------------------  
  public string updateCompany(Company__c comp){
      LIST<Company__c> CompanyLIST = [SELECT ID,Name,Company_Logo__c FROM Company__c WHERE Id =: comp.id LIMIT 1];
      if(CompanyList.size()>0){
        Database.Update(comp);
        CompanyId = comp.id; 
      }
      return CompanyId;  
  }
  //--------------------------------------Insert Company details in company extention ------
  public string insertcompdetails(string comid,Company_Ext__c comext){
  comext.Company__c = comid;
  database.upsert(comext);
  compextid = comext.id;
  return compextid;
  }
  
  
  //By Mallik
    public Company__c queryCompanyId(String companyName){
    
    UC_Role__c uc=[select id,name,Company__c,GN_User__r.Email__c,roleid__r.name,event__c from UC_Role__c where Company__r.name=:companyName and GN_User__r.Email__c=:UserInfo.getUserEmail() and RoleId__r.name='Company Admin' and Event__c=null limit 1];
     Company__c  companies =[SELECT ID, NAME,Website_URL__c,Description__c,isPersonAccount__c,Company_Logo__c, (SELECT ID, NAME, Business_Address1__c, Business_Address2__c, Business_City__c, BLN_Business_Country__c, BLN_Business_Country__r.Short_Name__c, BLN_Business_State__c,BLN_Business_State__r.Short_Name__c, Business_Zipcode__c, Work_Phone__c,Company__c,Duns_Number__c,
                                             Established_Date__c,Keywords__c,Number_Of_Employees__c,Primary_NAICS_Code__c,Revenue__c,Secondary_NAICS_Code__c,Tax_Id__c FROM Company_Ext__r) FROM Company__c WHERE id=: uc.Company__c LIMIT 1];
     
     return companies;
    }
   
    public Company__c queryCompany(id companyID){
     Company__c  company =[SELECT ID, NAME,Website_URL__c,Description__c, isPersonAccount__c,Company_Logo__c,(SELECT ID, NAME, Business_Address1__c, Business_Address2__c, Business_City__c, BLN_Business_Country__c, BLN_Business_Country__r.Short_Name__c, BLN_Business_State__c,BLN_Business_State__r.Short_Name__c, Business_Zipcode__c, Work_Phone__c,Company__c,Duns_Number__c,
                                             Established_Date__c,Keywords__c,Number_Of_Employees__c,Primary_NAICS_Code__c,Revenue__c,Secondary_NAICS_Code__c,Tax_Id__c FROM Company_Ext__r) FROM Company__c WHERE id =: companyID ];
     
     return company;
    }
    
  
  // By Phani for inserting List of companies 
  public BLN_StatusMessage insertCompanyBulk(List<Company__c> companies){
    MAP<string,company__c> companyNameMap = new MAP<string,company__c>();
    SET<string> companyNameExisted = new SET<string>();
    // make set for query where condition
    for(Company__c com :companies ){
      companyNameMap.put(com.name,com);
    }
    // Checking company name existed
    for(Company__c companyList : [select id,name,Company_Logo__c from Company__c where Name In :companyNameMap.keyset()]){
      companyNameMap.remove(companyList.Name);
    }
    if(companyNameMap.values()!=null){
    DataBase.saveresult[] companyresult = dataBase.insert(companyNameMap.values(),false);
       return new BLN_StatusMessage(companyresult);
    }else{
        
        return null;
    }
  }
  
  
   public List<Company__c> getcompanies(List<String> companyName){
     return [SELECT ID, NAME FROM Company__c WHERE NAME =: companyName];
   }
   
   
   
  public List<id> compinies(SET<String> companyName){
    List<id> comid = new List<id>();
       for(Company__c cot : [SELECT ID, NAME,isPersonAccount__c,Company_Logo__c FROM Company__c WHERE NAME =: companyName]){
        comid.add(cot.id);
       }
      return comid;
    }  
    
    
    public database.upsertResult upsertCompanyExt(Company_Ext__c comext  ){
         
         return dataBase.upsert(comext, false);
    }
    
    // Getting Companies along with Diversity types belongs to an Event written by Manasa Gandham
     public List<Company__c> companiesForEvent(SET<Id> companyIds){
     return [SELECT ID, NAME, (SELECT ID, Diversity__c, Diversity__r.Name FROM Company_Diversity__r) FROM Company__c WHERE ID IN: companyIds];
   }
   
   public List<Company__c> gnusercompanies(string gnid){
    
    List<UC_Role__c> UCRS =  [SELECT id,Name,Company__c from UC_Role__c where GN_User__r.id =: gnid AND RoleId__r.Name = 'Company Admin'];
    List<id> compids = new List<id> ();
        for(UC_Role__c uc : UCRS){
            
            compids.add(uc.Company__c);
        
        
        }
        List<Company__c>  companys =[SELECT ID, NAME,Website_URL__c,Description__c, isPersonAccount__c,Company_Logo__c,(SELECT ID, NAME, Business_Address1__c, Business_Address2__c, Business_City__c, BLN_Business_Country__c, BLN_Business_Country__r.Short_Name__c, BLN_Business_State__c,BLN_Business_State__r.Short_Name__c, Business_Zipcode__c, Work_Phone__c,Company__c,Duns_Number__c,
                                             Established_Date__c,Keywords__c,Number_Of_Employees__c,Primary_NAICS_Code__c,Revenue__c,Secondary_NAICS_Code__c,Tax_Id__c FROM Company_Ext__r) FROM Company__c WHERE id IN : compids];
        
        return companys ;
       }
   
}