global class AWS_EmailBatchCallouts implements Database.Batchable<String>, Database.AllowsCallouts{

    //global GN_User__c[] UsersToSendEmails;
    global LIST<String> Ueids;

    global void fetchEmails(LIST<String> setOfatts){   
        //UsersToSendEmails = [SELECT ID, Name, First_Name__c, Last_Name__c, Email__c, Company_Name__c FROM GN_User__c WHERE ID IN: setOfatts]; 
        Ueids = setOfatts;
    }
    
    global Iterable<String> start(database.batchablecontext BC){
        //return (UsersToSendEmails); 
        return (Ueids); 
    }
    
    global void execute(Database.BatchableContext BC, List<String> scope){
        try{ 
                        
            BLN_AWSKeys awsKey = BLN_AWSKeys.getInstance('AES Credentials');
            BLN_AWS_SES sesEmail = new BLN_AWS_SES(awsKey.key,awsKey.secret, awsKey.endpoint );
                        
            EmailTemplate E = new EmailTemplate();    
            E = [SELECT Body,Subject,HtmlValue,Markup FROM EmailTemplate WHERE Id = '00XF0000001CeUH'];
            
            String ReplaceHtml = E.HtmlValue;
            String ReplaceSubject = E.Subject;
            String ReplacedHtml;
            String ReplacedSubject;
            
            for(String use : scope){
                String sender;
                
                sender = 'rajeshc@globalnest.com';
                
                LIST<String> rlist = new LIST<String>();
                rlist.add(use);
                ReplacedHtml = ReplaceHtml.Replace('{!Name}','Rajesh kumar');                
                ReplacedSubject = ReplaceSubject.Replace('{!EventName}','Test');
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