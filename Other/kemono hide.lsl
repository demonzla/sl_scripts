integer cChan = -34525475;
integer tAttach;

default{
    attach(key id){
        if(id){
            if(tAttach){
                llSetTimerEvent(10);
            }
            else if(!tAttach){
                tAttach = 1;
                llWhisper(cChan, "add");    //This is required!
                llWhisper(cChan, "hide:hipL:hipR");
            }
        }
        else{
            tAttach = 0;
            llWhisper(cChan, "show:hipL:hipR");
            llWhisper(cChan, "remove"); //This is required!
        }
    }
    timer(){
        llWhisper(cChan, "add");
        llSetTimerEvent(0);
    }
} 