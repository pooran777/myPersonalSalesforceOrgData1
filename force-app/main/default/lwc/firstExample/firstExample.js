import { LightningElement,wire} from 'lwc';
import getAccounts from'@salesforce/apex/DemoLWC.getAccounts';
export default class FirstExample extends LightningElement {
    pankaj;
    @wire(getAccounts,{strAccountName :'$pankaj'})accounts //@wire(methodName,{parameterName:'$valuOfParamater'})anyVariableName 
    handle (event){
        this.pankaj = event.target.value;
    }
}