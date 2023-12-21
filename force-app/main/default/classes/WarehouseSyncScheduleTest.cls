
@isTest
private class WarehouseSyncScheduleTest {

    @isTest
    static void myUnitTest() {
        // TO DO: implement unit test
        String cron = '0 0 1 * * ?';
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        String jobID=system.schedule('MyJob', cron, new WarehouseSyncSchedule());
        CronTrigger ct = [SELECT TimesTriggered, NextFireTime, cronJobDetail.name FROM CronTrigger WHERE Id = :jobID];
        assert.areEqual('MyJob', ct.cronJobDetail.name);
        assert.areEqual('2023-12-22 01:00:00', string.valueOf(ct.NextFireTime));
    }
}