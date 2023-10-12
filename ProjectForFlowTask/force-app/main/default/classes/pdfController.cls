public with sharing class pdfController {
    @AuraEnabled
    public static Attachment generatePDF(Id recordId, string htmlData){
        Pagereference page = Page.renderAsPdf;
        page.getParameters().put('pdfText', htmlData);

        Contact con = new Contact(Id=recordId);
        Attachment objAttachment = new Attachment();
        objAttachment.Name='invoice.pdf';
        objAttachment.ParentId= con.Id;
        objAttachment.Body = page.getContentaspdf();
        objAttachment.IsPrivate = false;
        insert objAttachment;
        return objAttachment;
    }
}