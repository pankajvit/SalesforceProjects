public class ScheduleRemoveDuplicateLeads implements Schedulable {
    public void execute(SchedulableContext context) {
        RemoveDuplicateLeadsBatch batchJob = new RemoveDuplicateLeadsBatch();
        Database.executeBatch(batchJob);
    }
}