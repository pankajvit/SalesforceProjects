trigger accountTrg on Account (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        accountTrgHandler.accountTrgHandlerMethod(Trigger.new);
    }
}