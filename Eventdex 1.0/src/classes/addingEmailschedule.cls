global class addingEmailschedule implements Schedulable {

// This test runs a scheduled job every day

   
   
   global void execute(SchedulableContext ctx) {
   LIST<GN_User__c> GNUSERS = new LIST<GN_User__c> ();
   LIST<EmailCampaign__c> Emailcampaign = new LIST<EmailCampaign__c>();
   OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName = 'Booth Leads'];
   Emailcampaign = [SELECT id,Email_Send_Date__c,Event__c,CampEmailTemplate__c,CampFromName__c,CampFromEmailId__c,ToList__c FROM EmailCampaign__c WHERE Email_Send_Date__c != null AND Email_Send_Date__c <= Today];
   LIST<Emailtemplate> E = [select Body,Subject,HtmlValue,Markup from EmailTemplate ];    
   MAP<string,Emailtemplate> TempMap = new  MAP<string,Emailtemplate> ();
       for(Emailtemplate ET : E){
       TempMap.put(ET.id,ET);
       }
   LIST<ItemPool_Tag_Junction__c> ITJ = new LIST<ItemPool_Tag_Junction__c>();
   ITJ = [SELECT id,Pool_Id__r.id, Pool_Id__r.Event__c,Tag_Id__c,Tag_Id__r.Event__c FROM ItemPool_Tag_Junction__c];
   LIST<Ticket__c> tics = [SELECT id,Event__c,Item__r.Name,Item_Pool__r.id,Client_GN_User__c, 
                                   Event__r.City__c,Event__r.BLN_Country__r.Name,Event__r.Venue_Name__c,Event__r.End_Date__c,Event__r.Start_Date__c,
                                   Event__r.BLN_State__c,Event__r.Street2__c,Event__r.ZipCode__c FROM Ticket__c WHERE  Ticket_Status__c ='Booked'];
   MAp<string,Ticket__c> ticmapofevent = new MAp<string,Ticket__c>();
   MAP<string,Ticket__c> ticmap = new MAP<string,Ticket__c> ();
       for(Ticket__c tic : tics){
       ticmap.put(tic.Item_Pool__c,tic);
       ticmapofevent.put(tic.Client_GN_User__c,tic);
       } 
   GNUSERS = [SELECT id,Email__c,First_Name__c,Last_Name__c,Company_Name__c FROM GN_User__c];    
   MAP<id,GN_User__c>  GNUSERSMAP = new MAP<id,GN_User__c>();
         for(GN_User__c GN : GNUSERS ){
               GNUSERSMAP.put(GN.id,GN);
           } 
       
       List <Messaging.SingleEmailMessage> emails = new List <Messaging.SingleEmailMessage> ();
       LIST<String> emailbatch = new LIST<String>();
       SET<Ticket__c> ticset = new SET<Ticket__c> ();
       for(EmailCampaign__c Ecamp : Emailcampaign){
       Emailtemplate Emtemp = new Emailtemplate ();
       List<GN_User__c> emailids = new List<GN_User__c> ();
           if(Ecamp.Email_Send_Date__c != null && Ecamp.Email_Send_Date__c == system.TODAY()){
             system.debug(':::::::::;mythily1::::::;;;;;'+Ecamp.CampEmailTemplate__c);
                Emtemp = TempMap.get(Ecamp.CampEmailTemplate__c);
                system.debug(':::::::::;mythily1::::::;;;;;'+TempMap);
                for(ItemPool_Tag_Junction__c IPJ : ITJ ){
                    //if(ticmap.get(IPJ.Pool_Id__c)!= null){
                    //Ticket__c tict = ticmap.get(IPJ.Pool_Id__c);
                        for(Ticket__c tt :tics ){
                        system.debug('dddddddddddddddddddddddddddd'+tt.Event__c+'rrrrrrrrrrrrrrrrrrrrrrr'+tt.Item_Pool__r.id);
                      if(tt.Event__c == Ecamp.Event__c && tt.Item_Pool__r.id != null){  
                    if(tt.Item_Pool__r.id == IPJ.Pool_Id__r.id ){
                        if(ticset.add(tt)){
                            emailids.add(GNUSERSMAP.get(tt.Client_GN_User__c));
                            }
                        }    
                    } 
                   }
                }  
                system.debug('::::::::::Email Ids::::::::::::;'+emailids);
                for(GN_User__c GN : emailids){
                system.debug('eeeeeeeeeetem:::::;;'+Emtemp);
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    String[] toaddress = new String[] { GN.Email__c };
                    system.debug('eeeeeeeeeetem:::::;;'+toaddress);
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                    email.setToAddresses(toaddress);
                    
                    String subject = Emtemp.Subject;
                    String ReplaceContactName   = Emtemp.HtmlValue;
                    Ticket__c TT = ticmapofevent.get(GN.id);
                    
                if(ReplaceContactName.contains('{$Lastname}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$Lastname}',GN.Last_Name__c);                   
                }
                if(ReplaceContactName.contains('{$FirstName}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$FirstName}',GN.First_Name__c);                    
                }
                if(ReplaceContactName.contains('{$username}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$username}',GN.First_Name__c+' '+GN.Last_Name__c);                    
                }
                if(ReplaceContactName.contains('{$EventName}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$EventName}',TT.Event__r.Name);                    
                }
                if(ReplaceContactName.contains('{$Location}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$Location}',TT.Event__r.Venue_Name__c);                    
                }
                if(ReplaceContactName.contains('{$company}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$company}',GN.Company_Name__c);                    
                }
                if(ReplaceContactName.contains('{$logo}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$logo}','<img src="https://c.cs11.content.force.com/servlet/servlet.ImageServer?id='+TT.Event__r.Logo_URL__c+'&oid=00DZ0000000pGvZ"'+' width="150" height="140" style=" border:0px; padding:10px; " />');                    
                }
                if(ReplaceContactName.contains('{$date}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$date}',TT.Event__r.Start_Date__c+' TO ' +TT.Event__r.End_Date__c);                    
                }
                    
                   
                    email.setSubject(subject);
                    email.setHtmlBody(ReplaceContactName );
                    emails.add(email);
                    
                    String se = '';
                    se = GN.Email__c+'###'+subject+'###'+ReplaceContactName;
                    emailbatch.add(se);
               }      
           }
       }
         system.debug('emails====='+emails);          
       AWS_EmailBatchCallouts ebc = new AWS_EmailBatchCallouts();
       ebc.fetchEmails(emailbatch);
       database.executeBatch(ebc,100);
   
    //Messaging.SendEmailResult[] r = Messaging.sendEmail(emails,false);
    /*system.debug('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr'+r); 
    Map<Id,Messaging.SendEmailResult> targetToResultMap = new Map<Id,Messaging.SendEmailResult>();
    integer i=0;
    for(Messaging.SendEmailResult sendEmailResult: r){
    targetToResultMap.put(emails.get(i).getTargetObjectId(),sendEmailResult);    
    i++;
    }
    system.debug('ddddddddddddddddddddddddddddd'+targetToResultMap);*/
   }
   
   }