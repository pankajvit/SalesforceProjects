@isTest
public with sharing class studentStatusTest {
    @isTest
    public static void studentStatusHandlerTest(){
        List<Student__c> students = new List<Student__c>();
        Student__c student1 = new Student__c(Student_Name__c='ABC', Age__c=28, Experience__c=9);
        students.add(student1);
        Student__c student2 = new Student__c(Student_Name__c='XYZ', Age__c=32, Experience__c=7);
        students.add(student2);

        insert students;

        List<Student__c> studentList = [Select Student_Name__c, Age__c, Experience__c,Status__c  from Student__c];

        System.assertEquals(studentList[0].Status__c, 'Selected', 'Status field is not giving appropriate result');

        System.assertEquals(studentList[1].Status__c, 'Not Selected', 'Status field is not giving appropriate result');
    }
}