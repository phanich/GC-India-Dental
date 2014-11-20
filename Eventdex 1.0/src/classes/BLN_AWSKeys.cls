public class BLN_AWSKeys {
        
        public class AWSKeysException extends Exception {}
        
        private static BLN_AWSKeys instance = null;
        
        AWS_Credentials__c AWSkeyObj = null;
        public string key { get { return AWSkeyObj.Access_Key__c; } private set; }
        public string secret { get { return AWSkeyObj.Secret__c; } private set; }
        public string endPoint { get { return AWSkeyObj.End_Point_URL__c; } private set; }
        public String name {get; set;}

        // constructor
        public BLN_AWSKeys() {
        
        }
        
        public static BLN_AWSKeys getInstance(String name)
        {
                if(instance==null || instance.name != name)
                {
                        instance = new BLN_AWSKeys();
                        instance.name = name;
                        instance.getKeys();
                }
                return instance;  
        }
        
        private void getKeys()
        {
            try {
                    AWSkeyObj = [select Access_Key__c,Secret__c,End_Point_URL__c,id from AWS_Credentials__c where name = :name limit 1]; 
                    
                    //Check that key__c is not null
                    if(AWSkeyObj.Access_Key__c == null || AWSkeyObj.Access_Key__c == ''){
                       //ApexPages.addMessages();
                       ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: No key is specified for the AWS_Credentials__c record with name of [' +name+']. Pleaes enter the Key value and retry.');
                       ApexPages.addMessage(errorMsg);
                       throw new AWSKeysException('Error: No key is specified for the AWSKey__c record with name of [' +name+']. Pleaes enter the Key value and retry.');         
                    }
                    
                    //Check that secret__c is not null
                    if(AWSkeyObj.Secret__c == null || AWSkeyObj.Secret__c == ''){
                       ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: No secret is specified for the AWS_Credentials__c record with name of [' +name+']. Pleaes enter the Secret value and retry.');
                       ApexPages.addMessage(errorMsg);
                       throw new AWSKeysException('Error: No secret is specified for the AWSKey__c record with name of [' +name+']. Pleaes enter the Secret value and retry.');         
                    }
                    
                    //Check that End_Point_URL__c is not null
                    if(AWSkeyObj.End_Point_URL__c == null || AWSkeyObj.End_Point_URL__c == ''){
                       ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: No EndPoint is specified for the AWS_Credentials__c record with name of [' +name+']. Pleaes enter the Secret value and retry.');
                       ApexPages.addMessage(errorMsg);
                       throw new AWSKeysException('Error: No secret is specified for the AWSKey__c record with name of [' +name+']. Pleaes enter the Secret value and retry.');         
                    }
                    
            } catch (QueryException queryEx) {
                    system.debug('Error when querying the AWS_Credentials__c custom object. Did not find any record with name of ['+name+']. Please make sure the name is correct or create a record with the proper AWS credentials and retry.');
                    //ApexPages.addMessages(queryEx);
                    throw new AWSKeysException('Error when querying the AWS_Credentials__c custom object. Did not find any record with name of ['+name+']. Please make sure the name is correct or create a record with the proper AWS credentials and retry.');
                    //AWSkeyObj = new AWS_Credentials__c( Access_Key__c='not set', Secret__c='not set', End_Point_URL__c='not set' );
            } 
            //don't catch other exceptions, let them fall through to the calling class....
        }
}