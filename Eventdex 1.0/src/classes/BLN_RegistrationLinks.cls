public with sharing class BLN_RegistrationLinks {
/***************************************************************************************************************************************************************************************************
*   Author                  : Mahesh Sakunala
*   Date                    : 10/07/2014 
*   Purpose                 : This class is for Registration Links.
*   Last Modified           : Mahesh Sakunala - 16/07/2014
*****************************************************************************************************************************************************************************************************/

    public BLN_UtillDisplayLinks RegistrationLinks{get;set;} // For Util Class
    public Id selectedEvent{get;set;} // To Fetch Event Id
    public String RegistrationLink{get;set;} // To Display Registration Link
    public BLN_Event__c EventDetails{get; set;} // To fetch event details
    public string iframes{get;set;}
// ----------------------------------------------------------------------------------- Constructor Start ---------------------------------------------------------------------------------------------------    
    public BLN_RegistrationLinks(){
         Cookie k = ApexPages.currentPage().getCookies().get('counter');
         system.debug(k.getValue()+' 0000000000 '+k);
         if(k!=null){ 
             selectedEvent = k.getValue();
             system.debug('  SELECTED EVENT  '+selectedEvent );
         }
         RegistrationLinks = new BLN_UtillDisplayLinks();
         RegistrationLinks.isregistrationPage='active';
         RegistrationLinks.isregistrationPageExpand='expand';
         RegistrationLinks.tablabel='Registration Links';
         RegistrationLinks.eventId=selectedEvent;
         RegistrationLinks.userPermissions(userInfo.getUserId(),selectedEvent);
         
         
         
         BLN_Quick_Registration_BAL QuickRegBAL = new BLN_Quick_Registration_BAL();
         if(selectedEvent != NULL){
             // Getting Event Details from Event DAO
            EventDetails = QuickRegBAL.getEventDetails(selectedEvent);  
             system.debug('  1111111111111111  '+selectedEvent );
            RegistrationLink = 'https://blnew-boothleads.cs14.force.com/BLN_Registrationnew?id='+selectedEvent;
            iframes = ' <iframe width="560" height="315"  src="'+RegistrationLink+'"></iframe>';
         }

    }
// ------------------------------------------------------------------------------------ Constructor End ----------------------------------------------------------------------------------------------------

}