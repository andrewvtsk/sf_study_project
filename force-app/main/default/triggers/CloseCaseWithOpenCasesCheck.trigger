trigger CloseCaseWithOpenCasesCheck on Case (before insert) {
    Set<Id> accountIdsWithOpenCases = new Set<Id>();
    Map<Id, String> caseSubjects = new Map<Id, String>();

    // Collect Account Ids and Case Subjects for Cases in Closed stage
    for (Case c : Trigger.new) {
        if (c.IsClosed && c.Status == 'Closed') {
            accountIdsWithOpenCases.add(c.AccountId);
            caseSubjects.put(c.AccountId, c.Subject);
        }
    }

    // Query for open Cases related to the same Accounts with the same Subject
    List<Case> openCases = [SELECT Id, Subject FROM Case WHERE AccountId IN :accountIdsWithOpenCases AND Status != 'Closed' AND Subject IN :caseSubjects.values()];

    for (Case openCase : openCases) {
        // Check if there are open Cases with the same Subject
        if (caseSubjects.containsKey(openCase.AccountId) && caseSubjects.get(openCase.AccountId) == openCase.Subject) {
            openCase.addError('Cannot close this case because other open cases with the same subject exist.');
        }
    }
}