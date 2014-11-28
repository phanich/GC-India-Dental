@isTest
public class Test_PrimaryOrdergoalscon{
static testmethod void testmethod_PrimaryOrdergoalscon(){

 Profile p = [SELECT Id FROM Profile WHERE Name ='National Sales Manager'];

        User u = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = p.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'NSM', 
                           timezonesidkey='Asia/Kolkata', username='gcteste@gmail.com');
        insert u;

Profile mp = [SELECT Id FROM Profile WHERE Name ='Sales Manager'];
        
        User sm = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = mp.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'Manager', 
                           timezonesidkey='Asia/Kolkata', username='gctestex@gmail.com');
        insert sm;

Dealer__c deal = new Dealer__c();
deal.Name = 'aaa';
deal.Dealer_Code__c = 'ccc';
deal.Phone__c = '9656989563';
insert deal;
               
Primary_Order_Goals_for_manager__c pog= new Primary_Order_Goals_for_manager__c();
pog.Sales_Manager__c = sm.id;
pog.Start_Date__c = date.newInstance(2013, 11, 11);
pog.End_Date__c = date.newInstance(2014, 11, 11);
pog.Target_Revenue1__c = 1000.00;
insert pog;

SYSTEM.DEBUG('@@@@@@@@@@@@@@@@@@' +pog);

Primary_Order_Goals_Line_Items__c pogline= new Primary_Order_Goals_Line_Items__c();
pogline.Name = 'Test primarygoal-{1}';
pogline.Primary_Order_Goals_for_manager__c = pog.id;
pogline.Dealer__c=deal.id;
pogline.Target_Revenue__c = 100000.00;
pogline.Revenue_Generated__c = 50000.00;
insert pogline;

system.runas(u){
ApexPages.StandardController controller = new ApexPages.StandardController(pog);
PrimaryOrdergoalscon pgcon = new PrimaryOrdergoalscon(controller);
pgcon.addMore();
pgcon.deletegoalLine();
pgcon.saveall();
}

}


}