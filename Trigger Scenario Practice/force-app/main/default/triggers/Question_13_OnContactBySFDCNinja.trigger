// Prevent duplication of Contact records based on Email & Phone
trigger Question_13_OnContactBySFDCNinja on Contact (before insert, before update) {
    Map<String, Contact> emailMap = new Map<String, Contact>();
    Map<String, Contact> phoneMap = new Map<String, Contact>();

    if(trigger.isBefore && trigger.isInsert){
        if(!trigger.new.isEmpty()){
            for(Contact con : trigger.new){
                emailMap.put(con.Email, con);
                phoneMap.put(con.Phone, con);
            }
        }
    }

    if(trigger.isBefore && trigger.isUpdate){
        if(!trigger.new.isEmpty()){
            for(Contact con : trigger.new){
                if(trigger.oldMap.get(con.Id).Email != con.Email){
                    emailMap.put(con.Email, con);
                }
                if(trigger.oldMap.get(con.Id).Phone != con.Phone){
                    phoneMap.put(con.Phone, con);        
                }
            }
        }
    }

    String errorMsg = '';
    List<Contact> existingRecords = [Select Id, Email, Phone from Contact 
                                        Where Email IN :emailMap.keySet()
                                        OR Phone IN :phoneMap.keySet()];
    
    if(!existingRecords.isEmpty()){
        for(Contact conObj : existingRecords){
            if(conObj.Email != null){
                if(emailMap.get(conObj.Email) != null){
                    errorMsg = 'Email';
                }
            }
            if(conObj.Phone != null){
                if(phoneMap.get(conObj.Phone) != null){
                    errorMsg = errorMsg + (errorMsg != '' ? ' and Phone' : 'Phone');
                }
            }
        }
    }

    if(!trigger.new.isEmpty()){
        for(Contact objCon : trigger.new){
            if(errorMsg != ''){
                objCon.addError('Your Contact ' + errorMsg + ' already exists in system');
            }
        }
    }

}