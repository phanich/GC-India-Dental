global class TestScheduledApexFromTestMethod implements Schedulable {

// This test runs a scheduled job at midnight Sept. 3rd. 2022

   public static String CRON_EXP = '0 20 7 * *';
  // 0 0 13 * * ?
   //econds Minutes Hours Day_of_month Month Day_of_week optional_year
   
   global void execute(SchedulableContext ctx) {
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                FROM CronTrigger WHERE Id = :ctx.getTriggerId()];

      System.assertEquals(CRON_EXP, ct.CronExpression);
      System.assertEquals(0, ct.TimesTriggered);
      System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));

      Account a = [SELECT Id, Name FROM Account WHERE Name = 
                  'phani' limit 1];
      a.name = 'testScheduledApexFromTestMethodUpdated';
      update a;
      system.debug('IIIIIIIIIIIII '+a.id);
   }   
}