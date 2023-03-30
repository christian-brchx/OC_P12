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

    public static Account createAccount(String name) {
        Account a = new Account(Name=name, Phone = '0000000000');
        insert a;
        return a;
    }

    public static Contract createContractOnAccount(Id accId, Integer ctTerm) {
        Contract ct = new Contract(Status = 'Draft',StartDate = Date.today(),ContractTerm = ctTerm, AccountId = accId);
        insert ct;
        return ct;
    }


}