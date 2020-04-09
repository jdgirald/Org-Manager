public class ORG_Utill {
    public static String encript(String data){
        Blob encryptedData = Crypto.encryptWithManagedIV('AES256', EncodingUtil.base64Decode(ORG_Constant.PRIVATE_KEY),  Blob.valueOf(data));
        return EncodingUtil.base64Encode(encryptedData);
    }
    public static String decript(String data){
        Blob decryptedData = Crypto.decryptWithManagedIV('AES256',  EncodingUtil.base64Decode(ORG_Constant.PRIVATE_KEY), EncodingUtil.base64Decode(data));
        return decryptedData.toString();
    }

}