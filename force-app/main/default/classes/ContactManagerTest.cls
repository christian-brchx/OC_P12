@isTest
public with sharing class ContactManagerTest {
    @isTest static void testGetContactByEmail() {
        Contact ct = TestWSDataFactory.createContact('Test','','contacttest@test.org');
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Contacts/';
        request.httpMethod = 'GET';
        request.params.put('email',ct.Email);
        RestContext.request = request;
        // Call the method to test
        List<Contact> contacts = ContactManager.getContactByEmail();
        // Verify results
        System.assert(contacts.size() == 1,'Un contact doit avoir été trouvé');
        System.assertEquals('contacttest@test.org', contacts[0].Email,'Email invalide');
    }
    @isTest static void testCreateContact() {
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Contacts/';
        request.httpMethod = 'POST';
            request.requestbody = Blob.valueof('{"lastName" : "Test" , "email" : "testcreatecontact@test.org"}');
        RestContext.request = request;
        // Call the method to test
        ID thisContactId = ContactManager.createContact();
        // Verify results
        System.assert(thisContactId != null);
        Contact thisContact = [SELECT Id,Email FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null,'Un contact doit avoir été créé');
        System.assertEquals(thisContact.Email, 'testcreatecontact@test.org','Email invalide');
    }
    @isTest static void testupdateContactFields() {
        Contact ct = TestWSDataFactory.createContact('Test','','contacttest@test.org');
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Contacts/'+ct.Id;
        request.httpMethod = 'PATCH';
        request.requestbody = Blob.valueof('{"firstName" : "Contact"}');
        RestContext.request = request;
        // Call the method to test
        ContactManager.updateContactFields();
        // Verify results
        List<Contact> contacts = [SELECT Id, firstName FROM Contact WHERE Id=:ct.Id];
        System.assert(contacts.size() == 1,'Le contact doit être présent');
        System.assertEquals('Contact', contacts[0].firstName,'Le prénom devrait être modifié');
    }

    @isTest static void testDeleteContact() {
        Contact ct = TestWSDataFactory.createContact('Test','','contacttest@test.org');
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Contacts/'+ct.Id;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        // Call the method to test
        ContactManager.deleteContact();
        // Verify results
        List<Contact> contacts = [SELECT Id, Actif__c FROM Contact WHERE Id=:ct.Id];
        System.assert(contacts.size() == 1,'Le contact doit être présent');
        System.assertEquals(false, contacts[0].Actif__c,'Le contact doit être désactivé');
    }

}