trigger CaseTrigger on Case (after insert) {
    for (Case newCase : Trigger.new) {
        TaskCreator.createTasksForCase(newCase.Id);
    }
}