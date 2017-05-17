PROGRAM_NAME='EchoSystem ad hoc'
#if_not_defined ECHOSYSTEM_AD_HOC_AXI
#define ECHOSYSTEM_AD_HOC_AXI
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
(* This is an example of how you can create Ad Hoc         *)
(* recordings.  An Ad Hoc recording requires the following *)
(* information:  Description, Duration, ProductGroup.      *)
(* The ProductGroup can be obtained using the DEVICE       *)
(* PRODUCT GROUPS? command.  The ProductGroups will be     *)
(* reported at the next DEVICE REFRESH event.              *)
(* This example shows how to catch the Product Groups and  *)
(* present them as a list to the user, similar to the Room *)
(* List in the "EchoSystem room list.axi" example.         *)
(*                                                         *)
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
btAHGetProductGroups   = 80
bvtAHProductGroup1     = 81
bvtAHProductGroup2     = 82
bvtAHProductGroup3     = 83
bvtAHProductGroup4     = 84
bvtAHProductGroup5     = 85
bvtAHScrollUpBack      = 86
bvtAHScrollDownForward = 87
bvtAHDescription       = 88
bvtAHDuration          = 89
bvtAHStartRecording     = 90

AH_PRODUCT_GROUPS_PER_VIEW = 5
AH_SCROLL_SIZE = 5     //How many ProductGroups scroll by when you press up/down buttons.  Set this to
                       // what you prefer, but it must be <= AH_PRODUCT_GROUPS_PER_VIEW or you will scroll
                       // entirely past some ProductGroups.
MAX_AH_PRODUCT_GROUPS = 20

//Some constants to indicate what the current keypad value is to be used for.
//This .axi relies on eUserInput as defined in "EchoSystem config.axi"
kAdHocDescription = 12
kAdHocDuration    = 13

(***********************************************************)
(*              VARIABLE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_VARIABLE
volatile char    sAHProductGroups[MAX_AH_PRODUCT_GROUPS][200]  //Allow up to 200 chars in a ProductGroup name.
volatile integer iAHProductGroupsTotal
volatile integer iAHProductGroupsBaseIndex = 1
volatile integer iAHProductGroupsCurrent
volatile char    sAHDescription[100]
volatile integer iAHMinutes

devchan dcProductGroups[] = {{dvTp,bvtAHProductGroup1},{dvTp,bvtAHProductGroup2},{dvTp,bvtAHProductGroup3},{dvTp,bvtAHProductGroup4},{dvTp,bvtAHProductGroup5}}

(***********************************************************)
(*             SUBROUTINE DEFINITIONS GO BELOW             *)
(***********************************************************)
define_function ClearTPAdHoc(){
 stack_var integer i
 
 //Clear our list of product groups
 for(i = 1; i <= MAX_AH_PRODUCT_GROUPS; i++){
  sAHProductGroups[i] = ''
 }
 iAHProductGroupsTotal = 0
 iAHProductGroupsBaseIndex = 1
 iAHProductGroupsCurrent = 0
 
 //Update the touch panel.
 RefreshTPAdHoc()
}

define_function RefreshTPAdHoc(){
 stack_var integer i
 
 for(i = 0; i < AH_PRODUCT_GROUPS_PER_VIEW; i++){
  if(length_array(sAHProductGroups[iAHProductGroupsBaseIndex + i]) > 0){
   send_command dvTp,"'!T', type_cast(bvtAHProductGroup1 + i), sAHProductGroups[iAHProductGroupsBaseIndex + i]"
   if(iAHProductGroupsCurrent == iAHProductGroupsBaseIndex + i)
    on[dvTp,(bvtAHProductGroup1+i)]  //Turn button on to show it is selected.
   else
    off[dvTp,(bvtAHProductGroup1+i)]  //Turn button off.
  }
  else{
   send_command dvTp,"'!T', type_cast(bvtAHProductGroup1 + i), ''"
   off[dvTp,(bvtAHProductGroup1+i)]
  }
 }

 //Check each scroll button to see if it should be enabled or disabled.
 if(iAHProductGroupsTotal <= AH_PRODUCT_GROUPS_PER_VIEW){
  //Disabled both buttons
  send_command dvTp,"'^BMF-',itoa(bvtAHScrollUpBack),',0,%EN0'"
  send_command dvTp,"'^BMF-',itoa(bvtAHScrollDownForward),',0,%EN0'"
 }
 else{
  //Up/back button
  if(iAHProductGroupsBaseIndex > 1)
   send_command dvTp,"'^BMF-',itoa(bvtAHScrollUpBack),',0,%EN1'"
  else
   send_command dvTp,"'^BMF-',itoa(bvtAHScrollUpBack),',0,%EN0'"
  
  //Down/forward button
  if(iAHProductGroupsTotal >= (iAHProductGroupsBaseIndex + AH_PRODUCT_GROUPS_PER_VIEW))
   send_command dvTp,"'^BMF-',itoa(bvtAHScrollDownForward),',0,%EN1'"
  else
   send_command dvTp,"'^BMF-',itoa(bvtAHScrollDownForward),',0,%EN0'"
 }
}

(***********************************************************)
(*           MUTUALLY EXCLUSIVE CODE GOES BELOW            *)
(***********************************************************)
define_mutually_exclusive
([dvTp,bvtAHProductGroup1],[dvTp,bvtAHProductGroup2],[dvTp,bvtAHProductGroup3],[dvTp,bvtAHProductGroup4],[dvTp,bvtAHProductGroup5])
([dvTp,bvtAHScrollUpBack],[dvTp,bvtAHScrollDownForward])

(***********************************************************)
(*                  THE EVENTS GOES BELOW                  *)
(***********************************************************)
DEFINE_EVENT
button_event[dvTp,5]{  //Go to the Ad Hoc page
 push:{
  sAHDescription = ''
  iAHMinutes = 30
  send_command dvTp,"'!T',bvtAHDescription,''"
  send_command dvTp,"'!T',bvtAHDuration,'30'"
  ClearTPAdHoc()
 }
}

data_event[vdvEcho]{
 string:{
  stack_var integer i
  //This is how we can parse the response from vdvEcho.
  //A typical response looks like "DEVICE PRODUCT GROUP=<product group>" for each ProductGroup.
  if(find_string(data.text,'DEVICE PRODUCT GROUP=',1) == 1){
   i = 1
   //Find the first empty slot in our array.
   while((i <= MAX_AH_PRODUCT_GROUPS) && (length_array(sAHProductGroups[i])))
    i = i + 1
   if(i <= MAX_AH_PRODUCT_GROUPS){
    remove_string(data.text,'DEVICE PRODUCT GROUP=',1)
    sAHProductGroups[i] = data.text
    iAHProductGroupsTotal = iAHProductGroupsTotal + 1
   }
   wait 10 'AdHoc refresh'  //This is in a named-wait so we don't flood the TP with varText commands after we receive each and every product group.
    RefreshTPAdHoc()
  }
 }
}

button_event[dvTp,btAHGetProductGroups]{
 push:{
  to[dvTp,btAHGetProductGroups]
  ClearTPAdHoc()
  send_command vdvEcho,'DEVICE PRODUCT GROUPS?'
 }
}

//Here is a sample of how to do a scrolling list.
button_event[dvTp,bvtAHScrollUpBack]{
 push:{
  to[dvTp,bvtAHScrollUpBack]
 }
 release:{
  if((iAHProductGroupsBaseIndex > 1) && (iAHProductGroupsTotal > 0)){  //We have more ProductGroups
   //Decrement iAHProductGroupsBaseIndex by AH_SCROLL_SIZE, but do it safely to avoid negative results
   if(iAHProductGroupsBaseIndex > AH_SCROLL_SIZE)
    iAHProductGroupsBaseIndex = iAHProductGroupsBaseIndex - AH_SCROLL_SIZE
   else
    iAHProductGroupsBaseIndex = 1
   RefreshTPAdHoc()
  }
 }
}
button_event[dvTp,bvtAHScrollDownForward]{
 push:{
  to[dvTp,bvtAHScrollDownForward]
 }
 release:{
  if((iAHProductGroupsBaseIndex + AH_PRODUCT_GROUPS_PER_VIEW - 1) < iAHProductGroupsTotal){  //We have more ProductGroups
   iAHProductGroupsBaseIndex = iAHProductGroupsBaseIndex + AH_SCROLL_SIZE
   if(iAHProductGroupsBaseIndex > iAHProductGroupsTotal)  //Just a saftey measure to ensure iAHProductGroupsBaseIndex is not greater than iAHProductGroupsTotal
    iAHProductGroupsBaseIndex = iAHProductGroupsTotal
   RefreshTPAdHoc()
  }
 }
}

//The following is triggered when selecting a room on the scrolling list.
button_event[dcProductGroups]{
 push:{
  on[button.input]
  iAHProductGroupsCurrent = iAHProductGroupsBaseIndex + get_last(dcProductGroups) - 1
  if((length_array(sAHDescription) > 0) && (iAHMinutes > 0) && (iAHProductGroupsCurrent > 0))
   send_command dvTp,"'^BMF-',itoa(bvtAHStartRecording),',0,%EN1'"
  else
   send_command dvTp,"'^BMF-',itoa(bvtAHStartRecording),',0,%EN0'"
 }
}

button_event[dvTp,bvtAHDescription]{
 release:{
  eUserInput = kAdHocDescription
  send_command dvTp,"'@AKB-',sAHDescription,';Description'"
 }
}

button_event[dvTp,bvtAHDuration]{
 release:{
  eUserInput = kAdHocDuration
  send_command dvTp,"'@AKP-',itoa(iAHMinutes),';Duration (min)'"  //Suggested default of 30 minutes.
 }
}

//And finally, we initiate the Ad Hoc recording.
button_event[dvTp,bvtAHStartRecording]{
 push:{
  if(iAHProductGroupsCurrent != 0){
   to[dvTp,bvtAHStartRecording]
   send_command vdvEcho,"'AD HOC=',sAHDescription,';',itoa(iAHMinutes),';',sAHProductGroups[iAHProductGroupsCurrent]"
  }
 }
 release:{
  //Flip to our Control page to watch the appliance enter the Recording state.
  send_command dvTp,'PAGE-Control'
 }
}

//Handle feedback from the touch panel
data_event[dvTp]{
 online:{
  wait 70{
   send_command dvTp,"'!T', bvtAHDescription, sAHDescription"
   send_command dvTp,"'!T', bvtAHDuration, itoa(iAHMinutes)"
   if((length_array(sAHDescription) > 0) && (iAHMinutes > 0) && (iAHProductGroupsCurrent > 0))
    send_command dvTp,"'^BMF-',itoa(bvtAHStartRecording),',0,%EN1'"
   else
    send_command dvTp,"'^BMF-',itoa(bvtAHStartRecording),',0,%EN0'"
  }
 }
 string:{
  if(find_string(data.text,'KEYB-',1) == 1){  //Keyboard data
   remove_string(data.text,'KEYB-',1)
   if(find_string(data.text,'ABORT',1) != 1){
    if(eUserInput == kAdHocDescription){
     sAHDescription = data.text
     send_command dvTp,"'!T', bvtAHDescription, sAHDescription"
     if((length_array(sAHDescription) > 0) && (iAHMinutes > 0) && (iAHProductGroupsCurrent > 0))
      send_command dvTp,"'^BMF-',itoa(bvtAHStartRecording),',0,%EN1'"
     else
      send_command dvTp,"'^BMF-',itoa(bvtAHStartRecording),',0,%EN0'"
    }
   }
  }
  else if(find_string(data.text,'KEYP-',1) == 1){  //Keypad data
   remove_string(data.text,'KEYP-',1)
   if(find_string(data.text,'ABORT',1) != 1){
    if(eUserInput == kAdHocDuration){
     iAHMinutes = atoi(data.text)
     if(iAHMinutes > 240)  //Restrict recording to 4 hours to match EchoSystem Server UI.
      iAHMinutes = 240
     send_command dvTp,"'!T', bvtAHDuration, itoa(iAHMinutes)"
     if((length_array(sAHDescription) > 0) && (iAHMinutes > 0) && (iAHProductGroupsCurrent > 0))
      send_command dvTp,"'^BMF-',itoa(bvtAHStartRecording),',0,%EN1'"
     else
      send_command dvTp,"'^BMF-',itoa(bvtAHStartRecording),',0,%EN0'"
    }
   }
  }
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