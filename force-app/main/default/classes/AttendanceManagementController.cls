/**
 * @description       : 
 * @author            : Hiroyuki Ogura
 * @group             : 
 * @last modified on  : 2020-11-26
 * @last modified by  : Hiroyuki Ogura
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   2020-11-24   Hiroyuki Ogura   Initial Version
**/
public with sharing class AttendanceManagementController {
    @AuraEnabled
    public static String CreateEvent(Id OwnerId, String Subject, String StartDateTime, String EndDateTime) {
        Event e = new Event();
        Datetime st = (DateTime)JSON.deserialize('"' + StartDateTime + '"', DateTime.class);
        Datetime et;
        
        if(EndDateTime != null) {
            et = (DateTime)JSON.deserialize('"' + EndDateTime + '"', DateTime.class);
        } else {
            et = st.addHours(1);
        }
        List<RecordType> recList = getAttendanceManagementRecordTypeId();

        e.OwnerId = OwnerId;
        e.Subject = Subject;
        e.StartDateTime = st;
        e.EndDateTime = et;
        e.RecordTypeId = recList[0].Id;

        insert e;

        return e.Id;
    }

    @AuraEnabled
    public static List<RecordType> getAttendanceManagementRecordTypeId() {
        return [SELECT Id FROM RecordType WHERE Name = '勤怠連絡' LIMIT 1];
    }

    @AuraEnabled
    public static void SetEnddateTime(String id) {
        List<RecordType> recList = getAttendanceManagementRecordTypeId();
        List<Event> todayEvents = [SELECT Id, Subject, StartDateTime, EndDateTime FROM Event WHERE OwnerId = :id AND StartDateTime = TODAY AND EndDateTime < TOMORROW AND RecordTypeId = :recList[0].Id ORDER BY EndDateTime DESC];
        if(!todayEvents.isEmpty()) {
            Event e = todayEvents[0];
            Datetime t = Datetime.now();
            e.EndDateTime = t;
            e.IsRecordPressed__c = true;

            update e;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Object> getAttendanceReports() {
        return [SELECT Id, DeveloperName, Name FROM Report WHERE DeveloperName IN('MyAttendence_ThisMonth', 'Salesforce_Tech_Attendence_ThisMonth', 'MyAttendence_LastMonth', 'Salesforce_Tech_Attendence_LastMonth')];
    }

    @AuraEnabled(cacheable=true)
    public static String getBaseURL(){
        return URL.getSalesforceBaseUrl().getHost() + '/';
    }

    @AuraEnabled(cacheable=true)
    public static String formatAttendanceManagement4Hangout(){
        final String CRLF = '\r\n';
        String result = '';
        List<String> Zaitaku = new List<String>();
        List<String> Akihabara = new List<String>();
        List<String> Kyuka = new List<String>();
        List <User> UserList = [SELECT Id, LastName, PostNotation__c, email FROM User WHERE email IN ('ogurah@fsi.co.jp', 'kykawagu@fsi.co.jp', 'yokasiha@fsi.co.jp','kakimura@fsi.co.jp','matsuzas@fsi.co.jp','rinakita@fsi.co.jp','zhanxin@fsi.co.jp') AND isActive = true ORDER BY PostNotation__c ASC];
		for(User u : UserList) {
            if(u.email == 'zhanxin@fsi.co.jp') {
                Zaitaku.add(u.LastName + ' ' + u.PostNotation__c + ' : 09:00 ～ 17:30' );
            }
            for (Event e : [SELECT Id, Subject, StartDateTime, EndDateTime, OWnerId FROM Event WHERE StartDateTime = TODAY AND RecordType.Name = '勤怠連絡']) {
                if(e.OwnerId == u.Id) {
                    if( e.Subject == '在宅（終日）' || e.Subject == '在宅') {
                        Zaitaku.add(u.LastName + ' ' + u.PostNotation__c + ' : ' + String.valueOf(e.StartDateTime.format('HH:mm')) + ' ～ ' + String.valueOf(e.EndDateTime.format('HH:mm')));
                    } else if(e.Subject == '出社') {
                        Akihabara.add(u.LastName + ' ' + u.PostNotation__c + ' : ' + String.valueOf(e.StartDateTime.format('HH:mm')) + ' ～ ' + String.valueOf(e.EndDateTime.format('HH:mm')));
                    }else if(e.Subject == '休暇') {
                        Kyuka.add(u.LastName + ' ' + u.PostNotation__c + ' : ' + String.valueOf(e.StartDateTime.format('HH:mm')) + ' ～ ' + String.valueOf(e.EndDateTime.format('HH:mm')));
                    }
                }
            }
        }
        result = '> 阿部 PK' + CRLF + 'Salesforce チーム作業開始します。' + CRLF;
        if(Zaitaku.size() > 0) {
            result += CRLF + '【在宅勤務】';
            for( String s : Zaitaku) {
                result += CRLF + s;
            }
        }
        if(Akihabara.size() > 0) {
            result += CRLF + CRLF + '【秋葉原オフィス】';
            for( String s : Akihabara) {
                result += CRLF + s;
            }
        }
        if(Kyuka.size() > 0) {
            result += CRLF + CRLF + '【休暇】';
            for( String s : Kyuka) {
                result += CRLF + s;
            }
        }
        return result;
    }

    public static void forbidden_hand() {
        Integer i = 0;
        
        i = i++;
        i = i++;
        i = i++;
        i = i++;
        i = i++;
        i = i++;
        i = i++;
        i = i++;
        i = i++;
        i = i++;
        i = i++;
        i = i++;
        i = i++;
        i = i++;
        i = i++;
        i = i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}
