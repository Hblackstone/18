public with sharing class MaintenanceRequestHelper {
    
    public static void createCase (list<Case> caseList) {
        Map<Id,Case> myCases = new Map<Id,Case>([SELECT Id, (SELECT Id,Equipment__c FROM Equipment_Maintenance_Items__r) 
                                                         FROM Case WHERE Id IN :caseList]);
        Map<Id,Decimal> decMap= new Map<Id,Decimal>();
        AggregateResult[] results = [
            SELECT Maintenance_Request__c, 
            MIN(Equipment__r.Maintenance_Cycle__c)cycle 
            FROM Equipment_Maintenance_Item__c 
            WHERE Maintenance_Request__c 
            IN :caseList
            GROUP BY Maintenance_Request__c];
        for(Aggregateresult ar :results){
            decMap.put((Id)ar.get('Maintenance_Request__c'),
             (Decimal)ar.get('cycle'));

        }
        List<Case> newCases = new List<Case>();
        for(Case cs : caseList){
            if(cs.status== 'Closed' && (cs.type=='Repair'||cs.type=='Routine Maintenance')){
                case case1 = new Case();
                case1.ParentId= cs.id;
                case1.Vehicle__c= cs.Vehicle__c;
                case1.type= 'Routine Maintenance';
                case1.subject='new Routine Maintenance created';
                case1.Date_Reported__c= date.today();
                if(decMap.containsKey(cs.Id)){
                    case1.Date_Due__c= Date.today().addDays((Integer)decMap.get(cs.Id));

                }
                newCases.add(case1);            
            }
        }insert newCases;

        List<Equipment_Maintenance_Item__c> clonedEquipments = new List<Equipment_Maintenance_Item__c>();
           for (Case nc : newCases){
            for (Equipment_Maintenance_Item__c wp : myCases.get(nc.ParentId).Equipment_Maintenance_Items__r){
                Equipment_Maintenance_Item__c wpClone = wp.clone();
                wpClone.Maintenance_Request__c = nc.Id;
                clonedEquipments.add(wpClone);
                
                    
                }
            }
            insert clonedEquipments;
        

       
      
    }
}