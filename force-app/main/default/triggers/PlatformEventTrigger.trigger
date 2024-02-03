trigger PlatformEventTrigger on Platform_Event__e (after insert) {
    PlatformEventHandler.handlePlatformEvent(Trigger.new);
}