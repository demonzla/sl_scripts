integer wait;
key idx;
string on="on";
string owner;

beee()
{
    if ( !wait )
        {
            llSleep(0.5);
            //idx = llDetectedKey(0);
            wait = TRUE;
            owner = llGetDisplayName(llGetOwner());
            string oldname = llGetObjectName();
            llSetObjectName("");
            llSay(0, llGetDisplayName(idx)+" slapped " + owner + " 's butt ");
            llSetObjectName(oldname);
            llPlaySound("419bfa16-5f3c-feb2-e58d-f1fd5bdf2458", 1.0);
            llSetTimerEvent(1.0);
        }
}


default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    state_entry()
    {
        llPassTouches(TRUE);
        
        
        llListen(-10,"","","");     
    }
   
    listen(integer c,string n,key k,string m)
{
   if(llGetOwnerKey(k)==llGetOwner())
   {if(m=="Bee On"){on=="on";llOwnerSay("Bee ON");}else if(m=="Bee Off"){on="off";llOwnerSay("Bee OFF");}}else{
   if(llVecDist(llGetPos(),llList2Vector(llGetObjectDetails(k,[OBJECT_POS]),0))<1.0){if(m=="beee"){idx=k; beee();}}}    
}
    touch_start(integer total_number)
    {   if(on=="on")
        {  idx=llDetectedKey(0);
            beee();}
    }
    
    timer()
    {
        llSetTimerEvent(0.0);

        wait = FALSE;
    }
}