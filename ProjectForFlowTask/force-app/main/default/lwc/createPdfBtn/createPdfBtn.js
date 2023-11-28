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


		// Prepare data for the table
		// const tableData = this.TaskList.map(task => [
		// 	task.Task_List__r.Name,
		// 	task.Task_List__r.Estimated_Hour__c,
		// 	task.Description__c
		// ]);

		// doc.table(20, 110, this.tableData , this.headers, { autosize:true });
		// doc.autoTable({
		// 	head: this.headers,
		// 	body: tableData,
		// 	startY: 110,
		// 	tableWidth: 'auto',
		// 	showHead: 'firstPage',
		// 	showFoot: 'lastPage',
		// 	headStyles: {
		// 		fontSize: 12,
		// 		fontStyle: 'bold',
		// 		textColor: [0, 0, 0],
		// 	},
		// 	styles: { fontSize: 10 },
		// 	margin: { top: 10 },
		// });
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
	}
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
		console.log('Result from createHeader function' + result);
		return result;
	}
}
