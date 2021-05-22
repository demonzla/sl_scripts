integer selectedWeaponIndex = 0;

string WEAPON_TYPE_RAYCAST = "raycast";
string WEAPON_TYPE_CHARGER = "robot charger";
string WEAPON_TYPE_DISCHARGER = "robot discharger";

integer API_CHANNEL = -5;
list weaponList = [];

string LISTEN_STATE = "default";
string TIMER_STATE = "default";

log(string msg) {
    llOwnerSay(msg);
}

integer isBullet(string objectName) {
    return TRUE;
}

initWeaponList() {
    weaponList = llListInsertList([], [WEAPON_TYPE_RAYCAST, WEAPON_TYPE_CHARGER, WEAPON_TYPE_DISCHARGER], 0);
    integer objectInvLen = llGetInventoryNumber(INVENTORY_OBJECT);
    integer i = 0;
    for (i=0; i < objectInvLen; i++) {
        string objectName = llGetInventoryName(INVENTORY_OBJECT, i);
        if (isBullet(objectName)) {
            weaponList = llListInsertList(weaponList, [objectName], 0);
        }
    }
}

string getCurrentWeapon() {
    return llList2String(weaponList, selectedWeaponIndex);
}

settext(string msg) {
    llSetText(msg, <1,1,1>, 1);
}
updateText() {
    settext("Weapon: " + getCurrentWeapon());
}

shootRay(key id, integer level, integer edge) {
    
        if (level & edge & CONTROL_LBUTTON)
        {
            
        }
        
        if (level & edge & CONTROL_ML_LBUTTON)
        {
            vector start = llGetCameraPos();
            
            list results = llCastRay(start+<2.5,0.0,0.0>*llGetCameraRot(), start+<60.0,0.0,0.0>*llGetCameraRot(),[RC_REJECT_TYPES,RC_REJECT_PHYSICAL|RC_REJECT_LAND|RC_REJECT_NONPHYSICAL,RC_DETECT_PHANTOM,FALSE,RC_DATA_FLAGS,RC_GET_ROOT_KEY,RC_MAX_HITS,1]);
            llTriggerSound(llGetInventoryName(INVENTORY_SOUND,0),1.0);
            key target = llList2Key(results,0);
            
            if (llGetAgentSize(target) == ZERO_VECTOR) {
              
            } else {
                llSay(0, llKey2Name(target) + " is pseudo-damaged by the power of raycast!");
                
            }
            
            
        }
}

key CHARGER_TARGET_AVATAR = NULL_KEY;
key CHARGER_TARGET_BATTERY = NULL_KEY;
integer CHARGER_MUST_DISCHARGE = FALSE;
float BATTERY_REQUIRED_ENERGY = 0.0;
integer ACS_GLOBAL_CHANNEL = 360;
integer ACS_SECRET_CHANNEL = -1;
integer ACS_GLOBAL_LISTENER_HANDLE = -1;
integer ACS_SECRET_LISTENER_HANDLE = -1;
integer ACS_ON = FALSE;
shootCharger(key id, integer level, integer edge, integer mustDischarge) {
    CHARGER_MUST_DISCHARGE = mustDischarge;
    if ((level & edge & CONTROL_ML_LBUTTON) && (!ACS_ON)){
        ACS_ON = TRUE;
        vector start = llGetCameraPos();
        list results = llCastRay(start+<2.5,0.0,0.0>*llGetCameraRot(), start+<60.0,0.0,0.0>*llGetCameraRot(),[RC_REJECT_TYPES,RC_REJECT_PHYSICAL|RC_REJECT_LAND,RC_DETECT_PHANTOM,FALSE,RC_MAX_HITS,1]);
        llTriggerSound(llGetInventoryName(INVENTORY_SOUND,0),1.0);
        key target = llGetOwnerKey(llList2Key(results,0));
        
        if (llGetAgentSize(target) != ZERO_VECTOR){
            log("Target avatar: " + llKey2Name(target));
            CHARGER_TARGET_AVATAR = target;
            TIMER_STATE = "chargerStart";
            LISTEN_STATE = "listenForRobots";
            ACS_GLOBAL_LISTENER_HANDLE = llListen(ACS_GLOBAL_CHANNEL, "", NULL_KEY, "");
            llSay(ACS_GLOBAL_CHANNEL, "ACS,interface,CHARGER");
            llSetTimerEvent(50);
        }
    } else if ((~level & edge) & CONTROL_ML_LBUTTON) {
        TIMER_STATE = "chargingRobotComplete";
        llSetTimerEvent(0.1);
    }
}

shootBullet(key id, integer level, integer edge) {
    
        if (level & edge & CONTROL_LBUTTON)
        {
            
        }
        
        if (level & edge & CONTROL_ML_LBUTTON)
        {
            vector start = llGetCameraPos();
            llTriggerSound(llGetInventoryName(INVENTORY_SOUND,0),1.0);
            llRezObject(getCurrentWeapon(), llGetCameraPos() + <2,0,0>*llGetCameraRot(),llRot2Fwd(llGetCameraRot()) * 100, ZERO_ROTATION, 7);
        }
}

shoot(key id, integer level, integer edge) {
    if (getCurrentWeapon() == WEAPON_TYPE_RAYCAST) {
        shootRay(id,level,edge);
    } else if (getCurrentWeapon() == WEAPON_TYPE_CHARGER) {
        shootCharger(id,level,edge,FALSE);
    } else if (getCurrentWeapon() == WEAPON_TYPE_DISCHARGER) {
        shootCharger(id,level,edge,TRUE);
    }      
    else {
        shootBullet(id,level,edge);
    }
}

selectNextWeapon() {
    selectedWeaponIndex++;
    if (selectedWeaponIndex >= llGetListLength(weaponList)) {
        selectedWeaponIndex = 0;
    }
    log("Current weapon is " + getCurrentWeapon());
    updateText(); 
}

onListen(integer ch, string name, key id, string msg) {
    log("qmsg: " + msg);
    if (LISTEN_STATE == "default") {
        if (ch == API_CHANNEL) {
            if ((llGetOwnerKey(id) == llGetOwner()) || (id == llGetOwner()) ) {
                if (msg == "switchWeapon") {
                    selectNextWeapon();
                }
            }
        }
    } else if (LISTEN_STATE == "listenForRobots") {
        if (ch != ACS_GLOBAL_CHANNEL) { return; }
        if (llGetOwnerKey(id) != CHARGER_TARGET_AVATAR) { return; }
        CHARGER_TARGET_BATTERY = id;
        list args = llParseString2List(msg, [",",":"],[]);
        if (llList2String(args,1) == "interface") {
            settext("charging " + llKey2Name(CHARGER_TARGET_AVATAR) + "...");
            llParticleSystem(
            [
            PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_DROP,
            PSYS_SRC_BURST_RADIUS,0,
            PSYS_SRC_ANGLE_BEGIN,0,
            PSYS_SRC_ANGLE_END,0,
            PSYS_SRC_TARGET_KEY, CHARGER_TARGET_BATTERY,
            PSYS_PART_START_COLOR,<0.000000,0.000000,0.000000>,
            PSYS_PART_END_COLOR,<0.373401,0.940720,0.192093>,
            PSYS_PART_START_ALPHA,1,
            PSYS_PART_END_ALPHA,1,
            PSYS_PART_START_GLOW,1,
            PSYS_PART_END_GLOW,1,
            PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
            PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
            PSYS_PART_START_SCALE,<0.100000,0.100000,0.000000>,
            PSYS_PART_END_SCALE,<0.500000,0.500000,0.000000>,
            PSYS_SRC_TEXTURE,"",
            PSYS_SRC_MAX_AGE,0,
            PSYS_PART_MAX_AGE,5,
            PSYS_SRC_BURST_RATE,0.3,
            PSYS_SRC_BURST_PART_COUNT,5,
            PSYS_SRC_ACCEL,<0.000000,0.000000,0.000000>,
            PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
            PSYS_SRC_BURST_SPEED_MIN,0.5,
            PSYS_SRC_BURST_SPEED_MAX,0.5,
            PSYS_PART_FLAGS,
                0 |
                PSYS_PART_EMISSIVE_MASK |
                PSYS_PART_FOLLOW_SRC_MASK |
                PSYS_PART_FOLLOW_VELOCITY_MASK |
                PSYS_PART_INTERP_COLOR_MASK |
                PSYS_PART_INTERP_SCALE_MASK |
                PSYS_PART_TARGET_LINEAR_MASK |
                PSYS_PART_TARGET_POS_MASK
            ]);
            ACS_SECRET_CHANNEL=(integer)llList2String(args,2);        
        
            ACS_SECRET_LISTENER_HANDLE = llListen(ACS_SECRET_CHANNEL, "", NULL_KEY, "");
            LISTEN_STATE = "listenForTargetRobotChargerSummary";
            
            llSay(ACS_SECRET_CHANNEL, "ACS,chargersummary:");
            llSetTimerEvent(5.0);
        }
    } else if (LISTEN_STATE == "listenForTargetRobotChargerSummary") {
        log("msg: " + msg);
        if (ch != ACS_SECRET_CHANNEL) { return; }
        if (llGetOwnerKey(id) != CHARGER_TARGET_AVATAR) { return; }
        
        list args = llParseString2List(msg, [":",","], []);
        if (llList2String(args,1) == "chargersummary") {
            BATTERY_REQUIRED_ENERGY = llList2Float(args, -1); 
            if (CHARGER_MUST_DISCHARGE) {
                BATTERY_REQUIRED_ENERGY = -10000;
            }
            log("required energy: " + (string)BATTERY_REQUIRED_ENERGY);
        } else {
            return;
        }
        
        llSay(ACS_SECRET_CHANNEL, "ACS,charging:1");
        
        TIMER_STATE = "chargingRobot";     
        
        /*integer ticks = 600000;
        if (CHARGER_MUST_DISCHARGE) {
            ticks = -ticks;
        }
        llSay(ACS_SECRET_CHANNEL, "ACS,chargeseconds:" + (string)(ticks));
                
        llSay(ACS_SECRET_CHANNEL, "ACS,charging:0");
                
        llSay(ACS_SECRET_CHANNEL, "ACS,travel:1");
                
        llSay(ACS_SECRET_CHANNEL, "ACS,disconnect:");
        */
    }
}

onInit() {
    log("Gun initialization");
    onAttach(llGetOwner());
    initWeaponList();
    
    updateText();
    llListen(API_CHANNEL, "", NULL_KEY, "");
}

onAttach(key id) {
    llPreloadSound("shoot"); 
    llRequestPermissions(id,PERMISSION_TAKE_CONTROLS|PERMISSION_TRACK_CAMERA|PERMISSION_TRIGGER_ANIMATION);
}

onDetach() {
    llStopAnimation("hold_R_handgun");
    llStopAnimation("aim_R_handgun");
    llReleaseControls();
}

float min(float a, float b) {
        if (a < b) { return a; }
        return b;
    }

default
{
    
    state_entry() {
        onInit();
    }
    
    touch_start(integer n) {
        if (llDetectedKey(0) == llGetOwner()) {
            selectNextWeapon();
        }
    }
    
    listen(integer ch, string name, key id, string msg) {
        onListen(ch, name, id, msg);
    }
    
    attach(key id)
    {
        if (id != NULL_KEY)
        { 
            onAttach(id);
        } else {
            onDetach();
        }
    }
    
    

    timer() {
        log(TIMER_STATE);
        log(LISTEN_STATE);
        if (TIMER_STATE == "chargerStart") {
            llSetTimerEvent(0.0);
            TIMER_STATE = "default";
            LISTEN_STATE = "default";
            
            llListenRemove(ACS_SECRET_LISTENER_HANDLE);
            llListenRemove(ACS_GLOBAL_LISTENER_HANDLE);
            llParticleSystem([]);
            
            ACS_ON = FALSE;
            updateText();
        } else if (TIMER_STATE == "chargingRobot") {
            integer ticks = (integer)min(BATTERY_REQUIRED_ENERGY, 120.0);
            if (CHARGER_MUST_DISCHARGE) {
                ticks = -ticks;
            }
            llSay(ACS_SECRET_CHANNEL, "ACS,chargeseconds:" + (string)(ticks));
            BATTERY_REQUIRED_ENERGY = BATTERY_REQUIRED_ENERGY - ticks;
            if (llAbs((integer)BATTERY_REQUIRED_ENERGY) < 5) {
                TIMER_STATE = "chargingRobotComplete";
            }
            if (llAbs(ticks) < 5) {
                TIMER_STATE = "chargingRobotComplete";
            }
            llSetTimerEvent(1);
        } else if (TIMER_STATE == "chargingRobotComplete") {
            llSay(ACS_SECRET_CHANNEL, "ACS,charging:0");                
            llSay(ACS_SECRET_CHANNEL, "ACS,travel:1");
            llSay(ACS_SECRET_CHANNEL, "ACS,disconnect:");
            
            TIMER_STATE = "chargerStart";
            llSetTimerEvent(2);
        }
    }
 
    run_time_permissions (integer perm)
    {
        if (perm & PERMISSION_TAKE_CONTROLS|PERMISSION_TRACK_CAMERA|PERMISSION_TRIGGER_ANIMATION) 
        {
            llTakeControls(CONTROL_LBUTTON|CONTROL_ML_LBUTTON,TRUE,FALSE);
            llStartAnimation("hold_R_handgun");
        }
    }
 
    control (key id, integer level, integer edge)
    {
        shoot(id,level,edge);
    }            
}
