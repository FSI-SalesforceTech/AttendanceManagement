public with sharing class AttendanceManagementController {
    @AuraEnabled
    public static void CreateEvent(Id OwnerId, String Subject, String StartDateTime, String EndDateTime) {
        Event e = new Event();
        Datetime st = (DateTime)JSON.deserialize('"' + StartDateTime + '"', DateTime.class);
        Datetime et = (DateTime)JSON.deserialize('"' + EndDateTime + '"', DateTime.class);
        List<RecordType> recList = getAttendanceManagementRecordTypeId();

        e.OwnerId = OwnerId;
        e.Subject = Subject;
        e.StartDateTime = st;
        e.EndDateTime = et;
        e.RecordTypeId = recList[0].Id;

        insert e;
    }

    @AuraEnabled
    public static List<RecordType> getAttendanceManagementRecordTypeId() {
        return [SELECT Id FROM RecordType WHERE Name = '勤怠連絡' LIMIT 1];
    }

    @AuraEnabled
    public static void SetEnddateTime(String id) {
        List<RecordType> recList = getAttendanceManagementRecordTypeId();
        List<Event> todayEvents = [SELECT Id, Subject, StartDateTime, EndDateTime FROM Event WHERE OwnerId = :id AND StartDateTime = TODAY AND EndDateTime < TOMORROW AND RecordTypeId = :recList[0].Id ORDER BY EndDateTime DESC];
        Event e = todayEvents[0];
        Datetime t = Datetime.now();
        e.EndDateTime = t;

        update e;
    }

    @AuraEnabled(cacheable=true)
    public static List<Object> getAttendanceReports() {
        return [SELECT Id, DeveloperName, Name FROM Report WHERE DeveloperName IN('MyAttendence_ThisMonth', 'Salesforce_Tech_Attendence_ThisMonth', 'MyAttendence_LastMonth', 'Salesforce_Tech_Attendence_LastMonth')];
    }

    @AuraEnabled(cacheable=true)
    public static String getBaseURL(){
        return URL.getSalesforceBaseUrl().getHost() + '/';
    }
}
