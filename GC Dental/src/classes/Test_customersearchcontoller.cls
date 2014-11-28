@isTest
public class Test_customersearchcontoller{
static testmethod void Testmethod_customersearchcontoller(){

Profile p = [SELECT Id FROM Profile WHERE Name ='National Sales Manager'];

User mu = new User(alias = 'g0ctest', email='gctest@gmail.com',emailencodingkey='UTF-8',
                           profileid = p.Id, lastname='GC Test', languagelocalekey='en_US',
                           localesidkey='en_IN', country='India', GC_User_Role__c = 'NSM', 
                           timezonesidkey='Asia/Kolkata', username='gctestm1@gmail.com');

insert mu;
Account acc = new Account();
acc.Name = 'aaaa';
acc.Phone__c = '9696969696';
acc.Class__c = 'A';
insert acc;

ApexPages.StandardController controller = new ApexPages.StandardController(acc);
customersearchcontoller csc = new customersearchcontoller(controller);
csc.searchByName = 'aaaa';
csc.searchByCity = 'hyderabad';
csc.searchByPhone = '9563';
csc.searchByClinicName = 'sssss';
csc.search();
}
}