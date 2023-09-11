public class ScheduleUpdateContactTitle implements Schedulable {
    public void execute(SchedulableContext ct) {
        UpdateContactTitleBatch batchJob= new UpdateContactTitleBatch();
        Database.executeBatch(batchJob);
    }
}