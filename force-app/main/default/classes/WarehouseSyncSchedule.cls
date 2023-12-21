public with sharing class WarehouseSyncSchedule implements Schedulable{

    public void execute(SchedulableContext sch) {
        System.enqueueJob(new WarehouseCalloutService());
        
       /* String cron = '0 0 1 * * ?';
        String Jobid =System.schedule('WarehouseSyncScheduleJob', cron , new WarehouseSyncSchedule());
        */


    }
}