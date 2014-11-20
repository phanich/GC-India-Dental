global class sendingemail implements Schedulable {

// This test runs a scheduled job every day

  
   global void execute(SchedulableContext ctx) {
    
   // This test runs a scheduled job every day
     string[] toaddress = new string[]{'phani@globalnest.com'};
     string[] ccaddress = new string[]{'mythilyn@globalnest.com'};
     List<Messaging.SingleEmailMessage> mails= new List <Messaging.SingleEmailMessage>();
    
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setUseSignature(false);
    mail.setToAddresses( toaddress );
    mail.setCcaddresses(ccaddress );
    mail.setSubject('Your Statement');
    mail.setHtmlBody('Dear Customer,<br><br> Hi This is Phani schedule is working .');
     // Send the email
     mails.add(mail);
     Messaging.SendEmailResult[] r  = Messaging.sendEmail(mails);
     system.debug('PPPPPPPPPPPPPP '+r);
     system.debug('PPPPPPPPPPPPPP '+r);  
     
  
       }
  }