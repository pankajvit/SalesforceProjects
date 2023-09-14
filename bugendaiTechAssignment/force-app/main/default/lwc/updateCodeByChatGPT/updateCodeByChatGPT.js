import { LightningElement, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
const FIELDS = ['My_Object__c.Name', 'My_Object__c.Field1__c', 'My_Object__c.Field2__c'];
export default class UpdateCodeByChatGPT extends LightningElement {
    @track recordIdToEdit; // Id of the record to edit
    @track recordName = '';
    // Add other fields here

    // Fetch and display records
    @wire(fetchData) records; // Replace with your own Apex method to fetch records

    // Handle changes to the name field
    handleNameChange(event) {
        this.recordName = event.target.value;
    }

    // Handle the "Edit" button click
    editRecord(event) {
        this.recordIdToEdit = event.target.value;
        this.loadRecordData();
    }

    // Load record data for editing
    loadRecordData() {
        getRecord({ recordId: this.recordIdToEdit, fields: FIELDS })
            .then(result => {
                this.recordName = result.fields.Name.value;
                // Load other fields similarly
            })
            .catch(error => {
                console.error(error);
            });
    }

    // Handle the "Update" button click
    updateRecord() {
        const fields = {};
        fields.Id = this.recordIdToEdit;
        fields.Name = this.recordName;
        // Add other fields to update here

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                // Record updated successfully
                this.recordIdToEdit = undefined;
                this.clearForm(); // Clear the form fields
                // Refresh the record list if needed
            })
            .catch(error => {
                console.error(error);
            });
    }

    // Clear the form fields
    clearForm() {
        this.recordName = '';
        // Clear other fields similarly
    }

    // Add methods for deleteRecord and any other functionality as needed

}