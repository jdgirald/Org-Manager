({
	 handleLoad : function(component, event, helper) {
        let data=event.getParam("recordUi");
        data=JSON.parse(JSON.stringify(data));
        let action=component.get('c.getOrgUrl');
        action.setParams({
            endpoint: data.record.fields.Domain__c.value,
            token: data.record.fields.Refresh_Token__c.value
        });
        action.setCallback(this,function(result){
            let status=result.getState();
            let response=result.getReturnValue();
            if(status=='SUCCESS'){
                var eUrl= $A.get("e.force:navigateToURL");
                eUrl.setParams({
                    "url": response 
                });
                eUrl.fire();
               
            }     
            else if (status === "ERROR") {
                let errors = result.getError();
                component.find('notifLib').showNotice({
                    "variant": "error",
                    "header": 'Add to Remote site settings.',
                    "message": errors[0].message,
               
                });
                
            }
             $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    }
})