integer CHANNEL = -928571945;
integer cChan = -34525475;
default
{
    state_entry()
    {
        llListen(CHANNEL, "", "", "");
    }
    listen(integer channel, string name, key id, string msg)
    {   // Allow objects from our owner to communicate with us.
        if(llGetOwnerKey(id) != llGetOwner()) return;
        
        if(msg == "verpas_hidden")
        {
            // The cock is being hidden, reveal ourselves!
            // If certain parts of the object break because of this, you'll have to
            // find their link number AND the face, and add in an extra copy of the below
            // line.
            // EX: llSetLinkAlpha(5, 0.0, 1);
            llSetLinkAlpha(LINK_SET, 1.0, ALL_SIDES);
             llWhisper(cChan, "add"); //This is required!
        }
        else if(msg == "verpas_shown")
        {
            llSetLinkAlpha(LINK_SET, 0.0, ALL_SIDES);
             llWhisper(cChan, "remove"); 
        }
    } 
}
