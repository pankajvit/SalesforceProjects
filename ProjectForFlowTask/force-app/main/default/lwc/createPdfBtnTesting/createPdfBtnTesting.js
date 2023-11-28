import { LightningElement } from 'lwc';
import {loadScript} from "lightning/platformResourceLoader";
import JSPDF from '@salesforce/resourceUrl/jspdf';
import getContactsController from "@salesforce/apex/PdfGenerator.getContactsController";

export default class CreatePdfBtnTesting extends LightningElement {
    contactList = [];
	headers = this.createHeaders([
		"Id",
		"FirstName",
		"LastName"
	]);

	renderedCallback() {
		Promise.all([
			loadScript(this, JSPDF)
		]);
	}

	generatePdf(){
		const { jsPDF } = window.jspdf;
		const doc = new jsPDF({
			encryption: {
				userPermissions: ["print", "modify", "copy", "annot-forms"]
				// try changing the user permissions granted
			}
		});

		doc.text("Hi I'm Matt", 20, 20);
		doc.table(30, 30, this.contactList, this.headers, { autosize:true });
		doc.save("dummyContactRecord.pdf");
	}

	generateData(){
		getContactsController().then(result=>{
			this.contactList = result;
			this.generatePdf();
		});
	}

	createHeaders(keys) {
		var result = [];
		for (let i = 0; i < keys.length; i += 1) {
			result.push({
				id: keys[i],
				name: keys[i],
				prompt: keys[i],
				width: 65,
				align: "center",
				padding: 0
			});
		}
		return result;
	}
}