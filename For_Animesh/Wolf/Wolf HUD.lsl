default
{
    state_entry()
    {
       
    }

    touch_start(integer total_number)
    {
        if(llGetObjectDesc()=="debug")
       {llOwnerSay(">>> "+llGetLinkName(llDetectedLinkNumber(0)));}
       llSay(666,llGetLinkName(llDetectedLinkNumber(0)));
    }
}
