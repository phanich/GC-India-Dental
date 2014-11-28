public class TotalSalesProductivityCon{

    public Boolean ShowProductWiseSelect{get;set;}
    public Boolean ShowManagerWiseSelect{get;set;}
    public Boolean ShowCustomerWiseSelect {get;set;}
    public Boolean ShowNoofVisitsWiseSelect{get;set;}
    public Boolean ShowGoalsWiseSelect{get;set;}
    public Boolean ShowExecutiveWiseTable{get;set;}     
    public Boolean goaltypebool{get;set;}   
    public LIST<String> dates{get; set;}
    
    
    public List<SelectOption> ChoosenState{get;set;}
    public String SelectedState{get;set;}
    
    public List<SelectOption> ChoosenUser{get;set;}
    public String SelectedUser{get;set;}
    
    public List<SelectOption> ProductsPicklist{get; set;}
    public String SelectedProduct{get;set;}
    
    public List<SelectOption> ChoosenExecutive{get;set;}
    public String SelectedExecutive{get;set;}
    
    public List<SelectOption> ChoosenManager{get;set;}
    public String SelectedManager{get;set;}
    
    public List<SelectOption> ChoosenCustomerCategory{get;set;}
    public String SelectedCustomerCategory{get;set;}
    
    public List<SelectOption> ChoosenCustomerState{get;set;}
    public String SelectedCustomerState{get;set;}
    
    public List<SelectOption> ChoosenGoalType{get;set;}
    public String SelectedGoalType{get;set;}
    
    public LIST<Product__c> Products{get;set;}
    public LIST<ManagerProductivity> SalesManagerProductAchived{get; set;} 
    public LIST<ManagerProductivity> SalesExecutiveProductAchived{get; set;}
    public LIST<ManagerProductivity> AccountProductivityAchived{get; set;}
    public LIST<VisitsInner> seDateWiseVisits{get; set;}
    public LIST<ExecutiveGoalsTotal> SalesExecutiveGoalAchived{get; set;}
    
    public Account goa{get;set;} 
    public Account seo{get;set;}
    public User LoggedInuser{get;set;}
    
    public TotalSalesProductivityCon(){
    
        goa = new Account();
        seo = new Account();
        goa.Start_Date__c = system.Today().toStartOfMonth();
        goa.End_Date__c = system.Today().toStartOfMonth().addDays(45).TostartOfMonth().addDays(-1);
               
        goaltypebool = false;
        
        //2nd Executive Product Report
        ChoosenState = new LIST<SelectOption>();
        Schema.DescribeFieldResult countryFieldDescription = User.State__c.getDescribe();
        for(Schema.Picklistentry picklistEntry : countryFieldDescription.getPicklistValues()){
            ChoosenState.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        
        LoggedInuser = new User();
        LoggedInuser = [SELECT id, Name, Username, Email, GC_User_Role__c,UserRoleId, State__c, Manager.Id from User where id =: UserInfo.getUserId() and isActive =: TRUE];
        
        MAP<Id,User> ManagersUserMap = new MAP<Id,User>([SELECT ID, Name, Phone FROM USER WHERE GC_User_Role__c ='Manager' and isActive =: TRUE]);
        LIST<User> managersList = new LIST<User>();
        managersList =  ManagersUserMap.values();  
        managersList.sort();
        
        ChoosenManager = new LIST<SelectOption>(); 
        for(User u: managersList){
            ChoosenManager.add(new SelectOption(u.Id, U.Name));
        }
        
        
        
        //3rd Tab Customer Wise Report
        
        ChoosenCustomerCategory = new List<SelectOption>();
        
        ChoosenCustomerCategory.add(new SelectOption('All','ALL'));
        ChoosenCustomerCategory.add(new SelectOption('A','A'));
        ChoosenCustomerCategory.add(new SelectOption('B','B'));
        ChoosenCustomerCategory.add(new SelectOption('C','C'));
        
        SelectedCustomerCategory ='All';
        
        SET<ID> UserRolesUnderManager = new SET<ID>();    
        SET<ID> loginUserRollId = new SET<ID>();
        User ForUserRoleID = new User();
        
        ForUserRoleID = [SELECT id,UserRoleId, Name, Email, UserName from User where id=: UserInfo.getUserId() and isActive =: TRUE];     
        loginUserRollId.add(ForUserRoleID.UserRoleId);   
        
        UserRolesUnderManager.addAll(getAllSubRoleIds(loginUserRollId));
        
        MAP<Id,User> userListMap = new MAP<Id,User>([SELECT ID, Name, Email, UserName FROM USER WHERE GC_User_Role__c = 'Executive' and isActive =: TRUE AND UserRoleID IN: UserRolesUnderManager ]);
        
        LIST<User> usersList = new LIST<User>();
        usersList =  userListMap.values();  

        
        if(LoggedInuser.GC_User_Role__c != null){
            if(LoggedInuser.GC_User_Role__c == 'Manager'){
               usersList.add(ForUserRoleID); 
            }
            else if(LoggedInuser.GC_User_Role__c == 'NSM'){
                if(ManagersUserMap.size() > 0){
                    for(User u1: ManagersUserMap.values()){
                     usersList.add(u1);
                    }
                }
            }  
        }
        
        usersList.sort();
        
        ChoosenExecutive= new List<SelectOption>();                                
        for(User u: usersList){
            ChoosenExecutive.add(new SelectOption(u.id, u.name));
            SelectedExecutive = u.Id;
        }
        
        ChoosenCustomerState = new LIST<SelectOption>();
        ChoosenCustomerState.add(new SelectOption('All', 'All'));
        
        Schema.DescribeFieldResult stateFieldDescription = Account.Billing_State__c.getDescribe();
        for(Schema.Picklistentry picklistEntry : stateFieldDescription.getPicklistValues()){
            ChoosenCustomerState.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        SelectedCustomerState = 'All';
        
        LIST<Product__c> Productlist = [SELECT  Id, Name, Quantity_in_each_box__c, Product_Price__c, Product_Family__c, Product_Description__c, Product_Code__c 
                                        FROM Product__c ORDER BY Order_No__c DESC NULLS LAST];
        
        ProductsPicklist = new List<SelectOption>(); 
        ProductsPicklist.add(new SelectOption('All Products', 'All Products'));
        selectedproduct = 'All Products';
        for(Product__c pr: Productlist){
            ProductsPicklist.add(new SelectOption(pr.id, pr.name));
        } 
        
        ChoosenGoalType = new List<SelectOption>();
        ChoosenGoalType.add(new SelectOption('Revenue','Revenue'));
        ChoosenGoalType.add(new SelectOption('Unit','Unit'));
        SelectedGoalType = 'Revenue';
        
        
        if(LoggedInuser.GC_User_Role__c != null){
            if(LoggedInuser.GC_User_Role__c == 'Manager'){
                SelectedManager = LoggedInuser.ID;
                executivewisereportselect();
            }else if(LoggedInuser.GC_User_Role__c == 'Executive'){
                SelectedManager = LoggedInuser.Manager.Id;
                SelectedExecutive = LoggedInuser.ID;
                customerwisereportselect();
            }else if(LoggedInuser.GC_User_Role__c == 'NSM'){
                if(ManagersUserMap.size() > 0){
                    LIST<User> ManagerUsers = new LIST<User>();
                    ManagerUsers = ManagersUserMap.values();
                    SelectedManager = ManagerUsers[0].id;
                }
               productwisereportselect();
              //  noofvisitsreportselect();
            }   
        }
    }
 
    public void productwisereportselect(){
        ShowProductWiseSelect = TRUE;
        ShowManagerWiseSelect = TRUE;
        ShowExecutiveWiseTable = FALSE;
        ShowCustomerWiseSelect = FALSE;
        ShowNoofVisitsWiseSelect = FALSE;
        ShowGoalsWiseSelect = FALSE;
        
        MAP<Id,User> ManagersUserMap = new MAP<Id,User>([SELECT ID, Name, Phone FROM USER WHERE GC_User_Role__c ='Manager' and isActive =: TRUE]);
        LIST<User> usersList = new LIST<User>();
        usersList = ManagersUserMap.values();
        usersList.sort();
            
        LIST<AggregateResult> glanceProductsSalesOrder = [SELECT SUM(Order_Quantity__c), Product__c
                                                          FROM Sales_Order_Line_Items__c
                                                          WHERE (SalesOrder__r.Close_Date__c >=: goa.Start_Date__c 
                                                          AND SalesOrder__r.Close_Date__c <=: goa.End_Date__c) 
                                                          AND (SalesOrder__r.Customer__r.Owner.Manager.Id IN: usersList OR SalesOrder__r.Customer__r.Owner.Id IN: usersList)
                                                          GROUP BY Product__c]; 
        
        MAP<String, String> productWiseGrandTotal = new MAP<String, String>();
        for(AggregateResult ag: glanceProductsSalesOrder){  
              String productname =  String.valueOf(ag.get('Product__c'));
              String orderValue = String.valueOf(Integer.Valueof(ag.get('expr0')));
              productWiseGrandTotal.put(productname, orderValue );
        }
                  
        LIST<AggregateResult> glanceExecutiveSalesOrder = [SELECT SUM(Order_Quantity__c), Product__c, SalesOrder__r.Customer__r.Owner.Manager.ID ow
                                                           FROM Sales_Order_Line_Items__c
                                                           WHERE (SalesOrder__r.Close_Date__c >=: goa.Start_Date__c 
                                                           AND SalesOrder__r.Close_Date__c <=: goa.End_Date__c) 
                                                           AND SalesOrder__r.Customer__r.Owner.Manager.Id IN: usersList
                                                           GROUP BY Product__c, SalesOrder__r.Customer__r.Owner.Manager.ID];
         system.debug('^^^^ '+glanceExecutiveSalesOrder);
         MAP<Id, MAP<String, String>> SalesExecutiveProductAchivement = new MAP<ID, MAP<String, String>>();
        
         for(User U: usersList){
             MAP<String, String> productWiseAchivement = new MAP<String, String>();
             for(AggregateResult ag: glanceExecutiveSalesOrder){  
                  if(ag.get('ow') == U.Id ){
                   String prods =  String.valueOf(ag.get('Product__c'));
                   String orderVal = String.valueOf(Integer.Valueof(ag.get('expr0')));
                   productWiseAchivement.put( prods , orderVal);
                 } 
             }
            SalesExecutiveProductAchivement.put(U.ID, productWiseAchivement);
         }
         
         
         LIST<AggregateResult> glanceManagerSalesOrder = [SELECT SUM(Order_Quantity__c), Product__c, SalesOrder__r.Customer__r.Owner.ID ow
                                                          FROM Sales_Order_Line_Items__c
                                                          WHERE (SalesOrder__r.Close_Date__c >=: goa.Start_Date__c 
                                                          AND SalesOrder__r.Close_Date__c <=: goa.End_Date__c) 
                                                          AND SalesOrder__r.Customer__r.Owner.Id IN: usersList
                                                          GROUP BY Product__c, SalesOrder__r.Customer__r.Owner.ID];
         system.debug('$$$$ '+glanceManagerSalesOrder);
         MAP<Id, MAP<String, String>> SalesManagerProductAchivement = new MAP<ID, MAP<String, String>>();
         
         for(User U: usersList){
             MAP<String, String> productWiseAchivement = new MAP<String, String>();
             for(AggregateResult ag: glanceManagerSalesOrder){   
                  if(ag.get('ow') == U.Id ){
                   String prods =  String.valueOf(ag.get('Product__c'));
                   String orderVal = String.valueOf(Integer.Valueof(ag.get('expr0')));
                     productWiseAchivement.put( prods , orderVal);
                 } 
             }   
            SalesManagerProductAchivement.put(U.ID, productWiseAchivement);
         }    
        
        products = [SELECT ID, NAME, Product_Code__c, Product_Description__c, Product_Family__c, Product_Price__c, Quantity_in_each_box__c 
                    FROM Product__c ORDER BY Order_No__c DESC NULLS LAST];
            
        SalesManagerProductAchived = new LIST<ManagerProductivity>();
           
        //Headers To display    
        User dummyUser = new USER( LastName = 'User Name', FirstName='Test');
        
        LIST<ManagerProducts> productsWiseOrderForDummy = new LIST<ManagerProducts>();
        for(Product__c p: products){       
            ManagerProducts mp;            
            Integer prodVal = 0; 
            productsWiseOrderForDummy.add(new ManagerProducts(p.name , p.Name, TRUE));           
        }    
        SalesManagerProductAchived.add(new ManagerProductivity(dummyUser , productsWiseOrderForDummy));
        
        // For Grand Totals  
        User grandTotalUser = new User();
        grandTotalUser = [SELECT Id, Name, Email FROM User WHERE alias='reports'];
        LIST<ManagerProducts> productsWiseTotalSalesOrder= new LIST<ManagerProducts>();
        for(Product__c p: products){       
            ManagerProducts mp;            
            Integer prodVal = 0; 
            
            if(productWiseGrandTotal.containsKey(p.id)){
                productsWiseTotalSalesOrder.add(new ManagerProducts(p.name , productWiseGrandTotal.get(p.id) , FALSE));   
            }
            else{
                productsWiseTotalSalesOrder.add(new ManagerProducts(p.name , '0' , FALSE));   
            }
        }    
        SalesManagerProductAchived.add(new ManagerProductivity(grandTotalUser , productsWiseTotalSalesOrder));
           
           
           for(User u: usersList){
                
               MAP<String, String> UserProductOrder = new MAP<String, String>();
               UserProductOrder = SalesExecutiveProductAchivement.get(u.id);
              
               MAP<String, String> ManagerProductOrder = new MAP<String, String>();
               ManagerProductOrder = SalesManagerProductAchivement.get(u.id);
                 
               LIST<ManagerProducts> productsWiseOrder = new LIST<ManagerProducts>();
               for(Product__c p: products){       
                   
                     ManagerProducts mp;            
                     Integer prodVal = 0; 
                     
                     if(UserProductOrder.containsKey(p.id)){
                         prodVal = Integer.valueOf(UserProductOrder.get(p.id));
                     }
                     if(ManagerProductOrder.containsKey(p.id)){
                         prodVal += Integer.valueOf(ManagerProductOrder.get(p.id));
                     }
                     
                     productsWiseOrder.add(new ManagerProducts(p.name ,String.valueOf(prodVal), FALSE));           
               }    
               SalesManagerProductAchived.add(new ManagerProductivity(u , productsWiseOrder));       
           }   
    }
    //1st Manager Report End
    
    public void executivewisereportselect(){
            ShowProductWiseSelect = FALSE;
            ShowManagerWiseSelect = FALSE;
            ShowExecutiveWiseTable = TRUE;
            ShowCustomerWiseSelect = FALSE;
            ShowNoofVisitsWiseSelect = FALSE;
            ShowGoalsWiseSelect = FALSE;
            
            SET<ID> UserRolesUnderManager = new SET<ID>();    
            SET<ID> loginUserRollId = new SET<ID>();
            User ForUserRoleID = new User();
            
            ForUserRoleID = [SELECT id,UserRoleId, Name, Email, UserName from User where id=: SelectedManager and isActive =: TRUE];
            loginUserRollId.add(ForUserRoleID.UserRoleId);   
            
            UserRolesUnderManager.addAll(getAllSubRoleIds(loginUserRollId));
            UserRolesUnderManager.add(ForUserRoleID.UserRoleId);
                       
            MAP<Id,User> userListMap = new MAP<Id,User>([SELECT ID, Name, Email, UserName FROM USER WHERE isActive =: TRUE AND UserRoleID IN: UserRolesUnderManager ]);
                    
            LIST<User> usersList = new LIST<User>();
            usersList =  userListMap.values();  
            
            /*
            if(LoggedInuser.GC_User_Role__c == 'NSM' || LoggedInuser.GC_User_Role__c == 'Manager'){
             usersList.add(ForUserRoleID);
            }  
            */
            usersList.sort();
            
            LIST<AggregateResult> glanceProductsSalesOrder = [SELECT SUM(Order_Quantity__c), Product__c
                                                              FROM Sales_Order_Line_Items__c
                                                              WHERE SalesOrder__r.Close_Date__c >=: goa.Start_Date__c 
                                                              AND SalesOrder__r.Close_Date__c <=: goa.End_Date__c 
                                                              AND SalesOrder__r.Customer__r.Owner.Id IN: usersList
                                                              GROUP BY Product__c];

            MAP<String, String> productWiseGrandTotal = new MAP<String, String>();
            for(AggregateResult ag: glanceProductsSalesOrder){  
                  String productname =  String.valueOf(ag.get('Product__c'));
                  String orderValue = String.valueOf(Integer.Valueof(ag.get('expr0')));
                  productWiseGrandTotal.put( productname, orderValue );
            }
            
            LIST<AggregateResult> glanceSalesOrder = [SELECT SUM(Order_Quantity__c), Product__c, SalesOrder__r.Customer__r.Owner.Id ow
                                                        FROM Sales_Order_Line_Items__c
                                                        WHERE (SalesOrder__r.Close_Date__c >=: goa.Start_Date__c AND SalesOrder__r.Close_Date__c <=: goa.End_Date__c) 
                                                        AND SalesOrder__r.Customer__r.Owner.Id IN: usersList
                                                        GROUP BY Product__c, SalesOrder__r.Customer__r.Owner.id];
             
            MAP<ID , MAP<String , String> > userProductsAgrregate = new MAP<ID, MAP<String , String>>();
             
             for(User u: usersList){
                 MAP<String , String> userWiseAggResult = new  MAP<String , String>();
                 User salesExecutive = new User();
                 
                 for(AggregateResult ag: glanceSalesOrder){
                     if(ag.get('ow') == u.Id ){
                       String prods =  String.valueOf(ag.get('Product__c'));
                       String orderVal = String.valueOf(Integer.Valueof(ag.get('expr0')));
                         userWiseAggResult.put( prods , orderVal);
                     }
                 }
                 userProductsAgrregate.put(u.id, userWiseAggResult);
             }
             
             products = [SELECT ID, NAME, Product_Code__c, Product_Description__c, Product_Family__c, Product_Price__c, Quantity_in_each_box__c 
                         FROM Product__c ORDER BY Order_No__c DESC NULLS LAST];
                
             SalesExecutiveProductAchived = new LIST<ManagerProductivity>();
                     
             // For Dummy User   
             User dummyUser = new USER( LastName = 'User Name', FirstName='Test');
     
             LIST<ManagerProducts> productsWiseOrderForDummy = new LIST<ManagerProducts>();
             for(Product__c p: products){           
                     productsWiseOrderForDummy.add(new ManagerProducts(p.name , p.Name, TRUE));           
             }    
             SalesExecutiveProductAchived.add(new ManagerProductivity(dummyUser , productsWiseOrderForDummy));
                 
            // For Grand Totals  
            User grandTotalUser = new User();
            grandTotalUser = [SELECT Id, Name, Email FROM User WHERE alias='reports'];
            LIST<ManagerProducts> executiveWiseTotalSalesOrder= new LIST<ManagerProducts>();
            for(Product__c p: products){       
                ManagerProducts mp;            
                Integer prodVal = 0;
                
                if(productWiseGrandTotal.containsKey(p.id)){
                    executiveWiseTotalSalesOrder.add(new ManagerProducts(p.name , productWiseGrandTotal.get(p.id) , FALSE));   
                }
                else{
                    executiveWiseTotalSalesOrder.add(new ManagerProducts(p.name , '0' , FALSE));   
                }
            }    
            SalesExecutiveProductAchived.add(new ManagerProductivity(grandTotalUser , executiveWiseTotalSalesOrder));
           
            for(User u: usersList){
                
               MAP<String, String> UserProductOrder = new MAP<String, String>();
               UserProductOrder = userProductsAgrregate.get(u.id);
                 
               LIST<ManagerProducts> productsWiseOrder = new LIST<ManagerProducts>();

               for(Product__c p: products){      
                  ManagerProducts mp;   
                  if(UserProductOrder.containsKey(p.id)){
                       productsWiseOrder.add(new ManagerProducts(p.name , UserProductOrder.get(p.id), FALSE)); 
                  }else{
                       productsWiseOrder.add(new ManagerProducts(p.name ,'0', FALSE));
                  }
                    productsWiseOrder.add(mp);
               }                      
               SalesExecutiveProductAchived.add(new ManagerProductivity(u , productsWiseOrder));    
           }  
    }
    //2nd Executive Wise Report End
    
    //3rd Customer Wise Report Start
    public void customerwisereportselect(){
         
         MAP<Id,Account> AccountListMap;
         
         if(SelectedCustomerCategory.equalsIgnoreCase('All') && SelectedCustomerState.equalsIgnoreCase('All')){
             AccountListMap = new MAP<Id,Account>([SELECT ID, Name, Phone FROM Account WHERE OwnerId =: SelectedExecutive ORDER BY Name]);
         }
         else if((SelectedCustomerCategory.equalsIgnoreCase('All') == TRUE) && (SelectedCustomerState.equalsIgnoreCase('All') == FALSE)){
             AccountListMap = new MAP<Id,Account>([SELECT ID, Name, Phone FROM Account WHERE OwnerId =: SelectedExecutive AND Billing_State__c =: SelectedCustomerState ORDER BY Name]);
         }
         else if((SelectedCustomerCategory.equalsIgnoreCase('All') == FALSE) && (SelectedCustomerState.equalsIgnoreCase('All') == TRUE)){
             AccountListMap = new MAP<Id,Account>([SELECT ID, Name, Phone FROM Account WHERE OwnerId =: SelectedExecutive AND Class__c =: SelectedCustomerCategory ORDER BY Name]); 
         }
         else{
             AccountListMap = new MAP<Id,Account>([SELECT ID, Name, Phone FROM Account WHERE OwnerId =: SelectedExecutive AND Class__c =: SelectedCustomerCategory AND Billing_State__c =: SelectedCustomerState ORDER BY Name]);  
         }
        
        LIST<Account> accountslist = new LIST<Account>();
        accountslist = AccountListMap.values();
        accountslist.sort();
       
        LIST<AggregateResult> AccountglanceSalesOrderGT = [SELECT SUM(Order_Quantity__c), Product__c
                                                           FROM Sales_Order_Line_Items__c
                                                           WHERE (SalesOrder__r.Close_Date__c >=: goa.Start_Date__c 
                                                           AND SalesOrder__r.Close_Date__c <=: goa.End_Date__c) 
                                                           AND SalesOrder__r.Customer__r.Owner.Id =: SelectedExecutive 
                                                           AND SalesOrder__r.Customer__c IN: accountslist
                                                           GROUP BY Product__c];
        system.debug('&&&&&**** '+AccountglanceSalesOrderGT);
        MAP<String , String> userWiseAggResultGT = new  MAP<String , String>();
        
        for(AggregateResult ag: AccountglanceSalesOrderGT ){                           
           String products =  String.valueOf(ag.get('Product__c'));
           String orderVals = String.valueOf(Integer.Valueof(ag.get('expr0')));
           userWiseAggResultGT.put( products , orderVals);
        }
        system.debug('(((()))) '+userWiseAggResultGT);
        
        LIST<AggregateResult> AccountglanceSalesOrder = [SELECT SUM(Order_Quantity__c), Product__c, SalesOrder__r.Customer__c ow
                                                         FROM Sales_Order_Line_Items__c
                                                         WHERE (SalesOrder__r.Close_Date__c >=: goa.Start_Date__c 
                                                         AND SalesOrder__r.Close_Date__c <=: goa.End_Date__c) 
                                                         AND SalesOrder__r.Customer__r.Owner.Id =: SelectedExecutive     
                                                         GROUP BY Product__c, SalesOrder__r.Customer__c];
         
         MAP<ID , MAP<String , String> > AccountProductsAgrregate = new MAP<ID, MAP<String , String> >();
         
            for(Account a: accountslist){
                 MAP<String , String> userWiseAggResult = new  MAP<String , String>();
                             
                 for(AggregateResult ag: AccountglanceSalesOrder ){            
                     if(ag.get('ow') == a.Id){                
                       String prods =  String.valueOf(ag.get('Product__c'));
                       String orderVal = String.valueOf(Integer.Valueof(ag.get('expr0')));
                       userWiseAggResult.put( prods , orderVal);
                     }
                 }
                 AccountProductsAgrregate.put(a.id, userWiseAggResult);
            }
          
            if(selectedproduct == 'All Products'){
                Products = [SELECT  Id, Name, Quantity_in_each_box__c, Product_Price__c, Product_Family__c, Product_Description__c, Product_Code__c 
                               FROM Product__c
                               WHERE Name != Null];
            }
            else{
                Products = [SELECT  Id, Name, Quantity_in_each_box__c, Product_Price__c, Product_Family__c, Product_Description__c, Product_Code__c 
                               FROM Product__c
                               WHERE id =: selectedproduct];
            }

          // For Dummy Account
                              
          AccountProductivityAchived = new LIST<ManagerProductivity>();
          Account dummyAccount = new Account();
     
          LIST<ManagerProducts> productsWiseOrderForDummy = new LIST<ManagerProducts>();
          for(Product__c p: products){            
              productsWiseOrderForDummy.add(new ManagerProducts(p.name , p.Name, TRUE));           
          }    
          AccountProductivityAchived.add(new ManagerProductivity(dummyAccount , productsWiseOrderForDummy));
                  
          // For Grand Total

          Account GTAccount = new Account();
          List<Account> lstAccount = new List<Account>();
          lstAccount  = [SELECT id,Name From Account where Name='Grand Total'];
          if (lstAccount.size() > 0){
              GTAccount = lstAccount.get(0);
          }
          
          LIST<ManagerProducts> productsWiseOrderForGT = new LIST<ManagerProducts>();
          for(Product__c p: products){     
              if(userWiseAggResultGT.containsKey(p.id)){
                  productsWiseOrderForGT.add(new ManagerProducts(p.name ,userWiseAggResultGT.get(p.id) , FALSE));  
              }else{
                  productsWiseOrderForGT.add(new ManagerProducts(p.name , '0', FALSE));
              }                 
          }    
          AccountProductivityAchived.add(new ManagerProductivity(GTAccount , productsWiseOrderForGT));
            
          for(Account ac: accountslist){
                 
               MAP<String, String> AccountProductOrder = new MAP<String, String>();
               AccountProductOrder = AccountProductsAgrregate.get(ac.id);
                 
               LIST<ManagerProducts> productsWiseOrder = new LIST<ManagerProducts>();
                
               for(Product__c p: products){
                  ManagerProducts mp;     
                               
                  if(AccountProductOrder.containsKey(p.id)){
                      productsWiseOrder.add(new ManagerProducts(p.name , AccountProductOrder.get(p.id), FALSE));      
                  }else{
                       productsWiseOrder.add(new ManagerProducts(p.name ,'0', FALSE));
                  }
               }
               AccountProductivityAchived.add(new ManagerProductivity(ac, productsWiseOrder));
           } 
         
       ShowManagerWiseSelect = FALSE;
       ShowExecutiveWiseTable = FALSE;
       ShowCustomerWiseSelect = TRUE;
       ShowNoofVisitsWiseSelect = FALSE;
       ShowProductWiseSelect = FALSE;
       ShowGoalsWiseSelect = FALSE;
    }
    //3rd TAB Customer Wise Report End
    
    
    //4th Tab No. of Visits Report Start
    public void noofvisitsreportselect(){
    
        Dates = new LIST<String>();
        Integer InBetweendays = goa.Start_Date__c.daysBetween(goa.End_Date__c);
    
        if(InBetweendays > 0)
        {  
            date startdate = goa.Start_Date__c; 
            for(Integer i=0; i<= InBetweendays ; i++ )
            {
                Dates.add(String.valueOf(startdate));
                startdate +=1; 
            }     
        }    
        
        SET<ID> UserRolesUnderManager = new SET<ID>();    
        SET<ID> LoggedInUserIds= new SET<ID>();
        User ForUserRoleID = new User();
         
         ForUserRoleID = [SELECT ID,UserRoleId, Name, Email, UserName FROM User WHERE ID =: SelectedManager   AND isActive =: TRUE];
      //  ForUserRoleID = [SELECT ID,UserRoleId, Name, Email, UserName FROM User WHERE ID =: UserInfo.getUserId() AND isActive =: TRUE];
        LoggedInUserIds.add(ForUserRoleID.UserRoleId);
        UserRolesUnderManager.addAll(getAllSubRoleIds(LoggedInUserIds));
       UserRolesUnderManager.add(ForUserRoleID.UserRoleId);
        system.debug('TEST TEST TEST ' + UserRolesUnderManager);
        LIST<User> usersList = [SELECT ID, Name, Email, UserName FROM USER WHERE isActive =: TRUE AND UserRoleID IN: UserRolesUnderManager  ];         
        MAP<ID, String> useridMap = new MAP<ID, String>();
         
        for(User ul : usersList){
          useridMap.put(ul.id, ul.name);      
        } 
        
      /*  if(LoggedInuser.GC_User_Role__c == 'NSM' || LoggedInuser.GC_User_Role__c == 'Manager'){
             usersList.add(ForUserRoleID);
        }  */
        usersList.sort();
        
        LIST<aggregateResult>  userCompletedTasksGT = [SELECT count(id) CountResult,ActivityDate gt 
                                                     FROM TASK 
                                                     WHERE ActivityDate >=: goa.Start_Date__c 
                                                     AND ActivityDate <=: goa.End_Date__c 
                                                     AND OwnerID IN : usersList
                                                     AND Meeting_Type__c = 'Visited the Customer'
                                                     Group By ActivityDate];
        
        MAP<Date, String> dateWiseGrandTotal = new MAP<Date, String>();
        for(AggregateResult ag: userCompletedTasksGT){  
              Date ActivDate =  Date.valueOf(ag.get('gt'));
              String callCount = String.valueOf(ag.get('CountResult'));
              dateWiseGrandTotal.put(ActivDate , callCount );
        }
        
        LIST<aggregateResult> userCompletedTasks = [SELECT count(id) CountResult,ActivityDate gt,ownerID rt 
                                                     FROM TASK 
                                                     WHERE ActivityDate >=: goa.Start_Date__c 
                                                     AND ActivityDate <=: goa.End_Date__c 
                                                     AND OwnerID IN : usersList
                                                     AND Meeting_Type__c ='Visited the Customer'
                                                     Group By ActivityDate, ownerid];

        MAP<ID, MAP<Date, String>> userProductsAgrregate = new MAP<ID, MAP<Date, String>>();
        
        for(User u: usersList){
            MAP<Date , String> userWiseAggResult = new  MAP<Date , String>();
            
            for(AggregateResult ag: userCompletedTasks){
                if(ag.get('rt') == u.Id ){
                    Date ActDate =  Date.valueOf(ag.get('gt'));
                    String callsCount = String.valueOf(ag.get('CountResult'));
                    userWiseAggResult.put(ActDate, callsCount);
                }
            }
            userProductsAgrregate.put(u.id, userWiseAggResult);
        }       
        
        // For Dummy User
                    
        SEDateWiseVisits = new LIST<VisitsInner>();
        User dummyUser = new USER( LastName = 'User Name', FirstName='Test');
        
        LIST<datesWiseVisits> SEActivityHeaders = new LIST<datesWiseVisits>();
        Date startDateDummy = goa.Start_Date__c;
        for(Integer i=0; i <= InBetweendays ; i++ ){
            SEActivityHeaders.add(new datesWiseVisits(startDateDummy, '0', TRUE));
            startDateDummy= startDateDummy.AddDays(1);  
        }      
        SEDateWiseVisits.add(new VisitsInner(dummyUser, SEActivityHeaders));
        
        // For Grand Totals  
        
        User grandTotalUser = new User();
        grandTotalUser = [SELECT Id, Name, Email FROM User WHERE alias='reports'];
        
        Date startDateGT = goa.Start_Date__c;
        LIST<datesWiseVisits> SEActivityHeadersGT = new LIST<datesWiseVisits>();
        for(Integer i=0; i <= InBetweendays ; i++ ){    
            if(dateWiseGrandTotal.ContainsKey(startDateGT)){
                    SEActivityHeadersGT.add(new datesWiseVisits(startDateGT, dateWiseGrandTotal.get(startDateGT), FALSE));
                }
                else{
                    SEActivityHeadersGT.add(new datesWiseVisits(startDateGT, '0', FALSE));
                }
                startDateGT= startDateGT.AddDays(1);  
        }         
        SEDateWiseVisits.add(new VisitsInner(grandTotalUser, SEActivityHeadersGT ));
        
        
        for(User u: usersList){
        
            Date startDate = goa.Start_Date__c;
            LIST<datesWiseVisits> SEActivity = new LIST<datesWiseVisits>();
            
            MAP<Date , String> userWiseAggResult = new  MAP<Date , String>();
            userWiseAggResult = userProductsAgrregate.get(u.id);
            for(Integer i=0; i <= InBetweendays ; i++ ){
                  
                if(userWiseAggResult.ContainsKey(startDate)){
                    SEActivity.add(new datesWiseVisits(startDate, userWiseAggResult.get(startDate), FALSE));
                }else{
                    SEActivity.add(new datesWiseVisits(startDate, '0', FALSE));
                }
                 startDate = startDate.AddDays(1);  
            }          
            SEDateWiseVisits.add(new VisitsInner(u, SEActivity));
        }
        
       ShowManagerWiseSelect = FALSE;
       ShowExecutiveWiseTable = FALSE;
       ShowCustomerWiseSelect = FALSE;
       ShowNoofVisitsWiseSelect = TRUE;
       ShowProductWiseSelect = FALSE; 
       ShowGoalsWiseSelect = FALSE;
    }
    //4th TAB No. of Visits Report End
    
    //5th TAB Goals Vs. Achievements Report Start
    public void goalsreportselect() {
        ShowManagerWiseSelect = FALSE;
        ShowExecutiveWiseTable = FALSE;
        ShowCustomerWiseSelect = FALSE;
        ShowNoofVisitsWiseSelect = FALSE;
        ShowProductWiseSelect = FALSE; 
        ShowGoalsWiseSelect = TRUE;

        
        If(SelectedGoalType == 'Revenue'){
            goaltypebool = TRUE;
        }else{
            goaltypebool = FALSE;
        }
        
        
        SET<ID> UserRolesUnderManager = new SET<ID>();    
        SET<ID> loginUserRollId = new SET<ID>();
        User ForUserRoleID = new User();
        
       
            ForUserRoleID = [SELECT id,UserRoleId, Name, Email, UserName from User where id=: SelectedManager AND isActive =: TRUE];     
            loginUserRollId.add(ForUserRoleID.UserRoleId);   
            
            UserRolesUnderManager.addAll(getAllSubRoleIds(loginUserRollId));
            UserRolesUnderManager.add(ForUserRoleID.UserRoleId);
        
        
        MAP<Id,User> userListMap = new MAP<Id,User>([SELECT ID, Name, Email, UserName FROM USER WHERE isActive =: TRUE AND UserRoleID IN: UserRolesUnderManager]);
        
        LIST<User> usersList = new LIST<User>();
        usersList =  userListMap.values();  
        /*   
        if(LoggedInuser.GC_User_Role__c == 'NSM' || LoggedInuser.GC_User_Role__c == 'Manager'){
         usersList.add(ForUserRoleID);
        }   
        */
        usersList.sort();
        
        LIST<AggregateResult> glanceProductsGoals = [SELECT SUM(Quantity_Goal__c),SUM(Achieved_Quantity_Goal__c),SUM(Revenue_Goal__c),SUM(Achieved_Revenue__c), Product__c
                                                     FROM Goal_Line_Item__c
                                                     WHERE Goal__r.Start_Date__c >=: goa.Start_Date__c 
                                                     AND Goal__r.End_Date__c <=: goa.End_Date__c                                                     
                                                     AND Goal__r.Sales_Executive__c IN: usersList
                                                     GROUP BY Product__c]; 
        
        MAP<String, String> productWiseGrandTotal = new MAP<String, String>();
        
        for(AggregateResult ag: glanceProductsGoals){  
              String productname =  String.valueOf(ag.get('Product__c'));
              String revenuevalue = String.valueOf(Integer.Valueof(ag.get('expr3'))) + ' / ' + String.valueOf(Integer.Valueof(ag.get('expr2')));
              String quantityvalue = String.valueOf(Integer.Valueof(ag.get('expr1'))) + ' / ' + String.valueOf(Integer.Valueof(ag.get('expr0')));
              if(goaltypebool == true){
                  productWiseGrandTotal.put(productname, revenuevalue);
              }else{
                  productWiseGrandTotal.put(productname, quantityvalue);
              }
        }
        
        LIST<AggregateResult> glanceGoals = [SELECT SUM(Quantity_Goal__c),SUM(Achieved_Quantity_Goal__c),SUM(Revenue_Goal__c),SUM(Achieved_Revenue__c), Product__c, Goal__r.Sales_Executive__c gs
                                               FROM Goal_Line_Item__c
                                               WHERE Goal__r.Start_Date__c >=: goa.Start_Date__c 
                                               AND Goal__r.End_Date__c <=: goa.End_Date__c 
                                               AND Goal__r.Sales_Executive__c IN: usersList
                                               GROUP BY Product__c, Goal__r.Sales_Executive__c];
        
        MAP<ID , MAP<String , String> > userProductsAgrregate = new MAP<ID, MAP<String , String> >();
        
        for(User u: usersList){
            MAP<String , String> userWiseAggResult = new  MAP<String , String>();
            User salesExecutive = new User();

            for(AggregateResult ag: glanceGoals){
                if(ag.get('gs')==u.id){
                    String prods =  String.valueOf(ag.get('Product__c'));
                    String revenuegoal = String.valueOf(Integer.Valueof(ag.get('expr3'))) + ' / ' + String.valueOf(Integer.Valueof(ag.get('expr2')));
                    String quantitygoal = String.valueOf(Integer.Valueof(ag.get('expr1'))) + ' / ' + String.valueOf(Integer.Valueof(ag.get('expr0')));
                    
                    if(goaltypebool == true){
                        userWiseAggResult.put(prods, revenuegoal);
                    }else{
                        userWiseAggResult.put(prods, quantitygoal);    
                    }
                 }
            }
            userProductsAgrregate.put(u.id, userWiseAggResult);
        }

        products = [SELECT ID, NAME, Product_Code__c, Product_Description__c, Product_Family__c, Product_Price__c, Quantity_in_each_box__c 
                    FROM Product__c ORDER BY Order_No__c DESC NULLS LAST];
         
        SalesExecutiveGoalAchived = new LIST<ExecutiveGoalsTotal>();
        
        // For Dummy User
        User dummyUser = new USER( LastName = 'User Name', FirstName='Test');
        
        LIST<ExecutiveGoals> productsWiseOrderForDummy = new LIST<ExecutiveGoals>();
        for(Product__c p: products){           
            productsWiseOrderForDummy.add(new ExecutiveGoals(p.name , p.Name, TRUE));           
        }    
        SalesExecutiveGoalAchived.add(new ExecutiveGoalsTotal(dummyUser , productsWiseOrderForDummy));
        
        // For Grand Totals  
        User grandTotalUser = new User();
        grandTotalUser = [SELECT Id, Name, Email FROM User WHERE alias='reports'];
        LIST<ExecutiveGoals> productsWiseTotalGoals = new LIST<ExecutiveGoals>();
        for(Product__c p: products){       
            ExecutiveGoals eg;            
            Integer prodVal = 0; 
            
            if(productWiseGrandTotal.containsKey(p.id)){
                productsWiseTotalGoals.add(new ExecutiveGoals(p.name, productWiseGrandTotal.get(p.id), FALSE));   
            }
            else{
                productsWiseTotalGoals.add(new ExecutiveGoals(p.name, '0' , FALSE));   
            }
        }    
        SalesExecutiveGoalAchived.add(new ExecutiveGoalsTotal(grandTotalUser , productsWiseTotalGoals));
        
        
        for(User u: usersList){
            MAP<String, String> UserProductOrder = new MAP<String, String>();
            UserProductOrder = userProductsAgrregate.get(u.id);
            
            LIST<ExecutiveGoals> productsWiseOrder = new LIST<ExecutiveGoals>();
            
            for(Product__c p: products){         
                ExecutiveGoals eg;
                
                if(UserProductOrder.containsKey(p.id)){
                    productsWiseOrder.add(new ExecutiveGoals(p.name , UserProductOrder.get(p.id), FALSE)); 
                }else{
                    productsWiseOrder.add(new ExecutiveGoals(p.name ,'0', FALSE));
                }
                productsWiseOrder.add(eg);
            }                      
            SalesExecutiveGoalAchived.add(new ExecutiveGoalsTotal(u , productsWiseOrder));    
        }
    }
    //5th TAB Goals Vs. Achievements Report End
    
    
    public class ManagerProducts {
        public String product{get; set;}
        public String OrderNo{get; set;}
        public Boolean DisplayHeader{get; set;}
       
        public ManagerProducts(String prod, String ord, Boolean d){
            product = prod;
            OrderNo = ord;
            DisplayHeader = d;
        }  
    }
    
    public class ManagerProductivity{ 
        public User UserName{get; set;}
        public Account acc{get; set;}
        public LIST<ManagerProducts> manageInner{get; set;}
        
        public ManagerProductivity(User userN, LIST<ManagerProducts> prosList){
            manageInner = new LIST<ManagerProducts>();  
            manageInner = prosList;
            UserName = userN;
        }
        
        public ManagerProductivity(Account a, LIST<ManagerProducts> prosList){
            manageInner = new LIST<ManagerProducts>();  
            manageInner = prosList;
            acc = a;
        }  
    }
    
    
    public class VisitsInner{
        public User username{get;set;}
        public LIST<datesWiseVisits> userVisits{get;set;}
        public integer visits{get;set;}
        
        public VisitsInner(User uname, LIST<datesWiseVisits> visit ){
            username = uname;
            userVisits = Visit; 
        }
    }
    
    public class datesWiseVisits{    
        public String noOfVisits{get; set;}
        public Date ActivityDate{get; set;}
        public Boolean DisplayHeader{get; set;}
        
        public datesWiseVisits(Date dt, String visit, Boolean b){         
            noOfVisits = visit;
            ActivityDate = dt;       
            DisplayHeader = b;
        } 
    }
    
    public class ExecutiveGoals{  
        public String product{get; set;}
        public String QuantityGoal{get; set;}
        public Boolean DisplayHeader{get; set;}
        
        public ExecutiveGoals(String prod, String qg, Boolean d){
            product = prod;
            QuantityGoal = qg;
            DisplayHeader = d;
        }  
    }
    
    public class ExecutiveGoalsTotal{
        public User UserName{get; set;}
        public LIST<ExecutiveGoals> executiveinner{get; set;}
        
        public ExecutiveGoalsTotal(User userN, LIST<ExecutiveGoals> prosList){
            executiveinner = new LIST<ExecutiveGoals>();
            executiveinner = prosList;
            UserName = userN;
        }
    }
    
    public SET<ID> getAllSubRoleIds(Set<ID> roleIds){
        SET<ID> currentRoleIds = new SET<ID>();
        
        system.debug('2343243' + roleIds);
        for(UserRole userRole :[SELECT Id FROM UserRole WHERE ParentRoleId 
                                IN :roleIds AND ParentRoleID != null])
        currentRoleIds.add(userRole.Id); 
                system.debug('3544364564' + currentRoleIds);
       if(currentRoleIds.size() > 0)
        {
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds)); 
         }  
                         system.debug('457656768' + currentRoleIds);  
        return currentRoleIds;
    }  
   
}