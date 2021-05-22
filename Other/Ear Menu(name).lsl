list list_one = ["Шепот", "Лизнуть", "Обнять", "Играть", "Погладить", "Дразнить", "Ластиться", "Дернуть", "Комплимент", "Покусывать", "Ласкать", "Укусить"];
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
        owner = llList2String(llParseString2List(llKey2Name(llGetOwner()),[" "], []), 0);
        llListen(chan,"","","");
        llListen(1,"",llGetOwner(),"");
    }

    touch_start(integer total_number)
    {
        if(lock == FALSE){
        llDialog(llDetectedKey(0),"Что ты хочешь сделать с его ушком?",list_one,chan);
        } else {
            llInstantMessage(llDetectedKey(0),"мурр >.>");
        }
    }
    
    listen(integer c, string n, key i, string m)
    {
        if(m == "lock" && c != chan)
        {
            lock = TRUE;
            llOwnerSay("Заблокированно");
        }
        if(m == "unlock" && c != chan)
        {
            lock = FALSE;
            llOwnerSay("Разблокированно");
        }
        n=llList2String(llParseString2List(n,[" "], []), 0);
        if(m == "Покусывать")
        {
            llSay(0, " "+n + " нежно покусывает ушко " + owner + " =^.^=");
        }
        
        if(m == "Ласкать")
        {
            llSay(0, " "+n + " игриво ласкает ушки " + owner + " =^.^=");
        }
        if(m == "Ластиться")
        {
            llSay(0, " "+n + " нежно ластиться, урчит и поглаживает " + owner + " Муррр...");
        }
        if(m == "Шепот")
        {
            llSay(0," "+n + " нашептывает что-то " + owner + " на ушко...");
        }
        if(m == "Лизнуть")
        {
            llSay(0," "+n + " лижет ушко " + owner + " =^.^=");
        }
        if(m == "Дернуть")
        {
            llSay(0," "+n + " дергает " + owner + " за ухо, не вызвав этим ничего кроме раздражения...");
        }
        if(m == "Играть")
        {
            llSay(0," "+n + " мурлыча как котенок играется с ушками " + owner + " =^.^=");
        }
        if(m == "Обнять")
        {
            llSay(0," "+n + " прижимается обнимая " + owner + ", тихонько мырлычет и ласкает его ушко...Муррр...");
        }
        if(m == "Комплимент")
        {
            llSay(0," "+n + " делает " + owner + " красивый комплимент");
        }
        if(m == "Дразнить")
        {
            llSay(0," "+n + " ласково дразнит ушки " + owner + "... наверно хочет чего-то =^_~=");
        }
        if(m == "Погладить")
        {
            llSay(0," "+n + " ласково поглаживает " + owner + "...");
        }
        if(m == "Укусить")
        {
            llSay(0," "+n + " тихонько кусает " + owner + " за ушко");
        }
    }
}