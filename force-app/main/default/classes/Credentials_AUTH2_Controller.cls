public class Credentials_AUTH2_Controller {
    //Credentials_Auth2 component code start
    @auraEnabled//returns url for oAuth2.0 
    public static String getAUTH2URL(String userName,String loginType,String recordId){
        /*Descriptn: Setp 1. of oAuth2.0 flow 
* returns url that opens new window where user logins in to sf org and then authorize access and then it i redirected to redirect url provided
*/
        //based on login type add customer key and return url 
        string URI = 'https://'+loginType+'.salesforce.com/services/oauth2/authorize';
        String response_type='?response_type=code&';
        String client_id ='client_id=' + ORG_Constant.CONSUMER_KEY + '&';
        String redirect_uri='redirect_uri=' + ORG_Constant.RETURN_URL+'&';
        String login_hint='login_hint=' + userName+'&';
        String prompt='prompt=login&';
        
        String state='state='+ORG_Utill.encript(recordId);
        String url=URI+response_type+client_id+redirect_uri+prompt+login_hint+state;
        return url; 
    }
    
    @auraEnabled
    public static String getOrgUrl(String endpoint,String token){
        try{
        string URI = endpoint+'/services/oauth2/token';
        String response_type='?grant_type=refresh_token&';
        String client_id ='client_id=' + encodingUtil.urlencode(ORG_Constant.CONSUMER_KEY,'UTF-8') + '&';
        String client_secret='client_secret=' + ORG_Constant.CONSUMER_SECRET+'&';
        String refresh_token='refresh_token='+encodingUtil.URLEncode(token,'UTF-8');
        HttpRequest request=new HttpRequest();
        request.setEndpoint(URI+response_type+client_id+client_secret+refresh_token);
        request.setMethod('POST');
        request.setHeader('Authorization',EncodingUtil.base64Encode(Blob.valueOf(ORG_Constant.CONSUMER_KEY+':'+ORG_Constant.CONSUMER_SECRET)));
        HttpResponse response=new Http().send(request);
        if(response.getStatusCode() ==200){
            Map<String,Object> responseBody=(Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            String sessionId=String.valueOf(responseBody.get('access_token'));
            return endpoint+'/secur/frontdoor.jsp?sid='+sessionId;
        }
        return null;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}