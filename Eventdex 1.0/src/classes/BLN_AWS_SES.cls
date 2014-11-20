public class BLN_AWS_SES extends BLN_AWS {
        
        public String method = 'POST';

        public BLN_AWS_SES(String key, String secret, String endpoint){
                this.key = key;
                this.secret= secret;
                this.endpoint = endpoint;        
        }
          
        public void sendEmail(List<String> toAddresses, String fromAddress, String subject, String body)
        {        
                String awsFormattedNow=awsFormattedDate(Datetime.now());
                
                HttpRequest httpReq = new HttpRequest();
                httpReq.setMethod(method);
                httpReq.setEndpoint(this.endpoint);
                httpReq.setHeader('X-Amzn-Authorization',headerForAmazonAuthorization(key,signature(awsFormattedNow,this.secret)));
                httpReq.setHeader('Content-Type','application/x-www-form-urlencoded');
                httpReq.setHeader('Date',awsFormattedNow);
                
                BLN_AWS_SESEmail newEmail = new BLN_AWS_SESEmail(toAddresses,fromAddress,subject,body);
                
                httpReq.setBody(newEmail.encodedEmail);
                
                System.debug(httpReq.getBody());
                 
                Http http = new Http();
                
                HttpResponse response = http.send(httpReq);
                System.debug(response.getBody());
        }        
}