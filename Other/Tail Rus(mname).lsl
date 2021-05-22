list list_one = ["Играть", "Любоваться", "Ущипнуть", "Тискать", "Обнять", "Остановить", "Схватить", "Укусить"];
string owner;
integer lock = FALSE;
integer chan;
default
{
    on_rez(integer n)
    {
        llResetScript();
    }
    
    attach(key a)
    {
        llResetScript();
    }
    
    state_entry()
    {
        chan = 8000 + (integer)llFrand(8000);
        owner =  llList2String(llParseString2List(llKey2Name(llGetOwner()),[" "], []), 0);
        llListen(chan,"","","");
        llListen(1,"",llGetOwner(),"");
    }

    touch_start(integer total_number)
    {
        if(lock == FALSE){
        llDialog(llDetectedKey(0),"Что вы хотите сделать с его хвостиком?",list_one,chan);
        } else {
            llInstantMessage(llDetectedKey(0),"Мурр >.>");
        }
    }
    
    listen(integer c, string n, key i, string m)
    {
        if(m == "lock" && c != chan)
        {
            lock = TRUE;
            llOwnerSay("Заблокирован");
        }
        if(m == "unlock" && c != chan)
        {
            lock = FALSE;
            llOwnerSay("Разблокирован");
        }
        n=llList2String(llParseString2List(n,[" "], []), 0);
        if(m == "Играть")
        {
            llSay(0, " "+n + " мурлыча как котенок играется с большим, пушистым хвостиком " + owner + " =^.^=");
        }
        
        if(m == "Любоваться")
        {
            llSay(0, " "+n + " смущенно стоит в сторонке и любуется попкой и хвостиком " + owner + ". =^.^=");
        }
        if(m == "Ущипнуть")
        {
            llSay(0, " "+n + " щиплет " + owner + " за попку, и игриво ухмыляется... =^.~=");
        }
        if(m == "Тискать")
        {
            llSay(0," "+n + " обнимает и тискает хвостик " + owner + ", отказываясь его отпускать =^.^= ");
        }
        if(m == "Обнять")
        {
            llSay(0," "+n + " нежно обняв за талию и поцеловав " + owner + " в губы, поглаживает его по спинке... =^.~=");
        }
        if(m == "Остановить")
        {
            llSay(0," "+n + " хватает " + owner + " за хвост и тащит назад со словами: <<Куда это ты собрался!? Это еще не всё!>>");
        }
        if(m == "Схватить")
        {
            llSay(0," "+n + " пытается грубо схватить " + owner + " за хвост, но тот нивкакую не поддается...");
        }
        if(m == "Укусить")
        {
            llSay(0," "+n + " кусает " + owner + " за хвост... <<эЙ!... Ты что?!>>");
        }
        
        
    }
}