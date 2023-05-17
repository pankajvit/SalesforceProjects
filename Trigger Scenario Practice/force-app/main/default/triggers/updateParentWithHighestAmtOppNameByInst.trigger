trigger updateParentWithHighestAmtOppNameByInst on opportunity (after insert, after update, after delete, after undelete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUndelete){
            UpdParentWithHighestAmtOppNameByInsHdler.trgMethod(Trigger.new, null);
        }else if(Trigger.isUpdate){
            UpdParentWithHighestAmtOppNameByInsHdler.trgMethod(Trigger.new, Trigger.oldMap);
        }else if(Trigger.isDelete){
            UpdParentWithHighestAmtOppNameByInsHdler.trgMethod(Trigger.old, null);
        }
    }  
}