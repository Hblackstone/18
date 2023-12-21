public class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {   
    public void execute(QueueableContext ctx) {      
            Http h= new Http();
            HttpRequest req= new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint ('https://th-superbadge-apex.herokuapp.com/equipment');
            HttpResponse res = h.send(req);
    
            If(res.getstatuscode()==200){
                List<Object> results =(List<Object>) JSON.deserializeUntyped(res.getBody())   ;
                system.debug(results);
                List<Product2> proList = new List<Product2>();
                for (object obj: results){
                    map<String,Object> myMap= (Map<String,Object>)obj;
                    Product2 pro = new Product2();
                    pro.Warehouse_SKU__c= (String) myMap.get('_id');
                    pro.name = (string) myMap.get('name');
                    pro.Replacement_Part__c= True;
                    pro.Cost__c=(integer) myMap.get('cost');
                    pro.Current_Inventory__c= (Integer) myMap.get('quantity');
                    pro.Lifespan_Months__c= (Integer) myMap.get('lifespan');
                    pro.Maintenance_Cycle__c= (Integer) myMap.get('maintenanceperiod');
                    prolist.add(pro);
                }upsert prolist Warehouse_SKU__c;
                
   // system.enqueuejob(new WarehouseCalloutService());
            }
            
    }
}