import { LightningElement,track,wire, api } from 'lwc';

// custom functions
import fetchData from '@salesforce/apex/CrudAppController.fetchData';
import getDataByFilter from '@salesforce/apex/CrudAppController.getDataByFilter';

// standard function
import { createRecord } from 'lightning/uiRecordApi';
import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// object details
import CRUD_OBJECT from '@salesforce/schema/Crud__c';
import NAME_FIELD from '@salesforce/schema/Crud__c.Name';
import GENDER_FIELD from '@salesforce/schema/Crud__c.Gender__c';
import SUBJECT_FIELD from '@salesforce/schema/Crud__c.Subject__c';
import MESSAGE_FIELD from '@salesforce/schema/Crud__c.Message__c';



export default class CrudApp extends LightningElement {

    @track records = [];
    @track spinnerStatus = false;

    @track time        = "08:00";
    @track greeting    = "Good Evening"; 
    @track today       = "Current Day";  
    @track  data       = [];
    @api recordId; 

    // modal class
    @track isModalOpenAss = false;

    get modalClassAss() {
        return this.isModalOpenAss ? "slds-modal slds-modal_small slds-fade-in-open" : "slds-modal";
    }
    get modalBackdropClassAss() {
        return this.isModalOpenAss ? "slds-backdrop slds-p-around_medium slds-modal_small slds-backdrop_open" : "slds-backdrop";
    }

    connectedCallback(){     
            this.getTime(); 
        setInterval(()=>{
            this.getTime();
        },1000)
    }

    getTime(){
        const date      = new Date();
        const day       = date.getDay();
        const hour      = date.getHours();
        const min       = date.getMinutes(); 
        const second    = date.getUTCSeconds();

        if(day==0){
            this.today = "Sunday";
        }else if(day==1){
            this.today = "Monday";
        }else if(day==2){
            this.today = "Tuesday";
        }else if(day==3){
            this.today = "Wednesday";
        }else if(day==4){
            this.today = "Thursday";
        }else if(day==5){
            this.today = "Friday";
        }else if(day==6){
            this.today = "Saturday";
        }
     

        this.time = `${this.getDoubleDigit(this.getHour(hour))}:${this.getDoubleDigit(min)}:${this.getDoubleDigit(second)} ${this.getMidDay(hour)}`;

        this.setGreeting(hour);
    }

    setGreeting(hour){
        if(hour < 12){
            this.greeting = "Good Morning";
        }else if(hour >= 12 && hour < 17){
            this.greeting = "Good Afternoon";
        }else{
            this.greeting = "Good Evening";
        }
    }

    getHour(hour){
        return hour === 0 ? 12 : hour > 12 ? (hour-12) : hour;
    }

    getMidDay(hour){
        return hour <= 12 ? "AM" : "PM";
    }

    getDoubleDigit(digit){
        return digit < 10 ? "0"+digit : digit;
    }

    name            = "";
    gender          = "select";
    subject         = "";
    description     = "";
    error           = "";
    serachKey       = "";

 
    // fetch all data
    _wiredMyData;
    @wire(fetchData)
    wireAccountData(wireResultMy) { 
        const { data, error } = wireResultMy;
        this._wiredMyData = wireResultMy;  
            if (data) {  
                // console.log(data);
                if (data.length > 0) {
                    this.records = JSON.parse(data);
                    // console.log(this.records);
                    this.spinnerStatus = true;  
                } else if (data.length == 0) {
                    this.records = []; 
                    this.spinnerStatus = true;
                }
            } else if (error) {
                this.error = error;
                this.spinnerStatus = true;
            }
    }

    handleChange(event){
        this.error           = false;
        const field = event.target.name;
        if(field=='name'){
            this.name = event.target.value;
        }else if(field=='gender'){
            this.gender = event.target.value;
        }else if(field=='subject'){
            this.subject = event.target.value;
        }else if(field=='description'){
            this.description = event.target.value;
        }   
    }

    handleSave(){

        if(this.name=="" || this.subject=="" || this.description=="" || this.gender=="select"){
            this.error = true;
            this.toastMessage('Error','Please fill all details, beacuse all the fields are important.','warning');
        }
        if((this.name!="" || this.subject!="" || this.description!="") && this.gender=="select"){
            this.error = true; 
            dispatchEvent(toastEvent);
            this.toastMessage('Error','Please choose gender, beacuse It is an Important.','warning');
        }

        if(this.error == false){
            this.spinnerStatus = false;  
                const fields = {};
                fields[NAME_FIELD.fieldApiName]    = this.name;
                fields[GENDER_FIELD.fieldApiName]  = this.gender;
                fields[SUBJECT_FIELD.fieldApiName] = this.subject;
                fields[MESSAGE_FIELD.fieldApiName] = this.description;

                const recordInput = {apiName : CRUD_OBJECT.objectApiName, fields};
                console.log(JSON.stringify(recordInput));
                createRecord(recordInput)
                .then(details=>{       
                    console.log('success');                           
                    this.toastMessage('Success','Your Record Created, With Title '+this.name+'.','success');                    
                    return refreshApex(this._wiredMyData);
                }).catch(error=>{ 
                    console.log('error');
                    this.toastMessage('Error','Your Record Not Created, Please Try Again '+error,'error');
                }).finally(()=>{
                    console.log('finally');
                    this.spinnerStatus = true;  
                    this.name       ='';
                    this.gender     ='select';
                    this.subject    ='';
                    this.message    ='';
                    return refreshApex(this._wiredMyData);
                });

                console.log('exe ended');
                
        }
    }

    handleCancel(event){
            this.name       ='';
            this.gender     ='select';
            this.subject    ='';
            this.message    ='';
        const toastEvent = new ShowToastEvent({
            title   : 'From reset',
            message : 'Form Reset Successfully',
            variant : 'base'
        });
        this.dispatchEvent(toastEvent);
        
    }

    handleSearch(event){
        this.spinnerStatus = false;  
        this.serachKey = event.target.value;
        //send to method
        
        if(this.serachKey.length>=3){ 
            getDataByFilter({ searchKey: this.serachKey})
            .then(res => { 
                this.records = JSON.parse(res);
                this.spinnerStatus = true; 
                //console.log(this.records); 
            })
            .catch(err=>{
                this.spinnerStatus = true;  
            });
        }else if(this.serachKey.length==0){ 
            this.serachKey = '';
            getDataByFilter({ searchKey: this.serachKey})
            .then(res => { 
                this.records = JSON.parse(res);
                this.spinnerStatus = true;  
            })
            .catch(err=>{
                this.spinnerStatus = true;  
            });
        }else{ 
            this.spinnerStatus = true; 
            return refreshApex(this._wiredMyData);
        }
    }

 


    editRecord(event){
        
        let curId  = event.target.dataset.id;
        alert('Cur Red Id is '+curId);
    }
    
    deleteRecord(event){
        this.spinnerStatus = false;
        let curId  = event.target.dataset.id;
        alert('Cur Red Id is '+curId);
        if(curId!=''){
            deleteRecord(curId)
            .then((data)=>{
                 this.toastMessage('Success','Record Deleted Successfully.','success');
                 return refreshApex(this._wiredMyData);
            })
            .catch((error)=>{
                this.toastMessage('Error','Record not Deleted.','error');
            })
            .finally(()=>{
                this.spinnerStatus = true;
            });
        }else{
            this.toastMessage('Error','Record Not Found.','error');
            this.spinnerStatus = true;
        }
    }


    // modal functions
    showEditModal(event) {
        this.isModalOpenAss = true; 
    }

    closeEditModal() { 
        this.isModalOpenAss = false; 
    }
    
    toastMessage(msgtitle,msgContent,msgType){
        const toastEvent = new ShowToastEvent({
            title: msgtitle,
            message: msgContent,
            variant: msgType
        });
        this.dispatchEvent(toastEvent); 
    }
}