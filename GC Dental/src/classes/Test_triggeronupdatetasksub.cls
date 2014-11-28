@isTest
public class Test_triggeronupdatetasksub{
static testmethod void testmethod_triggeronupdatetasksub(){


Task t = new Task();
t.Status='In Progress';
t.Priority='Normal';
t.Meeting_Type__c = 'Visited the Customer';
if(t.subject == '')
{
t.subject = t.Meeting_Type__c;
}
Else{
}
insert t;

Task task=[select id,Meeting_Type__c,subject from Task where id =:t.id];
if(task.subject == task.Meeting_Type__c)
{
 task.subject = task.Meeting_Type__c;
update task;
}
else if(task.subject != task.Meeting_Type__c)
{
   task.Meeting_Type__c = 'Visited the Customer' ;
   update task;
}
else if(task.subject == NULL)
{  
   task.subject = task.Meeting_Type__c;
  upsert task;

}


}



}