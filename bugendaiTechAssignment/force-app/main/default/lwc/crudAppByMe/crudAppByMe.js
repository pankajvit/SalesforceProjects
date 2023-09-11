import { LightningElement, track, wire, api } from 'lwc';
import fetchData from '@salesforce/apex/CrudAppByMeController.fetchData';
import { createRecord } from 'lightning/uiRecordApi';
import { deleteRecord } from 'lightning/uiRecordApi';


import Crud from '@salesforce/schema/Crud__c';
import Name from '@salesforce/schema/Crud__c.Name';
import Gender from '@salesforce/schema/Crud__c.Gender__c';
import Subject from '@salesforce/schema/Crud__c.Subject__c';
import Message from '@salesforce/schema/Crud__c.Message__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CrudAppByMe extends LightningElement {
    name = '';
    gender = '';
    subject = '';
    description = '';
    @track records = [];
    get options() {
        return [
            { label: 'Male', value: 'Male' },
            { label: 'Female', value: 'Female' },
            { label: 'Other', value: 'Other' },
        ];
    }

    handleChange(event) {
        const field = event.target.name;
        if(field == 'name') {
            this.name = event.target.value;
        }else if(field == 'gender'){
            this.gender = event.target.value;
        }else if(field == 'subject'){
            this.subject = event.target.value;
        }else if(field == 'desc'){
            this.description = event.target.value;   
        }
    }

    handleSubmit(event) {
        console.log(this.name + ':' + this.gender + ':' + this.subject + ':' + this.description);

        
        const fields = {};

        fields[Name.fieldApiName] = this.name;
        fields[Gender.fieldApiName] = this.gender;
        fields[Subject.fieldApiName] = this.subject;
        fields[Message.fieldApiName] = this.description;

        const recordInput = { apiName : Crud.objectApiName, fields};

        createRecord(recordInput)
            .then(result => {
                console.log('Record created: ' + result.id);
                this.showToast('Success', 'Record created successfully', 'success');
            })
            .catch(err => {
                console.log('Record error: ' + err);
                this.showToast('Error', 'Record is not created', 'error');
            });
    }

    

    _wiredMyData;
    @wire(fetchData)
    wireAccountData(wireResultMy) { 
        const { data, error } = wireResultMy;
        this._wiredMyData = wireResultMy;  
            if (data) {  
                // console.log(data);
                if (data.length > 0) {
                    this.records = JSON.parse(data);
                    this.records.forEach((record, idx) =>{
                        record.number = idx + 1; // Now each contact object will have a property called "number"
                    });
                    // console.log(this.records);  
                } else if (data.length == 0) {
                    this.records = [];
                }
            } else if (error) {
                this.error = error;
            }
    }
    @api recordId;
    deleteRecord(){
        this.recordId = event.target.dataset.id;
        if (!this.recordId) {
            console.error('No record ID provided.');
            return;
        }

        deleteRecord(this.recordId)
            .then(() => {
                // Record deleted successfully, you can add any additional logic here
                console.log('Record deleted successfully.');
                this.showToast('Success','Record Deleted Successfully.','success');
            })
            .catch(error => {
                console.error('Error deleting record:', error);
                // Handle the error, display a toast message, or perform any other necessary actions
                this.showToast('Error','Record not Deleted.','error');
            });
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }
}