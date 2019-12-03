import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CreateEvent from'@salesforce/apex/AttendanceManagementController.CreateEvent';
import SetEnddateTime from '@salesforce/apex/AttendanceManagementController.SetEnddateTime';
import getAttendanceReports from '@salesforce/apex/AttendanceManagementController.getAttendanceReports';
import getBaseURL from '@salesforce/apex/AttendanceManagementController.getBaseURL';
import Id from '@salesforce/user/Id';

const AM9 = "T09:00:00.000+0900";
const AM10 = "T01:00:00.000Z";
const PM1 = "T13:00:00.000+0900";
const PM5 = "T17:30:00.000+0900";
export default class AttendanceManagement extends LightningElement {
    @track activeSections = ['A'];
    @track isSelected = false;
    @track a = false;
    @track b = false;
    @track c = false;
    @track d = false;
    @track e = false;

    @track thismonth = [];
    @track lastmonth = [];
    baseURL;
    calendarURL;
    subject;
    userId = Id;

    @wire(getBaseURL)
    wiregetBaseURL({error, data}){
        if(data) {
            this.baseURL = JSON.stringify(data).replace(/"/g, '');
            this.calendarURL = 'https://' + this.baseURL + 'lightning/o/Event/home';
        }
    }

    @wire(getAttendanceReports)
    wiregetAttendanceReports({ error, data }) {
        if (data) {
            let consData = JSON.parse(JSON.stringify(data));
            consData.forEach(element => {
                element['url'] = 'https://' + this.baseURL + element.Id;
                if(element.DeveloperName.endsWith('ThisMonth')) {
                    this.thismonth.push(element);
                } else {
                    this.lastmonth.push(element);
                }
            });
        } else if (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'エラー',
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        }
    }

    get options() {
        return [
            { label: '在宅（終日）', value: 'option1' },
            { label: '出社', value: 'option2' },
            { label: '在宅と出社', value: 'option3' },
            { label: '休暇', value: 'option4' },
        ];
    }

    connectedCallback(){
        let date = new Date(); 
        var year = date.getFullYear();
        var month = ('0' + (date.getMonth() + 1)).slice(-2);
        var day = ('0' + date.getDate()).slice(-2);

        this.input1value = `${year}-${month}-${day}` + AM9;
        this.input2value = `${year}-${month}-${day}` + PM5;

        this.input3value = `${year}-${month}-${day}` + AM10;
        this.input10value = `${year}-${month}-${day}` + PM5;

        this.input4value = `${year}-${month}-${day}` + AM9;
        this.input5value = `${year}-${month}-${day}` + PM1;
        this.input6value = `${year}-${month}-${day}` + PM1;
        this.input7value = `${year}-${month}-${day}` + PM5;

        this.input8value = `${year}-${month}-${day}` + AM9;
        this.input9value = `${year}-${month}-${day}` + PM5;
    }

    resetFlag() {
        this.isSelected = false;
        this.a = false;
        this.b = false;
        this.c = false;
        this.d = false;
    }

    handleRadioChange(event) {
        this.resetFlag();
        this.isSelected = true;
        const selectedOption = event.detail.value;
        switch(selectedOption) {
            case 'option1':
                this.a = true;
                this.subject = '在宅（終日）';
                break;
            case 'option2':
                this.b = true;
                this.subject = '出社';
                break;
            case 'option3':
                this.c = true;
                this.subject = '在宅と出社';
                break;
            case 'option4':
                this.d = true;
                this.subject = '休暇';
                break;
            default:
                break;
        }
    }

    registEvent() {
        let subj;
        let start;
        let end;

        if(this.a === true || this.b === true || this.d === true ){
            subj = this.subject;
            if(this.a === true) {
                start = String(this.input1value);
                end = String(this.input2value);
            }else if(this.b === true) {
                start = String(this.input3value);
                end = String(this.input10value);
            }else if(this.d === true) {
                start = String(this.input8value);
                end = String(this.input9value);
            }

            CreateEvent({'OwnerId': this.userId, 'Subject': subj, 'StartDateTime': start, 'EndDateTime': end})
                .then(event => {
                    let msg = '今日も１日頑張りましょう！';
                    if(this.d === true) msg = 'ゆっくり休んでください。';
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: msg,
                            variant: 'success',
                        }),
                    );
                    this.value = [];
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'レコード作成エラー',
                            message: error.body.message,
                            variant: 'error',
                        }),
                    );
            });
        } else if(this.c === true) {
            start = String(this.input4value);
            end = String(this.input5value);
            CreateEvent({'OwnerId': this.userId, 'Subject': '在宅', 'StartDateTime': start, 'EndDateTime': end})
            .then(event => {
                start = String(this.input6value);
                end = String(this.input7value);
                CreateEvent({'OwnerId': this.userId, 'Subject': '出社', 'StartDateTime': start, 'EndDateTime': end})
                    .then(event => {
                        let msg = '今日も１日頑張りましょう！';
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: msg,
                                variant: 'success',
                            }),
                        );
                        this.value = [];
                    })
                    .catch(error => {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'レコード作成エラー',
                                message: error.body.message,
                                variant: 'error',
                            }),
                        );
                    });
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'レコード作成エラー',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
        }
    }

    EndOfBusiness(){
        SetEnddateTime({'id': this.userId})
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'お疲れさまでした！',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'レコード更新エラー',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }

    handleinput1change(event) {
        this.input1value = event.target.value;
    }

    handleinput2change(event) {
        this.input2value = event.target.value;
    }

    handleinput3change(event) {
        this.input3value = event.target.value;
    }

    handleinput4change(event) {
        this.input4value = event.target.value;
    }

    handleinput5change(event) {
        this.input5value = event.target.value;
    }

    handleinput6change(event) {
        this.input6value = event.target.value;
    }

    handleinput7change(event) {
        this.input7value = event.target.value;
    }

    handleinput8change(event) {
        this.input8value = event.target.value;
    }

    handleinput9change(event) {
        this.input9value = event.target.value;
    }

    handleinput10change(event) {
        this.input10value = event.target.value;
    }
}