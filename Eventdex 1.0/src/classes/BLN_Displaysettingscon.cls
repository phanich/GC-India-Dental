global with sharing class BLN_Displaysettingscon {

     /***********************************************************************************************
    *   Controller Name         : BLN_Displaysettingscon
    *   Date                    : 05/08/2014 
    *   Author                  : Shruthi Reddy Gone
    *   Purpose                 : This class is for display settings in registration form.
    **************************************************************************************************/
   
   Public string selectedeventid{get;set;}
   Public BLN_Event__c eventslist {get;set;}
   public BLN_UtillDisplayLinks mydisplaysettings {get;set;}
   public List<Reg_Setting__c> regsettingslist{get;set;}
   public List<Reg_Setting__c> addnwregset{get;set;}
   public MAP<STRING,Reg_Setting__c> regsettingsMAP{get;set;}
   public Boolean cancelbool{get;set;}
   public SET<STRING> failuremessageset {get;set;}
   public List<Hash_Tag__c> hashtagslist{get;set;}
   public MAP<Id,Hash_Tag__c> tagslst{get;set;}
   public String tabsstring{get;set;}
   public Boolean tabinclude {get;set;}
   public String tablabel {get;set;}
   public String selectedoptions{get;set;}
   public List<Reg_Setting__c> refreshlst{get;set;}
   public void displayPermissions(){

     cancelbool = false;
     Cookie k = ApexPages.currentPage().getCookies().get('counter');
     if(k!=null){
     selectedeventid = k.getValue();
     }

     try{
     eventslist  = geteventdetails();
     }catch(exception e){}
   
    SYSTEM.DEBUG('EVENTID:' + selectedeventid );
         
         mydisplaysettings = new BLN_UtillDisplayLinks();
         mydisplaysettings.isdisplaySettingsPage='active';
         mydisplaysettings.isEventsettingsExpand='expand';
         mydisplaysettings.tablabel='Display Settings';
         try{
         mydisplaysettings .eventName = eventslist.Name;
         }catch(exception e){}
         mydisplaysettings.EventId= selectedeventid;
         mydisplaysettings.userPermissions(userInfo.getUserId(),selectedeventid);
         
    }

    Public BLN_Displaysettingscon (){
    
    Cookie k = ApexPages.currentPage().getCookies().get('counter');
     if(k!=null){
     selectedeventid = k.getValue();

     }
    try{
     eventslist  = geteventdetails();
     }catch(exception e){}
     failuremessageset = new SET<STRING>();
     hashtagslist = new List<Hash_Tag__c>();
     tagslst = new MAP<Id,Hash_Tag__c>();
     tabsstring = '';
     selectedoptions= '';
     cancelbool = false;
      tabinclude= false;
      refreshlst = new List<Reg_Setting__c>(); 
     // refreshlst.add(new Reg_Setting__c());
       //refreshlst.add(new Reg_Setting__c());
     getdisplaysetlist();
     

    }
        
        
        
    Public void getdisplaysetlist(){
    
     
      SYSTEM.DEBUG('eventslist  eventslist   '+eventslist  );
      tabsstring = '';
      tablabel = '';
      Map<string,string> tagname=new Map<string,string>();
     addnwregset= new List<Reg_Setting__c>(); 

      
         hashtagslist  = new List<Hash_Tag__c> ([SELECT ID,Name,RowId__c,Table_Name__c,Tag_Text__c,Event__c FROM Hash_Tag__c WHERE Event__c=:selectedeventid]);
      system.debug('123222222222' +hashtagslist  );

           tagslst = new MAP<Id,Hash_Tag__c>();

           for(Hash_Tag__c tags: hashtagslist  ){
                  tagslst.PUT(tags.Id,tags); 

           }
           system.debug(tagslst.size()+'  TABS SIZE ');
         

     
      
  // try{
        BLN_Displaysettings_BAL   blnregsetbal = NEW BLN_Displaysettings_BAL  ();
        regsettingslist  = new List<Reg_Setting__c>();    
        regsettingslist  = blnregsetbal.getregsettingslist(selectedeventid);
                     MAP<STRING,Reg_Setting__c> editMap = new MAP<STRING,Reg_Setting__c>();
      SYSTEM.DEBUG('regsettingslist  ::::regsettingslist  '+regsettingslist.size()  );
        
         regsettingsMAP = new MAP<STRING,Reg_Setting__c>();
         if(regsettingslist.size()>0){
         for(Reg_Setting__c reg : regsettingslist){
           regsettingsMAP.PUT(reg.Column_Name__c,reg);

         if(reg.Setting_Type__c == 'Registration Tab'){
            
           
            tabinclude =reg.Included__c ;
            
               

            if(editMap.containsKey(reg.Table_Name__c)){
               editMap.get(reg.Table_Name__c).Column_Name__c+=reg.Tag_Id__c ;
                //reg.Column_Name__c = reg.Tag_Id__c;
            }
            else{
             
              reg.Column_Name__c = reg.Tag_Id__c;
              addnwregset.add(reg);
              editMap.PUT(reg.Table_Name__c,reg);
              
              
             
            }
             
             
            // selectedoptions= selectedoptions+'!@#%'+reg.Tag_Id__c;
                regsettingsMAP.PUT(reg.Id,reg);
          } 
         
         
         
         
         
         system.debug('tabsstring tabsstring' +tabsstring  );
         }
         
         if(addnwregset.size()==0){
           Reg_Setting__c nwregset = new Reg_Setting__c();
           nwregset.Setting_Type__c = 'Registration Tab';
           nwregset.Event__c =selectedeventid;
          // nwregset.Tag_Id__c = 'a089000000Mg123456';
           nwregset.Column_Name__c = 'a089000000Mg123456';
           addnwregset.add(nwregset); 

         }
         else{
         refreshlst.add(new Reg_Setting__c());
         }
           
           
         
         
        
         
         }
   
   // }catch(exception e){}
        SYSTEM.DEBUG('regsettingsMAP::::regsettingsMAP'+regsettingsMAP);
       
       
    
    }



// -------------------------- This method is to Retrieve Event Details.--------------------------
      
       Public BLN_Event__c geteventdetails(){
         BLN_PromoCode_BAL blneventdetailbal = New BLN_PromoCode_BAL();
         RETURN eventslist = blneventdetailbal.eventdetails(selectedeventid);
      }
 
  
    Public void cancelmethod(){
    
    cancelbool = true;
     failuremessageset = new SET<STRING>();
     getdisplaysetlist();
    
    }


     Public void savemethod(){
         cancelbool = false;
         
        String  finalreglist = apexpages.currentpage().getparameters().get('chkArray');  
        String  regtabinclude  = apexpages.currentpage().getparameters().get('tabschkdval');  


        system.debug('finalreglist finalreglist' +finalreglist);
        list<string> regstring = finalreglist.split('123543-');

        Integer order = 0;

       addnwregset = new List<Reg_Setting__c>([SELECT ID,NAME,Event__c,Column_Name__c,Setting_Type__c FROM Reg_Setting__c WHERE Setting_Type__c=:'Registration Tab' AND  Event__c =: selectedeventid AND (ID!=NULL OR ID!= '')]);
       //Database.Delete(addnwregset,false);
       
        Integer i=0;
        
        
       
            for(string rg:regstring){
             system.debug('324354 ' +rg);
             
            order++;
               if(rg!=''){
               list<string> finregstring = NEW  list<string>();
                
               finregstring = rg.split('1!@#');
                    system.debug('finregstring finregstring ' +finregstring);
             
               list<string> tagssplitstring = NEW  list<string>();

              
               tagssplitstring = finregstring[1].split('123543');
               
               system.debug('tagssplitstring tagssplitstring  ' +tagssplitstring );
               system.debug('regtabinclude regtabinclude ' +regtabinclude);
                   for(string ts:tagssplitstring ){
                      
                     try{
                     Reg_Setting__c tabregrec = new Reg_Setting__c();
                     tabregrec =regsettingsMAP.get(addnwregset[i].ID); 
                     system.debug('tabregrec tabregrec ' +tabregrec);
                     tabregrec.Setting_Type__c = 'Registration Tab';
                     tabregrec.Event__c = selectedeventid;
                     tabregrec.Table_Name__c =finregstring[0];
                     tabregrec.Column_Name__c = '';                  
                     tabregrec.Tag_Id__c =ts;
                     tabregrec.Order__c = order;
                     if(regtabinclude == 'false'){
                     system.debug('454675686regtabinclude ' +regtabinclude);
                     tabregrec.Included__c = false;
                     }
                     else{
                        system.debug('ty56367' +regtabinclude);
                     tabregrec.Included__c = true;
                     }
                     i++;
                   }catch(Exception e){
                     
                     Reg_Setting__c tabregrec = new Reg_Setting__c();
                     tabregrec.Setting_Type__c = 'Registration Tab';
                     tabregrec.Event__c = selectedeventid;
                     tabregrec.Table_Name__c =finregstring[0];
                     tabregrec.Column_Name__c = '';                  
                     tabregrec.Tag_Id__c =ts;
                     tabregrec.Order__c = order;
                     if(regtabinclude == 'false'){
                     system.debug('454675686regtabinclude ' +regtabinclude);
                     tabregrec.Included__c = false;
                     }
                     else{
                        system.debug('ty56367' +regtabinclude);
                     tabregrec.Included__c = true;
                     }
                     
                     regsettingslist.add(tabregrec);
                   
                   }
                   
                   
                     
                   }
               }     
            }
            
            List<Reg_Setting__c> delregrec = new List<Reg_Setting__c>();
            for(integer j=i;j<addnwregset.size();j++){
            
            
            
              delregrec.add(regsettingsMAP.get(addnwregset[j].ID));
            
            }
        
        if(delregrec.size()>0){
        Database.Delete(delregrec,false);
       
        }
              
        
        
        system.debug('regsettingslist regsettingslist' +regsettingslist);
                system.debug('regsettingslist size ' +regsettingslist.size());
         
         BLN_Displaysettings_BAL   blnsavregsetbal = NEW BLN_Displaysettings_BAL  ();
         blnsavregsetbal.updateregsettings(regsettingslist);
     }

    public SET<Id> HashTagIdsSET{get; set;}
    public MAP<Id,Hash_Tag__c> tagslstMAP{get; set;}
     
    Public Void addrow(){
    
    //  refreshlst = new List<Reg_Setting__c>(); 
    selectedoptions= apexpages.currentpage().getparameters().get('addrow') ;
        system.debug('3224234' + selectedoptions);
        system.debug(addnwregset.size()+'   TO KNOW TAG NAMES SELECTED00000000  '+addnwregset);
        //HashTagIdsSET= new SET<Id>(); 
              
        hashtagslist  = new List<Hash_Tag__c> ([SELECT ID,Name,RowId__c,Table_Name__c,Tag_Text__c,Event__c FROM Hash_Tag__c WHERE Event__c=:selectedeventid]);
      system.debug(hashtagslist.size()+'  123222222222  ' +hashtagslist  );
           //tagslstMAP = new MAP<Id,Hash_Tag__c>();
           tagslst = new MAP<Id,Hash_Tag__c>();
           system.debug(hashtagslist.size()+'   HASH TAGS LIST  '+hashtagslist);
           for(Hash_Tag__c tags: hashtagslist  ){
               //if(! HashTagIdsSET.contains(tags.id)){
                   tagslst.PUT(tags.Id,tags);
               //}
               //tagslstMAP.PUT(tags.Id,tags);
                              
           }
           
        list<string> tabssplit = new list<string>();
        system.debug('  TOTAL STRING '+selectedoptions);
        tabssplit = selectedoptions.split('123456-');
                system.debug('  SPLIT11111111111111111 '+tabssplit );
        integer i =0;
        for(Reg_Setting__c rst : addnwregset){
        try{  list<string> namesp = tabssplit[i].split('1!@#');
              system.debug('  SPLIT22222222222222222 '+namesp);
              system.debug('3423534 r34 ' +namesp);
                //if(rst.Column_Name__c == NULL){
                rst.Table_Name__c =namesp[0]; 
               // rst.Tag_Id__c = namesp[1];                  
                  rst.Column_Name__c = namesp[1];
                  //}
                 // HashTagIdsSET.add(rst.Column_Name__c );
               }catch(Exception e){}
                
                i++;  
        }

        system.debug(addnwregset.size()+'   TO KNOW TAG NAMES SELECTED1111111111  '+addnwregset);        
        
        
        
       // if(tagslst.size() >0){
           Reg_Setting__c nwregset = new Reg_Setting__c();
           nwregset.Setting_Type__c = 'Registration Tab';
           nwregset.Event__c =selectedeventid;
           //nwregset.Tag_Id__c = 'a089000000Mg123456';
           nwregset.Column_Name__c = 'a089000000Mg123456';
           // nwregset.Column_Name__c = hashtagslist[0].Id;
           addnwregset.add(nwregset);
       // }
    system.debug('4435435436' +addnwregset);
    system.debug(tagslst.size()+'  HASH TAG LIST '+tagslst);
    
    }
  
   Public Void deleterec(){
    
    selectedoptions= apexpages.currentpage().getparameters().get('inputval') ;
        system.debug('3224234' + selectedoptions);
        
         hashtagslist  = new List<Hash_Tag__c> ([SELECT ID,Name,RowId__c,Table_Name__c,Tag_Text__c,Event__c FROM Hash_Tag__c WHERE Event__c=:selectedeventid]);
      system.debug('123222222222' +hashtagslist  );

           tagslst = new MAP<Id,Hash_Tag__c>();

           for(Hash_Tag__c tags: hashtagslist  ){
                  tagslst.PUT(tags.Id,tags); 
           }
        
        
        
        list<string> tabssplit = new list<string>();
        tabssplit = selectedoptions.split('123456-');
        integer i =0;
        for(Reg_Setting__c rst : addnwregset){
        try{  
        list<string> namesp = tabssplit[i].split('1!@#');
              system.debug('3423534 r34 ' +namesp);
               
                rst.Table_Name__c =namesp[0]; 
               // rst.Tag_Id__c = namesp[1];                  
                  rst.Column_Name__c = namesp[1];
               }catch(Exception e){}
                
                i++;  
        }
        
      
    Integer rownum = Integer.valueof(apexpages.currentpage().getparameters().get('deleterow'));
     system.debug('35436546' +rownum );
   refreshlst = new List<Reg_Setting__c>();
    for(integer k=0;k<addnwregset.size();k++){
    
    if( k == rownum){
    }else{
    
    refreshlst.add(addnwregset[k]);
    }
    
    }
    system.debug('1324325 ' +refreshlst);
    addnwregset = new List<Reg_Setting__c>();
    addnwregset = refreshlst.clone(); 
    
    refreshlst.add(new Reg_Setting__c());
    system.debug('53453' +addnwregset );
   }
     
    
    
    
      
    
    
    
    
}