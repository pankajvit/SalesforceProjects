// Prevent duplication of Contact records based on Email & Phone.
trigger preventDuplicatoinOfContact on contact (before insert, before update) {
    Map<List<String>,>
    if(trigger.isBefore && Trigger.is)
}