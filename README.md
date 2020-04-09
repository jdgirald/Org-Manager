# Salesforce App

Org Manager To connect all your salesforce orgs from one place

## Part 1:

Deploy metedata to your org

## Part 2:

Create Connect app in your org

Select following in "selected oauth scope"
```
Access your basic information (id, profile, email, address, phone)
Access and manage your data (api)
Provide access to your data via the Web (web)
Perform requests on your behalf at any time (refresh_token, offline_access)
```

In Callback URL  add following URL
```
https://<your domain>.salesforce.com/apex/ORG_OAUTH2
```

## Part 3:

Open "ORG_Manager" Custom Settings

Enter the following data from connected app 
```
Consumer Secret	
Consumer Key	
Callback URL	
```
Genrate Private Key and enter in the field  Private Key



