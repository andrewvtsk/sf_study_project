trigger AccountTriggerInfinite on Account (before insert, before update) {
    for(Account a : Trigger.new) {
        if(a.AnnualRevenue > 50000) {
            a.Type = 'Prospect';
        }
    }
}