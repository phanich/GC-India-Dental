global without sharing class AWS_SES_Test1con {

    public PageReference savecamptemp() {
        return null;
    }


  
 
  /***********************************************************************************************
    *   Controller Name         : BLN_Email_Dashboards
    *   Date                    : 08/08/2014 
    *   Author                  : Shruthi Reddy Gone
    *   Purpose                 : This class is for Creating Email Dashboards.
    **************************************************************************************************/
   public string inputValue  {get ; set ;}
   public date scheduleddate {get ; set ;}
   public string selectedeventid{get;set;}
   public string selectedtemplateval {get ; set ;}
   public string htmlbodyvalue {get;set;}
   public BLN_UtillDisplayLinks myemaildashboards {get;set;} 
   public BLN_Event__c eventslist {get;set;} 
   public List<EmailCampaign__c> emailcamplist {get;set;} 
   public List<EmailCampaign__c> anouncecmaplist{get;set;} 
   public List<EmailCampaign__c> remaindermaplist{get;set;}
   public List<EmailCampaign__c> registermaplist{get;set;}
   public List<EmailTemplate> emailtemp {get;set;}
   public List<Hash_Tag__c>  hashtagslist{get;set;} 
   public EmailCampaign__c emailcamp {get;set;} 
   public MAP<string,EmailCampaign__c> emailcampMAP {get;set;} 
   public MAP<String,EmailTemplate> emailtempMAP {get;set;} 
   public List<SelectOption> Tempnames {get;set;} 
   Public List<selectoption> viewoptionList {get;set;}
   public List<string> reciepientslist{get;set;} 
   public Boolean displaybool {get;set;} 
   public Boolean editbool{get;set;} 
   public Boolean escapebool{get;set;} 
   public string outputId {get;set;}
   public Boolean savebool {get;set;}
   public boolean scheduleBool {get ; set ;}
   public string daysbefore {get ; set ;}
   public LIST<selectoption> taglist {get ; set ;}
   public List<string> selectedtags {get ; set ;}
   public list<selectoption> fieldoptions {get;set;}
   public string selectedfield {get;set;}
   
   public void displayPermissions(){

          emailalert = false;
     Cookie k = ApexPages.currentPage().getCookies().get('counter');
     if(k!=null){
     selectedeventid = k.getValue();
     }
   
     try{
     eventslist  = geteventdetails();
     }catch(exception e){}
   
    SYSTEM.DEBUG('EVENTID:' + selectedeventid );
         
         myemaildashboards = new BLN_UtillDisplayLinks();
         myemaildashboards .isemailsPage='active';
         myemaildashboards .isregistrationPageExpand='expand';
         myemaildashboards .tablabel='Email Dashboard';
         try{
         myemaildashboards .eventName = eventslist.Name;
         }catch(exception e){}
         myemaildashboards .EventId= selectedeventid;
         myemaildashboards .userPermissions(userInfo.getUserId(),selectedeventid);
            // selectedeventid = 'a0sc0000001p8Xp' ;
    }
    
    Public AWS_SES_Test1con(){
    
      
     Cookie k = ApexPages.currentPage().getCookies().get('counter');
     if(k!=null){
         selectedeventid = k.getValue();
     }
     
    hashtagslist  = new List<Hash_Tag__c> ();
    reciepientslist = new List<String>();
    Tempnames = new List<SelectOption>();
    viewoptionList = new List<SelectOption>();
    htmlbodyvalue = '';
    outputId = '';
    displaybool = true;
    editbool = false;
    escapebool= false;
    savebool = false;
    emailalert = false;
    allcampaigns();
 //  selectedeventid = 'a0sc0000001xuYd' ;
}

    public void allcampaigns(){
    emailcamplist = new  List<EmailCampaign__c>();
    emailcamplist = [SELECT NAME,CampEmailTemplate__c,Available_to_Use__c,Email_Send_Date__c,CampFromEmailId__c,CampFromName__c,Template_Type__c,CreatedDate,Owner.Name,CampSubject__c,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:selectedeventid AND Event__c != NULL ORDER BY Template_Type__c];
     

     anouncecmaplist = new  List<EmailCampaign__c>();
     remaindermaplist = new  List<EmailCampaign__c>();
     registermaplist = new  List<EmailCampaign__c>();
         for(EmailCampaign__c email : emailcamplist ){
              
                 if(email.CampType__c == 'Registration email')
                {
                  registermaplist.add(email); 
                }
                if(email.CampType__c == 'Announcement')
                {
                  anouncecmaplist.add(email); 
                }
                  if(email.CampType__c == 'Reminder')
                {
                  remaindermaplist.add(email); 
                } 
 
 
       }
 
     fieldoptions = new list<selectoption> {};
            fieldoptions.add(new selectoption ('--None--','--None--'));
            fieldoptions.add(new selectoption ('First Name','First Name'));
            fieldoptions.add(new selectoption ('Last Name','Last Name'));
            fieldoptions.add(new selectoption ('Company Name','Company Name'));
            fieldoptions.add(new selectoption ('Event Name','Event Name'));
            fieldoptions.add(new selectoption ('Event Logo','Event Logo'));
            
            
            
    }
    //-------------------------------------SHOW FIELDS ---------------------------------------
    public string showfied {get;set;}
    public void fetchingfieldval(){
        if(selectedfield == 'First Name'){
            showfied ='{!FirstName}';
        }
         if(selectedfield == 'Last Name'){
             showfied = '{!LastName}';
        }
         if(selectedfield == 'Company Name'){
             showfied = '{!CompanyName}';
        }
         if(selectedfield == 'Event Name'){
             showfied = '{!EventName}';
        }
        if(selectedfield == 'Event Logo'){
             showfied = '{!EventLogo}';
        }
    
    }
    
    
    // -------------------------- This method is to Retrieve Event Details.--------------------------
      
       Public BLN_Event__c geteventdetails(){
         BLN_PromoCode_BAL blneventdetailbal = New BLN_PromoCode_BAL();
         RETURN eventslist = blneventdetailbal.eventdetails(selectedeventid);
      }
   //FOR CREATING NEW CAMPAIGN
    public List<selectoption> campaigntypelist {get ; set ;}
    public boolean newtype {get ; set ;}
    public boolean existingtype {get ; set ;}
    public string selectedcamptype {get ; set ;}
    public void createcampaign(){
    
    selectedcamptype  = '';
    campaigntypelist = new List<selectoption> ();
    campaigntypelist.add(new selectoption ('Announcement ','Announcement '));
    campaigntypelist.add(new selectoption ('Reminder','Reminder'));
    newtype = true;
    existingtype = false;
    emailcamp = new EmailCampaign__c();
      hashtagslist  = new List<Hash_Tag__c> ([SELECT ID,Name,RowId__c,Table_Name__c,Tag_Text__c,Event__c FROM Hash_Tag__c WHERE Event__c=:selectedeventid ]);
      system.debug('123222222222' +hashtagslist  );
      set<string> tagsset = new set<string>(); 
           
           for(Hash_Tag__c tags: hashtagslist  ){
                  tagsset.add(tags.Tag_Text__c); 
           }            
          system.debug('123222222222' +tagsset);
          reciepientslist = new List<String>();
          reciepientslist.addAll(tagsset);
    emailcamplist = new  List<EmailCampaign__c>();
    LIST<EmailCampaign__c> emailcampslist = [SELECT NAME,CampEmailTemplate__c,CampFromEmailId__c,Template_Body__c,CampFromName__c,Template_Type__c,Owner.Name,CampSubject__c,createdDate,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:selectedeventid AND Name != 'Order Confirmation' AND Name != 'Ticket Confirmation'];
    Tempnames = new List<SelectOption>();
            try{
            for(EmailCampaign__c EMC : emailcampslist ){
            Tempnames.add(new SelectOption(EMC.CampEmailTemplate__c,EMC.NAME));
            }
            }catch(Exception e){}
    savebool = false; 
       editbool = true;
       displaybool = true;
   
       
    }
   //EDIT CAMPAIGN
   Public Void editcamp(){
            
            emailalert = false;
            string  editcamid = Apexpages.Currentpage().getparameters().get('editcamid');
            string  selectedeventid  = Apexpages.Currentpage().getparameters().get('eventid');
              
            geteventdetails();

           System.debug('32423432 editcamid' + editcamid);
          campaigntypelist = new List<selectoption> ();
    campaigntypelist.add(new selectoption ('Announcement ','Announcement '));
    campaigntypelist.add(new selectoption ('Reminder','Reminder'));
    campaigntypelist.add(new selectoption ('Order Confirmation','Order Confirmation'));
    campaigntypelist.add(new selectoption ('Ticket Confirmation','Ticket Confirmation'));
         emailcamp = new EmailCampaign__c();
         emailcamp = [SELECT NAME,CampEmailTemplate__c,System_Template_Type__c,CampFromEmailId__c,Template_Body__c,CampFromName__c,Template_Type__c,Owner.Name,CampSubject__c,createdDate,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:selectedeventid AND id=:editcamid];
             if(emailcamp.CampType__c == 'Announcement ' || emailcamp.CampType__c == 'Reminder' ){
                  system.debug('dddddddddddd'+emailcamp.CampType__c);
                  selectedcamptype = emailcamp.CampType__c;
              }else{
                  system.debug('dddddddddddd'+emailcamp.CampType__c);
                  selectedcamptype = emailcamp.System_Template_Type__c;          
              }
          System.debug('32423432453' + emailcamp);
          newtype = false;
          existingtype = true;

            
            
          if(emailcamp.CampFromName__c == '' || emailcamp.CampFromName__c == NULL){
          
             emailcamp.CampFromName__c =  emailcamp.Owner.Name;
          }
          
           if(emailcamp.CampType__c == 'Registration email')
           {
             emailcamp.CampSubject__c = emailcamp.CampSubject__c.replace('{!eventname}',eventslist.Name);
           }
          

            Tempnames = new List<SelectOption>();
            try{
            Tempnames.add(new SelectOption(emailcamp.CampEmailTemplate__c,emailcamp.NAME));
            }catch(Exception e){}

     
      hashtagslist  = new List<Hash_Tag__c> ([SELECT ID,Name,RowId__c,Table_Name__c,Tag_Text__c,Event__c FROM Hash_Tag__c WHERE Event__c=:selectedeventid ]);
      system.debug('123222222222' +hashtagslist  );
      set<string> tagsset = new set<string>(); 
           
           for(Hash_Tag__c tags: hashtagslist  ){
                  tagsset.add(tags.Tag_Text__c); 
           }
            
          system.debug('123222222222' +tagsset);
          reciepientslist = new List<String>();
          reciepientslist.addAll(tagsset);
          system.debug('123222222222' +reciepientslist);
      
      emailcamplist = new  List<EmailCampaign__c>();
     emailcamplist = [SELECT NAME,CampEmailTemplate__c,Available_to_Use__c,Email_Send_Date__c,CampFromEmailId__c,CampFromName__c,Template_Type__c,CreatedDate,Owner.Name,CampSubject__c,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:selectedeventid ORDER BY Template_Type__c];
     

     anouncecmaplist = new  List<EmailCampaign__c>();
     remaindermaplist = new  List<EmailCampaign__c>();
     registermaplist = new  List<EmailCampaign__c>();
         for(EmailCampaign__c email : emailcamplist ){
              
                 if(email.CampType__c == 'Registration email')
                {
                  registermaplist.add(email); 
                }
                if(email.CampType__c == 'Announcement')
                {
                  anouncecmaplist.add(email); 
                }
                 if(email.CampType__c == 'Reminder')
                {
                  remaindermaplist .add(email); 
                }
                 
       }
       
   
           
            
   
       savebool = false; 
       editbool = true;
       displaybool = true;
       
   }
   
     Public Void cancelmethod(){
     
          editbool = false;
          displaybool = true;  
            savebool = false; 
            emailalert = false;
            scheduleBool = false;
     }
     
     
     
     
     Public Void updatetemp(){
            
            
            system.debug('iiiiiiiiiiiiiiiiiiiiiii'+inputValue);
           editbool = false;
           displaybool = true;   
           savebool = true;
           emailalert = false;     
            
            
            
            string  campname = Apexpages.Currentpage().getparameters().get('campname');
            string  frmname = Apexpages.Currentpage().getparameters().get('frmname');
            string  reciepients = Apexpages.Currentpage().getparameters().get('reciepients');
            string  updatetempbody = Apexpages.Currentpage().getparameters().get('updatestandardtemp');

            system.debug('232342343223 ' +updatetempbody);
                        system.debug('43546467457' +frmname);
                                    system.debug('tuytutyu43' +reciepients );
             
            
            
                                 
                                    
          if(emailcamp.Name == campname ){
          
          if(emailcamp.Template_Type__c == 'Standard'){
          
           
             if(updatetempbody !=''){
                     
              String devname =  emailcamp.id+'_'+emailcamplist.size();         
              
               emailtemp =new List<EmailTemplate>();
            emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE IsActive=:true AND ID=:emailcamp.CampEmailTemplate__c];
            System.debug('sfdasdf' + emailtemp);
              
           
             
             EmailTemplate custemailtemp =new EmailTemplate();
             custemailtemp = emailtemp[0].clone();
             custemailtemp.DeveloperName = devname.trim();
             custemailtemp.Name = campname;
             custemailtemp.HtmlValue= updatetempbody;
             custemailtemp.IsActive = true;
             custemailtemp.FolderId = '00lF0000001Izb7';
             custemailtemp.Subject =  emailcamp.CampSubject__c;
             Database.SaveResult  k = Database.Insert(custemailtemp,false);
             SET<STRING> failuremessagt = new SET<STRING>();

                    if(!k.isSuccess()){
                        Database.Error error = k.getErrors().get(0);
                        String failedDML =Error.getMessage();             
                        failuremessagt.add(failedDML);
                  
                    }
               
                       system.debug('47687979' + failuremessagt);
             
             
               system.debug('w33453 46' + custemailtemp.Id);
               system.debug('we5r456575646' + custemailtemp.Name);
               system.debug('46556768' + reciepients);
                 
               forinsertcampaign(custemailtemp.Name,custemailtemp.Id,emailcamp.CampFromEmailId__c,frmname,emailcamp.CampSubject__c,emailcamp.CampType__c,emailcamp.Event__c,reciepients,emailcamp.ToListType__c,selectedcamptype);   
  
             

         } 
          
          
          else{
          system.debug('24235435' + emailcamp.ToList__c );
          if(emailcamp.ToList__c == null){
           emailcamp.ToList__c ='';
          }
          
          
           if(emailcamp.ToList__c == reciepients ){
           emailcamp.CampFromName__c = frmname;
           emailcamp.ToList__c= reciepients ;
           System.debug('32423432453' + emailcamp);
           Database.update(emailcamp,false);
           }
           
           else{
           
           String devname =  emailcamp.id+'_'+emailcamplist.size();         
              
               emailtemp =new List<EmailTemplate>();
               emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE IsActive=:true AND ID=:emailcamp.CampEmailTemplate__c];
               System.debug('sfdasdf' + emailtemp);
              
           
             
             EmailTemplate custemailtemp =new EmailTemplate();
             custemailtemp = emailtemp[0].clone();
             custemailtemp.DeveloperName = devname.trim();
             custemailtemp.Name = campname;
             //custemailtemp.HtmlValue= updatetempbody;
             custemailtemp.IsActive = true;
             custemailtemp.FolderId = '00lF0000001Izb7';
             custemailtemp.Subject =  emailcamp.CampSubject__c;
             Database.SaveResult  k = Database.Insert(custemailtemp,false);
             SET<STRING> failuremessagt = new SET<STRING>();

                    if(!k.isSuccess()){
                        Database.Error error = k.getErrors().get(0);
                        String failedDML =Error.getMessage();             
                        failuremessagt.add(failedDML);
                  
                    }
               
                       system.debug('47687979' + failuremessagt);
             
             
               system.debug('w33453 46' + custemailtemp.Id);
               system.debug('we5r456575646' + custemailtemp.Name);
               system.debug('46556768' + reciepients);
               
               
           
               
               forinsertcampaign(custemailtemp.Name,custemailtemp.Id,emailcamp.CampFromEmailId__c,frmname,emailcamp.CampSubject__c,emailcamp.CampType__c,emailcamp.Event__c,reciepients,emailcamp.ToListType__c,selectedcamptype);   
  
             
           }
           
          
          } 
           
           
         }
         
         
         else{
        
         if(updatetempbody !=''){
         
      
         
          emailtemp =new List<EmailTemplate>();
            emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE IsActive=:true AND Id =: emailcamp.CampEmailTemplate__c];
            System.debug('sfdasdf' + emailtemp);
         
             emailtemp[0].HtmlValue= updatetempbody; 
             Database.Update(emailtemp,false);
            forinsertcampaign(emailcamp.Name,emailtemp[0].Id,emailcamp.CampFromEmailId__c,frmname,emailcamp.CampSubject__c,emailcamp.CampType__c,emailcamp.Event__c,reciepients,emailcamp.ToListType__c,selectedcamptype);     
         }
         else{
          emailcamp.CampFromName__c = frmname;
           emailcamp.ToList__c= reciepients ;
           System.debug('32423432453' + emailcamp);
           if(emailcamp.CampType__c == 'Announcement ' && emailcamp.CampType__c == 'Reminder' ){
                   emailcamp.CampType__c = selectedcamptype;
               }else{
                   emailcamp.CampType__c = 'Registration email';
               }
               if(emailcamp.CampType__c == 'Registration email'){
                   system.debug('::::::::::::::::::mythily::::::;'+selectedcamptype);
                   emailcamp.System_Template_Type__c = selectedcamptype;
          
               }
           Database.update(emailcamp,false);
         
         }
         
      
         }
           
   
         }
         
          else{
          
          if(emailcamp.Template_Type__c == 'Standard')
          {
          
          if(updatetempbody == ''){
          


             
              emailtemp =new List<EmailTemplate>();
            emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE IsActive=:true AND ID=:emailcamp.CampEmailTemplate__c];
            System.debug('sfdasdf' + emailtemp);
              
             String devname =  emailcamp.id+'_'+emailcamplist.size();         
             
             EmailTemplate custemailtemp =new EmailTemplate();
             custemailtemp = emailtemp[0].clone();
             custemailtemp.DeveloperName = devname.trim();
             custemailtemp.Name = campname;
             custemailtemp.HtmlValue= emailtemp[0].HtmlValue;
             custemailtemp.IsActive = true;
             custemailtemp.FolderId = '00lF0000001Izb7';
             custemailtemp.Subject =  emailcamp.CampSubject__c;
             Database.SaveResult  k = Database.Insert(custemailtemp,false);
          
                  forinsertcampaign(custemailtemp.Name,custemailtemp.Id,emailcamp.CampFromEmailId__c,frmname,emailcamp.CampSubject__c,emailcamp.CampType__c,emailcamp.Event__c,reciepients,emailcamp.ToListType__c,selectedcamptype);   
              }
            else{
            
             emailtemp =new List<EmailTemplate>();
            emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE IsActive=:true AND ID=:emailcamp.CampEmailTemplate__c];
            System.debug('sfdasdf' + emailtemp);
            
             String devname =  emailcamp.id+'_'+emailcamplist.size();         
             
             
             EmailTemplate custemailtemp =new EmailTemplate();
             custemailtemp = emailtemp[0].clone();
             custemailtemp.DeveloperName = devname.trim();
             custemailtemp.Name = campname;
             custemailtemp.HtmlValue= updatetempbody;
             custemailtemp.IsActive = true;
             custemailtemp.FolderId = '00lF0000001Izb7';
             custemailtemp.Subject =  emailcamp.CampSubject__c;
             Database.SaveResult  k = Database.Insert(custemailtemp,false);
             SET<STRING> failuremessagt = new SET<STRING>();

                    if(!k.isSuccess()){
                        Database.Error error = k.getErrors().get(0);
                        String failedDML =Error.getMessage();             
                        failuremessagt.add(failedDML);
                  
                    }
               
                       system.debug('47687979' + failuremessagt);
             
             
               system.debug('w33453 46' + custemailtemp.Id);
               system.debug('we5r456575646' + custemailtemp.Name);
               system.debug('46556768' + reciepients);
               
               
           
               
               forinsertcampaign(custemailtemp.Name,custemailtemp.Id,emailcamp.CampFromEmailId__c,frmname,emailcamp.CampSubject__c,emailcamp.CampType__c,emailcamp.Event__c,reciepients,emailcamp.ToListType__c,selectedcamptype);   
  
            
            }  
            
             }
           else{
           
           
              if(updatetempbody !=''){
              
         
                emailtemp =new List<EmailTemplate>();
                //emailcamp.CampEmailTemplate__c = emailtemp.id;
                emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE  Id =: inputvalue];
                
                System.debug('sfdasdf' + emailtemp);
         
                 emailtemp[0].HtmlValue= updatetempbody; 
                 Database.Update(emailtemp,false);
                forinsertcampaign(campname,emailtemp[0].Id,emailcamp.CampFromEmailId__c,frmname,emailcamp.CampSubject__c,emailcamp.CampType__c,emailcamp.Event__c,reciepients,emailcamp.ToListType__c,selectedcamptype);     
             }
             else{
               emailcamp.Name = campname;
               emailcamp.CampFromName__c = frmname;
               emailcamp.ToList__c= reciepients ;
               System.debug('32423432453' + emailcamp);
               Database.upsert(emailcamp,false);
             
             }
           
           }  
             
             
            SYSTEM.DEBUG('1111111111111111WSFSF' + anouncecmaplist);
           }
          
          
  

  
               system.debug('657hgjg' + editbool);
     }
 
  public List<EmailTemplate> emailtemps {get ; set ;}
 Public Void getemailcampslist(){
 
     emailcamplist = new  List<EmailCampaign__c>();
     emailcamplist = [SELECT NAME,CampEmailTemplate__c,Email_Send_Date__c,Available_to_Use__c,CampFromEmailId__c,CampFromName__c,Template_Type__c,CreatedDate,Owner.Name,CampSubject__c,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:selectedeventid AND Event__c != NULL ORDER BY Template_Type__c];
     

     anouncecmaplist = new  List<EmailCampaign__c>();
     remaindermaplist = new  List<EmailCampaign__c>();
     registermaplist = new  List<EmailCampaign__c>();
        
         for(EmailCampaign__c email : emailcamplist ){
              
                 if(email.CampType__c == 'Registration email')
                {
                  registermaplist.add(email); 
                }
                if(email.CampType__c == 'Announcement')
                {
                  anouncecmaplist.add(email); 
                }
                 if(email.CampType__c == 'Reminder')
                {
                  remaindermaplist .add(email); 
                }
 
    }
 
 }
   
   
   
   

      @RemoteAction
      
        global static EmailCampaign__c getcampaigninfo(String campaigntype ,string selectedeventid) {
      
          SYSTEM.DEBUG('1111111111111111WSFSF' + campaigntype);
          SYSTEM.DEBUG('rwerewrtewrt345' + selectedeventid );
          EmailCampaign__c emailcamp = new EmailCampaign__c();

          emailcamp = [SELECT NAME,CampEmailTemplate__c,CampFromEmailId__c,CampFromName__c,Owner.Name,CampSubject__c,createdDate,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:selectedeventid AND id=:campaigntype];
          System.debug('32423432453' + emailcamp);
          return emailcamp ;
      }
      
       @RemoteAction 
       global static EmailTemplate  getemailtempopts(string selectedtempid) {
        
            EmailTemplate emailtemp =new EmailTemplate();
            emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE IsActive=:true  AND ID=: selectedtempid];
            System.debug('sfdasdf' + emailtemp);
            //emailtemps.add(emailtemp);
            return emailtemp ;
               
       }
     
     
       @future 
    public static void forinsertcampaign(string campname,string custemailtemId,string EmailId,String frmname,String subject,String camptype,String event,string reciepients,string tolisttype,string selectedcamptype){
              system.debug('23436 45654' + campname);
               system.debug('32345325346456' + campname);
             
             List<EmailCampaign__c> newemailcamp = new List<EmailCampaign__c> (); 
             newemailcamp = [SELECT NAME,CampEmailTemplate__c,System_Template_Type__c,CampFromEmailId__c,CampFromName__c,Owner.Name,CampSubject__c,createdDate,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:event AND CampEmailTemplate__c=:custemailtemId];     
             if(newemailcamp .size() >0){
               newemailcamp[0].Name  = campname;
                newemailcamp[0].CampEmailTemplate__c =custemailtemId;
               newemailcamp[0].CampSubject__c = subject;
               newemailcamp[0].CampFromEmailId__c =  EmailId;
               newemailcamp[0].CampFromName__c = frmname;
               newemailcamp[0].ToList__c= reciepients ;
               newemailcamp[0].CampType__c = camptype;
              
               System.debug('32423432453' + newemailcamp );
               if(camptype == 'Registration email'){
                   system.debug('::::::::::::::::::mythily::::::;'+selectedcamptype);
                   newemailcamp[0].System_Template_Type__c = selectedcamptype;
          
               }
               Database.update(newemailcamp,false);
             }  
           else{    
            EmailCampaign__c nwemailcamp = new EmailCampaign__c (); 
             nwemailcamp.Name = campname;
             nwemailcamp.CampEmailTemplate__c =custemailtemId;
             nwemailcamp.CampFromEmailId__c =  EmailId;
             nwemailcamp.CampFromName__c = frmname;
             nwemailcamp.CampSubject__c = subject;
             nwemailcamp.CampType__c = camptype;
             nwemailcamp.Event__c = event;
             nwemailcamp.Template_Type__c = 'Custom';
             nwemailcamp.ToList__c = reciepients;
             nwemailcamp.ToListType__c = tolisttype;
              system.debug('ewr43t654365' + nwemailcamp);
                if(camptype == 'Registration email'){
                   system.debug('::::::::::::::::::mythily::::::;'+selectedcamptype);
                   nwemailcamp.System_Template_Type__c = selectedcamptype;
          
               }
               Database.SaveResult s= Database.Insert(nwemailcamp,false);
               
                SET<STRING> failuremessageset = new SET<STRING>();

                    if(!s.isSuccess()){
                        Database.Error error = s.getErrors().get(0);
                        String failedDML =Error.getMessage();             
                        failuremessageset.add(failedDML);
                  
                    }
               
                       system.debug('232434565ncb ' + failuremessageset);
     
      
            }
               
   }
   
    
   
   
   Public void campaignslist(){
               getemailcampslist();
               savebool = false;
              editbool = false;
              displaybool = true; 
              emailalert = false;
  // Pagereference pg = new Pagereference('/apex/BLN_Email_Dashboards');
   //return pg;

   }
   
   //FOR AUTO SCHEDULE
    public EmailCampaign__c ecamp {get ; set ;}
    public list<selectoption> radiooptions {get ; set ;}
    public string selectedRadio {get ; set ;}
    public void autoschedule(){
    
    savebool= false;
    taglist = new List<selectoption>();
    selectedtags = new List<string> ();
    radiooptions = new list<selectoption> ();
    
    ecamp = new EmailCampaign__c();
    scheduleBool = true;
    
    radiooptions.add(new selectoption ('Days before the event','Days before the event'));
    radiooptions.add(new selectoption ('Date','Date'));
    string  editcamid = Apexpages.Currentpage().getparameters().get('editcamid');
    string  selectedeventid  = Apexpages.Currentpage().getparameters().get('eventid');
    system.debug('::::::::::::::::::editcamid ::::::::::::::;'+editcamid );
    ecamp = [SELECT id,name, auto_schedule_Type__c,Email_Send_Date__c, ToList__c FROM EmailCampaign__c WHERE id =: editcamid];
    BLN_Event__c event = [select id,name,Start_Date__c From BLN_Event__c WHERE id =: selectedeventid ];
        if(ecamp.Email_Send_Date__c != null){ 
             Integer noOfDays = event.Start_Date__c.daysBetween(ecamp.Email_Send_Date__c);
        }
        if(ecamp.auto_schedule_Type__c != null && ecamp.auto_schedule_Type__c != ' '){
            if( ecamp.auto_schedule_Type__c == 'Days before the event'){
                selectedRadio = 'Days before the event';
                daysbool = true;
                datebool = false;
                daysbefore = string.valueOf(ecamp.Email_Send_Date__c.daysBetween(event.Start_Date__c));
            }else{
                selectedRadio = 'Date';
                datebool = true;
                daysbool = false;
                scheduleddate = ecamp.Email_Send_Date__c;
            }
            //ecamp.Email_Send_Date__c = ecamp.Email_Send_Date__c;
        }
    hashtagslist  = new List<Hash_Tag__c> ([SELECT ID,Name,RowId__c,Table_Name__c,Tag_Text__c,Event__c FROM Hash_Tag__c WHERE Event__c=:selectedeventid ]);
    system.debug('123222222222' +hashtagslist  );
    set<string> tagsset = new set<string>(); 
           
           for(Hash_Tag__c tags: hashtagslist  ){
                  tagsset.add(tags.Tag_Text__c);
                  taglist.add(new selectoption(tags.Tag_Text__c,tags.Tag_Text__c)); 
           }
     LIST<string> tolist =  new LIST<string>();
     if(ecamp.ToList__c != null && ecamp.ToList__c != ' '){
         tolist = ecamp.ToList__c.split(',');
             for(string st : tolist){
              selectedtags.add(st);
    
             }   
         }
          system.debug('123222222222' +tagsset);
          reciepientslist = new List<String>();
          reciepientslist.addAll(tagsset);
    
    }
    //SAVING SCHEDULED DATE
    public void addingschedule(){
    
    string seltag ='';
    BLN_Event__c event = [select id,name,Start_Date__c From BLN_Event__c WHERE id =: selectedeventid ];
        
        if(selectedRadio == 'Days before the event'){
            date dd = event.Start_Date__c-integer.valueOf(daysbefore);
                for(string sst:selectedtags ){
                    seltag += sst+',';
                }                 
        ecamp.Email_Send_Date__c = dd;
        }else{
            system.debug('pppppppppppppppppppppppppppppppppppppppppppp'+scheduleddate);
            ecamp.Email_Send_Date__c =scheduleddate ;
        }
        
    system.debug('pppppppppppppppppppppppppppppppppppppppppppp'+ecamp.Email_Send_Date__c);
        if(seltag != null && seltag != ' '){
            ecamp.ToList__c = seltag ;
        }
    ecamp.auto_schedule_Type__c = selectedRadio;
    update ecamp ;
    scheduleBool = false;
    system.debug('pppppppppppppppppppppppppppppppppppppppppppp'+ecamp );
    }
    
   //FOR SENDING EMAILS NOW
   public LIST<id> emailids {get ; set ;}
   public LIST<GN_User__c> GNUSERS {get ; set ;}
   public boolean emailalert {get ; set ;}
   
   public void sendnow(){
   
   GNUSERS = new LIST<GN_User__c>();
   emailids = new LIST<String>();
   /*string  editcamid = Apexpages.Currentpage().getparameters().get('editcamid');
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
      system.debug('emailids.size()-111------'+emailids.size());
      if(emailids.size() != 0){      
          system.debug('emailids.size()---222----'+emailids.size());
          AWS_EmailBatchCallouts ebc = new AWS_EmailBatchCallouts();
          ebc.fetchEmails(emailids);
          database.executeBatch(ebc,10);
      
      
      
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
     }else{*/
        /*emailids.add('rajeshc+1@globalnest.com');
emailids.add('rajeshc+2@globalnest.com');
emailids.add('rajeshc+3@globalnest.com');
emailids.add('rajeshc+4@globalnest.com');
emailids.add('rajeshc+5@globalnest.com');
emailids.add('rajeshc+6@globalnest.com');
emailids.add('rajeshc+7@globalnest.com');
emailids.add('rajeshc+8@globalnest.com');
emailids.add('rajeshc+9@globalnest.com');
emailids.add('rajeshc+10@globalnest.com');
emailids.add('krishna+11@globalnest.com');
emailids.add('krishna+12@globalnest.com');
emailids.add('krishna+13@globalnest.com');
emailids.add('krishna+14@globalnest.com');
emailids.add('krishna+15@globalnest.com');
emailids.add('krishna+16@globalnest.com');
emailids.add('krishna+17@globalnest.com');
emailids.add('krishna+18@globalnest.com');
emailids.add('krishna+19@globalnest.com');
emailids.add('krishna+20@globalnest.com');
emailids.add('krishna+21@globalnest.com');
emailids.add('krishna+22@globalnest.com');
emailids.add('krishna+23@globalnest.com');
emailids.add('durga+24@globalnest.com');
emailids.add('durga+25@globalnest.com');
emailids.add('durga+26@globalnest.com');
emailids.add('durga+27@globalnest.com');
emailids.add('durga+28@globalnest.com');
emailids.add('durga+29@globalnest.com');
emailids.add('durga+30@globalnest.com');
emailids.add('durga+31@globalnest.com');
emailids.add('durga+32@globalnest.com');
emailids.add('durga+33@globalnest.com');
emailids.add('durga+34@globalnest.com');
emailids.add('durga+35@globalnest.com');
emailids.add('durga+36@globalnest.com');
emailids.add('durga+37@globalnest.com');
emailids.add('durga+38@globalnest.com');
emailids.add('durga+39@globalnest.com');
emailids.add('durga+40@globalnest.com');
emailids.add('durga+41@globalnest.com');
emailids.add('durga+42@globalnest.com');
emailids.add('durga+43@globalnest.com');
emailids.add('durga+44@globalnest.com');
emailids.add('durga+45@globalnest.com');
emailids.add('durga+46@globalnest.com');
emailids.add('durga+47@globalnest.com');
emailids.add('durga+48@globalnest.com');
emailids.add('durga+49@globalnest.com');
emailids.add('durga+50@globalnest.com');
emailids.add('durga+51@globalnest.com');
emailids.add('durga+52@globalnest.com');
emailids.add('durga+53@globalnest.com');
emailids.add('durga+54@globalnest.com');
emailids.add('durga+55@globalnest.com');
emailids.add('durga+56@globalnest.com');
emailids.add('durga+57@globalnest.com');
emailids.add('durga+58@globalnest.com');
emailids.add('durga+59@globalnest.com');
emailids.add('durga+60@globalnest.com');
emailids.add('durga+61@globalnest.com');
emailids.add('durga+62@globalnest.com');
emailids.add('durga+63@globalnest.com');
emailids.add('durga+64@globalnest.com');
emailids.add('durga+65@globalnest.com');
emailids.add('durga+66@globalnest.com');
emailids.add('durga+67@globalnest.com');
emailids.add('durga+68@globalnest.com');
emailids.add('durga+69@globalnest.com');
emailids.add('durga+70@globalnest.com');
emailids.add('durga+71@globalnest.com');
emailids.add('durga+72@globalnest.com');
emailids.add('durga+73@globalnest.com');
emailids.add('durga+74@globalnest.com');
emailids.add('durga+75@globalnest.com');
emailids.add('durga+76@globalnest.com');
emailids.add('durga+77@globalnest.com');
emailids.add('durga+78@globalnest.com');
emailids.add('durga+79@globalnest.com');
emailids.add('durga+80@globalnest.com');
emailids.add('durga+81@globalnest.com');
emailids.add('durga+82@globalnest.com');
emailids.add('durga+83@globalnest.com');
emailids.add('durga+84@globalnest.com');
emailids.add('durga+85@globalnest.com');
emailids.add('durga+86@globalnest.com');
emailids.add('durga+87@globalnest.com');
emailids.add('durga+88@globalnest.com');
emailids.add('durga+89@globalnest.com');
emailids.add('durga+90@globalnest.com');
emailids.add('durga+91@globalnest.com');
emailids.add('durga+92@globalnest.com');
emailids.add('durga+93@globalnest.com');
emailids.add('durga+94@globalnest.com');
emailids.add('durga+95@globalnest.com');
emailids.add('durga+96@globalnest.com');
emailids.add('durga+97@globalnest.com');
emailids.add('durga+98@globalnest.com');
emailids.add('durga+99@globalnest.com');
emailids.add('durga+100@globalnest.com');
emailids.add('durga+101@globalnest.com');
emailids.add('durga+102@globalnest.com');
emailids.add('durga+103@globalnest.com');
emailids.add('durga+104@globalnest.com');
emailids.add('durga+105@globalnest.com');
emailids.add('durga+106@globalnest.com');
emailids.add('durga+107@globalnest.com');
emailids.add('durga+108@globalnest.com');
emailids.add('durga+109@globalnest.com');
emailids.add('durga+110@globalnest.com');
emailids.add('raj+111@globalnest.com');
emailids.add('raj+112@globalnest.com');
emailids.add('raj+113@globalnest.com');
emailids.add('raj+114@globalnest.com');
emailids.add('raj+115@globalnest.com');
emailids.add('raj+116@globalnest.com');
emailids.add('raj+117@globalnest.com');
emailids.add('raj+118@globalnest.com');
emailids.add('raj+119@globalnest.com');
emailids.add('raj+120@globalnest.com');
emailids.add('raj+121@globalnest.com');
emailids.add('raj+122@globalnest.com');
emailids.add('raj+123@globalnest.com');
emailids.add('raj+124@globalnest.com');
emailids.add('raj+125@globalnest.com');
emailids.add('raj+126@globalnest.com');
emailids.add('raj+127@globalnest.com');
emailids.add('raj+128@globalnest.com');
emailids.add('raj+129@globalnest.com');
emailids.add('raj+130@globalnest.com');
emailids.add('raj+131@globalnest.com');
emailids.add('raj+132@globalnest.com');
emailids.add('raj+133@globalnest.com');
emailids.add('raj+134@globalnest.com');
emailids.add('raj+135@globalnest.com');
emailids.add('raj+136@globalnest.com');
emailids.add('raj+137@globalnest.com');
emailids.add('raj+138@globalnest.com');
emailids.add('raj+139@globalnest.com');
emailids.add('rajeshc+140@globalnest.com');
emailids.add('rajeshc+141@globalnest.com');
emailids.add('rajeshc+142@globalnest.com');
emailids.add('rajeshc+143@globalnest.com');
emailids.add('rajeshc+144@globalnest.com');
emailids.add('rajeshc+145@globalnest.com');
emailids.add('rajeshc+146@globalnest.com');
emailids.add('rajeshc+147@globalnest.com');
emailids.add('rajeshc+148@globalnest.com');
emailids.add('rajeshc+149@globalnest.com');
emailids.add('rajeshc+150@globalnest.com');
emailids.add('rajeshc+151@globalnest.com');
emailids.add('rajeshc+152@globalnest.com');
emailids.add('rajeshc+153@globalnest.com');
emailids.add('rajeshc+154@globalnest.com');
emailids.add('rajeshc+155@globalnest.com');
emailids.add('rajeshc+156@globalnest.com');
emailids.add('rajeshc+157@globalnest.com');
emailids.add('rajeshc+158@globalnest.com');
emailids.add('rajeshc+159@globalnest.com');
emailids.add('rajeshc+160@globalnest.com');
emailids.add('rajeshc+161@globalnest.com');
emailids.add('rajeshc+162@globalnest.com');
emailids.add('rajeshc+163@globalnest.com');
emailids.add('rajeshc+164@globalnest.com');
emailids.add('rajeshc+165@globalnest.com');
emailids.add('rajeshc+166@globalnest.com');
emailids.add('rajeshc+167@globalnest.com');
emailids.add('rajeshc+168@globalnest.com');
emailids.add('rajeshc+169@globalnest.com');
emailids.add('rajeshc+170@globalnest.com');
emailids.add('rajeshc+171@globalnest.com');
emailids.add('rajeshc+172@globalnest.com');
emailids.add('rajeshc+173@globalnest.com');
emailids.add('rajeshc+174@globalnest.com');
emailids.add('rajeshc+175@globalnest.com');
emailids.add('rajeshc+176@globalnest.com');
emailids.add('rajeshc+177@globalnest.com');
emailids.add('rajeshc+178@globalnest.com');
emailids.add('rajeshc+179@globalnest.com');*/
emailids.add('rajeshc@globalnest.com');



    
    
          system.debug('emailids.size()---333----'+emailids.size());
          AWS_EmailBatchCallouts ebc = new AWS_EmailBatchCallouts();
          ebc.fetchEmails(emailids);
          database.executeBatch(ebc,100);
     
     //}
   }
   public boolean datebool {get ; set ;}
   public boolean daysbool {get ; set ;}
   public void selectradiobool(){
   if(selectedradio == 'Days before the event'){
   daysbool = true;
   datebool = false;
   }else{
   daysbool = false;
   datebool = true;
   }
   }
   public void savenewcampaign(){
   
    emailtemp =new List<EmailTemplate>();
    emailcamplist =emailcamplist = [SELECT NAME,CampEmailTemplate__c,Available_to_Use__c,CampFromEmailId__c,CampFromName__c,Template_Type__c,CreatedDate,Owner.Name,CampSubject__c,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE  Event__c != NULL ORDER BY Template_Type__c];
    emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE  Id =: inputvalue];
    string  campname = Apexpages.Currentpage().getparameters().get('campname');
    string  frmname = Apexpages.Currentpage().getparameters().get('frmname');
    string  reciepients = Apexpages.Currentpage().getparameters().get('reciepients');
    string  updatetempbody = Apexpages.Currentpage().getparameters().get('updatestandardtemp'); 
    system.debug(':::::::::::::::::::HTML BODY::::::::::::::::;;;'+updatetempbody );
    EmailTemplate custemailtemp =new EmailTemplate();
    String devname1 =  'MatchLeads'+'_'+emailcamplist.size(); 
    system.debug(':::::::::::Eventdex:::::::::::::'+devname1);
             custemailtemp = emailtemp[0].clone();
             custemailtemp.DeveloperName = devname1.trim();
             custemailtemp.Name = campname;
             custemailtemp.HtmlValue= updatetempbody;
             custemailtemp.IsActive = true;
             custemailtemp.FolderId = '00lF0000001Izb7';
             custemailtemp.Subject =  emailcamp.CampSubject__c;
             Database.SaveResult  k = Database.Insert(custemailtemp,false);
             system.debug(':::::::::::::saved Result::::::;;'+k);
             SET<STRING> failuremessagt = new SET<STRING>();

                    if(!k.isSuccess()){
                        Database.Error error = k.getErrors().get(0);
                        String failedDML =Error.getMessage();             
                        failuremessagt.add(failedDML);
                  
                    }
              emailcamp.Event__c = selectedeventid;      
              emailcamp.CampType__c = selectedcamptype ;      
             forinsertcampaign(campname,custemailtemp.Id,emailcamp.CampFromEmailId__c,frmname,emailcamp.CampSubject__c,emailcamp.CampType__c,emailcamp.Event__c,reciepients,emailcamp.ToListType__c,selectedcamptype);     
           system.debug('eeeeeeeeeeeeeeeeee'+emailcamp);
            editbool = false;
           displaybool = true;   
           savebool = true;
           emailalert = false;
               
   }
   public void creatingnewtemplate(){
   string  newtemp = Apexpages.Currentpage().getparameters().get('newtemp');
   string  updatetempbody = Apexpages.Currentpage().getparameters().get('updatestandardtemp');
   system.debug('ssssssssssssssssssssssssssssssssss'+newtemp );
   EmailTemplate custemailtemp =new EmailTemplate();
    String devname =  emailcamp.id+'_'+emailcamplist.size(); 
             custemailtemp.HtmlValue= updatetempbody;
             custemailtemp.DeveloperName = devname.trim();
             custemailtemp.Name = newtemp ;
             custemailtemp.HtmlValue= updatetempbody;
             custemailtemp.IsActive = true;
             custemailtemp.FolderId = '00lF0000001Izb7';
             custemailtemp.Subject =  emailcamp.CampSubject__c;
             Database.SaveResult  k = Database.Insert(custemailtemp,false);
   }
   
    public string status {get ; set ;}
    public void activatetemp(){
    
        string ss = Apexpages.Currentpage().getparameters().get('active');
        system.debug('aaaaaaaaaaaaaaaaaa'+ss);
        EmailCampaign__c ec = [SELECT id,Name,System_Template_Type__c,CampEmailTemplate__c,Available_to_Use__c from EmailCampaign__c where id =: ss];
        if(ec.Available_to_Use__c == true){
        ec.Available_to_Use__c = false;
        status = 'inactive';
        }else{
        ec.Available_to_Use__c = true;
        status = 'active';
        }
        update ec;
        EmailTemplate e = [SELECT id,Name from EmailTemplate Where id=: ec.CampEmailTemplate__c];
        system.debug(':::::::::::::::18id::::::::::'+e.id);
        string namet = e.Name;
        LIST<EmailCampaign__c> ecs = [SELECT id,Name,System_Template_Type__c,CampEmailTemplate__c,Available_to_Use__c from EmailCampaign__c where Event__c =: selectedeventid];
        MAP<string,EmailCampaign__c> ecmap = new MAP<string,EmailCampaign__c>();
            for(EmailCampaign__c em : ecs){
                ecmap.put(em.CampEmailTemplate__c,em);
            }
        LIST<EmailTemplate> es = [SELECT id,Name from EmailTemplate Where id !=: e.id];
        LIST<EmailCampaign__c> newcamps = new LIST<EmailCampaign__c> ();
            for(EmailTemplate e1 : es){
            EmailCampaign__c ecm = ecmap.get(e1.id);   
              if(ecmap.get(e1.id) != null && ecm.System_Template_Type__c == ec.System_Template_Type__c){
              system.debug(':::::::::::;mythily1::::::::::'+ecm.System_Template_Type__c);
              EmailCampaign__c ecam =  ecmap.get(e1.id);
              ecam.Available_to_Use__c = false;
              newcamps.add(ecam);
             }
            }
            system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+newcamps);
        update newcamps;
      allcampaigns();
    } 
    
    public void deleteremcamp(){
    
        string renid= Apexpages.Currentpage().getparameters().get('remid');
        EmailCampaign__c ecm = [select id,CampEmailTemplate__c from EmailCampaign__c WHERE id =: renid];
        //Emailtemplate e = [select id from emailtemplate WHERE id =: ecm.CampEmailTemplate__c];
        //delete e;
        delete ecm;
    allcampaigns();
    }
    
    public void CancelAction(){
        string campid = ApexPages.Currentpage().getparameters().get('cancelid');
        EmailCampaign__c ec = [SELECT id,Name,Email_Send_Date__c,System_Template_Type__c,CampEmailTemplate__c,Available_to_Use__c from EmailCampaign__c where id =: campid];
        ec.Email_Send_Date__c = null;
        ec.auto_schedule_Type__c = ' ';
        update ec;
         
        allcampaigns();
    
    }
}