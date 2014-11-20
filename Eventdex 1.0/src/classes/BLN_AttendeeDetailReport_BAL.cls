/***********************************************************************************************
*   Controller Name : BLN_AttendeeDetailReport_BAL
*   Date            : 10/31/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the Attendee Details Report
*   Change History  : 10/31/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*    10/31/2014              Manasa Gandham                 To Create Page
*  
**************************************************************************************************/

public without sharing class BLN_AttendeeDetailReport_BAL{

    public BLN_AttendeeDetailReport_BAL(){
    
    }  
    public BLN_Ticket_DAO ticketsDAOClass{get; set;}
    //public BLN_User_Ext_DAO userExtDAOClass{get; set;}
    public BLN_Company_Ext_DAO companyExtDAOClass{get; set;}
    public BLN_Company_DAO companyDiversityDAOClass{get; set;}
    
    public LIST<LIST<AttendeeDetailInner>> ticketsListForEvent(String EventId, Date FromDate, Date ToDate, String SearchString){
        
        ticketsDAOClass= new BLN_Ticket_DAO();
        //userExtDAOClass= new BLN_User_Ext_DAO();
        companyExtDAOClass= new BLN_Company_Ext_DAO();
        companyDiversityDAOClass= new BLN_Company_DAO();
        
        String queryString= '';
        queryString= ' Event__c = \''+EventId+'\'';
        queryString += ' AND Ticket_Status__c = \''+'Booked'+'\'';
        system.debug('  000000000000  '+queryString);
        if(FromDate != NULL){
            system.debug('  FROM DATE00000000000 '+FromDate);
            FromDate= FromDate.addDays(1);            
            dateTime d1 = FromDate;
            system.debug('  FROM DATE1111111111 '+d1);
            string FromDateStr= d1.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            system.debug('  FROM DATE2222222222222 '+FromDateStr);
            queryString += ' AND CreatedDate >= '+FromDateStr;
        } 
        system.debug('  111111111  '+queryString);
        if(ToDate != NULL){
            ToDate= ToDate.addDays(1);            
            dateTime d1 = ToDate;
            string ToDateStr= d1.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');

            queryString += ' AND CreatedDate <='+ToDateStr;            
        }
        if(SearchString != NULL){
            queryString += ' AND (Client_GN_User__r.First_Name__c Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Last_Name__c Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Email__c Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Company_Name__c Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Title__c Like \'%'+SearchString+'%\''+' OR item__r.item_Name__c Like \'%'+SearchString+'%\''+' OR Badge_Label__c Like \'%'+SearchString+'%\''+')'; 
          
        }
        system.debug('  QUERY STRING '+queryString );
        LIST<Ticket__c> ticksList= new LIST<Ticket__c>();
        ticksList= ticketsDAOClass.ticketsListForEvent(queryString);
        SET<Id> UserIds= new SET<Id>();
        SET<Id> CompanyIds= new SET<Id>();
        MAP<String, User_Ext__c> UserExtsMAP= new MAP<String, User_Ext__c>();
        MAP<String, Company_Ext__c> CompanyExtsMAP= new MAP<String, Company_Ext__c>();        
        MAP<String, LIST<Company_Diversity__c>> diversityListMAP= new MAP<String, LIST<Company_Diversity__c>>();
        
        for(Ticket__c tic: ticksList){
            UserIds.add(tic.Client_GN_User__r.user__r.Id);
            CompanyIds.add(tic.Client_Company__r.Id);
        }
        
        /*
        LIST<User_Ext__c> UserExtsList= new LIST<User_Ext__c>();
        UserExtsList= userExtDAOClass.userExtsForUserIds(UserIds);
        for(User_Ext__c userExt: UserExtsList){
            UserExtsMAP.put(userExt.User__c, userExt);
        
        }
        */
        
        LIST<Company_Ext__c> companyExtsList= new LIST<Company_Ext__c>();
        companyExtsList= companyExtDAOClass.companyExtsForCompanyIds(CompanyIds);
        for(Company_Ext__c company: companyExtsList){
            CompanyExtsMAP.put(company.Company__c, company);
        }
        LIST<Company__c> companyDiversityList= new LIST<Company__c>();
        companyDiversityList= companyDiversityDAOClass.companiesForEvent(CompanyIds);
        for(Company__c company: companyDiversityList){
            diversityListMAP.put(company.Id, company.Company_Diversity__r);
        }

        LIST<LIST<AttendeeDetailInner>> AttendeeDetailInnerListOfList= new LIST<LIST<AttendeeDetailInner>>();        
        LIST<AttendeeDetailInner> AttendeeDetailInnerList999= new LIST<AttendeeDetailInner>();
        for(Ticket__c tic: ticksList){
            //AttendeeDetailInnerList999.add(new AttendeeDetailInner(tic, UserExtsMAP.get(tic.Client_GN_User__r.user__r.Id), CompanyExtsMAP.get(tic.Client_Company__r.Id), diversityListMAP.get(tic.Client_Company__r.Id)));
            AttendeeDetailInnerList999.add(new AttendeeDetailInner(tic, CompanyExtsMAP.get(tic.Client_Company__r.Id), diversityListMAP.get(tic.Client_Company__r.Id)));
            if(AttendeeDetailInnerList999.size() == 999){
                AttendeeDetailInnerListOfList.add(AttendeeDetailInnerList999);
                AttendeeDetailInnerList999= new LIST<AttendeeDetailInner>();
            }
        }
        if(AttendeeDetailInnerList999.size() != NULL){
                AttendeeDetailInnerListOfList.add(AttendeeDetailInnerList999);
                AttendeeDetailInnerList999= new LIST<AttendeeDetailInner>();
            }
        
        return AttendeeDetailInnerListOfList;
        }
        
        public Class AttendeeDetailInner{
            
            public Ticket__c ticketData{get; set;}
            //public User_Ext__c userExtData{get; set;} User_Ext__c userExtData, 
            public Company_Ext__c companyExtData{get; set;}
            public LIST<Company_Diversity__c> companyDiversityData{get; set;}
            
            public AttendeeDetailInner(Ticket__c ticketData, Company_Ext__c companyExtData, LIST<Company_Diversity__c> companyDiversityData){
                
                this.ticketData= ticketData;
                //this.userExtData= userExtData;
                this.companyExtData= companyExtData;
                this.companyDiversityData= companyDiversityData;
            }
        }
}