public with sharing class StudentStatus {
    public static void studentStatusHandler(List<Student__c> stuList){
        for(Student__c stu : stuList){
            if(stu.Age__c < 30 && stu.Experience__c > 8){
                stu.Status__c = 'Selected';
            }else {
                stu.Status__c = 'Not Selected';
            }
        }
    }
}