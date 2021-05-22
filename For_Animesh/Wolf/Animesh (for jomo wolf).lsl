integer on=0;
string anim = "fresh_hovering";
string dance = "steet";
//string mouth = "Mouth8";
//string eyel = "LidL2";
//string eyer = "LidR2";
//string anLH = "D9351-Human Beat";
string anRH = "shou01";
string mouth = "zuikai02";
string tail = "weiba01";
string yiffM ="ride1b";
string yiffF = "ride1a";
string cock = "BentoCock_Rot_khard_1";
string cockh = "BentoCock_Rot_khard_";
integer ch = 30;
list yifflT = [];
integer yiffi=0;
integer line;
vector startpos = <-0.76080, 0.02585, 0.08710>;
list configline;


debug(string a)
{
if(llGetObjectDesc()=="debug")
{
llOwnerSay(a);    
}       
}

init()
{
       /*list an = llGetObjectAnimationNames();
       llOwnerSay(">>> "+llList2CSV(an));
        integer i;
        for(i=0;i<llGetListLength(an);i++){
           llMessageLinked(LINK_SET,2,llList2String(an,i),NULL_KEY);
        }*/
         llMessageLinked(LINK_SET,5,"",NULL_KEY);
         llMessageLinked(LINK_SET,1,anim,NULL_KEY);          
         llMessageLinked(LINK_SET,1,tail,NULL_KEY);          
  //      llStartObjectAnimation(eyel);
  //      llStartObjectAnimation(eyer);
       llMessageLinked(LINK_SET,1,mouth,NULL_KEY);
  //      llStartObjectAnimation(anLH);
        llMessageLinked(LINK_SET,1,anRH,NULL_KEY);
   //     llMessageLinked(LINK_SET,2,"BentoCock_HIDE",NULL_KEY);
        llMessageLinked(LINK_SET,1,cock,NULL_KEY);
    
}

stopanim()
{
    
    
}

default
{
    state_entry()
    {
        llListen(666,"","","");
        init();
    }
    dataserver(key k, string data)
    {
        if(data!=EOF)
        {
            if(data!="")
                    {
                        yifflT+=data;                    
                    }
        line++;
        llGetNotecardLine("config",line);
        }
        else
        {

         debug(">>> "+llList2CSV(yifflT));  
         llOwnerSay(">>> LOADED ");
        }
    }
    listen(integer c,string n,key k,string m)
    {
        if(llGetOwnerKey(k)==llGetOwner())
        {
            if(m=="rconfig")
            {
               line=0;   
               yifflT=[];
               llOwnerSay(">>> START LOAD");
                llGetNotecardLine("config",0);    
            }
            if(m=="d"){
                 llMessageLinked(LINK_SET,2,anim,NULL_KEY);
                 llMessageLinked(LINK_SET,1,dance,NULL_KEY);
                 llMessageLinked(LINK_SET,3,dance,NULL_KEY);
                }
            else if(m=="s"){
                llMessageLinked(LINK_SET,2,dance,NULL_KEY);
                llMessageLinked(LINK_SET,1,anim,NULL_KEY);
                llMessageLinked(LINK_SET,4,dance,NULL_KEY);
                }
            else if(m=="start")
            {
            yiffi=0;
 
            if(llGetSubString(llList2String(yifflT,yiffi),0,1)==" *")
            {debug("!++!"); yiffi++;}
 
            configline=llParseString2List(llList2String(yifflT,yiffi),["|"],[]);
           
            yiffM = llList2String(configline,0);
            yiffF = llList2String(configline,1);
            string yiffpoz = llList2String(configline,2);
            string yiffrot = llList2String(configline,3);
            string hover = llList2String(configline,5);
            llMessageLinked(LINK_SET,2,cockh+(string)ch,NULL_KEY);
            ch=llList2Integer(configline,4);
            llMessageLinked(LINK_SET,1,cockh+(string)ch,NULL_KEY);
            if(yiffrot!="0")
            {
                llSetLocalRot((rotation)yiffrot);    
            }
            else
            {
                  llSetLocalRot(ZERO_ROTATION);        
            }
            llOwnerSay("@adjustheight:"+hover+"=force");
            llSetPos((vector)yiffpoz);    
          /*  if(alph != 0){
                integer ii;
                for(ii=5;ii>=alph;ii--)
                {llSetLinkAlpha(3,0.0,ii);}
                }
                else
                {llSetLinkAlpha(3,1.0,ALL_SIDES);} */
                
                 llMessageLinked(LINK_SET,2,anim,NULL_KEY);
                 llMessageLinked(LINK_SET,1,yiffM,NULL_KEY);
                 llMessageLinked(LINK_SET,3,yiffF,NULL_KEY);
                 llMessageLinked(LINK_SET,2,cock,NULL_KEY);
                 llMessageLinked(LINK_SET,1,cockh+(string)ch,NULL_KEY);

            }
            else if(m=="stop")
            {
                llSetPos(startpos);
                llSetLocalRot(ZERO_ROTATION);
                init();
                llMessageLinked(LINK_SET,4,yiffF,NULL_KEY);
                llOwnerSay("@adjustheight:0=force");
                 yiffi=0;

            }
            else if(m=="+")
            {
            llMessageLinked(LINK_SET,2,cockh+(string)ch,NULL_KEY);
            if(ch<48){ch++;debug((string)ch);};
            llMessageLinked(LINK_SET,1,cockh+(string)ch,NULL_KEY);
            }
            else if(m=="-")
            {
            llMessageLinked(LINK_SET,2,cockh+(string)ch,NULL_KEY);
            if(ch>1){ch--;debug((string)ch);};
            llMessageLinked(LINK_SET,1,cockh+(string)ch,NULL_KEY);
            }
            else if(m=="N")
            {
              llTextBox(llGetOwnerKey(k),"NA ^^",666);      
            }
            else if(llGetSubString(m,0,2)=="NA ")
            {
               
               string data = llGetSubString(m,3,-1);
               debug(">>> "+m+"\n"+data);
               yiffi=(integer)data;
               if(llGetSubString(llList2String(yifflT,yiffi),0,1)==" *")
               {debug("!++!"); yiffi++;}
               if(yiffi<llGetListLength(yifflT))
            {           
           
            configline=llParseString2List(llList2String(yifflT,yiffi),["|"],[]);
           
            yiffM = llList2String(configline,0);
            yiffF = llList2String(configline,1);
            string yiffpoz = llList2String(configline,2);
            string yiffrot = llList2String(configline,3);
            llMessageLinked(LINK_SET,2,cockh+(string)ch,NULL_KEY);
            ch=llList2Integer(configline,4);
            debug(">>> "+(string)ch);
            llMessageLinked(LINK_SET,1,cockh+(string)ch,NULL_KEY);
                if(yiffrot!="0")
                {
                    llSetLocalRot((rotation)yiffrot);    
                }
                else
                {
                      llSetLocalRot(ZERO_ROTATION);        
                }
            llSetPos((vector)yiffpoz);
            }    
            else
            {
            yiffi=0;
           
            configline=llParseString2List(llList2String(yifflT,yiffi),["|"],[]);
           
            yiffM = llList2String(configline,0);
            yiffF = llList2String(configline,1);
            string yiffpoz = llList2String(configline,2);
            string yiffrot = llList2String(configline,3);
            llMessageLinked(LINK_SET,2,cockh+(string)ch,NULL_KEY);
            ch=llList2Integer(configline,4);
            llMessageLinked(LINK_SET,1,cockh+(string)ch,NULL_KEY);
                if(yiffrot!="0")
                {
                    llSetLocalRot((rotation)yiffrot);    
                }
                else
                {
                      llSetLocalRot(ZERO_ROTATION);        
                }
            llSetPos((vector)yiffpoz);    
            }
            debug(">>> "+yiffM);   
            llMessageLinked(LINK_SET,1,yiffM,NULL_KEY);
            llMessageLinked(LINK_SET,3,yiffF,NULL_KEY); 
            }
            else if(m=="S+")
            {
            configline=llParseString2List(llList2String(yifflT,yiffi),["|"],[]);
            //yiffi++;
            do
            {
               yiffi++;
               if(yiffi>llGetListLength(yifflT)){yiffi=0;}
            }
            while(llGetSubString(llList2String(yifflT,yiffi),0,1)!=" *");
            llOwnerSay("SECTION: "+llList2String(yifflT,yiffi));
            /*if(llGetSubString(llList2String(yifflT,yiffi),0,1)==" *")
            {llOwnerSay("!++!"); yiffi++;}*/
            }
            else if(m=="S-")
            {
            configline=llParseString2List(llList2String(yifflT,yiffi),["|"],[]);
          //  yiffi--;
            do
            {yiffi--;
            if(yiffi<0){yiffi=llGetListLength(yifflT);}}
            while(llGetSubString(llList2String(yifflT,yiffi),0,1)!=" *");
            llOwnerSay("SECTION: "+llList2String(yifflT,yiffi));   
            }
            else if(m=="anim+")
            {
            
            debug(">>! "+llList2String(yifflT,yiffi));
            yiffM = llList2String(configline,0);
            yiffF = llList2String(configline,1);
            llMessageLinked(LINK_SET,2,yiffM,NULL_KEY);
            llMessageLinked(LINK_SET,4,yiffF,NULL_KEY);
            
            if(yiffi<llGetListLength(yifflT))
            {
            debug("+++> "+llGetSubString(llList2String(yifflT,yiffi),0,1));
            yiffi+=1;
            if(llGetSubString(llList2String(yifflT,yiffi),0,1)==" *")
            {debug("!++!"); yiffi++;}
            debug(">>!! "+llList2String(yifflT,yiffi));
            configline=llParseString2List(llList2String(yifflT,yiffi),["|"],[]);
            yiffM = llList2String(configline,0);
            yiffF = llList2String(configline,1);
            string hover = llList2String(configline,5);
            string yiffpoz = llList2String(configline,2);
            string yiffrot = llList2String(configline,3);
            llMessageLinked(LINK_SET,2,cockh+(string)ch,NULL_KEY);
            ch=llList2Integer(configline,4);
            debug(">>> "+(string)ch);
            llMessageLinked(LINK_SET,1,cockh+(string)ch,NULL_KEY);
            llOwnerSay("@adjustheight:"+hover+"=force");
            if(yiffrot!="0")
            {
                llSetLocalRot((rotation)yiffrot);    
            }
            else
            {
                  llSetLocalRot(ZERO_ROTATION);        
            }
            llSetPos((vector)yiffpoz);
            }    
            else
            {
            yiffi=0;
            configline=llParseString2List(llList2String(yifflT,yiffi),["|"],[]);
            yiffM = llList2String(configline,0);
            yiffF = llList2String(configline,1);
            string yiffpoz = llList2String(configline,2);
            string yiffrot = llList2String(configline,3);
            llMessageLinked(LINK_SET,2,cockh+(string)ch,NULL_KEY);
            ch=llList2Integer(configline,4);
            llMessageLinked(LINK_SET,1,cockh+(string)ch,NULL_KEY);
            if(yiffrot!="0")
            {
                llSetLocalRot((rotation)yiffrot);    
            }
            else
            {
                  llSetLocalRot(ZERO_ROTATION);        
            }
            llSetPos((vector)yiffpoz);    
            }
            debug(">>> "+yiffM);
         /*   integer alph = llList2Integer(yiffalpha,yiffi);
            if(alph != 0){
                integer ii;
                for(ii=5;ii>=alph;ii--)
                {llSetLinkAlpha(3,0.0,ii);}
                }
                else
                {llSetLinkAlpha(3,1.0,ALL_SIDES);} */
            llMessageLinked(LINK_SET,1,yiffM,NULL_KEY);
            llMessageLinked(LINK_SET,3,yiffF,NULL_KEY); 
            }
         //    llDialog(k,"Anim",["start","stop","rconfig","+","-","anim+","N"],666);
        }    
        
    }
    touch_start(integer tnum)
    {
        llOwnerSay((string)llGetLocalPos()+" | "+(string)llGetLocalRot());
    }
/*        on=1-on;
        if(llDetectedKey(0)==llGetOwner())
        {
    llDialog(llDetectedKey(0),"Anim",["start","stop","rconfig","+","-","anim+","N"],666);
    }
    }
    moving_start()
    {    
       llStopObjectAnimation("stay 4");
       llStartObjectAnimation("walk");              
    }
    moving_end()
    {    
        llStopObjectAnimation("walk");          
        llStartObjectAnimation("stay 4");
    }
*/

/*    attach(key i)
    {
        if(i)
        {llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
          llStartAnimation("^reverse3m");}
          else
          {
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
          llStopAnimation("^reverse3m");            
            }
        
    }*/

}
