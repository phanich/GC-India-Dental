Public without sharing class  BLN_SurveyQuestionscon {
 
  /***********************************************************************************************
    *   Controller Name         : BLN_PromoCodecon
    *   Date                    : 30/06/2014 
    *   Author                  : Shruthi Reddy Gone
    *   Purpose                 : This class is for Creating Survey Questions.
    **************************************************************************************************/
    

    public List<Question__c> questionslist{get;set;}
    public Question__c questionrecord{get;set;}
    public List<Answer__c> answerslist{get;set;}
    public Answer__c answerrecord{get;set;}
    public Item_Question__c Itemquerecord{get;set;}
    public List<Item_Question__c> Itemquelist{get;set;}
    public MAP<string,BLN_Item__c> ItemMAP{get;set;}
    public MAP<ID,Question__c> QuestionMAP{get;set;}
    Public MAP<string,List<User_Answer__c>> useranswersMAP{get;set;}
    public List<Answer__c> deletedansonedit{get;set;}
   
    Public LIST<BLN_Item__c> itemslist {get;set;}
    Public MAP<String,Item_Question__c> ItemQuestionDupMAP{get;set;}
    Public MAP<STRING,List<Item_Question__C>> itmqueansMap {get;set;}
    Public MAP<String,Answer__c> AnswerDupMAP{get;set;}
    Public List<SelectOption> itemnames{get;set;}
    Public string selectedeventid{get;set;}
    Public Set<String> failuremessageset {get;set;}
    
    public Boolean createquestionbool{get;set;}
    public Boolean multiplechoiceoptions {get; set;}
    public Boolean displaytablebool{get;set;}
    public Boolean errormessagebool{get;set;}
    public Boolean editbool{get;set;}
    public Boolean itemdisplaybool{get;set;}
    
    Public String CheckTicketsforedit{get;set;}
    Public String CheckreqTicketsforedit{get;set;}
    Public String CheckvisTicketsforedit{get;set;}
    Public String selectedquelevl{get;set;}
    
    public List<SelectOption> minscale{get;set;}
    public List<SelectOption> maxscale{get;set;}
    public string selctdminscale{get;set;}
    public string selctdmaxscale{get;set;}
    
    public MAP<Decimal,Answer__c> answerMAP{get;set;}
    public Decimal Uniqueno{get;set;}
    public string selectedtype {get;set;}
    public Set<String> dupselectedtype {get;set;}
    Public BLN_Event__c eventslist {get;set;}
    public BLN_UtillDisplayLinks mysurveyque {get;set;}

   
    public void displayPermissions(){

   
     Cookie k = ApexPages.currentPage().getCookies().get('counter');
     if(k!=null){
     selectedeventid = k.getValue();
     }
     
     
     try{
     eventslist  = geteventdetails();
     }catch(exception e){}
   
    SYSTEM.DEBUG(selectedeventid +'  EVENTID:  ' + eventslist);
         
         mysurveyque = new BLN_UtillDisplayLinks();
         mysurveyque.issurveyPage='active';
         mysurveyque.isTicketsPageExpand='expand';
         mysurveyque.tablabel='Survey Questions';
         try{
         mysurveyque.eventName = eventslist.Name;
         }catch(exception e){}
         mysurveyque.EventId= selectedeventid;
         mysurveyque.userPermissions(userInfo.getUserId(),selectedeventid);
         system.debug('  MY SURVEY QUESTIONS '+mysurveyque);
    }
   
    public BLN_SurveyQuestionscon(){
    
   Cookie k = ApexPages.currentPage().getCookies().get('counter');
     if(k!=null){
     selectedeventid = k.getValue();
     }
    
   
    questionslist = new List<Question__c>();
    questionrecord = new Question__c();
    answerslist = new List<Answer__c>();
    answerrecord = new Answer__c();
    deletedansonedit= new List<Answer__c>();
    useranswersMAP = new MAP<string,List<User_Answer__c>> ();
    ItemMAP = new MAP<string,BLN_Item__c> ();
    itemslist = new LIST<BLN_Item__c>();
    Itemquerecord = new Item_Question__c();
    Itemquelist = new List<Item_Question__c>();
    QuestionMAP = new MAP<ID,Question__c>();
    ItemQuestionDupMAP = new MAP<String,Item_Question__c>();
    AnswerDupMAP = new MAP<String,Answer__c> ();
    itmqueansMap = new MAP<String,LIST<Item_Question__c>>();
   
    createquestionbool = FALSE;
    multiplechoiceoptions = FALSE;
    displaytablebool = TRUE;
    errormessagebool = FALSE;
    editbool= FALSE;
    itemdisplaybool= TRUE;
    
    
    CheckTicketsforedit = '!@#$%^&';
    CheckreqTicketsforedit= '!@#$%^&';
    CheckvisTicketsforedit= '!@#$%^&';
    
    selectedtype = '';
    selectedquelevl= 'Ticket Level';
    Uniqueno = 0;
    answerMAP = new MAP<Decimal,Answer__c>();
    dupselectedtype = new  Set<String>(); 
    failuremessageset = new  Set<String>(); 
      
     minscale = new List<SelectOption>();
     minscale.add(new Selectoption('0', '0'));       
     minscale.add(new Selectoption('1', '1'));  
     
     maxscale = new List<SelectOption>();
     maxscale.add(new Selectoption('2', '2')); 
     maxscale.add(new Selectoption('3', '3')); 
     maxscale.add(new Selectoption('4', '4')); 
     maxscale.add(new Selectoption('5', '5')); 
     maxscale.add(new Selectoption('6', '6'));   
     maxscale.add(new Selectoption('7', '7')); 
     maxscale.add(new Selectoption('8', '8')); 
     maxscale.add(new Selectoption('9', '9')); 
     maxscale.add(new Selectoption('10', '10')); 
     
     system.debug('  SELECTED EVENT ID '+selectedeventid);
     // try{
     eventslist= new BLN_Event__c();
     eventslist= geteventdetails();
     //}catch(exception e){}
     
     //try{
     getquestionslist();
     //}catch(exception e){}
     
     
       
     
     
     
    }
 
  // -------------------------- This method is to Retrieve Event Details.--------------------------
      
       Public BLN_Event__c geteventdetails(){
         BLN_PromoCode_BAL blneventdetailbal = New BLN_PromoCode_BAL();
         RETURN eventslist = blneventdetailbal.eventdetails(selectedeventid);
      }
 
  
  
  //-------------- This method is to retrieve QuestionsList for the event------------.
    
     Public void getquestionslist(){
    
            questionslist = new List<Question__c>();      
          BLN_SurveyQuestions_BAL blnquestionsbal = New BLN_SurveyQuestions_BAL();
          questionslist = blnquestionsbal.questionslist(selectedeventid,questionslist);
         
        Itemquelist = new List<Item_Question__c>();
        
        BLN_SurveyQuestions_BAL blnitmquestionsbal = New BLN_SurveyQuestions_BAL();
        Itemquelist = blnquestionsbal.itemquestionslist(selectedeventid,Itemquelist);
        

         
           for(Item_Question__C que : Itemquelist ){
            string code = que.Question__r.Id;
            
           if(itmqueansMap.ContainsKey(code)){
               
                LIST<Item_Question__C> listnew = new LIST<Item_Question__C>();
                      listnew = itmqueansMap.get(code);
                      itmqueansMap.remove(code);
                       listnew.add(que);
                      itmqueansMap.Put(que.Question__r.Id,listnew);
           }
           
           else{
                      LIST<Item_Question__C>  listnew1 = new LIST<Item_Question__C> ();
                      listnew1.add(que);
                      itmqueansMap.Put(que.Question__r.Id,listnew1);
             }
           
           }
        
         
        system.debug('questionslist questionslist : ' + questionslist );
            for(Question__c que : questionslist){
               QuestionMAP.PUT(que.ID,que);
               
            }
           
            displaytablebool = TRUE;
            createquestionbool = FALSE;
            multiplechoiceoptions = FALSE; 
     }
     
     
     
     
     
   //-------------- End of retrieving QuestionsList for the event------------.   
     
    
    
    // ----------------------------This method is To retrieve all the items for the selected event.--------------------------
    
    Public void getitems(){
    
            
            
            BLN_PromoCode_BAL blnItembal = New BLN_PromoCode_BAL();
            itemslist = blnItembal.itemslist(selectedeventid);
                 System.Debug('ItemMap.values:' + itemslist);
            if(Itemslist.size()>0){  
             itemnames  = new List<SelectOption>();
             ItemMAP = new MAP<string,BLN_Item__c> ();
             itemnames.add(new SelectOption('a089000000Mg123456','Select All' ));  
             
                 for(BLN_Item__c items : Itemslist){
                        if(items.item_name__c != null){
                            itemnames.add(new SelectOption(items.id,items.item_name__c ));                    
                        }
                     ItemMAP.Put(items.id,items);
                 } 
             
            }
                    System.Debug('ItemMap.values:' + ItemMap);
    }
    
    // ----------------------------End of retrieving all the items for the selected event.--------------------------
    
    
    // ----------------------------This method is to get AnswerTypes options.--------------------------
    
    
    
    public List<SelectOption> getquetyps()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult = Question__c.Answer_Type__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
    }
    
    // ----------------------------End Of getting AnswerTypes options.--------------------------
      
  
  
  public List<SelectOption> getquestionlevel()
    {
      List<SelectOption> questionoptions = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult = Item_Question__c.Question_Level__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          questionoptions.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return questionoptions;
    }
  
  
  
      
  // ------------------------- This Method Is to Add A Question.-------------------------
  
    
    Public Void Addquestion(){
  
        selctdminscale = '1';
        selctdmaxscale = '5'; 
        getitems();
        getquestionlevel();
        CheckTicketsforedit = '!@#$%^&';
        CheckreqTicketsforedit  = '!@#$%^&';
         CheckvisTicketsforedit= '!@#$%^&';
        selectedtype = '';
        
        questionslist = new List<Question__c>();
        questionrecord = new Question__c();
        answerslist = new List<Answer__c>();
        answerrecord = new Answer__c();
        answerMAP = new MAP<Decimal,Answer__c>();
        Itemquelist = new List<Item_Question__c>();
        dupselectedtype = new  Set<String>(); 
        ItemQuestionDupMAP = new MAP<String,Item_Question__c>();
        AnswerDupMAP = new MAP<String,Answer__c> ();
        deletedansonedit= new List<Answer__c>();
        
    
        questionrecord.Event__c = selectedeventid;
        //questionrecord.Question_Order__c = QuestionMAP.size()+1;
        questionslist.add(questionrecord);
        selectedquelevl= 'Ticket Level'; 
        
        createquestionbool = TRUE;
        editbool = FALSE;
        itemdisplaybool = TRUE;
        displaytablebool = FALSE;
    
    }

  // ------------------------- End Of Adding A Question.-------------------------

//---------------------------------------Method  To add multiple Option based on answer type.------------------

    Public Void optionslabel(){
         
       System.debug('=================77777 ' + selectedtype  );   
       
       String  del = apexpages.currentpage().getparameters().get('dupanschk');  
         if(selectedtype  == 'Scale'){
             
             selctdminscale = '1';
             selctdmaxscale = '5'; 
             dupselectedtype = new  Set<String>(); 
             answerslist.clear();
             uniqueNo = 0;
             multiplechoiceoptions = TRUE;
          }
          
         else if(selectedtype  == 'Multiple choice' || selectedtype  == 'Checkboxes' || selectedtype  == 'Choose from a list'  ){
          
           dupselectedtype.add(selectedtype);
           SYSTEM.DEBUG('1111111 ' + selectedtype);
            
            if(dupselectedtype.size()==1){
                
                answerrecord = new Answer__c(); 
                answerMAP.PUT(uniqueNo,answerrecord); 
                uniqueNo++;       
                answerslist.add(answerrecord);           
                multiplechoiceoptions = TRUE;
            }
            
            else{
             dupselectedtype = new  Set<String>(); 
             
            }
        }
        
        else{
          
          uniqueNo = 0;
          answerslist.clear();  
          dupselectedtype = new  Set<String>(); 
          answerMAP = new MAP<Decimal,Answer__c>();
          multiplechoiceoptions = FALSE;
          
          
        
          
        }
        
        
          System.debug('=================dddddddddd ' + multiplechoiceoptions );  
    }
    
    
    //--------------------------------------End of Method  To add multiple Option based on answer type.------------------
    
    
    
    Public Void deleteoptionline(){
      
       String  del = apexpages.currentpage().getparameters().get('deletedid');
      
           System.debug('=================del del del : ' + del ); 
       
     
        BLN_SurveyQuestions_BAL blndelansoptionbal = New BLN_SurveyQuestions_BAL();
        answerMAP= blndelansoptionbal.deleteanswerline(del,answerMAP);
    
         answerslist= NEW LIST<Answer__c>();

      
          System.debug('answerMAP:' + answerMAP);
          Decimal Count = 0;
        
        for(Answer__c amap :  answerMAP.values()){
    
            answerslist.add(answerMAP.get(Count));
            Count++;
       }
          

         uniqueNo = answerslist.size();

          if(answerMAP.size() == 0){
                uniqueNo= -1;  
          }
      
    }
    
     Public Void savequestion(){
     
      String itemid= Apexpages.Currentpage().getparameters().get('chkArray');
      String requiredid = Apexpages.Currentpage().getparameters().get('chkreqArray');
      String visibleitemid = Apexpages.Currentpage().getparameters().get('chkvisArray');
       
       SYSTEM.DEBUG('CheckedTicketids' + itemid);
       SYSTEM.DEBUG('CheckedReqTicketids' + requiredid );
        SYSTEM.DEBUG('WWWWWWWWWWWWWW  ' + Itemquelist );
        
       
        failuremessageset = new set<String>(); 
        
      SYSTEM.DEBUG('deletedansoneditdeletedansoneditdeletedansonedit  AnswerDupMAP '  + deletedansonedit);   
        
  
    
     BLN_SurveyQuestions_BAL blnansbal = New BLN_SurveyQuestions_BAL();
      answerslist = blnansbal.answeroptions(selectedtype,selctdminscale,selctdmaxscale,editbool,answerslist,AnswerDupMAP);
     
     
       if(editbool == TRUE){
        system.debug('AnswerDupMAPonEDit AnswerDupMAPonEDit: ' + AnswerDupMAP);
            BLN_SurveyQuestions_BAL blndelansopbal = New BLN_SurveyQuestions_BAL();
            failuremessageset = blndelansopbal.deleteansmethod(selectedtype,answerslist,AnswerDupMAP,deletedansonedit) ;
        
        }
        
     if(failuremessageset.size()==0){
      
      if(selectedquelevl == 'Ticket Level'){

     BLN_SurveyQuestions_BAL blnitemquebal = New BLN_SurveyQuestions_BAL();
     Itemquelist = blnitemquebal.itemquestions(itemid,requiredid,visibleitemid,editbool,Itemquelist,ItemQuestionDupMAP);
     
        
       if(editbool == TRUE){
        
            BLN_SurveyQuestions_BAL blndelitemquebal = New BLN_SurveyQuestions_BAL();
            failuremessageset = blndelitemquebal.deletemethod(Itemquelist,ItemQuestionDupMAP) ;
        
        }
        
        if(failuremessageset.size() == 0){ 
      system.debug('1111111111dfdds ' + Itemquelist);
       
       questionslist[0].Answer_Type__c = selectedtype;  
       
       BLN_SurveyQuestions_BAL blnsavequebal = New BLN_SurveyQuestions_BAL();
       failuremessageset = blnsavequebal.upsertquestiosave(questionslist,answerslist,Itemquelist);
      
      if(failuremessageset.size()==0){
        Itemquelist = new List<Item_Question__C>();   
         getitems();
         System.Debug('ItemMap.values:' + ItemMap);
          for(BLN_Item__c  itm: ItemMap.values()){
                 Integer iqeorder = 1; 
                 System.Debug('itm.Item_Question__r' + itm.Item_Question__r);
               for(Item_Question__c iqe :itm.Item_Question__r){
               System.Debug('iqe iqe iqe :' + iqe );
                  iqe.IQ_Order__c =iqeorder;
                  Itemquelist.add(iqe);
                  iqeorder++;
               }  
                 
          }
        System.Debug('Itemquelist:' + Itemquelist);
         Database.Upsert(Itemquelist,false);
   
        
        
        
        
        
         if(failuremessageset.size()==0)
          {
            createquestionbool = FALSE;
            displaytablebool = TRUE;
            errormessagebool = FALSE;
            editbool= FALSE;
            getquestionslist(); 
          }
          
          else{
          errormessagebool = TRUE;
         }
       }   
        else{
          errormessagebool = TRUE;
         }
      }  
    }  
    
    
    else{
           
              
           if(editbool == TRUE){
           
            Itemquelist = new List<Item_Question__c>();
            BLN_SurveyQuestions_BAL blndelitemquebal = New BLN_SurveyQuestions_BAL();
            failuremessageset = blndelitemquebal.deletemethod(Itemquelist,ItemQuestionDupMAP) ;
           } 
            
          if(failuremessageset.size()==0)
          {
            Itemquerecord = new Item_Question__c();
            Itemquelist = new List<Item_Question__C>();
              Itemquerecord.Question_Level__c = selectedquelevl;
              Itemquerecord.Question__c = questionslist[0].id;
              Itemquerecord.Event__c = selectedeventid;
               Itemquelist.add(Itemquerecord );        
             questionslist[0].Answer_Type__c = selectedtype;  
       
               BLN_SurveyQuestions_BAL blnsavequebal = New BLN_SurveyQuestions_BAL();
               failuremessageset = blnsavequebal.upsertquestiosave(questionslist,answerslist,Itemquelist);
               
                if(failuremessageset.size()==0)
          {
            createquestionbool = FALSE;
            displaytablebool = TRUE;
            errormessagebool = FALSE;
            editbool= FALSE;
            getquestionslist(); 
          }
          
          else{
          errormessagebool = TRUE;
         }
               
               
          }
          
         else{
          errormessagebool = TRUE;
         }
            
    }
    
    
    
    }
    
    
       else{
          errormessagebool = TRUE;
         }   
    
         
            
  }  
    
    
   Public Void editquestion(){
         
         questionslist = new List<Question__c>();    
          QuestionMAP = new MAP<ID,Question__c>();
       BLN_SurveyQuestions_BAL blnquestionsbal = New BLN_SurveyQuestions_BAL();
        questionslist = blnquestionsbal.questionslist(selectedeventid,questionslist);

         for(Question__c que : questionslist){
               QuestionMAP.PUT(que.ID,que);
           }
      
      
      
       createquestionbool = TRUE;
       displaytablebool = FALSE;
        editbool= TRUE;
      
      
      
        questionslist = new List<Question__c>();
       questionrecord = new Question__c();
       answerslist= NEW LIST<Answer__c>();
       answerMAP=  new MAP<Decimal,Answer__c> ();
       AnswerDupMAP = new MAP<String,Answer__c> ();
        ItemQuestionDupMAP = new MAP<String,Item_Question__c>();
        Itemquelist = new LIST<Item_Question__c>();
        deletedansonedit  = new List<Answer__c>  ();
        selectedtype = '';
        getitems();
         
      
       String editquid = Apexpages.Currentpage().getparameters().get('editquid');
       SYSTEM.DEBUG('21324233 ' + editquid );
        questionrecord = QuestionMAP.get(editquid);
       //if(questionrecord.Answer_Type__c!=Null)
       selectedtype = questionrecord.Answer_Type__c;
       SYSTEM.DEBUG('21324233questionrecord  ' + questionrecord);
        uniqueNo = 0;
        dupselectedtype = new Set<String>();
        dupselectedtype.add(selectedtype);
        Integer size = questionrecord.Answers__r.size();
        
        if(size>0){
        
        for(Answer__c answerrecord : questionrecord.Answers__r){
             AnswerDupMAP.PUT(answerrecord.Answer_Text__c,answerrecord ); 
         }
        
        }
        system.debug('AnswerDupMAPonEDit: ' + AnswerDupMAP);
        
        
        if(selectedtype == 'Scale'){
          multiplechoiceoptions = TRUE;
          
           selctdminscale = questionrecord.Answers__r[0].Answer_Text__c;
            selctdmaxscale = questionrecord.Answers__r[size-1].Answer_Text__c;
        }  
         
        else if(selectedtype  == 'Multiple choice' || selectedtype  == 'Checkboxes' || selectedtype  == 'Choose from a list'  ){
        
                for(Answer__c answerrecord : questionrecord.Answers__r){
                
                    answerMAP.PUT(uniqueNo,answerrecord); 
                    uniqueNo++;       
                    answerslist.add(answerrecord); 
                }
                
            multiplechoiceoptions = TRUE;
                
        }
      else{
      
          multiplechoiceoptions = FALSE;
      
      } 
      
               // Itemquerecord.Question_Level__c = selectedquelevl;
      
      CheckTicketsforedit = '!@#$%^&';
      CheckreqTicketsforedit  = '!@#$%^&';
      CheckvisTicketsforedit = '!@#$%^&';
     
      list<Item_Question__c> editItemquerecord = new  List<Item_Question__c>();
      editItemquerecord = questionrecord.Item_Question__r;
      system.debug('editItemquerecord :' + editItemquerecord ); 
      selectedquelevl = '';
       selectedquelevl =editItemquerecord[0].Question_Level__c ;
            
              for(Item_Question__c iprecord : editItemquerecord )
               {
                if(iprecord.Question_Level__c == 'Ticket Level')
                {
                    system.debug('1w3453453w4 :');       
                  CheckTicketsforedit += iprecord.Item__C + '!@#$%^&';
                  ItemQuestionDupMAP.Put(iprecord.Item__C,iprecord); 
                  
                  if(iprecord.isRequired__c == TRUE)
                  { 
                      CheckreqTicketsforedit += iprecord.Item__C + '!@#$%^&';
                  }
                   if(iprecord.Visibility__c == TRUE)
                  { 
                      CheckvisTicketsforedit += iprecord.Item__C + '!@#$%^&';
                  }
                  itemdisplaybool = TRUE;
                  
                }   
                Else{
                  itemdisplaybool = FALSE;
                   ItemQuestionDupMAP.Put(iprecord.Event__C,iprecord); 
                  
                  
                }
               }
      
      
      questionslist.add(questionrecord);
      

       useranswersMAP = new MAP<string,List<User_Answer__c>> ();
       
     if(itmqueansMap.get(editquid).size()>0){
      for(Item_Question__c iq : itmqueansMap.get(editquid)){
           
            LIST<User_Answer__c> listnew = new LIST<User_Answer__c>();
           
           for(User_Answer__c ui : iq.User_Answers__r){
           
                   listnew.add(ui); 
           }

            useranswersMAP.PUT(iq.item__c,listnew);

            
         
      }
      }     
  
     
     System.debug('useranswersMAP:' + useranswersMAP);
   
   }
    
   
   Public Void updateanswerslist(){
   
   answerslist= NEW LIST<Answer__c>(); 
   answerMAP = new MAP<Decimal,Answer__c>();
   uniqueno=0;
   String answeroptorder= Apexpages.Currentpage().getparameters().get('answeroptorder');
    SYSTEM.DEBUG('answeroptorder:answeroptorder' + answeroptorder);
    List<string> ansorder = new list<string>();
    ansorder = answeroptorder.split('-');
      SYSTEM.DEBUG('ansorder :ansorder ' + ansorder );
   
    for(string ans : ansorder){
          
          answerrecord = new Answer__c(); 
           answerrecord.Answer_Text__c = ans.replace('*&^%$','-');    
                    answerMAP.PUT(uniqueNo,answerrecord); 
                    uniqueNo++;       
                    answerslist.add(answerrecord); 
     }
                
   
   }
   
   
 /*  Public Void updatequestion(){
   
   questionslist = new List<Question__c>();
   answerslist= NEW LIST<Answer__c>(); 
   Itemquelist = new LIST<Item_Question__c>();
   
    String questionorder= Apexpages.Currentpage().getparameters().get('questionorder');
    SYSTEM.DEBUG('questionorder:questionorder' + questionorder);
    List<string> queorder = new list<string>();
    queorder = questionorder.split('-');
      SYSTEM.DEBUG('queorder :queorder ' + queorder );
      Integer qorder = 1; 
        for(string sr : queorder)
        {
           SYSTEM.DEBUG('1233243 ' +sr  );
           if(sr!=''){
           if(QuestionMAP.ContainsKey(sr)){
            questionrecord = new Question__c();
            questionrecord = QuestionMAP.get(sr);
            questionrecord.Question_Order__c = qorder;
            questionslist.add(questionrecord);
            SYSTEM.DEBUG('questionslist' +questionslist);
            qorder++;
            }
           }
        }
        SYSTEM.DEBUG('questionslist:questionslist' + questionslist);
       BLN_SurveyQuestions_BAL blnsavequebal = New BLN_SurveyQuestions_BAL();
       failuremessageset = blnsavequebal.upsertquestiosave(questionslist,answerslist,Itemquelist);
       
         if(failuremessageset.size() == 0){
             getquestionslist();
         }
         else{
             errormessagebool = TRUE;
          }
         
       
        
   }*/
   
   Public Void cancelmethod(){
   
    createquestionbool = FALSE;
    displaytablebool = TRUE;
    editbool= FALSE;
    getquestionslist();
   
   } 
    
  Public Void itemdisplay(){
           
      system.debug('11111221312' + selectedquelevl);
      if(selectedquelevl== 'Ticket Level'){
          itemdisplaybool = TRUE;
      }
      else{
          itemdisplaybool = FALSE;
      }
  } 
  
  public Integer queanscount;
  Public Void delquestion(){ 
        
        createquestionbool = FALSE;
        displaytablebool = TRUE;
        editbool= FALSE;
        
         Itemquelist = new LIST<Item_Question__c>();
         answerslist= NEW LIST<Answer__c>();
         
         String delquid = Apexpages.Currentpage().getparameters().get('delquid');
         queanscount= Integer.valueof(Apexpages.Currentpage().getparameters().get('queanscount'));
         questionrecord = QuestionMAP.get(delquid);
         
        
         questionslist = new list<Question__C>();
         questionslist.add(questionrecord);
         
         if(queanscount == 0){
          
          BLN_SurveyQuestions_BAL blndelquebal = New BLN_SurveyQuestions_BAL();
          failuremessageset = blndelquebal.deletemethod(questionslist);
          
          if(failuremessageset.size() == 0){
             
                  getquestionslist();
                  Integer queorder = 1;
                 for(Question__c qu : questionslist ){
                 
                     qu.Question_Order__c = queorder ;
                     queorder++;
                 
                 } 
              BLN_SurveyQuestions_BAL blnsavequebal = New BLN_SurveyQuestions_BAL();
              failuremessageset = blnsavequebal.upsertquestiosave(questionslist,answerslist,Itemquelist);
              if(failuremessageset.size() != 0){
                errormessagebool = TRUE;
              }
              
          }
          else{
          
           errormessagebool = TRUE;
          }
          
        }
      else{
      
      getquestionslist();
      }   
         
          
         
    
   }  
   
   
   
}