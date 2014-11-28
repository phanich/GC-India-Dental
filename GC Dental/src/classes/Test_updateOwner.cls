@isTest
public class Test_updateOwner{
static testmethod void testmethod_updateOwner (){

Profile p = [SELECT Id FROM Profile WHERE Name ='National Sales Manager'];

User mu = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = p.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'NSM', 
                           timezonesidkey='Asia/Kolkata', username='gctestm@gmail.com');

insert mu;

Profile mp = [SELECT Id FROM Profile WHERE Name ='Sales Manager'];
        
        User sm = new User(alias = 'gctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = mp.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'Manager', 
                           timezonesidkey='Asia/Kolkata', username='gctestex@gmail.com');
        insert sm;
        
MAP<String, String> Usermap = new MAP<string,string>();
Usermap.put(mu.Lastname,mu.id);


Account acc = new Account();
acc.Name = 'bbbbbb';
acc.Phone__c = '9696969695';
acc.Class__c = 'A';
Usermap.put(acc.Owner.Lastname,acc.Owner.id);
acc.Assign_To__c = mu.id;

acc.OwnerId = acc.Assign_To__c;
insert acc;




}

}