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
        });
        $A.enqueueAction(action);
    }
})