public class ORG_Constant {

    public static String CONSUMER_KEY{set;get{
        return  ORG_Manager__c.getInstance().Consumer_Key__c;
    }}
    public static String PRIVATE_KEY{set;get{
        return  ORG_Manager__c.getInstance().Private_Key__c;
    }}
    public static String CONSUMER_SECRET{set;get{
        return  ORG_Manager__c.getInstance().Consumer_Secret__c;
    }}
    public static String RETURN_URL{set;get{
        return ORG_Manager__c.getInstance().Callback_URL__c;
    }}
}