import { LightningElement } from 'lwc';

import myResource from '@salesforce/resourceUrl/AuthorizeDotNet';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import payByAuthrizePayment from '@salesforce/apex/PaymentGatewayController.payByAuthrizePayment';
import payByEcheck from '@salesforce/apex/PaymentGatewayController.payByEcheck';

export default class PaymentGatewayControllerr extends LightningElement {
    image = myResource;
    isCreditCardEnable = true;
    isRedirect = false;
    showSpinner = false;
    monthOptions = [
        {
            value: "01",
            label: "January"
        },
        {
            value: "02",
            label: "February"
        },
        {
            value: "03",
            label: "March"
        },
        {
            value: "04",
            label: "April"
        },
        {
            value: "05",
            label: "May"
        },
        {
            value: "06",
            label: "June"
        },
        {
            value: "07",
            label: "July"
        },
        {
            value: "08",
            label: "August"
        },
        {
            value: "09",
            label: "September"
        },
        {
            value: "10",
            label: "October"
        },
        {
            value: "11",
            label: "November"
        },
        {
            value: "12",
            label: "December"
        }];
    yearOptions = [
        {
            value: "2023",
            label: "2023"
        },
        {
            value: "2024",
            label: "2024"
        },
        {
            value: "2025",
            label: "2025"
        },
        {
            value: "2026",
            label: "2026"
        },
        {
            value: "2027",
            label: "2027"
        },
        {
            value: "2028",
            label: "2028"
        },
        {
            value: "2029",
            label: "2029"
        },
        {
            value: "2030",
            label: "2030"
        }];
    cardNumber;
    cvv;
    cardMonth;
    cardYear;
    amount;
    routingNumber;
    accountNumber;
    accountHolderName;

    handleChange(event) {
        if (event.target.name == 'Card Number') {
            this.cardNumber = event.detail.value;
        } else if (event.target.name == 'Expire Month') {
            this.cardMonth = event.detail.value;
        } else if (event.target.name == 'Expire Year') {
            this.cardYear = event.detail.value;
        } else if (event.target.name == 'CVV Number') {
            this.cvv = event.detail.value;
        } else if (event.target.name == 'Amount') {
            this.amount = event.detail.value;
        }
        else if (event.target.name == 'Routing Number') {
            this.routingNumber = event.detail.value;
        }
        else if (event.target.name == 'Account Number') {
            this.accountNumber = event.detail.value;
        }
        else if (event.target.name == 'Name Of Account Holder') {
            this.accountHolderName = event.detail.value;
        }
    }
    handleSpinner() {
        this.showSpinner = !this.showSpinner;
    }

    handlePayment() {
        if (this.cardNumber != undefined && this.cardMonth != undefined && this.cardYear != undefined && this.amount != undefined && this.cvv != undefined && this.cvv != '' && this.cardNumber != '' && this.amount != '') {
            console.log('enter in handlepayment');
            this.handleSpinner();
            this.cardNumber = this.cardNumber.replace(/ /g, "");
            payByAuthrizePayment({
                cardNumber: this.cardNumber, expireMonth: this.cardMonth, expireYear: this.cardYear, amount: '50', cvv: this.cvv
            }).then(result => {
                this.isRedirect = true;
            }).catch(err => {
                this.ShowToast('Error!!', err.body.message, 'error', 'dismissable');
            }).finally(() => {
                this.handleSpinner();
            })
        }
        else {
            alert('Compelte all the field to Palce Order');
        }

    }

    changePage() {
        this.isCreditCardEnable = this.isCreditCardEnable ? false : true;
    }

    handlePaymentByEcheck() {
        if (this.routingNumber != undefined && this.routingNumber != '' && this.accountNumber != undefined && this.accountNumber != '' && this.accountHolderName != undefined && this.accountHolderName != '' && this.amount != undefined && this.amount != '') {
            this.handleSpinner();
            this.routingNumber = this.routingNumber.replace(/ /g, "");
            this.accountNumber = this.accountNumber.replace(/ /g, "");
            payByEcheck({ routingNumber: this.routingNumber, accountNumber: this.accountNumber, accountHolderName: this.accountHolderName, amount: this.amount })
                .then(result => {
                    this.isRedirect = true;
                })
                .catch(err => {
                    this.ShowToast('Error!!', err.body.message, 'error', 'dismissable');
                }).finally(() => {
                    this.handleSpinner();
                })
        }
        else {
            alert('Compelte all the field to Palce Order');
        }
    }

    returnTopaymentPage() {
        this.isRedirect = false;
    }

    ShowToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }
}