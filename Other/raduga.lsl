float step = 0.005;
integer index = 0;
integer step_index = 0;
integer step_max = 0;
vector current = < 1.000, 0.000, 0.000 >;
vector plus = ZERO_VECTOR;
list incr = [];

default {
    state_entry() {
        step_max = (integer)(1.0 / step);

        incr = [
            < 0.000, step, 0.000 >, 
            < -step, 0.000, 0.000 >, 
            < 0.000, 0.000, step>, 
            < 0.000, -step, 0.000 >, 
            < step, 0.000, 0.000 >,
            < 0.000, 0.000, -step >
        ];
        
        plus = llList2Vector(incr, 0);
        llSetLinkColor(LINK_THIS, current, ALL_SIDES);

        llSetTimerEvent(0.040); 
    }

    timer() {
        if (step_index++ == step_max) {
            if (index++ == 5) {
                index = 0;
            }
            step_index = 0;
            plus = llList2Vector(incr, index);
        }
        current += plus;
        llSetLinkColor(LINK_THIS, current, ALL_SIDES);
    }
}