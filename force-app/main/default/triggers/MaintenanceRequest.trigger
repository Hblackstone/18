trigger MaintenanceRequest on Case (before update) {
    If(trigger.isUpdate){
        MaintenanceRequestHelper.createCase(trigger.new);

    }

}