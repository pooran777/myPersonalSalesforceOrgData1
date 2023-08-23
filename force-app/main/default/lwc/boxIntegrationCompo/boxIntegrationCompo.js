import { LightningElement, wire } from 'lwc';
import BoxAuthUri from '@salesforce/apex/BoxIntegration.BoxAuthUri';
import getAccessToken from '@salesforce/apex/BoxIntegration.getAccessToken';
import ListFiles from '@salesforce/apex/BoxIntegration.ListFiles';
import checkUser from '@salesforce/apex/BoxIntegration.checkUser';
import deleteItems from '@salesforce/apex/BoxIntegration.deleteItems';

export default class BoxIntegrationCompo extends LightningElement {
    error='';
    data;
    isExist;
    isFolder;

    breadcrumbData = [{id: '0', label: 'Home', name: 'Home'}];
    
    Authorization() {
        console.log('enter on button click');
        BoxAuthUri()
        .then(result =>{
            console.log('enter');
            window.location.href = result;
        })
        .catch(error =>{
            this.error = error;
        })
    }
    connectedCallback() {
        var url = window.location.search;
        var urlParams = new URLSearchParams(url);
        var authcode = urlParams.get('code');
        console.log('code??',authcode);     

        checkUser()
            .then(result=>{
                this.isExist = result;
                console.log('this.authanticationCode111===',authcode);
                console.log('isExist==',this.isExist);
                if(this.isExist == false && authcode == null){
                    console.log('isExist false condition1   ---->if');
                    this.Authorization();
                }
                else if(this.isExist == false && authcode != null){
                    console.log('isExist false condition2   --->else if');
                    getAccessToken({code:authcode})
                    .then(result =>{
                        console.log('enter access');
                         var accessToken = result;
                        console.log('result==',result);
        
                        if(accessToken != null || accessToken != undefined){
                            console.log('enter in accessToken if');                   
                            ListFiles({parentID : ''})
                                .then(result1 =>{
                                    console.log('enter for data');
                                    console.log('result1===',result1);
                                    result1.forEach(ele =>{
                                        if(ele.type == 'folder'){
                                            ele.isFolder = true;
                                            this.isFolder = true;
                                        }else{
                                            ele.isFolder = false;
                                            this.isFolder = false;
                                        }
                                    })
                                    console.log('result1  ele==',result1);
                                    this.data = result1;
                                })
                                .catch(error =>{
                                    console.log(error);
                                })
                        }
                    })
                    .catch(error =>{
                        console.log(error);
                    })
                }
               else{
                    console.log('isExist true condition ---->else');
                    ListFiles({parentID : ''})
                        .then(result1 =>{
                            console.log('enter for data');
                            console.log('result1===',result1);
                            result1.forEach(ele =>{
                                if(ele.type == 'folder'){
                                    ele.isFolder = true;
                                    this.isFolder = true;
                                }else{
                                    ele.isFolder = false;
                                    this.isFolder = false;
                                }
                            })
                            console.log('result1  ele==',result1);
                            this.data = result1;
                        })
                        .catch(error =>{
                            console.log(error);
                        })
                }
            })
            .catch(error =>{
                console.log('error===',error);
            })
       
    }

    handleNavigateTo(event){
        var folderId = event.target.dataset.id;
        //var folderName = event.target.name;
        //console.log('folderName==',folderName);
        console.log('folderId??',folderId);
        var count = 0;
        //var parentId = '0';
        
        console.log('this.breadcrumbData.length111111111===',this.breadcrumbData.length);
        for (let index = 0; index < this.breadcrumbData.length; index++) {   
            count++;
            if(folderId === this.breadcrumbData[index].id){
                console.log('enter in second if');
                //parentId = this.breadcrumbData[index].id;
                break;
            } 
        }   
        console.log('count==',count);
        this.breadcrumbData.splice(count);
        console.log('this.breadcrumbData.length222222222===',this.breadcrumbData.length);
        console.log('count==',count);
        //console.log('parentId===',parentId);
        ListFiles({parentID : folderId})
            .then(result =>{
                console.log('result???',result);   
                result.forEach(ele => {
                    if(ele.type == 'folder'){
                        ele.isFolder = true;
                    }
                    else{
                        ele.isFolder = false;
                    }    
                });
                console.log('result==',result);
                this.data = result;
            }) 
            .catch(error=>{
                console.log('error==',error);
            })
    }
    
    openFile(event){
        var fileId = event.currentTarget.dataset.id;
        console.log('fileId===',fileId);
        window.open("https://app.box.com/file/" + fileId);
    }

    openFolder(event){
        var folderId = event.currentTarget.dataset.id;
        var folderName = event.target.dataset.name;
        console.log('folderId===',folderId);
        ListFiles({parentID : folderId})
            .then(result =>{
                console.log('enter for data');
                console.log('result1===',result);
                result.forEach(ele =>{
                    if(ele.type == 'folder'){
                        ele.isFolder = true;
                        this.isFolder = true;
                    }else
                        ele.isFolder = false;
                        this.isFolder = false;
                })
                console.log('result1  ele==',result);
                this.data = result;
                this.breadcrumbData.push({id:folderId, label:folderName ,name:folderName});
            })
            .catch(error =>{
                console.log(error);
            })
    }
    onClickDelete(event){
        console.log('onClickDelete method');
        var folderId = event.currentTarget.dataset.id;
        console.log('fieldId===',folderId);

        deleteItems({folder_id : folderId, isFolder : this.isFolder, parentID : null})
            .then(result=>{
                
                result.forEach(ele =>{
                    if(ele.type == 'folder'){
                        ele.isFolder = true;
                        this.isFolder = true;
                    }else
                        ele.isFolder = false;
                        this.isFolder = false;
                })
                
                this.data = result;
                console.log('result????',result);
            })
            .catch({
                
            })
        }
}