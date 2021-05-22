string config = "Config";
integer play=0;
list music=[];
list names=[];
integer lines;
key notecardQueryId;
integer pos = 0;
float vol = 1.0;

startplay()
{
     llLoopSound(llList2String(music,pos),vol);       
}

status()
{if(play==1){llSay(-111,"u>"+(string)(pos+1)+" "+llList2String(names,pos)+"\nPLAY (vol "+(string)llRound(vol*100)+"%)");startplay();}
 if(play==0){llSay(-111,"u>"+(string)(pos+1)+" "+llList2String(names,pos)+"\nPAUSE (vol "+(string)llRound(vol*100)+"%)");llStopSound();}}

default
{
    state_entry()
    {
        llListen(-111,"","","");
        if (llGetInventoryKey(config) == NULL_KEY)
        {
            llOwnerSay( "'"+ config + "' notecard missing");
        return;
        }
        llSay(-111,"u>LOADING LIST");
        notecardQueryId = llGetNotecardLine(config, 0);
    }
    
    changed(integer i)
    { if(i==CHANGED_INVENTORY){
       llResetScript();}
    }
    
    dataserver(key query_id, string data)
    {
        if (query_id == notecardQueryId)
        {            
            if (data == EOF)
            {llOwnerSay("Done reading notecard, read " + (string) lines + " notecard lines.");status();}
            else
            {    ++lines;
               // llOwnerSay( "Line: " + (string) lines + " " + data);
                list parse = llParseString2List(data,["|"],[]);
                music += llList2String(parse,0);
                if(llList2String(parse,1)==""){names+="noname";}else{names+=llList2String(parse,1);};
                notecardQueryId = llGetNotecardLine(config, lines);
            }
        }
    }
    
    listen(integer c, string n, key kk, string m)
    {
    if(llGetOwnerKey(kk)==llGetOwner())
        {
        if(m == "play")
            {
              play=1-play;
              status();
            }
        else if (m == "fwd")
                {
                    if(pos<llGetListLength(music)-1)
                        {
                            pos++;
                            status();
                        }
                    else {pos = 0; status();}
                }   
        else if (m == "pwd")
            {
                if(pos>0)
                    {
                        pos--;
                        status();
                    }
                else {pos = llGetListLength(music)-1; status();}
            }
        else if (m == "status") {status();}
        else if (m == "vol+") {if(vol<1.0){vol+=0.05;llAdjustSoundVolume(vol);status();}}
        else if (m == "vol-") {if(vol>0.0){vol-=0.05;llAdjustSoundVolume(vol);status();}}
        else if (m == "rand") {integer old=pos; do pos=llRound(llFrand(((float)llGetListLength(music)-1)+0.1)); while (old==pos); status();}   
        }
    }
}
