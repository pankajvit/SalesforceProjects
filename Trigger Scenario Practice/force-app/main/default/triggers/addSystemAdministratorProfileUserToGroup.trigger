// Asked by Yogesh - Whenever a new User having profile “System Administrator” is inserted and
//is Active, add the user to the public group “Admins”. Create a public group named Admins.
trigger addSystemAdministratorProfileUserToGroup on User (after insert) {
    Set<Id> userId = new Set<Id>();
    if(Trigger.isAfter && Trigger.isInsert){
        for(User u : Trigger.new){
            userId.add(u.Id);
        }

        List<User> userList = [SELECT Id, Profile.Name FROM User Where Id IN :userId];

        List<GroupMember> GMlist = new List<GroupMember>();
        for(User U : Trigger.New) {
            if(U.isActive && U.Profile.Name == 'System Administrator') {
                GroupMember GM = new GroupMember();
                GM.GroupId = '00G5j000000mFpKEAU';
                GM.UserOrGroupId = U.Id;
                GMList.add(GM);        
            }
        }
        if(!GMList.isEmpty()) {
            insert GMList;
        }
    }
}