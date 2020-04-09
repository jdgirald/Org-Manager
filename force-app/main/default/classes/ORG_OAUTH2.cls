public class ORG_OAUTH2 {
    
    public PageReference init(){
        String STATE='state';
        String ERROR='error';
        String CODE='code';
         
        PageReference pageref=ApexPages.currentPage();
        Map<String,String> parameters=pageref.getParameters();        
        if(parameters.containsKey(STATE)){
            String[] recordId=parameters.get(STATE).split(' ');
            String cid=ORG_Utill.decript(String.join(recordId,'+'));
            List<Credential__c> crids=[SELECT id,Org_Id__c,Name,Type__c,Authenticated__c,Refresh_Token__c,Domain__c,Active__c FROM Credential__c WHERE id=:cid];            
            if(crids.size()>0){
                String SFcode=parameters.get(CODE);
                //using auth key getting token
                String uri='https://'+crids.get(0).Type__c+'.salesforce.com/services/oauth2/token';
                String grant_type='?grant_type=authorization_code&';
                String codeParam='code='+SFcode+'&';        
                String client_id='client_id='+ORG_Constant.CONSUMER_KEY+'&';
                String client_secret='client_secret='+ORG_Constant.CONSUMER_SECRET+'&';
                String redirect_uri='redirect_uri='+ORG_Constant.RETURN_URL;
                HttpRequest request=new HttpRequest();
                request.setEndpoint(uri+grant_type+codeParam+client_id+client_secret+redirect_uri);
                request.setMethod('POST');
                request.setHeader('Authorization',EncodingUtil.base64Encode(Blob.valueOf(ORG_Constant.CONSUMER_KEY+':'+ORG_Constant.CONSUMER_SECRET)));
                HttpResponse response=new Http().send(request);
                if(response.getStatusCode() ==200){
                    Map<String,Object> responseBody=(Map<String,Object>) JSON.deserializeUntyped(response.getBody());
                    String orgUrl=String.valueOf(responseBody.get('instance_url'));
                    String refresh_token=String.valueOf(responseBody.get('refresh_token'));
                    String identity_url=String.valueOf(responseBody.get('id'));
					String access_token=String.valueOf(responseBody.get('access_token'));                    
                    String organization_id=getUserDetails(identity_url,access_token);
                    crids.get(0).Authenticated__c=true;
                    crids.get(0).Refresh_Token__c=refresh_token;
                    crids.get(0).Domain__c=orgUrl;
                    crids.get(0).Active__c=true;
                    crids.get(0).Org_Id__c=organization_id;
                    
                    update crids;
                    String s='/lightning/r/Credential__c/'+crids.get(0).Id+'/view';
                    PageReference pgRef = new PageReference(s);
                    return pgRef;
                }
            }
        
        }
       
        return new PageReference('/apex/Unauthorized');
    }
    private string getUserDetails(String url,String accessToken){
        HttpRequest request=new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setHeader('Authorization','Bearer '+accessToken);
        HttpResponse response=new Http().send(request);
        Map<String,Object> responseBody=(Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        return (String)responseBody.get('organization_id');
        
    }
}