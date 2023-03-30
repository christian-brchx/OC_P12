@isTest
public class TestWSDataFactory {
    public static Contact createContact(String lastName, String firstName, String Email) {
        Contact thisContact = new Contact(
            LastName=lastName,
            FirstName=firstName,
            Email=email,
            Actif__c=true);
        insert thisContact;
        return thisContact;
    }
}