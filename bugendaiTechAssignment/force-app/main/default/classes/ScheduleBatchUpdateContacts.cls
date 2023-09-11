public class ScheduleBatchUpdateContacts implements Schedulable {
    public void execute(SchedulableContext sc) {
        // Instantiate the batch class
        UpdateContactsWithoutPhoneNumber batchClass = new UpdateContactsWithoutPhoneNumber();

        // Start the batch job
        Database.executeBatch(batchClass, 200);
    }
}