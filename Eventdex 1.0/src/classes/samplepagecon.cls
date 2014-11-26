public with sharing class samplepagecon {

     public DateTime dateTimeValue { get; set; }
     public String localeFormatDT  { get; set; }
     public integer x{get;set;}
     public Decimal iterateValue {get;set;}
     public string s {get;set;}
     public String encodedCipherText {get;set;}
        public LIST<SelectOption> countryOptions {get ; set ;}
     public List<integer> integers{get;set;}
     
    public samplepagecon() {
       integer f = integer.valueOf(2.0);
         iterateValue = 3/f;
         system.debug('SSSSSSSSSSSSSSSSSSS '+iterateValue );
         string SearchString ='phani';
         s='22';
         integers = new List<integer>();
         for(integer r=1;r<10;r++){
           integers.add(r);
         }
         Blob key = Blob.valueOf('a1Dc0000001iEN9');
         encodedCipherText += '  AND (Name Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Email__c Like \'%'+SearchString+'%\' OR Id IN :OrderIds)'; 
          countryOptions= new LIST<SelectOption>();
          countryOptions.add(new SelectOption('none' ,'Choose Country'));
          countryOptions.add(new SelectOption('IN' ,'India'));
          countryOptions.add(new SelectOption('US' ,'United States'));
           
         //EncodingUtil.base64Encode(key);
        // s='display:';
      //   s = EncodingUtil.base64Decode(encodedCipherText ).toString();
          
    }
    
    
    
    
    
    public List<SelectOption> getProductFields() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('', 'Products', true));
        return options;
    }

    
    
    
    @RemoteAction
    public static List<Company__c> getCompanies(string searchstr,string emailid){
     SET<id> comids = new SEt<id>();
       for(UC_Role__c uc : [select id,Company__r.name,Company__c,name from UC_Role__c where GN_User__r.email__c =:emailid]){
            comids.add(uc.Company__c);
            system.debug('WWWWWWWWWWW '+uc.Company__c);
       }
        
       string v = '%' + searchstr   + '%';  
        
       return [select id,name,isPersonAccount__c from Company__c where id In :comids and name like :v ] ;
        
    }
    
    
}