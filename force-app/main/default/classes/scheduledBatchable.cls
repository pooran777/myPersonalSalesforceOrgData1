global class scheduledBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      ContactUpdBatch cub = new ContactUpdBatch();
      Database.executeBatch(cub);
       
       //scheduledBatchable sb = new scheduledBatchable();
      //String cron_expr = '0 0 0 ? * * *';      // At 00:00:00am every day
      //String jobId = System.schedule('Contact Job',cron_expr, sb);
   }
}