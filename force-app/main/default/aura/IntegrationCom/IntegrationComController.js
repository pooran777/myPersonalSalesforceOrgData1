({
    doInit : function(component, event, helper) {
        console.log('enter in init method:');
        //Authenticatopn code
        const url = window.location.search;
        const urlParams = new URLSearchParams(url);
        const code = urlParams.get('code')
        console.log('code??',code);
        console.log('909090909090');
        var action = component.get('c.checkUser'); 
        
        console.log('Check');
        action.setCallback(this, function(response){
            var status = response.getState();
            var isExist =  response.getReturnValue();
            console.log('isExist==',isExist);
            if(status === "SUCCESS"){
                if(isExist == false && code == undefined && code == null){
                    console.log('hello from if part');
                    var action  = component.get("c.createAuthURL");
                    action.setCallback(this, function(response){
                        var status = response.getState();
                        if(status === "SUCCESS"){
                            var authUrl = response.getReturnValue();
                            console.log(authUrl);
                            window.location.href = response.getReturnValue();    
                        }
                    });
                    $A.enqueueAction(action);
                }
                else if(isExist == false && code != undefined && code != null){
                    console.log('hello from else if paart');
                    var action = component.get('c.getAccessToken');
                    action.setParams({
                        'code' : code
                    });
                    action.setCallback(this, function(response){
                        var status = response.getState();
                        if(status === "SUCCESS"){
                            var accessToken = response.getReturnValue();
                            component.set('v.accessToken',accessToken);
                            console.log('accessToken ==',accessToken);
                            var action  = component.get("c.ListFiles");
                            action.setParams({
                                'parentID' : ''
                            });
                            action.setCallback(this, function(response){
                                var status = response.getState();
                                if(status === "SUCCESS"){
                                    var data = response.getReturnValue();
                                    console.log('data===',data);
                                    component.set('v.data',data);
                                    component.set('v.currentFolderId', '');
                                    //component.set('v.breadcrumData', [{Id:'root', name:'Home'}]);
                                    component.set('v.showData', true);    
                                }
                            });
                            
                            $A.enqueueAction(action);
                        }
                    });
                    $A.enqueueAction(action);
                }
                    else{
                        var action  = component.get("c.ListFiles");
                        console.log('Hello From Else Part')
                        action.setParams({
                            'parentID' : ''
                            
                        });
                        action.setCallback(this, function(response){
                            var status = response.getState();
                            if(status === "SUCCESS"){
                                var data = response.getReturnValue();
                                console.log('data==',data);
                                component.set('v.data',data);
                                
                                component.set('v.currentFolderId', '');
                                //component.set('v.breadcrumData', [{Id:'root', name:'Home'}]);
                                component.set('v.showData', true);    
                            }
                        });
                        $A.enqueueAction(action);
                    }  
            }
        });
        $A.enqueueAction(action);  
    },
    
    //Root data
    fetchData : function(component, event, helper) {
        console.log('enter in fetchdata');
        var action  = component.get('c.ListFiles');
        console.log('action===',action);
        console.log('middle');
        action.setParams({
            'parentID' : ''
        });
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                console.log('enter innnnnnnnnnnn');
                var data = response.getReturnValue();
                console.log('data===',data);
                
                component.set('v.data', data);
                component.set('v.currentFolderId', '');
            }
        });
        
        $A.enqueueAction(action);
    },
    
    //Inner Folders/Files
    fetchFile : function(component, event, helper){
        
        var action  = component.get("c.ListFiles");
        var fieldId = event.target.getAttribute('aria-label');
        console.log('fieldId==',fieldId);
        
        action.setParams({
            'parentID' : fieldId
        });
        component.set('v.currentFolderId', fieldId);
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var data = response.getReturnValue();
                console.log('data===',data);
                component.set('v.data', data);
                
            }
        });
        
        $A.enqueueAction(action);
    },
    onClickDelete : function(component, event, helper){
        console.log('onClickDelete method');
        var fieldId = event.target.getAttribute('aria-label');
        console.log('fieldId===',fieldId);
        var parentId =  component.get('v.currentFolderId');
        console.log('parentId===',parentId);
        var action  = component.get("c.deleteFile");
        action.setParams({
            'fieldId' : fieldId,
            'parentID' : parentId
        });
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                console.log('==================');
                var data = response.getReturnValue();
                console.log(data);
                component.set('v.data', data);
            }
        });
        $A.enqueueAction(action);
    },
    
    
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    
    //Create Folder
    submitDetails: function(component, event, helper) {
        console.log('enter in submit detail');
        var action  = component.get("c.createFolder");
        var foldername = component.find('folderName').get("v.value");
        //var parentId =  component.get('v.currentFolderId');
        var mimeType = 'application/vnd.google-apps.folder'
        console.log('foldername==',foldername);
        //console.log('parentId===',parentId); 
        action.setParams({
            'parentFolderId' : component.get('v.currentFolderId'),
            'title' : foldername,
            'mimeType' : mimeType
        });
        action.setCallback(this, function(response){
            var status = response.getState();
            console.log('status==',status);
            if(status === "SUCCESS"){
                console.log('enter in if:::');
                var data = response.getReturnValue();
                console.log('data==',data);
                component.set('v.data', data); 
                component.set('v.isModalOpen', false);      
            }
        });
        $A.enqueueAction(action); 
    },
    
    //Upload File
    handleFilesChange : function(component, event, helper) {
        
        var uploadedFiles = event.getParam("files");
        var attachmentId = uploadedFiles[0].documentId;
        console.log('attachmentId===',attachmentId);
        // Get the file name
        uploadedFiles.forEach(file => console.log('fileName=====',file.name));
        var parentId =  component.get('v.currentFolderId');
        console.log('parentId====',parentId);
        var action  = component.get("c.UploadFile");
        console.log('Hello');
        action.setParams({
            "attachmentId": attachmentId,
            "FolderId" : component.get('v.currentFolderId')
        });
        console.log('Hello');
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                console.log('enter in if');
                var responseCode = response.getReturnValue();
                console.log("responseCode===",responseCode);
                if(responseCode == '200')
                    alert('File Uploaded successfully');
                else
                    alert('There was some error');
            }
            $A.enqueueAction(component.get('c.fetchData'));
        });
        
        $A.enqueueAction(action);
    }
    
})