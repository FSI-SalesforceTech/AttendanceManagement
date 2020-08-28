@isTest
public with sharing class TestAttendanceManagementController {
    @isTest static void TestCreateEvent() {
        User u1 = createUser('test1');

        Test.startTest();
        AttendanceManagementController.CreateEvent(u1.Id, '件名', '0900', '1730');
        Test.stopTest();
    }

    @isTest static void TestSetEnddateTime() {
        User u2 = createUser('test2');

        Test.startTest();
        System.runAs(u2) {
            AttendanceManagementController.SetEnddateTime(u2.Id);
        }
        Test.stopTest();
    }

    @isTest static void TestgetBaseURL() {
        Test.startTest();
        AttendanceManagementController.getBaseURL();
        Test.stopTest();
    }

    @isTest static void TestgetAttendanceReports() {
        Test.startTest();
        AttendanceManagementController.getAttendanceReports();
        Test.stopTest();
    }

    public static User createUser(String name){
        Profile profile = getStandardProfile();
        String profileId = profile.id;
    
        User user = new User();
        user.Email = name + 'test@xx.xxx.com';
        user.UserName = name + 'test@xx.xxx.com';
        user.FirstName = name;
        user.LastName = '123';
        user.Alias = user.UserName.split('@')[0].left(8);
        user.ProfileId = profileId;
        //user.UserRoleId = role.Id;
        user.EmailEncodingKey = 'ISO-2022-JP';
        user.LanguageLocaleKey = 'ja';
        user.LocaleSidKey = 'ja_JP';
        user.TimeZoneSidKey = 'Asia/Tokyo';
        insert user;
        user = [select Name, UserName, FirstName, LastName, Alias, UserRoleId, ProfileId, CreatedDate from user where UserName = :user.Username limit 1];
    
        return user;
     }
    
     public static Profile getStandardProfile(){
        Profile[] profiles;
        profiles =  [select Id From Profile where Name = '標準ユーザ' limit 1];
        if (profiles.isEmpty()){
           profiles =  [select Id From Profile where Name = 'Standard User' limit 1];
        }
        return profiles[0];
    }
}
