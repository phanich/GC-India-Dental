global class AWS_EmailBatchCallouts implements Database.Batchable<Messaging.SingleEmailMessage>, Database.AllowsCallouts{

    //global GN_User__c[] UsersToSendEmails;
    global LIST<Messaging.SingleEmailMessage> Ueids;

    global void fetchEmails(LIST<Messaging.SingleEmailMessage> setOfatts){   
        //UsersToSendEmails = [SELECT ID, Name, First_Name__c, Last_Name__c, Email__c, Company_Name__c FROM GN_User__c WHERE ID IN: setOfatts]; 
        Ueids = setOfatts;
    }
    
    global Iterable<Messaging.SingleEmailMessage> start(database.batchablecontext BC){
        //return (UsersToSendEmails); 
        return (Ueids); 
    }
    
    global void execute(Database.BatchableContext BC, List<Messaging.SingleEmailMessage> scope){
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
            for(Messaging.SingleEmailMessage use : scope){
                
                
                
                LIST<String> emailist = new LIST<String>();
                //emailist.add()
                LIST<String> rlist = new LIST<String>();
                rlist.addAll(use.getToAddresses());
                ReplacedHtml = use.getHtmlBody();                
                ReplacedSubject = use.getSubject();
                sesEmail.sendEmail(rlist,sender,ReplacedSubject,ReplacedHtml);
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