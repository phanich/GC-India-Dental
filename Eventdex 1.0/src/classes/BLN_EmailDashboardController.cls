public without sharing class BLN_EmailDashboardController {

    public String EditCampaignPopup { get; set; }

   

    public String EventName { get; set; }

    public String CompanyName { get; set; }

    public String LastName { get; set; }

    public String FirstName { get; set; }



    public String selectedcontype { get; set; }

    public String getContactTypesval { get; set; }
    public String ListItemValue{get;set;}
    public Boolean ConTypeDiv { get; set; }
    
    public List<String> ConTypes { get; set; }
    public List<SelectOption> ConTypeList { get; set; }

    
    public List<SelectOption> campTypeList { get; set; }

    public String campType { get; set; }
    
    public Boolean step2 { get; set; }
    public Boolean step1 { get; set; }
    public Boolean step3 { get; set; }
    public Boolean step4 { get; set; }
    public Boolean ShowCreateCamp { get; set; }

    public List<EmailCampaign__c> ListCamps{get;set;}
    public String SelectedEventId{get;set;}
    public List<String> EmailtempIds{get;set;}
    public List<EmailTemplate> EmailTemps{get;set;}
    public List<CampaignWrapper> WFCT{get;set;}
    
    public EmailCampaign__c campNewRec {get;set;}    
    
    public List<SelectOption> toListItems{get;set;}
    
    public String Ctitle{get;set;}
    public String Ctype{get;set;}
    public String CFname{get;set;}
    public String CFEmail{get;set;}
    public String CSubject{get;set;}
    public String CToList{get;set;}
    public String CSelectedCons{get;set;}
    public Id CEmailTemp{get;set;}
    public EmailTemplate EmailTempName{get;set;}
    
    public String SelectedCamp{get;set;}

    public BLN_EmailDashboardController(){
    
        campTypeList = new List<SelectOption>();
        campTypeList.add(new SelectOption('Announcement','Announcement'));//, Reminder, invitation
        campTypeList.add(new SelectOption('Reminder','Reminder'));
        campTypeList.add(new SelectOption('Invitation','Invitation'));
        
        campNewRec = new EmailCampaign__c();
        ListOfCampaigns();
        
        toListItems = new List<SelectOption>();
        toListItems.add(new SelectOption('All Contacts','All Contacts'));
        toListItems.add(new SelectOption('Selected Contacts','Selected Contacts'));
        
        ConTypeList = new List<SelectOption>();
        ConTypeList.add(new SelectOption('Attendees','Attendees'));
        ConTypeList.add(new SelectOption('Exhibitors','Exhibitors'));
        ConTypeList.add(new SelectOption('Sponsors','Sponsors'));
        ConTypeList.add(new SelectOption('Attendees From Past Event','Attendees From Past Event'));
        ConTypeList.add(new SelectOption('Exhibitors From Past Event','Exhibitors From Past Event'));
        
        ConTypes = new List<String>();
        
        
    }
    
    public void ListOfCampaigns(){
      try{
        ListCamps = new List<EmailCampaign__c>();
        SelectedEventId = 'a0sc0000001mIzZ';
        ListCamps = [SELECT Id, Name, CampType__c, ToListType__c, ToList__c, CampEmailTemplate__c, CreatedDate, Event__r.Start_Date__c
                     FROM EmailCampaign__c WHERE Event__r.Id=:SelectedEventId ];
        
        system.debug('ListCamps of camps========================'+ListCamps.size());
        
        EmailtempIds = new List<String>();
          for(EmailCampaign__c ec : ListCamps){
             EmailtempIds.add(ec.CampEmailTemplate__c);
          }
        
        EmailTemps = new List<EmailTemplate>();
        EmailTemps = [SELECT Id, name, Subject FROM EmailTemplate Where Id in: EmailtempIds];  
        
          Map<Id, EmailTemplate> EmailTemplateMap = new Map<Id,EmailTemplate>();
          for(EmailTemplate et:EmailTemps ){//repeating EMail template
             EmailTemplateMap.put(et.id, et);
          }
          
          WFCT = new List<CampaignWrapper>();
          for(EmailCampaign__c ecamp:ListCamps ){//Repeating Comapin Object to get Comapiagn complete record
              WFCT.add(new CampaignWrapper(ecamp, EmailTemplateMap.get(ecamp.CampEmailTemplate__c)));
          }          
      }catch(Exception ex){}
    
    
    }
    
    public class CampaignWrapper{
    
        public EmailCampaign__c Emcmp{get;set;}
        public EmailTemplate Emtmp{get;set;}
        
        public CampaignWrapper(EmailCampaign__c ec, EmailTemplate et){
            Emcmp = ec;
            Emtmp = et;            
        }
    
    
    }
    
    public void closepopup() {
        ShowCreateCamp = false;
    }
    
    public void ShowCreateCampPopup() {
        campNewRec = new EmailCampaign__c();
        ShowCreateCamp = true;
        step1 = true;
        step2 = false;
        step3 = false;
        step4 = false;
        
        SelectedCamp = ApexPages.currentPage().getParameters().get('EmailCampId');
        if(SelectedCamp!=NULL){
            system.debug('SelectedCamp 2222222222222222222222222'+SelectedCamp);
            campNewRec = [SELECT id,Name,CampEmailTemplate__c,CampFromEmailId__c,CampFromName__c,CampSubject__c,CampType__c,Event__r.Name,
                          ToList__c,ToListType__c FROM EmailCampaign__c WHERE Id=:SelectedCamp];
            if(campNewRec.ToListType__c=='Selected Contacts'){
                ConTypes.addAll(campNewRec.ToList__c.split(', '));
                ConTypeDiv = true;
            }else{
                ConTypes.add(campNewRec.ToList__c);
            }
            if(campNewRec.CampEmailTemplate__c!=''){
                selectedtemp = campNewRec.CampEmailTemplate__c;
                desiredemailTemplate();
            }
        }
    }
    
    public void ShowNext1() {
        ShowCreateCamp = true;
        step1 = false; 
        step2 = true;
        step3 = false;
        step4 = false;
        
    }    
    public void ShowNext2() {
        ShowCreateCamp = true;        
        step1 = false;
        step2 = false;
        step3 = true;
        step4 = false;
        stepTWO();     
        
    }
    public void ShowNext3() {
        ShowCreateCamp = true;        
        step1 = false;
        step2 = false;
        step3 = false;
        step4 = true;
        
       
        Ctitle = campNewRec.Name;
        Ctype = campNewRec.CampType__c;
        CSubject = campNewRec.CampSubject__c;
        CFname = campNewRec.CampFromName__c;
        CFEmail = campNewRec.CampFromEmailId__c;
        CToList = campNewRec.ToListType__c;
        
        system.debug('ConTypes==='+ConTypes);
        String cts = '';
        if(campNewRec.ToListType__c=='All Contacts')
            cts += 'All Contacts';
        else{
          if(ConTypes.size()!=0){
            for(String ct:ConTypes){
              cts += ct+', '; 
            }
            integer iintCon = cts.length();                        
            cts = cts.substring(0,iintCon-2);
            }
        }
        CSelectedCons = cts;
        CEmailTemp = selectedtemp;
        EmailTempName = new EmailTemplate();
        system.debug('CEmailTemp ==========='+CEmailTemp);
        if(CEmailTemp !=NULL){
          EmailTempName = [SELECT Id, Name FROM EmailTemplate WHERE Id=:CEmailTemp];
        }
    }
    
    public void ShowPrev1() {    
        ShowCreateCamp = true;  
        step1 = true;
        step2 = false;
        step3 = false;
        step4 = false;
        
    }
    public void ShowPrev2() {
        ShowCreateCamp = true;  
        step1 = false;
        step2 = true;
        step3 = false;
        step4 = false;        
    }
    public void ShowPrev3() {
        ShowCreateCamp = true;  
        step1 = false;
        step2 = false;
        step3 = true;
        step4 = false;
        stepTWO();
        displaybool =true;
        
        
    }
    
    public void saveCamp() {
        ShowCreateCamp = false;

        SelectedEventId = 'a0sc0000001mIzZ';
                
        String cts = '';
        campNewRec.CampEmailTemplate__c = selectedtemp;
        campNewRec.Event__c = SelectedEventId;
        if(campNewRec.ToListType__c=='All Contacts'){
            
            cts = campNewRec.ToListType__c;
            campNewRec.ToList__c = cts;
        }else{
          if(ConTypes.size()!=0){
              for(String ct:ConTypes){
              cts += ct+', '; 
              }
              integer iintCon = cts.length();          
              cts = cts.substring(0,iintCon-2);
              campNewRec.ToList__c = cts;
            }
        }
        
        
        Database.UpsertResult res = Database.Upsert(campNewRec, false);
        
        ListOfCampaigns();
        
    }
    
    public void getContactTypes() {
        ListItemValue = campNewRec.ToListType__c;
        if(ListItemValue=='Selected Contacts'){
          ConTypeDiv = true;
        }else{
          ConTypeDiv = false;
        }
    }
    
    
    /* Taken from other */
    public boolean displayeditbool {get;set;}
    public boolean Existingtemp {get;set;}
    public list<selectoption> templist {get;set;}
    public list<EmailTemplate> emtemlist {get;set;}
    public string selectedtemp {get;set;}
    public boolean errorboolname {get;set;}
    public boolean errorboolduplicate {get;set;}
    public boolean errorboolsubject {get;set;}
    public integer dup {get;set;}
    public EmailTemplate etemplate  {get;set;}
    public string uid {get;set;}
    public string TemplateName {get;set;}
    public string subjectval {get;set;}
    public string htmlbodyvalue {get;set;}
    public boolean editbuttonbool {get;set;}
    public boolean Clonebuttonbool {get;set;}
    public boolean promosDisplaybool {get;set;}
    public boolean displaybool {get;set;}
    public list<selectoption> fieldoptions {get;set;}
    public boolean escapebool {get;set;}
    public string selectedfield {get;set;}
    public string showfied {get;set;}
    public boolean displayclonebool {get;set;}
    public Boolean CancelClone {get;set;}
    public boolean newtempbool  {get;set;}
    public List<selectoption> viewoptionList {get;set;}
    public string viewopt {get;set;}
    public boolean CancelEdit{get;set;}
    
    
    public void stepTWO(){
        system.debug('            nnnnnnnnnnnnnnnnnnnnnnnnnn    '+Userinfo.getlastname( ));
        //folder f = [select id,name from folder where name Like: 'Admin'];
        displayeditbool = false;
        Existingtemp =true;
        templist = new list<selectoption> {};
        emtemlist = new list<EmailTemplate> {};  
        
        List<Folder> Folder = new List<Folder>();
        
        
        Folder = [select id, Name from Folder Where DeveloperName = 'Booth_Leads_Templates'];
        
        system.debug('============================'+Folder.size());
    
    
        if(Folder.size() > 0){
          
            emtemlist =[select name from EmailTemplate where Folder.id =: Folder[0].id AND 
                        (Owner.id =: userinfo.getuserid() OR Owner.id =:'005F0000002ODHv')AND 
                        (NOT name LIKE : '%MatchMaking%' ) ];
                        
             system.debug('    mmmmmmmmmmmmmmmmmmmmmmmmmmm 00lF0000001ItDM   '+emtemlist );
            for(EmailTemplate emtm: emtemlist ){
                templist.add(new selectoption(emtm.id,emtm.name));
            }
        }
    }
    
    public void desiredemailTemplate(){
        errorboolname = false;
        errorboolduplicate = false;
        errorboolsubject = false;
        system.debug('      selectedtemp  '+selectedtemp);
        etemplate  = new EmailTemplate();
        etemplate = [select name,Subject,HtmlValue,owner.id from EmailTemplate Where id =: selectedtemp ];
        uid = userinfo.getuserId();
        system.debug('           1111111111111111111111111        '+etemplate.owner.id);
        system.debug('           2222222222222222222222222222     '+uid);
        Templatename = etemplate.name;
        Subjectval = etemplate.Subject;
        htmlbodyvalue =etemplate.HtmlValue;
        
        if(etemplate.owner.id == uid){
        system.debug('KKKKKKKKKKK ');
        editbuttonbool = true;
        Clonebuttonbool = true;
        }
        else{
        editbuttonbool = false;
        Clonebuttonbool = true;
        }
        displaybool =true;
        displayeditbool =false;
        system.debug('      selectedtemp  rrrrrrrrrrrrrrr'+etemplate.HtmlValue  );
        system.debug('      selectedtemp  rrrrrrrrrrrrrrr 4444444444444 '+etemplate );
    }
    
    
    
    /* EDIT TEMPLATES STARTS */
    

    
    
    public void edittemplate(){
     errorboolname = false;
     errorboolduplicate = false;
     errorboolsubject = false;
     editbuttonbool = false;
     Clonebuttonbool = False;
     Existingtemp = true;
     
     
        fieldoptions = new list<selectoption> {};
        fieldoptions.add(new selectoption ('--None--','--None--'));
        fieldoptions.add(new selectoption ('First Name','First Name'));
        fieldoptions.add(new selectoption ('Last Name','Last Name'));
        fieldoptions.add(new selectoption ('Company Name','Company Name'));
        fieldoptions.add(new selectoption ('Event Name','Event Name'));
        escapebool = true;
        CancelEdit = TRUE;
        viewoptionList   = new List<selectoption> {};
        viewoptionList.add(new selectoption('Text','Text'));
        viewoptionList.add(new selectoption('HTML','HTML'));      
        displaybool = false;
       
        displayeditbool = true;
    }
    
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
    }
    
    public void escapevalue(){    
        if(viewopt == 'Text'){
            escapebool = true;
        }
        else{
            escapebool = false;
        }
    }
    
    public void updateTemplate(){
        errorboolname = false;
        errorboolduplicate = false;
        errorboolsubject = false;
        
        system.debug('              name    '+TemplateName );
        etemplate.subject = subjectval;
        etemplate.name=TemplateName;  
        etemplate.Htmlvalue = htmlbodyvalue ;
        etemplate.Isactive = True;
        Update etemplate;
        stepTWO();
        desiredemailTemplate();
    
    }
    
    public void canceltemp(){
        ShowCreateCamp = true;  
        step1 = false;
        step2 = false;
        step3 = true;
        step4 = false;
     errorboolname = false;
     errorboolduplicate = false;
     errorboolsubject = false;
     displaybool = TRUE;
     displayeditbool = false;
     Existingtemp =true;
     
     
     
         if(CancelClone == TRUE){
            displayclonebool=FALSE;          
            if(etemplate.owner.id == uid){
             editbuttonbool = TRUE;
             Clonebuttonbool = TRUE;
                 }else{
             Clonebuttonbool = TRUE;
             }
         }
         if(CancelEdit == TRUE){
                      
            if(etemplate.owner.id == uid){
             editbuttonbool = TRUE;
             Clonebuttonbool = TRUE;
                 }else{
             Clonebuttonbool = TRUE;
             }
         }
         newtempbool=false;
         
         
         
    }
    
    /* EDIT TEMPLATE ENDS*/
    /* Taken from other */

}