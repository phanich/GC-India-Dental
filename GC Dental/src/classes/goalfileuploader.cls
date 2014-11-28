/***********************************************************************************************
*   Controller Name : goalfileuploader 
*   Date            : 17/01/2014 
*   Author          : Shruthi Reddy.Gone
*   Purpose         : This class is for Importing Goals From CSV File.

**************************************************************************************************/



public class goalfileuploader {
    
    public string nameFile{get;set;}
    public List<goal__C> tobeinsertedgoal{get;set;}
    public List<goal__C> goalinsertedlist{get;set;}
    public List<goal__C> goalinsertedwithoutline{get;set;}
    
    public List<Goal_Line_Item__c> tobeinsertedgoallineitems{get;set;}
    public List<user> user{get;set;}
    public Map<string,Goal_Line_Item__c> goalMap{get;set;}
    public List<Product__c> allproducts{get;set;}
    

    Public LIST<ID> goalSuccessIds {get;set;}
    Public Set<ID> goallinesuccessIds{get;set;}
    Public LIST<String> SuccessCSVRecords{get;set;}
    Public LIST<String> FailureCSVRecords{get;set;}
   
    Public Set<string> goalinsertSet{get;set;}
    Public String OrgzId{get;set;}
    public String dataFromJavaScript{get; set;}
    public String loaddatafunction{get; set;}
    
   public Boolean headerDisplay{get; set;}
   public Boolean Insertedgoals{get; set;}
   public Boolean UTF8Bool{get; set;}
   public Boolean alertbool{get; set;}
   
 public goalfileuploader (){
    dataFromJavaScript ='';
    tobeinsertedgoal = new List<goal__c>();
    tobeinsertedgoallineitems= new List<Goal_Line_Item__c>();
    user = new List<user>();
    goalMap = new Map<string,Goal_Line_Item__c>();
    allproducts = new List<Product__c>();
    goalinsertedlist =  new List<goal__C>();
    goalinsertedwithoutline = new List<goal__C>();
    OrgzId = '' ;
    
                headerDisplay = true;
                Insertedgoals = false;
                UTF8Bool = false;     
                alertbool=false;

                             
                             system.debug( '  OrgzId  ' + UserInfo.getOrganizationId());      
               
                       
    
      }
     public PageReference exportToCSV()
        {
                PageReference pageRef= new PageReference('/apex/Import_Goal_Template');
                pageRef.setredirect(false);
                return pageRef;
        }
       public PageReference Goalsview()
        {      
                system.debug('  OrgzId  ' + UserInfo.getOrganizationId());
                 String OrgzId =  UserInfo.getOrganizationId();
                             if(OrgzId == '00D90000000oecgEAA'){
                                system.debug('trueeee' );
                                PageReference pageRef= new PageReference('/a0F?fcf=00B90000005jSvy');
                                pageRef.setredirect(false);
                                 return pageRef;       
                             }
                             else{
                                system.debug('trueeee' );
                                PageReference pageRef= new PageReference('/a0A?fcf=00BN0000000ZUfy');
                                pageRef.setredirect(false);
                                 return pageRef;       
                             }
              
        }  
       public PageReference Importpage()
        {
              PageReference pageRef= new PageReference('/apex/Goalsimport');
                pageRef.setredirect(true);
                return pageRef;
        }  
        
  
        public List<String> parseCSV(String contents) 
        {
           List<String> allFields = new List<String>();
           
           nameFile = contents.subString(contents.indexOf('????:::::******&&&&&&%%%%;;;;'));
           nameFile = nameFile.replace('????:::::******&&&&&&%%%%;;;;','');
            system.debug('BBBBBBBBBBBBBBBBBBBBBBB'+ nameFile );   
             List<String> lines = new List<String>();
             lines = contents.split('aazz11ttt222ggg'); // Using Carriage return
             for(String line: lines) {
                if (line.replaceAll(',','').trim().length() == 0) break;
                List<String> fields = line.split(','); 
                    String cleanFields='';
                    String compositeField;
                    Boolean makeCompositeField = false;
                    for(String field: fields) {
                       field = field.trim();
                            if(field == '"'){ 
                            compositeField += ',' + field;
                            cleanFields+=(compositeField.replaceAll('DBLQT','"')+';;;:::');
                            makeCompositeField = FALSE;
                        }else if (field.startsWith('"') && field.endsWith('"')) {
                            cleanFields+=(field.replaceAll('DBLQT','"')+';;;:::' );
                        }else if (field.startsWith('"')) {
                                makeCompositeField = true;
                            compositeField = field;
                        }else if (field.endsWith('"')) {
                         compositeField += ',' + field;
                            cleanFields+=(compositeField.replaceAll('DBLQT','"')+';;;:::');
                            makeCompositeField = false;
                        } else if (makeCompositeField) {
                        compositeField +=  ',' + field;
                        } else {
                           cleanFields+=(field.replaceAll('DBLQT','"')+';;;:::');
                        }
                         }
                      allFields.add(cleanFields);
           }
             return allFields;      

        }
  
  
  
  
    public Pagereference ReadFile()
    {
       dataFromJavaScript =ApexPages.currentPage().getparameters().get('one');
       system.debug('          mythily  '+dataFromJavaScript );
        if(!dataFromJavaScript.endsWith('.csv')){ 
                   
                     alertbool=true;
                     Insertedgoals = FALSE;
                     UTF8Bool = false;
               system.debug(' !!!!!!!! Excel ' +alertbool);
               
       }
        else{
         system.debug('       CSV ' );
         alertbool=false;
         headerDisplay = false;
         Insertedgoals = true;
         UTF8Bool = false;
         system.debug('!!!@@@@$$$' + dataFromJavaScript );
     Try {
        goalinsertSet = new Set<String>();
        List<String> parsedCSV= new List<String>();
                
        nameFile=dataFromJavaScript ; 
        parsedCSV=parseCSV(nameFile);
              system.debug('parsedCSV ' + parsedCSV);
        Map<string,Id> UserNamesMap = new Map<string,Id>();
            user = [select id,name,username from User where IsActive = :True];
             for(user u:user){
                UserNamesMap.put(u.username,u.id);
             }
         Map<string,Id> ProductNamesMap = new Map<string,Id>();
         allproducts  = [select id,name from Product__c ]; 
         for(Product__c p : allproducts  ){
           ProductNamesMap.put(p.Name.tolowercase().replaceAll( '\\s+', ''),p.id);
         }
        
       for(Integer i=1;i<parsedCSV.size()-1;i++)
        {

          system.debug('ParsedCsvSplit ' + parsedCSV[i].split(';;;:::'));
          String[] inputvalues = new String[]{};
          inputvalues = parsedCSV[i].split(';;;:::');
          if(!goalinsertSet.contains(inputvalues[0].trim())){
              system.debug('^^^^^^^^^^ 522 ' + inputvalues+'   Usernames   '+UserNamesMap);  
              goal__c g = new goal__C();
           try{   
            if(UserNamesMap.ContainsKey(inputvalues[0])){
                 g.Sales_Executive__C = UserNamesMap.get(inputvalues[0]);
                 g.ownerId = UserNamesMap.get(inputvalues[0]);
             g.Start_Date__c = date.parse(inputvalues[1]);
             g.End_Date__c = date.parse(inputvalues[2]);
             g.Goal_From__c = 'Import';
             
             goalinsertSet.add(inputvalues[0].trim());
             tobeinsertedgoal.add(g);
            } 
           }catch(Exception e){}
        }    
          Goal_Line_Item__c glineitems = new Goal_Line_Item__c();
          system.debug('@@@QQQQ ' + ProductNamesMap.keyset());
          system.debug('inputvalues[3]' + inputvalues[3].trim().tolowercase().replaceAll( '\\s+', ''));
         try{
          if(ProductNamesMap.ContainsKey(inputvalues[3].tolowercase().replaceAll( '\\s+', ''))){
                    system.debug('shruthi reddy ' );
                 glineitems.Product__c = ProductNamesMap.get(inputvalues[3].tolowercase().replaceAll( '\\s+', ''));
         
             system.debug('glineitems.Product__c       ' + glineitems.Product__c);
          }
       
          glineitems.Quantity_Goal__c = Integer.valueOf(inputvalues[4]);
          glineitems.Product_Quantity_in__c = inputvalues[5];
          if((inputvalues[6]!=null) || (inputvalues[6]!= '')){
              system.debug('NNNNNNNNNNNNNNNNNNNNNNNNNNNN111111111 ' + inputvalues[6] );
           if(inputvalues[6].trim().isNumeric()){
               system.debug('NNNNNNNNNNNNNNNNNNNNNN222222222222 ' );
             glineitems.Revenue_Goal__c = Integer.valueOf(inputvalues[6].trim());
             }
          } 
          } catch(Exception e){}

          try{
            goalMap.put(inputvalues[0].trim()+inputvalues[3].tolowercase().trim().replaceAll( '\\s+', ''),glineitems);
          } catch(Exception e){}
          system.debug('WWWWWWWWW TTTT ' + goalmap);
          tobeinsertedgoallineitems.add(glineitems);

        }
            if(tobeinsertedgoal.size() >0) {
                 goalSuccessIds = new LIST<ID>();
                 Database.SaveResult[] goalrecord = DataBase.insert(tobeinsertedgoal,false);
                 System.debug('QQQQ YYY ' + goalrecord );
                 for(DataBase.SaveResult s: goalrecord){
                     if(s.isSuccess()){
                     goalSuccessIds.add(s.getId());}
                  }
               system.debug('***************** ' +goalSuccessIds );
               List<Product__c> products = [select id,name from Product__C];
               List<goal__C> goallist = [select id,Name,Sales_Executive__r.Username,Sales_Executive__c from goal__c where id in : goalSuccessIds];
               system.debug('&&&&&&&**** ' + goallist );
               
               for(goal__C gg : goallist ){
                       Integer Uniqueno = 1;
                       system.debug('8886666' + gg.Sales_Executive__r.Username);
                            for(Product__c p : products){
                                  system.debug('^^^^&&&& ' + goalmap.keyset());
                                  
                                  if(goalMap.containskey((gg.Sales_Executive__r.Username.trim())+(p.name.tolowercase().trim().replaceAll( '\\s+', '')))){
                                     (goalMap.get((gg.Sales_Executive__r.Username.trim())+(p.name.tolowercase().trim().replaceAll( '\\s+', '')))).goal__C = gg.id;
                                     (goalMap.get((gg.Sales_Executive__r.Username.trim())+(p.name.tolowercase().trim()).replaceAll( '\\s+', ''))).Name =string.valueOf(gg.Name + '-' + Uniqueno);
                                      Uniqueno++; 
                                  }
                             }
               }
              DataBase.SaveResult[] GoalLineItems = DataBase.insert(tobeinsertedgoallineitems,false);
              
                       string failureline='';
                       list<string> fileline = new list<string>();
                       integer lineno=1;
                       Integer csvRecordsCount=0;
                       Integer FailurecsvRecordsCount = 0;
                       string header = 'UserName,Start Date,End Date,Product,Quantity Goal,Quantity In,Revenue Goal,Error Message \n';
                       string finalstr = header ;
                      for(Database.SaveResult rer : GoalLineItems)
                       {
                       system.debug('11111111111111 %%%% &&& ' + rer);
                       String em = ''; // error message
                        if(rer.isSuccess())
                        {
                           csvRecordsCount++;
                        } else{  
                        
                         system.debug('Error ' + rer);
                           for(Database.Error dbe : rer.getErrors()) { 
                           em += (dbe.getMessage()+' ').replaceAll(',','');
                            }
                           system.debug('em'  + em );
                            
                          system.debug('ParsedCsvLine  ' +parsedCSV[lineno].split(';;;:::'));
                          if(parsedCSV[lineno].contains(';;;:::'))
                           {
                             system.debug('ParsedCsvLineTrue   ' + em);
                             if(em.contains('Required fields are missing: [Revenue Goal]')){
                            
                                     failureline = parsedCSV[lineno].split(';;;:::')+','+''+','+em+'\n';
                                     system.debug('shruthi shruthi ' + failureline );
                             }else{
                             failureline = parsedCSV[lineno].split(';;;:::')+','+em+'\n';
                            }
                             if(failureline.startsWith('(')){
                             failureline = failureline.remove('(');
                             }
                             if(failureline.contains(')')){
                             failureline = failureline.remove(')');
                             }
                             //failureline= (parsedCSV[lineno].substring(0,(parsedCSV[lineno].length()-2))).split(';;;:::')+','+em+'\n';
                             system.debug('failureline' + failureline);
                            } 
                              finalstr = finalstr +failureline;
                            
                           FailurecsvRecordsCount++;
                        }
                        system.debug('^^^^ &&& *** ' + failureline);
                        system.debug('! ^!^^ &&& *** 555' + finalstr );
                        lineno++;
                      
                       
                     }
                     system.debug('1111111111 QQQQQQ ' + SuccessCSVRecords  + '%%%% $$$ &&& ***' + FailureCSVRecords);
                     String success =  'Number of records imported: '+ (parsedCSV.size()-2) + '<br/>'+
                                 'Number of records Inserted successfully: '+ csvRecordsCount+'<br/>'+
                                 'Number of records failed: '+ FailurecsvRecordsCount+'<br/>';
                                 
                     String emailMessage =  'You have just completed your import process!'+'<br/><br/>'+
                                       success +
                                       'We strongly recommend that you check a few of your imported records to verify that your information was imported as expected.'+'<br/><br/>'+
                                       'If you encounter any problems or have any questions, please contact Administrator.<br/><br/>'+
                                       'Thank you! <br/> Gc India Dental Pvt.Ltd.<br/>';
                
                
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                blob csvBlob = Blob.valueOf(finalstr);
                string csvname= 'Import Failure Records.csv';
                csvAttc.setFileName(csvname);
                csvAttc.setBody(csvBlob);
                            
                
                
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {UserInfo.getUserEmail()};
                system.debug('!@@@@@@@@@ ' +  toAddresses );
                 mail.setToAddresses(toAddresses);
                 mail.setSubject('Import Goals Summary');
                 mail.setPlainTextBody(emailMessage);
                 mail.setHtmlBody(emailMessage);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   }
               
               system.debug('IIIDDD   ' +goalSuccessIds);
              goalinsertedlist = [select id,Count_of_line_items__c,name,Sales_Executive__c,Start_Date__c,End_Date__c,(select Name,Product__c,Quantity_Goal__c,Revenue_Goal__c from Goal_Line_Items__r Order By Name  ) from goal__C where id IN : goalSuccessIds And Count_of_line_items__c > 0];
              system.debug('QQQQQ EEEE RRRWWW' +goalinsertedlist); 
              goalinsertedwithoutline = [select id,Count_of_line_items__c,name,Sales_Executive__c,Start_Date__c,End_Date__c,(select Name,Product__c,Quantity_Goal__c,Revenue_Goal__c from Goal_Line_Items__r Order By Name  ) from goal__C where id IN : goalSuccessIds And Count_of_line_items__c =: 0];
              for(goal__C g : goalinsertedwithoutline)
              {
                  Database.DeleteResult[] drList = Database.delete(goalinsertedwithoutline, false);
              }     
  
 }    
    catch(Exception e){
                        UTF8Bool = true;
                        Insertedgoals = false;
                        headerDisplay = false;
                        
        } 
  }
         
         return null;
}
}