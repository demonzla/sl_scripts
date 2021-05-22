debug(string a)
{
if(llGetObjectDesc()=="debug")
{
llOwnerSay(a);    
}    
}


default
{
    state_entry()
    {
    }
    
    link_message(integer l,integer i,string s,key k)
    {
       if(i==-5)
       {
          integer a;
          debug((string)llGetInventoryNumber(INVENTORY_ANIMATION)+"\n");
          for(a=0;a<llGetInventoryNumber(INVENTORY_ANIMATION);a++){
              llOwnerSay(llGetInventoryName(INVENTORY_ANIMATION,a)+"\n");
              llStopObjectAnimation(llGetInventoryName(INVENTORY_ANIMATION,a));
          } 
        }
        if(i==5)
        {
          list an = llGetObjectAnimationNames();
          debug("+>>> "+llList2CSV(an));
          integer a;
          for(a=0;a<llGetListLength(an);a++){
             llOwnerSay(llList2String(an,a)+"\n");
             llStopObjectAnimation(llList2String(an,a));
          } 
        }
       if(llGetInventoryType(s)!=INVENTORY_ANIMATION){
           //llOwnerSay("NOtFOund: "+s);
           return;}
       if(i==2)
       {
           llStopObjectAnimation(s);
       }
       else if(i==1)
       {
          llStartObjectAnimation(s);
       } 
       else if(i==3)
       {
          llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
        llStartAnimation(s);
       }
       else if(i==4)
       {
          llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
        llStopAnimation(s);
       }
      
    }
    
}
