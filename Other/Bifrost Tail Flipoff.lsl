//start_unprocessed_text
/*#include "libjas.lsl"

#define HAND_LEFT 0
#define HAND_RIGHT 1
#define HAND_TIMEOUT 2
#define STATE_DEFAULT 0
#define STATE_GRAPPLE 1
#define STATE_CLOSED 2
#define STATE_CLENCHED 3
#define STATE_RELAXED 4
#define STATE_BECKON 5
#define STATE_GRAB 6

integer bitfield;
/|/ 1 = used
float Vector2Avatar(vector vec)
{
    vec = vec-llGetPos();
    vector fwd = vec * <0.0, 0.0, -llSin(PI_BY_TWO * 0.5), llCos(PI_BY_TWO * 0.5)>;
    fwd.z = 0.0;
    fwd = llVecNorm(fwd);
    vector left = fwd * <0.0, 0.0, llSin(PI_BY_TWO * 0.5), llCos(PI_BY_TWO * 0.5)>;
    rotation rot = llAxes2Rot(fwd, left, fwd % left);
    vector euler = -llRot2Euler(rot);
    return euler.z;
}

timerEvent(string id, string data){
    if(id == "REUSE"){
        bitfield=bitfield&~1;
    }else if(id == "STAHP"){
        if(llGetPermissions()&PERMISSION_TRIGGER_ANIMATION)llStopAnimation("khantflipoff");
    }
}

default
{
    on_rez(integer mew){
        llResetScript();
    }
    
    attach(key id){
        if(id != NULL_KEY)llResetScript();
    }
    
    state_entry(){
        llSetMemoryLimit(llCeil((float)llGetUsedMemory()*1.5));
        if(llGetAttached()){
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        }
        
        
    }
    
    touch_start(integer total_number)
    {
        if(bitfield&1 || llDetectedKey(0) == llGetOwner() || ~llGetPermissions()&PERMISSION_TRIGGER_ANIMATION)return;
        bitfield = bitfield|1;
        vector pos = llDetectedPos(0);
        llOwnerSay("@setrot:"+(string)Vector2Avatar(pos)+"=force");
        multiTimer(["REUSE","", 10, FALSE]);
        multiTimer(["STAHP","", 3, FALSE]);
        
        string flipoff = llList2Json(JSON_OBJECT, [
            "0", STATE_CLOSED,
            "1", STATE_CLOSED,
            "2", STATE_DEFAULT,
            "3", STATE_CLOSED,
            "4", STATE_CLOSED 
        ]);
        
        llRegionSayTo(llGetOwner(), 0x80085, "BFBF"+llList2Json(JSON_OBJECT, [
            (string)HAND_LEFT, flipoff,
            (string)HAND_RIGHT, flipoff,
            (string)HAND_TIMEOUT, 3
        ]));
        llStartAnimation("khantflipoff");
    }
    timer(){
        multiTimer([]);
    }
}
*/
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Firestorm-Betax64 4.5.1.38838 - Jasdac Stockholm
//mono


list timers;
integer bitfield;




timerEvent(string id, string data){
    if(id == "REUSE"){
        bitfield=bitfield&~1;
    }else if(id == "STAHP"){
        if(llGetPermissions()&PERMISSION_TRIGGER_ANIMATION)llStopAnimation("khantflipoff");
    }
}

multiTimer(list data){
    integer i;
    if(data != []){
        integer pos = llListFindList(llList2ListStrided(llDeleteSubList(timers,0,0), 0, -1, 5), llList2List(data,0,0));
        if(~pos)timers = llDeleteSubList(timers, pos*5, pos*5+4);
        if(llGetListLength(data)==4){
            if(timers==[])llResetTime();
            timers+=[llGetTime()+llList2Float(data,2)]+data;
        }
    }
    for(i=0; i<llGetListLength(timers); i+=5){
        if(llList2Float(timers,i)<=llGetTime()){
            string t = llList2String(timers, i+1);
            string d = llList2String(timers,i+2);
            if(!llList2Integer(timers,i+4))timers = llDeleteSubList(timers, i, i+4);
            else timers = llListReplaceList(timers, [llGetTime()+llList2Float(timers,i+3)], i, i);
            timerEvent(t, d);
            i-=5;
        }
    }
    if(timers == []){llSetTimerEvent(0); return;}
    timers = llListSort(timers, 5, TRUE);
    float t = llList2Float(timers,0)-llGetTime();
    if(t<.01)t=.01;
    llSetTimerEvent(t);
}
float Vector2Avatar(vector vec)
{
    vec = vec-llGetPos();
    vector fwd = vec * <0.0, 0.0, -llSin(PI_BY_TWO * 0.5), llCos(PI_BY_TWO * 0.5)>;
    fwd.z = 0.0;
    fwd = llVecNorm(fwd);
    vector left = fwd * <0.0, 0.0, llSin(PI_BY_TWO * 0.5), llCos(PI_BY_TWO * 0.5)>;
    rotation rot = llAxes2Rot(fwd, left, fwd % left);
    vector euler = -llRot2Euler(rot);
    return euler.z;
}


default
{
    on_rez(integer mew){
        llResetScript();
    }
    
    attach(key id){
        if(id != NULL_KEY)llResetScript();
    }
    
    state_entry(){
        llSetMemoryLimit(llCeil((float)llGetUsedMemory()*1.5));
        if(llGetAttached()){
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        }
        
        
    }
    
    touch_start(integer total_number)
    {
        if(bitfield&1 || llDetectedKey(0) == llGetOwner() || ~llGetPermissions()&PERMISSION_TRIGGER_ANIMATION)return;
        bitfield = bitfield|1;
        vector pos = llDetectedPos(0);
        llOwnerSay("@setrot:"+(string)Vector2Avatar(pos)+"=force");
        multiTimer(["REUSE","", 10, FALSE]);
        multiTimer(["STAHP","", 3, FALSE]);
        
        string flipoff = llList2Json(JSON_OBJECT, [
            "0", 2,
            "1", 2,
            "2", 0,
            "3", 2,
            "4", 2 
        ]);
        
        llRegionSayTo(llGetOwner(), 0x80085, "BFBF"+llList2Json(JSON_OBJECT, [
            (string)0, flipoff,
            (string)1, flipoff,
            (string)2, 3
        ]));
        llStartAnimation("khantflipoff");
    }
    timer(){
        multiTimer([]);
    }
}

