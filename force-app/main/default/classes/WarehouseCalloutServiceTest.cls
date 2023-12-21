@IsTest
private class WarehouseCalloutServiceTest {

    
    static testmethod void myUnitTest() {

        test.starttest();
        Test.setMock(HttpCalloutMock.class,new WarehouseCalloutServiceMock());
        System.enqueueJob(new WarehouseCalloutService());
        test.stoptest();
        Assert.areequal(1,[select COUNT() from Product2]);

    }

}