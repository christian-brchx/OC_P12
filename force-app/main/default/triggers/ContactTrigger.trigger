trigger ContactTrigger on Contact (before insert) {
    for (Contact ct : trigger.new) {
        ct.UI_Postgres__c = String.valueOf(datetime.now().getTime());
    }
}