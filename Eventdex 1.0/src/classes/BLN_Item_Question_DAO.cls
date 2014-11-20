public  without sharing class BLN_Item_Question_DAO {

 
 
 
   //-------------- This method is to retrieve ItemQuestionsList for the event------------.
    
    Public LIST<Item_Question__c> itmquestionslist(String selectedeventid ,LIST<Item_Question__c> itmquestionslist )
     
     {
        return itmquestionslist = [Select Id,item__c,Question__c,Question__r.Event__c,IQ_Order__c,Question__r.Id,(SELECT ID,NAME,Item_Question__c,Answer__c,UAnswer_Text__c,User__c FROM User_Answers__r ) FROM Item_Question__c WHERE Question__r.Event__c =: selectedeventid];
     }
     
     


 
 //---------------------- This method is Insert/Update Question-------------------------  

 Public  List<Database.upsertResult> srList{get;set;}
   
    Public List<Database.upsertResult> UpsertItemQuestion(List<Item_Question__c> itmque)
     {
    
         system.debug('========ItemQuestionlist' +itmque);
         srList = new List<Database.upsertResult>();
         return  srList = Database.upsert(itmque, false);
         
     }
     
    


     //----------------------------Method to delete ItemQuestions-------------------------------------------
        
        public LIST<Database.DeleteResult> deleteitmque(LIST<Item_Question__c> delitemquelist ){
        
            Database.DeleteResult[] DR_Dels = Database.Delete(delitemquelist,false);
            return  DR_Dels ;
        
        }
        
        
         




}