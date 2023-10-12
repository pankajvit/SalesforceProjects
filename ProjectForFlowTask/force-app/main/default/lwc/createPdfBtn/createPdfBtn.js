import { LightningElement } from "lwc";
import { loadScript } from "lightning/platformResourceLoader";
import JSPDF from "@salesforce/resourceUrl/jspdf";
import getScopeOfWorkData from "@salesforce/apex/PdfGenerator.getScopeOfWorkData";
import getRelatedTaskToSowData from "@salesforce/apex/PdfGenerator.getRelatedTaskToSowData";

export default class CreatePdfBtn extends LightningElement {
	sowData = {};
	// Define a function to create table headers
    // createHeaders(headerArray) {
    //     return headerArray.map((header) => {
    //         return { name: header, prompt: header, width: 65, align: "center" };
    //     });
    // }
	// added code for making table of Sow Related task starts here
	TaskList = [];
	headers = this.createHeaders([
		"TaskName",
		"TaskEstimatedHours",
		"Description"
	]);

	createHeaders(keys) {
		console.log('Inside createHeader function', + keys);
		let result = [];
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
	// added code for making table of Sow Related task ends here
	renderedCallback() {
		Promise.all([loadScript(this, JSPDF)]);
	}

	generatePdf() {
		console.log("Inside generate PDF function");
		const { jsPDF } = window.jspdf;
        const doc = new jsPDF({
            encryption: {
                userPermissions: ['print', 'modify', 'copy', 'annot-forms'],
            },
        });

        // Add your data to the PDF
        let yPos = 20; // Initial Y position

        // Define the data in the format you mentioned
        const data = [
            `Project Name: ${this.sowData.Name}`,
            `Region: ${this.sowData.Region__r.Name}`,
			`Cloud Used: ${this.sowData.Cloud__r.Name}`,
			`Rate Type: ${this.sowData.Rate__c}`,
			`Rate Per Hour: ${this.sowData.Rate_Per_Hour__c}`,
            `Total Estimation hour: ${this.sowData.Total_Estimation__c}`,
            `Total Estimation Cost: ${this.sowData.totalCostInRange__c}`,
        ];

        data.forEach((line) => {
            doc.text(line, 20, yPos);
            yPos += 10; // Increment Y position
        });

		// added code for making table of Sow Related task starts here
		doc.text("Task List: ", 20, 100);
		doc.table(20, 110, this.TaskList , this.headers, { autosize:true });
		// added code for making table of Sow Related task ends here
		doc.save("projectDetails.pdf");

	}

	generateData() {
		console.log('sow Id:'+this.sowData.Id);
		let recordId;
		getScopeOfWorkData()
			.then((result) => {
				if (result && result.length > 0) {
					this.sowData = result[0];
					recordId = result[0].Id;
					console.log(this.sowData);
					console.log('sow Id'+recordId);
					// commented for checking the code
					//this.generatePdf();
				}
			}).then((data) => {
				getRelatedTaskToSowData({sowId: recordId}).then(result=>{
					console.log('Result:'+result);
					this.TaskList = result;
					console.log('TaskList:'+this.TaskList);
					this.generatePdf();
				});
			})
			.catch((error) => {
				console.error("Error fetching data:", error);
			});
		// added code for making table of Sow Related task starts here
		// getRelatedTaskToSowData({sowId: recordId}).then(result=>{
		// 	console.log('Result:'+result);
		// 	this.TaskList = result;
		// 	console.log(this.TaskList);
		// 	this.generatePdf();
		// });
		// added code for making table of Sow Related task ends here
	}	
}
