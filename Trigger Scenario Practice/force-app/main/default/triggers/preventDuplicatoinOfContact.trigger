// Asked by Yogesh - Prevent duplication of Contact records based on Email & Name.
trigger preventDuplicatoinOfContact on contact (before insert, before update) {
    Map<String, Contact> mapOfEmail = new Map<String, Contact>();
    Map<String, Contact> mapOfName = new Map<String, Contact>();
    if(trigger.isBefore && Trigger.isInsert){
        for(Contact con : Trigger.new){
            mapOfEmail.put(con.Email, con);
            mapOfName.put(con.Name, con);
        }
    }

    if(trigger.isBefore && Trigger.isUpdate){
        for(Contact con : Trigger.new){
            if(con.Email != Trigger.oldMap.get(con.Id).Email && con.Email != null){
                mapOfEmail.put(con.Email, con);
            }
            if(con.Name != Trigger.oldMap.get(con.Id).Name && con.Name != null){
                mapOfName.put(con.Name, con);
            }
        }
    }

    List<Contact> listContact = [SELECT Id, Name, Email 
                                    FROM Contact 
                                    Where Name IN :mapOfName.keySet() 
                                    OR Email IN :mapOfEmail.keySet()];
    for(Contact con : Trigger.new){
        if(mapOfEmail.containsKey(con.Email)){
            con.addError('your entered contact email is already exist with us');
        }
        if(mapOfName.containsKey(con.Name)){
            con.addError('your entered contact name is already exist with us');
        }
    }
}