@RestResource(urlMapping='/Contacts/*')
global  with sharing class ContactManager {
    @HttpGet
    global static List<Contact> getContactByEmail() {
        List<Contact> result;
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        if (request.params.containsKey('email')) {
            String email = request.params.get('email');
            result =  [SELECT Id,Email FROM Contact WHERE Email = :email AND Actif__c = true];
        } else {
            response.statusCode = 400;
        }
        return result;
    }

    @HttpPost
    global static ID createContact() {
    RestRequest request = RestContext.request;
        Contact thisContact = new Contact();
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Case sObject
            thisContact.put(fieldName, params.get(fieldName));
        }
        thisContact.Actif__c = true;
        upsert thisContact Contact.fields.Email;
        return thisContact.Id;
    } 

    @HttpPatch
    global static ID updateContactFields() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        try {
            Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId AND Actif__c = true];
            // Deserialize the JSON string into name-value pairs
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
            // Iterate through each parameter field and value
            for(String fieldName : params.keySet()) {
                // Set the field and value on the Case sObject
                thisContact.put(fieldName, params.get(fieldName));
            }
            update thisContact;
            return thisContact.Id;
        } catch (System.QueryException e) {
            response.statusCode = 404;
            return null;
        }
    }    

    @HttpDelete
    global static void deleteContact() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        try {
            Contact thisContact = [SELECT Id, Actif__c FROM Contact WHERE Id = :contactId];
            thisContact.Actif__c = false;
            update thisContact;
        } catch (System.QueryException e) {
            response.statusCode = 404;
        }
    }     

}