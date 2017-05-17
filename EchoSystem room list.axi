PROGRAM_NAME='EchoSystem room list'
#if_not_defined ECHOSYSTEM_ROOM_LIST_AXI
#define ECHOSYSTEM_ROOM_LIST_AXI
(*****************************************************************************************************)
(* MIT License                                                                                       *)
(*                                                                                                   *)
(* Copyright (c) 2017 Swinburne University                                                           *)
(*                                                                                                   *)
(* Permission is hereby granted, free of charge, to any person obtaining a copy                      *)
(* of this software and associated documentation files (the "Software"), to deal                     *)
(* in the Software without restriction, including without limitation the rights                      *)
(* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell                         *)
(* copies of the Software, and to permit persons to whom the Software is                             *)
(* furnished to do so, subject to the following conditions:                                          *)
(*                                                                                                   *)
(* The above copyright notice and this permission notice shall be included in all                    *)
(* copies or substantial portions of the Software.                                                   *)
(*                                                                                                   *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR                        *)
(* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,                          *)
(* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE                       *)
(* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER                            *)
(* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,                     *)
(* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE                     *)
(* SOFTWARE.                                                                                         *)
(*****************************************************************************************************)
(* Roger McLean, Swinburne Uni.  20140123                  *)
(***********************************************************)
(* This is an example of how you can use the ROOMS? command*)
(* to retrieve a list of rooms from the EchoSystem Server. *)
(* Note that at the time of writing, the server returns the*)
(* entire list of rooms to the AMX.  Due to fixed buffer   *)
(* sizes in the module, the AMX can cater for approx 60    *)
(* rooms.  If your deployment has more than 60 rooms the   *)
(* results will be undefined.  If this is an issue for you,*)
(* don't forget to +1 the feature request at:              *)
(* http://opax.swin.edu.au/~romclean/amx/echo              *)
(***********************************************************)

(***********************************************************)
(*           DEVICE NUMBER DEFINITIONS GO BELOW            *)
(***********************************************************)
DEFINE_DEVICE
//This .axi assumes that the following devices are already defined:
//dvTp
//dvEcho

(***********************************************************)
(*              CONSTANT DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_CONSTANT
bvtRmRoom1             = 191
bvtRmRoom2             = 192
bvtRmRoom3             = 193
bvtRmRoom4             = 194
bvtRmRoom5             = 195
bvtRmScrollUpBack      = 196
bvtRmScrollDownForward = 197
btRmGetRooms           = 198
btRmCampusWizard       = 199
vtRmCurrentRoom        = 199
vtRmSelectAXXX         = 190

ITEMS_PER_VIEW = 5
SCROLL_SIZE    = 5  //How many rooms scroll by when you press up/down buttons.  Set this to
                    // what you prefer, but it must be <= ITEMS_PER_VIEW or you will scroll
                    // entirely past some rooms.
MAX_ITEMS = 60

cwNone     = 0
cwCampus   = 1
cwBuidling = 2
cwRoom     = 3

(***********************************************************)
(*              VARIABLE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_VARIABLE
volatile char sResults[MAX_ITEMS][100]
volatile integer i
volatile integer iResultsTotal
volatile integer iResultsBaseIndex = 1

volatile char iCampusWizardStep
volatile char sCampusName[100]
volatile char sBuildingName[100]
volatile char sRoomName[100]

devchan dcListButtons[] = {{dvTp,bvtRmRoom1},{dvTp,bvtRmRoom2},{dvTp,bvtRmRoom3},{dvTp,bvtRmRoom4},{dvTp,bvtRmRoom5}}

(***********************************************************)
(*             SUBROUTINE DEFINITIONS GO BELOW             *)
(***********************************************************)
define_function TouchPanelRefreshList(){
 //Update list from sResults content
 for(i = 0; i < ITEMS_PER_VIEW; i++){
  if(length_array(sResults[iResultsBaseIndex + i]) > 0)
   send_command dvTp,"'!T', type_cast(bvtRmRoom1 + i), sResults[iResultsBaseIndex + i]"
  else
   send_command dvTp,"'!T', type_cast(bvtRmRoom1 + i), ''"
 }
 CheckListScrollButtons()
}
define_function TouchPanelClearList(){
 for(i = 0; i < ITEMS_PER_VIEW; i++){
  send_command dvTp,"'!T',type_cast(bvtRmRoom1 + i), ''"
 }
 send_command dvTp,"'!T',vtRmSelectAXXX,''"  //Nothing to select.
}

define_function CheckListScrollButtons(){
 //Check each scroll button to see if it should be enabled or disabled.
 
 if(iResultsTotal <= ITEMS_PER_VIEW){
  //Disabled both buttons
  send_command dvTp,"'^BMF-',itoa(bvtRmScrollUpBack),',0,%EN0'"
  send_command dvTp,"'^BMF-',itoa(bvtRmScrollDownForward),',0,%EN0'"
 }
 else{
  //Up/back button
  if(iResultsBaseIndex > 1)
   send_command dvTp,"'^BMF-',itoa(bvtRmScrollUpBack),',0,%EN1'"
  else
   send_command dvTp,"'^BMF-',itoa(bvtRmScrollUpBack),',0,%EN0'"
  
  //Down/forward button
  if(iResultsTotal >= (iResultsBaseIndex + ITEMS_PER_VIEW))
   send_command dvTp,"'^BMF-',itoa(bvtRmScrollDownForward),',0,%EN1'"
  else
   send_command dvTp,"'^BMF-',itoa(bvtRmScrollDownForward),',0,%EN0'"
 }
}

define_function ParseSemicolonReply(char inString[1024]){
 //Take a list of semicolon-separated items and populate the sResuls list.
 i = 0
 iResultsTotal = 0
 while(find_string(inString,';',1) && (i < MAX_ITEMS)){
  i = i + 1
  sResults[i] = remove_string(inString,';',1)
  if(length_array(sResults[i]) > 1){
   sResults[i] = left_string(sResults[i], length_array(sResults[i])-1)  //Drop the ';'
  }
 }
 if((length_array(inString) > 0) && (i < MAX_ITEMS)){  //Extract the last item from the list.  N.B. No trailing ';'.
  i = i + 1
  sResults[i] = inString
  iResultsTotal = i
 }
 while(i < MAX_ITEMS){
  i = i + 1
  sResults[i] = ''  //Clear whatever old data may have been in the rest of sResults[] array.
 }
 iResultsBaseIndex = 1
}


(***********************************************************)
(*           MUTUALLY EXCLUSIVE CODE GOES BELOW            *)
(***********************************************************)
define_mutually_exclusive
([dvTp,bvtRmRoom1],[dvTp,bvtRmRoom2],[dvTp,bvtRmRoom3],[dvTp,bvtRmRoom4],[dvTp,bvtRmRoom5])
([dvTp,bvtRmScrollUpBack],[dvTp,bvtRmScrollDownForward])

(***********************************************************)
(*                  THE EVENTS GOES BELOW                  *)
(***********************************************************)
DEFINE_EVENT
button_event[dvTp,2]{  //This button is on the main page, with a page-flip to Rooms page
 push:{
  send_command vdvEcho,'ROOM?'
  TouchPanelRefreshList()
 }
}

data_event[vdvEcho]{
 string:{
  //This is how we can parse the response from vdvEcho.
  //A typical response from vdvEcho looks like  'ROOMS=Abc123;My big theatre;Room G28'
  select{
   active((find_string(data.text,'CAMPUSES=',1) == 1) && (iCampusWizardStep == cwCampus)):{
    remove_string(data.text,'CAMPUSES=',1)
    ParseSemicolonReply(data.text)
    TouchPanelRefreshList()
    send_command dvTp,"'!T',vtRmSelectAXXX,'Select a campus below...'"
   }
   active((find_string(data.text,'BUILDINGS=',1) == 1) && (iCampusWizardStep == cwBuidling)):{
    remove_string(data.text,'BUILDINGS=',1)
    ParseSemicolonReply(data.text)
    TouchPanelRefreshList()
    send_command dvTp,"'!T',vtRmSelectAXXX,'Select a building below...'"
   }
   active(find_string(data.text,'ROOMS=',1) == 1):{
    remove_string(data.text,'ROOMS=',1)
    ParseSemicolonReply(data.text)
    TouchPanelRefreshList()
    send_command dvTp,"'!T',vtRmSelectAXXX,'Select a room below...'"
   }
   active(find_string(data.text,'ROOM=',1) == 1):{  //Feedback on a ROOM? request
    remove_string(data.text,'ROOM=',1)
    send_command dvTp,"'!T', vtRmCurrentRoom, data.text"
   }
   active(find_string(data.text,'No buildings found for <',1) == 1):{
    remove_string(data.text,'<',1)
    send_command dvTp,"'!T',vtRmSelectAXXX,'No buildings at ',left_string(data.text,length_array(data.text) - 1),' campus,'"  //left_string drops the trailing '>'
    iCampusWizardStep = cwNone
    TouchPanelClearList()
   }
   active(find_string(data.text,'No rooms found for <',1) == 1):{
    remove_string(data.text,'<',1)
    send_command dvTp,"'!T',vtRmSelectAXXX,'No rooms in ',left_string(data.text,length_array(data.text) - 1),' building.'"  //left_string drops the trailing '>'
    iCampusWizardStep = cwNone
    TouchPanelClearList()
   }
  }
 }
}

//Here is a sample of how to do a scrolling list.
button_event[dvTp,bvtRmScrollUpBack]{
 push:{
  to[dvTp,bvtRmScrollUpBack]
 }
 release:{
  if((iResultsBaseIndex > 1) && (iResultsTotal > 0)){  //We have more rooms
   //Decrement iResultsBaseIndex by SCROLL_SIZE, but do it safely to avoid negative results
   if(iResultsBaseIndex > SCROLL_SIZE)
    iResultsBaseIndex = iResultsBaseIndex - SCROLL_SIZE
   else
    iResultsBaseIndex = 1
   TouchPanelRefreshList()
  }
 }
}
button_event[dvTp,bvtRmScrollDownForward]{
 push:{
  to[dvTp,bvtRmScrollDownForward]
 }
 release:{
  if((iResultsBaseIndex + ITEMS_PER_VIEW - 1) < iResultsTotal){  //We have more rooms
   iResultsBaseIndex = iResultsBaseIndex + SCROLL_SIZE
   if(iResultsBaseIndex > iResultsTotal)  //Just a saftey measure to ensure iResultsBaseIndex is not greater than iResultsTotal
    iResultsBaseIndex = iResultsTotal
   TouchPanelRefreshList()
  }
 }
}

//The following is triggered when selecting a room on the scrolling list.
button_event[dcListButtons]{
 push:{
  to[button.input]
 }
 release:{
  i = get_last(dcListButtons)
  if(length_array(sResults[iResultsBaseIndex + i - 1]) > 0){
   //We have pushed a button which contains a value
   switch(iCampusWizardStep){
    case cwNone:
     sRoomName = sResults[iResultsBaseIndex + i - 1]
     if(length_array(sCampusName) && length_array(sBuildingName)){
      send_command vdvEcho,"'ROOM=',sCampusName,':',sBuildingName,':',sRoomName"  //This is the Room Name in the fully-qualified format.
      send_command dvTp,"'!T',vtRmCurrentRoom,sCampusName,':',sBuildingName,':',sRoomName"  //Update the current room name on the touch panel.
     }
     else{
      send_command vdvEcho,"'ROOM=',sRoomName"  //This is the Room Name in the short format.
      send_command dvTp,"'!T',vtRmCurrentRoom,sRoomName"  //Update the current room name on the touch panel.
     }
     TouchPanelClearList()
     iCampusWizardStep = cwNone
     break;
    case cwCampus:
     sCampusName = sResults[iResultsBaseIndex + i - 1]  //We cache the campus name so we can use it in ROOMS IN BUILDINGS?<campus>:<building> below.
     iCampusWizardStep = cwBuidling
     send_command vdvEcho,"'BUILDINGS ON CAMPUS?',sCampusName"
     break;
    case cwBuidling:
     sBuildingName = sResults[iResultsBaseIndex + i - 1]
     iCampusWizardStep = cwRoom
     send_command vdvEcho,"'ROOMS IN BUILDING?',sCampusName,':',sBuildingName"
     break;
    case cwRoom:
     sRoomName = sResults[iResultsBaseIndex + i - 1]
     send_command vdvEcho,"'ROOM=',sCampusName,':',sBuildingName,':',sRoomName"  //This is the Room Name in the fully-qualified format.
     send_command dvTp,"'!T',vtRmCurrentRoom,sCampusName,':',sBuildingName,':',sRoomName"  //Update the current room name on the touch panel.
     TouchPanelClearList()
     iCampusWizardStep = cwNone
     break;
   }
  }
 }
}

//And finally, we request the list of rooms from EchoSystem Server.
button_event[dvTp,btRmGetRooms]{
 push:{
  sCampusName   = ''
  sBuildingName = ''
  sRoomName     = ''
  iCampusWizardStep = cwNone
  send_command vdvEcho,'ROOMS?'
 }
}

//Initiate the Campus Wizard
button_event[dvTp,btRmCampusWizard]{
 push:{
  sCampusName   = ''
  sBuildingName = ''
  sRoomName     = ''
  iCampusWizardStep = cwCampus
  send_command vdvEcho,'CAMPUSES?'
 }
}



(***********************************************************)
(*              THE ACTUAL PROGRAM GOES BELOW              *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*         DO NOT PUT ANY CODE BELOW THIS COMMENT          *)
(***********************************************************)
#end_if