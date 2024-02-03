trigger UpdateAccountStatusOnOpportunity on Opportunity (before insert) {
    Set<Id> accountIdsToUpdate = new Set<Id>();
    Map<Id, Integer> closedWonOpportunityCounts = new Map<Id, Integer>();

    // Collect Account Ids and count Closed/Won Opportunities
    for (Opportunity opp : Trigger.new) {
        if (opp.StageName == 'Closed/Won') {
            accountIdsToUpdate.add(opp.AccountId);
            closedWonOpportunityCounts.put(opp.AccountId, 0);
        }
    }

    // Query for Closed/Won Opportunities related to the same Accounts
    List<Opportunity> relatedOpportunities = [SELECT Id, AccountId FROM Opportunity WHERE AccountId IN :accountIdsToUpdate AND StageName = 'Closed/Won'];

    // Count the number of Closed/Won Opportunities for each Account
    for (Opportunity relatedOpp : relatedOpportunities) {
        if (closedWonOpportunityCounts.containsKey(relatedOpp.AccountId)) {
            closedWonOpportunityCounts.put(relatedOpp.AccountId, closedWonOpportunityCounts.get(relatedOpp.AccountId) + 1);
        }
    }

    // Update the Account Status to "Customer" if no other Closed/Won Opportunities exist
    for (Opportunity opp : Trigger.new) {
        if (opp.StageName == 'Closed/Won' && closedWonOpportunityCounts.containsKey(opp.AccountId) && closedWonOpportunityCounts.get(opp.AccountId) == 1) {
            Account accountToUpdate = new Account(Id = opp.AccountId, Type = 'Customer');
            accountIdsToUpdate.remove(opp.AccountId);
            update accountToUpdate;
        }
    }
}