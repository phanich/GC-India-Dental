public with sharing class clearDataBaseCon {

 public String selected { get; set; }
 public string replace { get; set; }
 public string[]  q{get;set;}
    
    
    
 public clearDataBaseCon() {
 q =new string[]{};
 List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values(); 
   for(Schema.SObjectType f : gd){
       if(string.valueOf(f).contains('__c')&& string.valueOf(f)!='NAICS_Code__c' && string.valueOf(f)!='Profile__c'){
         q.add(string.valueOf(f));
        }
   }
    }


public Pagereference clear(){



for(string spl :q){

if(spl !='State__c' && spl !='Country__c' && spl !='Item_Type__c'  && spl !='PGateway_Type__c' && spl !='Currency__c' && spl !='Registration_Template__c' ){


string str = '';

 string eves = '\'Default Event(Boothleads)\'';
 
 if(spl=='BLN_Event__c'){
      
    str = ' where name !='+eves ;
    
 }
 
 
 
string makestr ='select id  from '+spl ;

 if(str !=''){
   makestr+=str;
 }
 
   makestr +=' limit 999';
system.debug('SSSSSSSSSSSSSSSSSSSSSSSSSSS '+makestr );

List<sObject> listofvalues = new List<sObject>();
listofvalues = dataBase.query(makestr); 

system.debug('WWWWWWWWWWWWWWWWWWWWWWW '+listofvalues );
    
   
   if(listofvalues.size()>0){
   
      dataBase.deleteResult[] db = dataBase.delete(listofvalues,false);
      system.debug('RRRRRRRRRRRR '+db );
    }
 }  
}

return null;
}

 



}