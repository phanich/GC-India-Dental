public with sharing class customersearchcontoller{
    /*   
        Author   : G.Shruthi Reddy
        Date     : 23/9/2013
        Version  : 1.0 
    */
    public ApexPages.StandardController controller {get; set;}
    public List<Account> searchResults {get;set;}
    public Account a;
    public string searchByName {get;set;}
    public string searchByCity{get;set;}
    public string searchByPhone{get;set;}
    public string searchByClinicName{get;set;}

    public customersearchcontoller (ApexPages.StandardController controller) {
        this.controller = controller;
        this.a = (Account)controller.getRecord();
        searchResults = new List<Account>();
        searchByName = '';
        searchByCity = '';
        searchByPhone = '';
        searchByClinicName = '';
        
        search();
        
    }
    // fired when the search button is clicked
    public PageReference search()
    {
      
       String QueryString = ' where ';
       IF(searchByName != '') { 
           QueryString += '(Name LIKE  \''+ searchByName +'%\') AND ';        
       }
       IF(searchByCity != ''){
           QueryString += '(Billing_City__c LIKE \'%'+searchByCity +'%\') AND ';
       }
       IF(searchByPhone != ''){
           QueryString += '(Phone__c LIKE \'%'+searchByPhone+'%\') AND ';
       }
       IF(searchByClinicName!= ''){
           QueryString += '(Clinic_Name__c LIKE \'%'+searchByClinicName+'%\') AND ';
       }
         
       String qry;
       if(QueryString.length() > 7){  
           QueryString = QueryString.subString(0,QueryString.lastIndexOf('AND'));
           System.debug('RRRRRRRRRRRR**********************'+QueryString );
           qry = 'select Id,Name,Phone__c,Billing_City__c,Type__c,Clinic_Name__c from Account ' + QueryString;
       }
       else
           qry = 'select Id,Name,Phone__c,Billing_City__c,Type__c,Clinic_Name__c from Account  Order By Name LIMIT 250';
       searchResults = new List<Account>();
       searchResults = Database.query(qry);
       return null;  
       } 
     
}