@isTest
private class ContactTrigger_Test {
    @isTest static void createContactMustSetTheExternId() {
        Test.startTest();
        Contact ct = TestWSDataFactory.createContact('Test','','contacttest@test.org');
        Test.stopTest();
        List<Contact> contacts = [SELECT Id , UI_Postgres__c FROM Contact WHERE Email = 'contacttest@test.org'];
        // Verify results
        System.assert(contacts.size() == 1,'Un contact doit avoir été trouvé');
        System.assert(contacts[0].UI_Postgres__c != null);
    }
}