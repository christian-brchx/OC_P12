@RestResource(urlMapping='/Contracts/*')
global  with sharing class ContractManager {
    @HttpPost
    global static ID createContract() {
    RestRequest request = RestContext.request;
        Contract thisContract = new Contract();
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Case sObject
            switch on fieldName {
                when 'StartDate','EndDate' {
                    thisContract.put(fieldName, Date.parse((String)(params.get(fieldName))));
                }
                when else {
                    thisContract.put(fieldName, params.get(fieldName));
                }
            }
        }
        insert thisContract;
        return thisContract.Id;
    } 

    @HttpPatch
    global static ID updateContractFields() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String ContractId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        List<Contract> thisContract = [SELECT Id FROM Contract WHERE Id = :ContractId];
        if (thisContract.size()> 0) {
            // Deserialize the JSON string into name-value pairs
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
            // Iterate through each parameter field and value
            for(String fieldName : params.keySet()) {
                switch on fieldName {
                    when 'StartDate','EndDate' {
                        thisContract[0].put(fieldName, Date.parse((String)(params.get(fieldName))));
                    }
                    when else {
                        thisContract[0].put(fieldName, params.get(fieldName));
                    }
                }
                }
            update thisContract[0];
            return thisContract[0].Id;
        } else {
            response.statusCode = 404;
            return null;
        }
    }    
}