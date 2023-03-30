@isTest
public with sharing class ContractManagerTest {
    @isTest static void testCreateContract() {
        // create an account
        Account acc = TestWSDataFactory.createAccount('Test create Contract');
        RestRequest request = new RestRequest();
        request.requestUri = 'https://yourInstance.my.salesforce.com/services/apexrest/Contracts/';
        String strBlob = '{"Status" : "Draft" , "ContractTerm" : 12 , "StartDate" : "30/03/2023","AccountId" : "' +
                        acc.Id + '"}';
        request.requestbody = Blob.valueof(strBlob);
        RestContext.request = request;
        // Call the method to test
        ID thisContractId = ContractManager.createContract();
        // Verify results
        System.assert(thisContractId != null);
        Contract thisContract = [SELECT Id,ContractTerm FROM Contract WHERE Id=:thisContractId];
        System.assert(thisContract != null,'Un Contract doit avoir été créé');
        System.assertEquals(thisContract.ContractTerm,12,'Durée invalide');
    }
    @isTest static void testupdateContractFields() {
        // create an account
        Account acc = TestWSDataFactory.createAccount('Test create Contract');
        Contract ct = TestWSDataFactory.createContractOnAccount(acc.Id,12);
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Contracts/'+ct.Id;
        request.httpMethod = 'PATCH';
        String strBlob = '{"ContractTerm" : 24}';
        request.requestbody = Blob.valueof(strBlob);
        RestContext.request = request;
        // Call the method to test
        ContractManager.updateContractFields();
        // Verify results
        List<Contract> Contracts = [SELECT Id, ContractTerm FROM Contract WHERE Id=:ct.Id];
        System.assert(Contracts.size() == 1,'Le Contrat doit être présent');
        System.assertEquals(24, Contracts[0].ContractTerm,'La durée du contrat devrait avoir été modifiée');
    }

}