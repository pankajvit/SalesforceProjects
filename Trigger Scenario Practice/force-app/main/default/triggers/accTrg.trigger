trigger accTrg on Account (after insert) {
    trgHandlerClass.trgMethod(Trigger.new);
}