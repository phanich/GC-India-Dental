public with sharing class aws_ses_test_con {


    public EmailCampaign__c emailcamp {get;set;}

    public aws_ses_test_con ()
    {
    
    }




  public PageReference sendEmail()
  {
    
    
        BLN_AWSKeys awsKey = BLN_AWSKeys.getInstance('AES Credentials');
        BLN_AWS_SES sesEmail = new BLN_AWS_SES(awsKey.key,awsKey.secret, awsKey.endpoint );
        
        List<String> recipients = new List<String>();
        recipients.add('mythilyn@globalnest.com');
        recipients.add('krishna@globalnest.com');
        String sender = 'rajeshc@globalnest.com';
        String subject = 'Test message';
        String body = 'Hello, Test Mail';
        
        sesEmail.sendEmail(recipients,sender,subject,body);
        
        return null;
  }

 /* public void sendEmail1()
  {
    //Creating the instance of AWS_EmailFormat class
    //AWS_EmailFormat emailUtil = new AWS_EmailFormat();

    //body of that method AWS_EmailDateFormat is defined in AWS_EmailFormat class.
    //String AWSEmailDateFormat = emailUtil.AWS_EmailDateFormat(Datetime.now());
    
    String awstodate =  Datetime.now().format('EEE, dd MMM yyyy HH:mm:ss Z');
    system.debug('awstodate----'+awstodate);

    String algorithmName = 'HmacSHA256';
    Blob hmacData = Crypto.generateMac(algorithmName, Blob.valueOf(awstodate), Blob.valueOf(secret));
    system.debug('hmacData ----'+hmacData);
    
    String Signature =  EncodingUtil.base64Encode(hmacData);
    system.debug('Signature ----'+Signature );
    
    HttpRequest httpReq = new HttpRequest(); 
    httpReq.setEndpoint(endpoint);
    httpReq.setMethod(method);
    httpReq.setHeader('X-Amzn-Authorization', 'AWS3-HTTPS AWSAccessKeyId='+key+', Algorithm=HmacSHA256, Signature='+Signature); 
    httpReq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    httpReq.setHeader('Date', awstodate);

    List<String> recipients = new List<String>();
    recipients.add('mythilyn@globalnest.com');
    //recipients.add('kalyan@globalnest.com'); 
    //recipients.add('vineel@globalnest.com'); 
    //recipients.add('phani@globalnest.com'); 
    String sender = 'rajeshc@globalnest.com';
    String subject = 'Test message';
    String body = 'Hello, Test Mail';

    

    String email = 'Action=SendEmail';
           email += '&Source='+EncodingUtil.urlEncode(sender,'UTF-8');
             for(Integer i=1;i<recipients.size()+1;i++)
              {
                email += '&Destination.BccAddresses.member.'+i+'='+EncodingUtil.urlEncode(recipients[i-1],'UTF-8');
              } 
            email += '&Message.Subject.Data='+EncodingUtil.urlEncode(subject,'UTF-8');
            email += '&Message.Body.Html.Data='+EncodingUtil.urlEncode(body,'UTF-8');

    httpReq.setBody(email);

    System.debug('*******BODY*******'+httpReq.getBody()); 

    Http http = new Http();
    HttpResponse response = http.send(httpReq); 
      
    //system.debug('http.send(httpReq)----'+http.send(httpReq));
    
    System.debug('RESPONSE FROM AWS'+response.getBody());
    system.debug('OKAY THATS FINE THANKS!!!'); 
    }
    */
    public String getSendEmail() {
        sendEmail();
        return null;
    }   
    
    
   //FOR SENDING EMAILS NOW
   public LIST<id> emailids {get ; set ;}
   public LIST<GN_User__c> GNUSERS {get ; set ;}
   public boolean emailalert {get ; set ;}
   
   public void sendnow(){
   
   GNUSERS = new LIST<GN_User__c>();
   emailids = new LIST<id>();
   string  editcamid = Apexpages.Currentpage().getparameters().get('editcamid');
   string  selectedeventid  = Apexpages.Currentpage().getparameters().get('eventid');
   //geteventdetails();
   system.debug('::::::::::::::::editcamid::::::::::::::::;'+editcamid);
   emailcamp = new EmailCampaign__c();
   emailcamp = [SELECT NAME,CampEmailTemplate__c,CampFromEmailId__c,Template_Body__c,CampFromName__c,Template_Type__c,Owner.Name,CampSubject__c,createdDate,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:selectedeventid AND id=:editcamid];
   system.debug('RRRRRRRRRRRRRRRRRRRRRRRRrrrr'+emailcamp.ToList__c);
   LIST<string> taglist =  emailcamp.ToList__c.split(',');     
   Emailtemplate E = [select Body,Subject,HtmlValue,Markup from EmailTemplate Where id=: emailcamp.CampEmailTemplate__c];
   system.debug('EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEe'+E);
   LIST<ItemPool_Tag_Junction__c> ITJ = new LIST<ItemPool_Tag_Junction__c>();
   ITJ = [SELECT id,Pool_Id__c,Tag_Id__c FROM ItemPool_Tag_Junction__c WHERE Tag_Id__r.Event__c =:selectedeventid ];
  
   system.debug('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHh'+ITJ );
   LIST<Ticket__c> tics = [SELECT id,Item__r.Name,Item_Pool__r.Name,Client_GN_User__c FROM Ticket__c WHERE  Event__c =:selectedeventid AND Ticket_Status__c ='Booked'];
     if(ITJ.size() != 0){
       for(ItemPool_Tag_Junction__c ITJR : ITJ ){
       system.debug('::::::::::;RowId__c:::::::::::::;;;;'+ITJR.Pool_Id__c );
         if(tics.size() != 0){
           for(Ticket__c TIC : tics ){
               IF(TIC.Item_Pool__c == ITJR.Pool_Id__c){
                      emailids.add(TIC.Client_GN_User__c); 
               }
           
           }
           }
      }
      }
      if(emailids.size() != 0){
    GNUSERS = [SELECT id,Email__c,First_Name__c,Last_Name__c,Company_Name__c FROM GN_User__c WHERE id IN :emailids ];
      system.debug('::::::::::::EMAIL IDS :::::::::::;;;'+emailids);
      
      //SENDING MAIL
      BLN_Event__c BLEvent = [SELECT id,name,City__c,BLN_Country__c,Venue_Name__c,Description__c,End_Date__c,End_Time__c,Hosting_Location__c,Start_Date__c,BLN_State__c,Street2__c,ZipCode__c,Website_Url__c FROM BLN_Event__c WHERE id =:selectedeventid  ];
      list <Messaging.SingleEmailMessage> emails = new List <Messaging.SingleEmailMessage> ();
        for(GN_User__c GN : GNUSERS){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String[] toaddress = new String[] { GN.Email__c };
            email.setToAddresses(toaddress);
            String subject = E.Subject;
            String ReplaceContactName   = E.HtmlValue;
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
                    ReplaceContactName  = ReplaceContactName.Replace('{$EventName}',BLEvent.Name);                    
                }
                if(ReplaceContactName.contains('{$Location}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$Location}',BLEvent.Venue_Name__c);                    
                }
                if(ReplaceContactName.contains('{$company}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$company}',GN.Company_Name__c);                    
                }
                if(ReplaceContactName.contains('{$logo}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$logo}','<img src="https://c.cs11.content.force.com/servlet/servlet.ImageServer?id='+BLEvent.Logo_URL__c+'&oid=00DZ0000000pGvZ"'+' width="150" height="140" style=" border:0px; padding:10px; " />');                    
                }
                if(ReplaceContactName.contains('{$date}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$date}',BLEvent.Start_Date__c+' ' +BLEvent.End_Date__c);                    
                }
            email.setHtmlBody(ReplaceContactName);
            email.setSubject(subject);       
            emails.add(email);
      
       }
       
    Messaging.SendEmailResult[] r = Messaging.sendEmail(emails);
    system.debug('::::::::::::::;;EMAIL RESULT:::::::::;'+r);
    boolean check = true;
         for (Messaging.SendEmailResult ms: r) {
             check = check && ms.isSuccess();
         }
         if (check == true){
             emailalert = true;
     }  
     }
   }
    
    
    
    
    
    
    
}