({
    handleLoad : function(component, event, helper) {
        let data=event.getParam("recordUi");
        data=JSON.parse(JSON.stringify(data));
        let action=component.get('c.getAUTH2URL')
        action.setParams({
            userName: data.record.fields.Name.value,
            loginType: data.record.fields.Type__c.value,
            recordId:component.get('v.recordId')
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
                $A.get("e.force:closeQuickAction").fire();
            }     
            else{
                component.find('notifLib').showNotice({
                    "variant": "error",
                    "header": "Connected app and Custom settings is not setup.",
                    "message": "Follow the instruction mention here https://github.com/sonicfurqan/Org-Manager fro creation of a connected app and custom setting details",
               
                });
            }
        });
        $A.enqueueAction(action);
    }
})