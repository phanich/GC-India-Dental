public with sharing class BLN_UserAnswers_DAO{

/***************************************************************************************************************************************************************************************************
*   Author                  : Mahesh Sakunala
*   Date                    : 28/07/2014 
*   Purpose                 : This class is for inserting and fetching User Answers for Survey Questions.
*   Last Modified           : Mahesh Sakunala - 28/07/2014
*****************************************************************************************************************************************************************************************************/

//------------------------------------------------------------- Method to insert User Answer Start --------------------------------------------------------------------------------     
     public BLN_StatusMessage insertUserAnswer(Id UserId,String AnswerId, Id ItemQuestionId){
         
         // Fetching Answer Details using Answer Id
         LIST<Answer__c> Answer = new LIST<Answer__c>();
         Answer = [SELECT ID,NAME,Answer_Text__c,Answer_Order__c,Answer_Default__c 
                   FROM Answer__c 
                   WHERE ID =: AnswerId];
         
         User_Answer__c UAnswer = new User_Answer__c();
         
         UAnswer.User__c = UserId;
         UAnswer.Item_Question__c = ItemQuestionId;
         if(Answer.size() > 0){
             UAnswer.Answer__c =  Answer[0].Id;
             UAnswer.UAnswer_Text__c = Answer[0].Answer_Text__c;
         }
         else{
             UAnswer.UAnswer_Text__c = AnswerId;
         }
         
         Database.Saveresult Response = Database.Insert(UAnswer,false);
         return new BLN_StatusMessage(Response);
     }
//------------------------------------------------------------- Method to insert User Answer End --------------------------------------------------------------------------------    

//------------------------------------------------------------- Method to Fetch User Answer Start --------------------------------------------------------------------------------     
     public LIST<User_Answer__c> fetchUserAnswer(Id UserId){
         
         // Fetching User Answer Details using User Id
         LIST<User_Answer__c> UserAnswer = [SELECT ID,NAME,User__c,Item_Question__c,Answer__c,Answer__r.Answer_Text__c,UAnswer_Text__c 
                                            FROM User_Answer__c
                                            WHERE User__c =: UserId];
         return UserAnswer;
     }
//------------------------------------------------------------- Method to Fetch User Answer End --------------------------------------------------------------------------------  



}