trigger OrderEventTrigger on Order_Event__e (after insert) {
    List<Task> taskList = new List<Task>();

    for (Order_Event__e event : Trigger.new) {
        // Check if the order has shipped
        if (event.Has_Shipped__c) {
            Task newTask = new Task();
            newTask.Priority = 'Medium';
            newTask.Subject = 'Follow up on shipped order ' + event.Order_Number__c;
            newTask.OwnerId = event.CreatedById;
            taskList.add(newTask);
        }
    }

    if (!taskList.isEmpty()) {
        insert taskList;
    }
}