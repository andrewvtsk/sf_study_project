trigger OpportunityChangeTrigger on OpportunityChangeEvent (after insert) {
    // Create a list to hold tasks
    List<Task> tasks = new List<Task>();

    // Iterate over each change event
    for (OpportunityChangeEvent event : Trigger.new) {
        // Access header directly from the event
        eventbus.ChangeEventHeader header = event.ChangeEventHeader;

        // Check if the change type is 'UPDATE' and opportunity is 'Closed Won'
        if ((header.changeType == 'UPDATE') && (event.IsWon == true)) {
            // Create a task
            Task tk = new Task();
            tk.Subject = 'Follow up on won opportunities: ' + header.recordIds;
            tk.OwnerId = header.commitUser;
            tasks.add(tk);
        }
    }

    // Insert the tasks
    if (!tasks.isEmpty()) {
        insert tasks;
    }
}