trigger updateOwner on account(before update,before insert) {
    
     list<account> acc=Trigger.new;
     
     system.debug('AAAAAAAAAAAAAA'+acc);
     MAP<String, String> Usermap = new MAP<string,string>();  
    list<user> userlist=[select id,lastname from user WHERE isActive=TRUE];
       
      for(user u: userlist){
        Usermap .put(u.Lastname,u.id);
      }
      system.debug('TTTTTTTTTTTTT'+Usermap);
      system.debug('SSSSSSSSSSSSSSSSSSS' +Usermap.size());
      
         for(account a:acc){
            system.debug('WWWWWWWWWWWWWWWWWWWW' +a.Assign_To__c);
            if(a.Assign_To__c != null){
                if(Usermap.containsKey(a.Assign_To__c )){
                    a.OwnerId = Usermap.get(a.Assign_To__c );
                }
            }
          
         system.debug('QQQQQQQQQQQQ'+a);}
          
         
         }