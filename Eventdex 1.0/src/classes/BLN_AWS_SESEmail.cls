public with sharing class BLN_AWS_SESEmail {
        public List<String> toAddresses { get; set; }
        public string fromAddress { get; set; }
        public string subject { get; set; }
        public string body { get; set; }

        public String encodedEmail { 
            get{
                return encodeEmail();
            }
            set;
        }

        public BLN_AWS_SESEmail(List<String> toAddresses,String fromAddress,String subject, String body)
        {
            this.toAddresses = toAddresses;
            this.fromAddress = fromAddress;
            this.subject = subject;
            this.body = body;
        } 
        
        /**
         * Encode the email as described in the SES documentation:
         * http://docs.amazonwebservices.com/ses/latest/DeveloperGuide/
         **/ 
         
        private String encodeEmail()
        {
            String email = 'Action=SendEmail';
            email += '&Source='+EncodingUtil.urlEncode(this.fromAddress,'UTF-8');
            for(Integer i=1;i<this.toAddresses.size()+1;i++)
            {
                email += '&Destination.ToAddresses.member.'+i+'='+EncodingUtil.urlEncode(this.toAddresses[i-1],'UTF-8');
            } 
            email += '&Message.Subject.Data='+EncodingUtil.urlEncode(this.subject,'UTF-8');
            email += '&Message.Body.Html.Data='+EncodingUtil.urlEncode(this.body,'UTF-8');
            return email;
        }
}