public with sharing class sampleCon {

 public class innercls{
   public List<Account> accounts{get;set;}
       public innercls(string s){
          accounts = new List<Account>();
          accounts = [select id,Name from account limit 3];
       }
       
       
        public innercls(){
          accounts = new List<Account>();
         
       }
 
 }    
    
  
}