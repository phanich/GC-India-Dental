trigger triggeronupdatetasksub on Task (Before insert,Before update) {
  if(trigger.isinsert)
  {
  for (Task t: Trigger.new) {
           if(t.Subject == null){
              t.Subject = t.Meeting_Type__c;
           }else{
           }
  }
  }
 if(trigger.isupdate)
  {
 for (Task t: Trigger.new) {
        Task oldTask = Trigger.oldMap.get(t.ID);
        if(oldTask .Meeting_Type__c == oldTask .Subject && oldTask .Subject == t.Subject ) {
           t.Subject = t.Meeting_Type__c;
        }
        else if(t.Subject == null)
        {
           t.Subject = t.Meeting_Type__c;
        }
        
      }
   }   
}