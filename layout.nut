////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// 10/11/2016 updated by DGM for the RetroPie Facebook group 
// Updated and enhanced to now include many new features and options
//
// Updated 9/08/2016 by omegaman                                                                      
// Attract-Mode "Robospin" layout. Thanks to verion for cleaning cab skins and to malfacine's for glogos                             
// Notes: Lots of changes...  
////////////////////////////////////////////////////////////////////////////////////////////////////////   

class UserConfig {
</ label="--------  Main theme layout  --------", help="Show or hide additional images", order=1 /> uct1="select below";
   </ label="Select listbox, wheel, vert_wheel", help="Select wheel type or listbox", options="listbox", order=4 /> enable_list_type="listbox";
   </ label="Select spinwheel art", help="The artwork to spin", options="marquee,wheel", order=5 /> orbit_art="wheel";
   </ label="Wheel transition time", help="Time in milliseconds for wheel spin.", order=6 /> transition_ms="25";  
</ label=" ", help=" ", options=" ", order=15 /> divider5="";
</ label="--------    Miscellaneous    --------", help="Miscellaneous options", order=16 /> uct6="select below";
   </ label="Enable genre icon", help="Show genre icon", options="Yes,No", order=18 /> enable_genre="Yes";
   </ label="Enable monitor static effect", help="Show static effect when snap is null", options="Yes,No", order=18 /> enable_static="No"; 
   </ label="Random Wheel Sounds", help="Play random sounds when navigating games wheel", options="Yes,No", order=25 /> enable_random_sound="Yes";
}

local my_config = fe.get_config();
local flx = fe.layout.width;
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;
fe.layout.font="raptor_sans_font_by_rotweiler83_d222zcf.ttf";

// modules
fe.load_module("fade");
fe.load_module( "animate" );
fe.load_module("scrollingtext");

// Load background image
local b_art = fe.add_image("basic.png", 0, 0, flw, flh );

// Load wheel image
local w_art = fe.add_image("art/[Name]", flx*0.735, fly*0.2, flw*0.25, flh*0.8 );
w_art.alpha=255;
w_art.skew_x = -flx*0.003;

// Video Preview or static video if none available
// remember to make both sections the same dimensions and size
if ( my_config["enable_static"] == "Yes" )
{
//adjust the values below for the static preview video snap
   const SNAPBG_ALPHA = 200;
   local snapbg=null;
   snapbg = fe.add_image( "static.mp4", flx*0.165, fly*0.001, flw*0.45, flh*0.65 );
   snapbg.trigger = Transition.EndNavigation;
   snapbg.skew_y = 0;
   snapbg.skew_x = 0;
   snapbg.pinch_y = 0;
   snapbg.pinch_x = 0;
   snapbg.rotation = 0;
   snapbg.set_rgb( 155, 155, 155 );
   snapbg.alpha = SNAPBG_ALPHA;
}
 else
 {
 local temp = fe.add_text("", flx*0.185, fly*0.001, flw*0.45, flh*0.65 );
// temp.bg_alpha = SNAPBG_ALPHA;
 }

//create surface for snap
local surface_snap = fe.add_surface( 640, 480 );
local snap = FadeArt("snap", 0, 0, 640, 480, surface_snap);
snap.trigger = Transition.EndNavigation;
snap.preserve_aspect_ratio = true;

//now position and pinch surface of snap
//adjust the below values for the game video preview snap
surface_snap.set_pos(flx*0.175, fly*0.001, flw*0.47, flh*0.67);
surface_snap.skew_y = 0;
surface_snap.skew_x = 0;
surface_snap.pinch_y = 0;
surface_snap.pinch_x = 0;
surface_snap.rotation = 0;

// Wheel art to display
local wheelart = fe.add_artwork("wheel", flx*0.8275, fly*0.0215, flw*0.15, flh*0.15);
wheelart.preserve_aspect_ratio = true;

// The following section sets up what type and wheel and displays the users choice

if ( my_config["enable_list_type"] == "listbox" )
{
local listbox = fe.add_listbox( flx*0.185, fly*0.6, flw*0.45, flh*0.21 );
listbox.rows = 5;
listbox.charsize = 30;
listbox.set_rgb( 211, 211, 211 );
listbox.bg_alpha = 0;
listbox.align = Align.Centre;
listbox.selbg_alpha = 0;
listbox.sel_red = 71;
listbox.sel_green = 121;
listbox.sel_blue = 210;
//listbox.font = "moonhouse.ttf";
}

// Play random sound when transitioning to next / previous game on wheel
function sound_transitions(ttype, var, ttime) 
{
	if (my_config["enable_random_sound"] == "Yes")
	{
		local random_num = floor(((rand() % 1000 ) / 1000.0) * (124 - (1 - 1)) + 1);
		local sound_name = "sounds/GS"+random_num+".mp3";
		switch(ttype) 
		{
		case Transition.EndNavigation:		
			local Wheelclick = fe.add_sound(sound_name);
			Wheelclick.playing=true;
			break;
		}
		return false;
	}
}
fe.add_transition_callback("sound_transitions")

//System count text info
local textgc = fe.add_text( "System Count: [ListEntry]-[ListSize]", flx*0.001, fly*0.9, flw*0.4, flh*0.025  );
textgc.set_rgb( 225, 255, 255 );
//textgc.style = Style.Bold;
textgc.align = Align.Left;
textgc.rotation = 0;
textgc.word_wrap = true;

//Emulator text info
local textemu = fe.add_text( "[Name]", flx*0.1095, fly*0.87, flw*0.6, flh*0.04  );
textemu.set_rgb( 225, 255, 255 );
//textemu.style = Style.Bold;
textemu.align = Align.Centre;
textemu.rotation = 0;
textemu.word_wrap = true;

//category icons 
if ( my_config["enable_genre"] == "Yes" )
{
local glogo1 = fe.add_image("glogos/unknown1.png", flx*0.685, fly*0.857, flw*0.04, flh*0.07);
glogo1.trigger = Transition.EndNavigation;

class GenreImage1
{
    mode = 1;       //0 = first match, 1 = last match, 2 = random
    supported = {
        //filename : [ match1, match2 ]
        "action": [ "action","gun", "climbing" ],
        "adventure": [ "adventure" ],
        "arcade": [ "arcade" ],
        "casino": [ "casino" ],
        "computer": [ "computer" ],
        "console": [ "console" ],
        "collection": [ "collection" ],
        "fighter": [ "fighting", "fighter", "beat-'em-up" ],
        "handheld": [ "handheld" ],
		"jukebox": [ "jukebox" ],
        "platformer": [ "platformer", "platform" ],
        "mahjong": [ "mahjong" ],
        "maze": [ "maze" ],
        "paddle": [ "breakout", "paddle" ],
        "puzzle": [ "puzzle" ],
	    "pinball": [ "pinball" ],
	    "quiz": [ "quiz" ],
	    "racing": [ "racing", "driving","motorcycle" ],
        "rpg": [ "rpg", "role playing", "role-playing" ],
	    "rhythm": [ "rhythm" ],
        "shooter": [ "shooter", "shmup", "shoot-'em-up" ],
	    "simulation": [ "simulation" ],
        "sports": [ "sports", "boxing", "golf", "baseball", "football", "soccer", "tennis", "hockey" ],
        "strategy": [ "strategy"],
        "utility": [ "utility" ]
    }

    ref = null;
    constructor( image )
    {
        ref = image;
        fe.add_transition_callback( this, "transition" );
    }
    
    function transition( ttype, var, ttime )
    {
        if ( ttype == Transition.ToNewSelection || ttype == Transition.ToNewList )
        {
            local cat = " " + fe.game_info(Info.Category, var).tolower();
            local matches = [];
            foreach( key, val in supported )
            {
                foreach( nickname in val )
                {
                    if ( cat.find(nickname, 0) ) matches.push(key);
                }
            }
            if ( matches.len() > 0 )
            {
                switch( mode )
                {
                    case 0:
                        ref.file_name = "glogos/" + matches[0] + "1.png";
                        break;
                    case 1:
                        ref.file_name = "glogos/" + matches[matches.len() - 1] + "1.png";
                        break;
                    case 2:
                        local random_num = floor(((rand() % 1000 ) / 1000.0) * ((matches.len() - 1) - (0 - 1)) + 0);
                        ref.file_name = "glogos/" + matches[random_num] + "1.png";
                        break;
                }
            } else
            {
                ref.file_name = "glogos/blank.png";
            }
        }
    }
}
GenreImage1(glogo1);
}


