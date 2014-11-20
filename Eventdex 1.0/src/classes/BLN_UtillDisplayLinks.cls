public class BLN_UtillDisplayLinks{
 
 public string tablabel {get;set;}
 public string eventId {get;set;}
  public string eventName {get;set;}
  
 public string isDashboardPage{get;set;}
 public string isTicketsPage{get;set;}
 public string ispromocodesPage{get;set;}
 public string issurveyPage{get;set;}
 
 // Attendee PAge
 public string isAttendeesPage{get;set;}
 public string isimportAttendeesPage{get;set;}
 public string isAttendeeSettingsPage{get;set;}
 
// Ragistration Page
 public string isregistrationPage{get;set;}
 public string isonsiteRegistrationPage{get;set;}
 public string isIframeRegSetPage{get;set;}
 public string isDispalySettingsPage{get;set;}  
 public string isDisplaySettingsPage{get;set;} 
 public string ispaymentSettingsPage{get;set;}
  
 // Seminars Page...............................
 public string isSeminorsPage{get; set;}
 public String isSeminorsPageExpand{get; set;}
 public String isTracksPage{get; set;}
 public string isroomsPage{get; set;}
 public String isSpeackersPage{get; set;}
  public String iseventschedulePage{get; set;}
  
    // Reports Page...............................
    public string isReportsPageExpand{get;set;}    
    public string isOrderReportPage{get; set;}
    public String isTicketReportPage{get; set;}
    public string isAttendeeReportPage{get; set;}
    public String isAttendeeDetailReportPage{get; set;}
    public String isPromocodeReportPage{get; set;}
 // --------------------------------------------------------------------- Expand Page ------------------------------------------ 
  public string isTicketsPageExpand{get;set;}
 
 // Attendee PAge
 public string isAttendeesPageExpand{get;set;}

// Ragistration Page
 public string isregistrationPageExpand{get;set;}
 public string isemailsPage{get;set;}
 public string isemailcampaignpage {get ; set ;}
 
// ---------------------------------------------------------- End ----------------------------------------------
 
 
 // Orders Page
 public string isOrdersPage{get;set;}
 //Event Staff Page
 public string isEventsettingsExpand {get ; set ;}
 public string isEventsettings {get ; set ;}
 public string isEventsettingsPage {get ; set ;}
 public string isEventstaffPage {get ; set ;}
 public string isEventstaffsettingsPage {get ; set ;}
 
 // Booleans to display or hide according to role
    public boolean isAttendee {get;set;}
    public boolean isBoothAdmin {get;set;}
    public boolean isBoothStaff {get;set;}
    public boolean isCompanyAdmin {get;set;}
    public boolean isEventAdmin {get;set;}
    public boolean isEventStaff {get;set;}
    public boolean isMatchLeadsBuyer {get;set;}
    public boolean isMatchLeadsSeller {get;set;}
    //FOR EVENT STAFF SETTINGS
    public boolean IstickettabAvailable {get ; set ;}
    public boolean IsAttendeeTabAvailable {get ; set ;}
    public boolean IsDashboardTabAvailable {get ; set ;}
    public boolean IsRegistrationTabAvailable {get ; set ;}
    public boolean IsReportsTabAvailable {get ; set ;}
    public boolean IsSeminarTabAvailable {get ; set ;}
    public boolean IsEventSettingsTabAvailable {get ; set ;}
    public string isTicketFeeSettingsPage {get ; set ;}
      
    public LIST<Reg_Setting__c> ESsettings {get ; set ;}
       public void userPermissions(string uid , string eveid){
         ESsettings  = new LIST<Reg_Setting__c>();
          
           isEventAdmin = true; // This is temparary i am giving. In general we should use for loop which is in comment.
         
         
         /*
         for(UC_Role__c ucRoles : [select id,RoleId__r.Name,GN_User__c,Event__c from UC_Role__c where GN_User__r.user__c=:uid and Event__c = :eveid]){
            if(ucRoles.RoleId__r.Name=='Event Admin' || ucRoles.RoleId__r.Name=='Event Staff'){
               isEventAdmin = true;
               
               
            }else if(ucRoles.RoleId__r.Name=='Booth Admin' || ucRoles.RoleId__r.Name=='Booth Staff' || ucRoles.RoleId__r.Name=='Company Admin'){
               isBoothAdmin =true;
            } 
            //edited by Mythily from here 
            //it is for getting the settings of event staff based on role
            if(ucRoles.RoleId__r.Name == 'Full Admin' || ucRoles.RoleId__r.Name == 'Registration User' || ucRoles.RoleId__r.Name == 'Onsite Staff'){
            IsEventstaff = true;
                for(Reg_Setting__c REGS : [SELECT id,Column_Name__c,Label_Name__c,Create_Access__c,Delete_Access__c,Event__c,Read_Access__c,Setting_Type__c,Update_Access__c FROM Reg_Setting__c WHERE Setting_Type__c =: 'Event Staff' AND Event__c = :eveid]){
                    if(ucRoles.RoleId__r.Name == REGS.Column_Name__c){
                        if(REGS.Label_Name__c == 'Tickets' && REGS.Read_Access__c == true){
                        IstickettabAvailable = true;
                        }else
                        if(REGS.Label_Name__c == 'Attendee' && REGS.Read_Access__c == true){
                        IsAttendeeTabAvailable = true;
                        }
                        if(REGS.Label_Name__c == 'Registration' && REGS.Read_Access__c == true){
                        IsRegistrationTabAvailable = true;
                        }
                        if(REGS.Label_Name__c == 'Dashboard' && REGS.Read_Access__c == true){
                        IsDashboardTabAvailable = true;
                        }
                        if(REGS.Label_Name__c == 'Reports' && REGS.Read_Access__c == true){
                        IsReportsTabAvailable = true;
                        }
                        if(REGS.Label_Name__c == 'Seminar' && REGS.Read_Access__c == true){
                        IsSeminarTabAvailable = true;
                        }
                        if(REGS.Label_Name__c == 'Event Settings' && REGS.Read_Access__c == true){
                        IsEventSettingsTabAvailable = true;
                        }
                        //ESsettings.add(REGS);
            
                    }
                }
            }
         }*/
         
         
         
       }
   
   
 
 
}