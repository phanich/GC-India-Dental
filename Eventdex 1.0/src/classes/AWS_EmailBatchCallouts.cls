global class AWS_EmailBatchCallouts implements Database.Batchable<String>, Database.AllowsCallouts{
//Messaging.SingleEmailMessage
    //global GN_User__c[] UsersToSendEmails;
    global LIST<String> Ueids;
    //global LIST<String> emailbatch = new LIST<String>();

    global void fetchEmails(LIST<String> setOfatts){   
        //UsersToSendEmails = [SELECT ID, Name, First_Name__c, Last_Name__c, Email__c, Company_Name__c FROM GN_User__c WHERE ID IN: setOfatts]; 
        Ueids = setOfatts;
        system.debug('Ueids in BatchCallout======'+Ueids );
        
       /* for(Messaging.SingleEmailMessage es: Ueids ){
            String se = '';
            se = es.getToAddresses()+'###'+es.getSubject()+'###'+es.getHtmlBody();
            system.debug('es.getToAddresses()====='+es.getToAddresses());
            emailbatch.add(se);
        }
        system.debug('emailbatch================'+emailbatch);*/
        
    }
    
    global List<String> start(database.batchablecontext BC){
        //return (UsersToSendEmails); 
        system.debug('Ueids in  BatchCallout======'+Ueids );
        return (Ueids); 
    }
    
    global void execute(Database.BatchableContext BC, List<String> scope){
    system.debug('scope============'+scope);
        try{ 
                        
            BLN_AWSKeys awsKey = BLN_AWSKeys.getInstance('AES Credentials');
            BLN_AWS_SES sesEmail = new BLN_AWS_SES(awsKey.key,awsKey.secret, awsKey.endpoint );
                        
            /*EmailTemplate E = new EmailTemplate();    
            E = [SELECT Body,Subject,HtmlValue,Markup FROM EmailTemplate WHERE Id = '00XF0000001CeUH'];
            
            String ReplaceHtml = E.HtmlValue;
            String ReplaceSubject = E.Subject;*/
            String ReplacedHtml;
            String ReplacedSubject;
            String sender;
            sender = 'rajeshc@globalnest.com';
            for(String use : scope){ 
            
            String[] SliptStrng = use.split('###');
            //system.debug('use.getToAddresses()====='+use.getToAddresses());          
                
                LIST<String> rlist = new LIST<String>();
                rlist.add(SliptStrng[0]);
               
                 ReplacedSubject = SliptStrng[1];               
                 ReplacedHtml = SliptStrng[2];
                sesEmail.sendEmail(rlist,sender,ReplacedSubject,ReplacedHtml);
                //asr.add();
            }
        } 
        catch(Exception ex){
            system.debug(ex.getStackTraceString());
        } 
    }
    
    global void finish(Database.BatchableContext BC){
    
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob 
                          WHERE Id =:BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'rajeshc@globalnest.com'};
        mail.setToAddresses(toAddresses);
        mail.setInReplyTo('rajeshc@globalnest.com');
        mail.setSubject('BoothLeads: Mass Email Batch Process ' + a.Status);
        mail.setHTMLBody('Mass Email Batch Process ' + a.JobItemsProcessed + ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}