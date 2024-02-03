trigger AccountTriggerUntilExeption on Account (before insert, before update) {
    for(Account a : Trigger.new) {
        List<Account> updatedAccounts = new List<Account>();

        for (Integer i = 0; i < 200; i++) {
            Account acc = new Account(Id = a.Id);
            updatedAccounts.add(acc);
        }

        try {
            // Inserting 200 records multiple times in a single transaction
            // will exceed the DML rows limit (10,000)
            insert updatedAccounts;
        } catch (System.LimitException e) {
            a.addError('DML rows limit exceeded');
        }
    }
}