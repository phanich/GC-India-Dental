public without sharing class BLN_CustomBadgeCon {

    public String bdgQrValue { get; set; }
    public String bdgLogoValue { get; set; }
    public String bdgCnValue { get; set; }
    public String bdgFulNValue { get; set; }
    public String bdgLnValue { get; set; }
    public String bdgFnValue { get; set; }   
    public BadgeTemplate_Styles__c BDTEMP { get; set; }    
    public string selectedevent {get ; set ;}
    public transient  list<BadgeTemplate_Styles__c> exsitingtemps {get ; set ;}
    public list<string> jsonstr {get;set;}
   
    
    public BLN_CustomBadgeCon(){
    foradd = false;
    foredit = false;
    jsonstr = new list<string> ();
   
    selectedevent = '' ;
    selectedevent = Apexpages.currentpage().getparameters().get('eventid');
    exsitingtemps = new list<BadgeTemplate_Styles__c> ();
    exsitingtemps = [select id,FirstRowElement__c,SecondElement__c,ThirdElement__c,FourthElement__c,BadgeName__c,FifthElement__c,Event__r.Name from BadgeTemplate_Styles__c where Event__c =: selectedevent];
    for(BadgeTemplate_Styles__c bdt : exsitingtemps ){
    bdt.FirstRowElement__c = bdt.FirstRowElement__c.replace('[','');
    bdt.FirstRowElement__c = bdt.FirstRowElement__c.removeend(']');
    bdt.SecondElement__c = bdt.SecondElement__c.replace('[','');
    bdt.SecondElement__c = bdt.SecondElement__c.removeend(']');
    bdt.ThirdElement__c = bdt.ThirdElement__c.replace('[','');
    bdt.ThirdElement__c = bdt.ThirdElement__c.removeend(']');
    
     bdt.FourthElement__c = bdt.FourthElement__c.replace('[','');
    bdt.FourthElement__c = bdt.FourthElement__c.removeend(']');
    if(bdt.FifthElement__c != null && bdt.FifthElement__c != '')
    {
     bdt.FifthElement__c  = bdt.FifthElement__c .replace('[','');
    bdt.FifthElement__c  = bdt.FifthElement__c .removeend(']');
    }
    string  jsonstr1 = '';
     bdt.BadgeName__c = bdt.BadgeName__c.removeend(',');
     jsonstr1 = bdt.BadgeName__c+'***';
     jsonstr.add(jsonstr1);
    }
    
   
    }
        

    public void savedimensions() {
        //return null;
        BDTEMP  = new BadgeTemplate_Styles__c ();
        system.debug('HHHHH========================  '+ApexPages.currentPage().getParameters().get('Abcd'));
      
         string  ss = ApexPages.currentPage().getParameters().get('Abcd');
         list<string> objects = ss.split('"elementPropertiesArray":');
            //list<string> bdnames = objects[0].split('{"badgeDetailsObject":');
          
        list<string> listarray = new list<string> ();
        //objects[1] = objects[1].replace('}]','');
        system.debug('ddddddddddddddddddddddddddddddddddddddddddddddddddd'+objects[1]);
        objects[1]=objects[1].removeEnd('}]}');
         listarray  = objects[1].split('},');
        objects [0]=objects [0].replace('{"badgeDetailsObject":','');
      BDTEMP.BadgeName__c = objects [0];
      list<string> fornames = objects [0].split('savedImageDataUrl');
      list<string> actualval = fornames[0].split('width');
      string exactname = '';
      exactname = actualval[0].replace('{"name":"','');
      exactname = exactname.replace(',','');
       exactname = exactname.replace('"','');
         system.debug('HHHHH  '+listarray[0]);
         BDTEMP.Name = exactname;
        
         
         BDTEMP.FirstRowElement__c = listarray[0]+'}]';
          BDTEMP.SecondElement__c    = '['+listarray[1]+'}]';
           BDTEMP.ThirdElement__c = '['+listarray[2]+'}]';
            BDTEMP.FourthElement__c = '['+listarray[3]+'}]';
                if(listarray.size() > 4){
               
              BDTEMP.fifthElement__c = '['+listarray[4]+'}]';}
            
            
              if(listarray.size() > 5){
              
             BDTEMP.SixthElement__c = '['+listarray[5]+'}]';}
             if(listarray.size() > 6){
             system.debug('6666666666666666666666666'+listarray[6]);
             BDTEMP.SeventhElement__c = '['+listarray[6]+'}]';}
             if(listarray.size() > 7){
             BDTEMP.EightthElement__c = '['+listarray[7]+'}]';}
             BDTEMP.Event__c = selectedevent;
            database.upsert(BDTEMP);
        
        system.debug('bbbbbbbbbbbbbbbbbbbbbbbbb'+BDTEMP);
      
        
        
    }
    
    Public BadgeTemplate_Styles__c  ShowSelectedadge{get;set;}
    public string ShowBadge {get;set;}
    public boolean foradd {get; set;}
    public boolean foredit {get;set;}
    public void editBadge(){
    foradd= false;
    foredit = true;
    ShowBadge = '';
    system.debug('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'+Apexpages.currentpage().getparameters().get('editnameval'));
    string namevaledit = Apexpages.currentpage().getparameters().get('editnameval');
    ShowSelectedadge =  new BadgeTemplate_Styles__c(); 
    ShowSelectedadge = [select id,Name,FirstRowElement__c,SecondElement__c,ThirdElement__c,FourthElement__c,FifthElement__c,
                        SixthElement__c,SeventhElement__c,EightthElement__c,BadgeName__c from BadgeTemplate_Styles__c
                        where Event__c =: selectedevent AND Name =: namevaledit ];
                        
    ShowSelectedadge.FirstRowElement__c = ShowSelectedadge.FirstRowElement__c.replace('[','');
    ShowSelectedadge.FirstRowElement__c = ShowSelectedadge.FirstRowElement__c.removeend(']');
    ShowSelectedadge.SecondElement__c = ShowSelectedadge.SecondElement__c.replace('[','');
    ShowSelectedadge.SecondElement__c = ShowSelectedadge.SecondElement__c.removeend(']');
    ShowSelectedadge.ThirdElement__c = ShowSelectedadge.ThirdElement__c.replace('[','');
    ShowSelectedadge.ThirdElement__c = ShowSelectedadge.ThirdElement__c.removeend(']');    
    ShowSelectedadge.FourthElement__c = ShowSelectedadge.FourthElement__c.replace('[','');
    ShowSelectedadge.FourthElement__c = ShowSelectedadge.FourthElement__c.removeend(']'); 
    if(ShowSelectedadge.FifthElement__c != null && ShowSelectedadge.FifthElement__c != ''){   
    ShowSelectedadge.FifthElement__c  = ShowSelectedadge.FifthElement__c .replace('[','');
    ShowSelectedadge.FifthElement__c  = ShowSelectedadge.FifthElement__c .removeend(']}}'); 
    ShowSelectedadge.FifthElement__c  = ShowSelectedadge.FifthElement__c .removeend(']');}
    if(ShowSelectedadge.SixthElement__c != null){
    ShowSelectedadge.SixthElement__c = ShowSelectedadge.SixthElement__c.replace('[','');
    ShowSelectedadge.SixthElement__c = ShowSelectedadge.SixthElement__c.removeend(']'); 
    }else{
    ShowSelectedadge.SixthElement__c = '';
    }
    if(ShowSelectedadge.SeventhElement__c != null){ 
    ShowSelectedadge.SeventhElement__c = ShowSelectedadge.SeventhElement__c.replace('[','');
    ShowSelectedadge.SeventhElement__c = ShowSelectedadge.SeventhElement__c.removeend(']');  
    }else{   
    ShowSelectedadge.SeventhElement__c = '';
    }
    
    
    ShowBadge = ShowSelectedadge.FirstRowElement__c +'***'+ ShowSelectedadge.SecondElement__c  +'***'+ ShowSelectedadge.ThirdElement__c  +'***'+ ShowSelectedadge.FourthElement__c  +'***'+ ShowSelectedadge.FifthElement__c +'***'+ ShowSelectedadge.SixthElement__c +'***'+ ShowSelectedadge.SeventhElement__c ;
    
                      
    
    
    }
    
    public void deletename(){
    
    system.debug(';;;;;;;;;;;;;;;;;;;;;;;;;Del val ;;;;;;;;;;;;;;;;;;;;'+ApexPages.currentPage().getParameters().get('nameval'));
    
    string delvalue = ApexPages.currentPage().getParameters().get('nameval');
    BadgeTemplate_Styles__c bddel = [select id from BadgeTemplate_Styles__c where Event__c =: selectedevent AND Name LIKE : delvalue ];
    system.debug('------------------'+bddel.id );
    delete bddel;
    
    }
     public void updatetemplate(){
     delete ShowSelectedadge;
     ShowSelectedadge = new BadgeTemplate_Styles__c ();
     system.debug('=============mythily ================');
      string  ss = ApexPages.currentPage().getParameters().get('updtnameval');
         list<string> objects = ss.split('"elementPropertiesArray":');
            //list<string> bdnames = objects[0].split('{"badgeDetailsObject":');
          
        list<string> listarray = new list<string> ();
        //objects[1] = objects[1].replace('}]','');
        system.debug('ddddddddddddddddddddddddddddddddddddddddddddddddddd'+objects[1]);
        objects[1]=objects[1].removeEnd('}]}');
         listarray  = objects[1].split('},');
        objects [0]=objects [0].replace('{"badgeDetailsObject":','');
      ShowSelectedadge.BadgeName__c = objects [0];
      list<string> fornames = objects [0].split('savedImageDataUrl');
      list<string> actualval = fornames[0].split('width');
      string exactname = '';
      exactname = actualval[0].replace('{"name":"','');
      exactname = exactname.replace(',','');
       exactname = exactname.replace('"','');
         system.debug('HHHHH  '+listarray[0]);
         ShowSelectedadge.Name = exactname;
        
         
         ShowSelectedadge.FirstRowElement__c = listarray[0]+'}]';
          ShowSelectedadge.SecondElement__c    = '['+listarray[1]+'}]';
           ShowSelectedadge.ThirdElement__c = '['+listarray[2]+'}]';
            ShowSelectedadge.FourthElement__c = '['+listarray[3]+'}]';
                if(listarray.size() > 4){
               
              ShowSelectedadge.fifthElement__c = '['+listarray[4]+'}]';}
            
            
              if(listarray.size() > 5){
              
             ShowSelectedadge.SixthElement__c = '['+listarray[5]+'}]';}
             if(listarray.size() > 6){
             system.debug('6666666666666666666666666'+listarray[6]);
             ShowSelectedadge.SeventhElement__c = '['+listarray[6]+'}]';}
             if(listarray.size() > 7){
             ShowSelectedadge.EightthElement__c = '['+listarray[7]+'}]';}
             ShowSelectedadge.Event__c = selectedevent;
            database.insert(ShowSelectedadge);
        
        system.debug('bbbbbbbbbbbbbbbbbbbbbbbbb'+ShowSelectedadge);
      
     
     
     
    }
   
}