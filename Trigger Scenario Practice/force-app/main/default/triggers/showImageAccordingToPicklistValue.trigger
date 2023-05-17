trigger showImageAccordingToPicklistValue on Account (before update) {
    if(trigger.isBefore && trigger.isUpdate){
        for(Account acc : trigger.new){
            if(acc.Industry == 'Biotechnology'){
                acc.Message__c = '<img alt="applicationImage" src="https://picsum.photos/id/237/200/300">';
            }
        }
    }
}