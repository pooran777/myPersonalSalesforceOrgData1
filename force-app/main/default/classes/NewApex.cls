public class NewApex {
    public Integer input1 = 10 ;
    public Integer input2 = 20 ;
    public Integer getinput1(){
        System.debug('GetMethod1');
        return input1;
    }
    public Integer getinput2(){
        System.debug('GetMethod2');
        return 20;
    } 
    public void setinput1(Integer int1){
        System.debug('SetMethod1');
    }
    public void setinput2(Integer int2){
 
        System.debug('SetMethod2');
    }
    public void check(){
        System.debug('CheckMehthod');
    }
}