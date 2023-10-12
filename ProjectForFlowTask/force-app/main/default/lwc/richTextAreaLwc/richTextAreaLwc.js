import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationBackEvent, 
            FlowNavigationNextEvent, FlowNavigationPauseEvent, 
            FlowNavigationFinishEvent 
        } from 'lightning/flowSupport';

export default class RichTextAreaLwc extends LightningElement {
    @api placeholder;
    @api value;
    @api label;
    @api required;
    requiredMessage = ' Value is required for this field.';

    handleChange = (event) => {
        event.preventDefault();
        this.value = event.target.value;
    }
    @api validate(){

    }
}