PROGRAM_NAME='EchoSystem room list'
#if_not_defined ECHOSYSTEM_PRODUCT_GROUPS_AXI
#define ECHOSYSTEM_PRODUCT_GROUPS_AXI
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
(* This example demonstrates the following:                *)
(*  1) Providing a human-readable version of the current   *)
(*     product group, called "shortName" in this example.  *)
(*  2) Allowing certain Product Groups to enable extra     *)
(*     spot/flood lights if a camera is in use.            *)
(*                                                         *)
(* This example retrieves all Product Groups from the      *)
(* EchoSystem server.  It is up to each institution to     *)
(* determin suitable human-readable alternatives for each  *)
(* Product Group.  Likewise, you will need to determine if *)
(* additional lighting is required per Product Group.      *)
(* The demonstration allows you to save all this to a file *)
(* which can be reloaded and/or distributed across your    *)
(* AMX deployment.  The file can be edited with a basic    *)
(* text editor provided that the syntax is followed.  The  *)
(* module bundle has an example file, with the default     *)
(* Product Groups, some "real world" alternatives, and a   *)
(* flag to indicate camera-based recordings.               *)
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
bvtPGScrollUpBack      = 41
bvtPGScrollDownForward = 42
btPGSaveToFile         = 43
btPGLoadFromFile       = 44
btPGRefresh            = 45

vtPGEditName          = 46
bvtPGEditShortName    = 47
btPGEditExtraLighting = 48
btPGEditAccept        = 49

bvtPGName1      = 51
bvtPGName2      = 52
bvtPGName3      = 53
bvtPGName4      = 54
bvtPGName5      = 55
bvtPGShortName1 = 61
bvtPGShortName2 = 62
bvtPGShortName3 = 63
bvtPGShortName4 = 64
bvtPGShortName5 = 65
btPGLight1      = 71
btPGLight2      = 72
btPGLight3      = 73
btPGLight4      = 74
btPGLight5      = 75

vtCtlCurrentPG = 133  //On Control page
btCtlLights    = 118  //On Control page


char PRODUCT_GROUP_FILENAME[] = 'EchoSystem_prodGroups.txt'
MAX_CHARS_PER_LINE = 1024

MAX_PRODUCT_GROUPS = 20
PRODUCTS_PER_VIEW = 5
PRODUCT_SCROLL_SIZE = 5  //This aught to be <= PRODUCTS_PER_VIEW otherwise some will scroll by without you seeing them.

kPGShortName            = 101  //For tracking what the currrent action of the TP keyboard.

define_type
structure ProductGroup{
 char name[200]      //The Product Group name, as per EchoSystem.
 char shortName[50]  //An alternative name for the product group.
 char extraLighting  //BOOLEAN, whether we require additional lighting for the product group.
}

(***********************************************************)
(*              VARIABLE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_VARIABLE
volatile ProductGroup sProductGroup[MAX_PRODUCT_GROUPS]
volatile integer iProductGroupTotal
volatile integer iProductGroupBaseIndex = 1
volatile integer iProductGroupActiveButton
volatile char    editShortName[50]
volatile char    editExtraLighting

devchan dcPGNameButtons[] = {{dvTp,bvtPGName1},{dvTp,bvtPGName2},{dvTp,bvtPGName3},{dvTp,bvtPGName4},{dvTp,bvtPGName5}}
devchan dcPGShortNameButtons[] = {{dvTp,bvtPGShortName1},{dvTp,bvtPGShortName2},{dvTp,bvtPGShortName3},{dvTp,bvtPGShortName4},{dvTp,bvtPGShortName5}}

(***********************************************************)
(*             SUBROUTINE DEFINITIONS GO BELOW             *)
(***********************************************************)
define_function ProdGroupsSaveToFile(){
 stack_var integer i
 stack_var char buffer[MAX_CHARS_PER_LINE]
 stack_var slong fileHandle
 stack_var slong result
 
 fileHandle = file_open("'\',PRODUCT_GROUP_FILENAME",file_rw_new)
 if(fileHandle > 0){
  for(i = 1; i <= MAX_PRODUCT_GROUPS; i++){
   if(length_array(sProductGroup[i].name)){
    buffer = "sProductGroup[i].name,';',sProductGroup[i].shortName,';',itoa(sProductGroup[i].extraLighting)"
    result = file_write_line(fileHandle,buffer,length_array(buffer))
    if(result != length_array(buffer)){
     send_string 0,"'Error <',itoa(result),'> while writing to <',PRODUCT_GROUP_FILENAME,'>'"
    }
   }
  }
  result = file_close(fileHandle)
  if(result != 0)
   send_string 0,"'Error <',itoa(result),'> while closing <',PRODUCT_GROUP_FILENAME,'>'"
 }
 else{
  send_string 0,"'Error <',itoa(fileHandle),'> creating/opening <',PRODUCT_GROUP_FILENAME,'>'"
 }
}

define_function ProdGroupsLoadFromFile(){
 stack_var integer i
 stack_var char buffer[MAX_CHARS_PER_LINE]
 stack_var slong fileHandle
 stack_var slong result
 
 ClearProductGroupsList()
 i = 1
 
 fileHandle = file_open("'\',PRODUCT_GROUP_FILENAME",file_read_only)
 if(fileHandle > 0){
  result = file_seek(fileHandle,0)  //Start from the beginning of the file.
  if(result >= 0){
   result = file_read_line(fileHandle,buffer,MAX_CHARS_PER_LINE)
   while((i <= MAX_PRODUCT_GROUPS) && ((result >= 0) || (length_array(buffer) > 0))){
    sProductGroup[i].name = remove_string(buffer,';',1)
    sProductGroup[i].name = left_string(sProductGroup[i].name, length_array(sProductGroup[i].name)-1)  //Drop ';'
    sProductGroup[i].shortName = remove_string(buffer,';',1)
    sProductGroup[i].shortName = left_string(sProductGroup[i].shortName, length_array(sProductGroup[i].shortName)-1)  //Drop ';'
    sProductGroup[i].extraLighting = atoi(buffer)
    iProductGroupTotal = iProductGroupTotal + 1
    i = i + 1
    result = file_read_line(fileHandle,buffer,MAX_CHARS_PER_LINE)
   }
   if(result != -9){  //-9 is end-of-file
    send_string 0,"'Error <',itoa(result),'> while reading file <',PRODUCT_GROUP_FILENAME,'>'"
   }
  }
  else
   send_string 0,"'Error <',itoa(result),'> while rewinding file <',PRODUCT_GROUP_FILENAME,'>'"
 }
 else
  send_string 0,"'Error <',itoa(fileHandle),'> opening <',PRODUCT_GROUP_FILENAME,'>'"
 RefreshTPProductGroups()
}

define_function ClearProductGroupsList(){
 stack_var integer i
 
 for(i = 1; i <= MAX_PRODUCT_GROUPS; i++){
  sProductGroup[i].name = ''
  sProductGroup[i].shortName = ''
  sProductGroup[i].extraLighting = 0
 }
 for(i = 0; i < PRODUCTS_PER_VIEW; i++){
  send_command dvTp,"'!T',type_cast(bvtPGName1 + i),''"       //Clear the varText
  send_command dvTp,"'!T',type_cast(bvtPGShortName1 + i),''"  //Clear the varText
  off[dvTp,type_cast(btPGLight1 + i)]
 }
 iProductGroupTotal = 0
 iProductGroupBaseIndex = 1
}
define_function RefreshTPProductGroups(){
 stack_var integer i
 
 //Update the varText buttons.  We have a moving iProductGroupBaseIndex which changes as we scroll through the list.
 for(i = 0; i < PRODUCTS_PER_VIEW; i++){
  if(length_array(sProductGroup[iProductGroupBaseIndex + i].name) > 0){
   send_command dvTp,"'!T',type_cast(bvtPGName1 + i),sProductGroup[iProductGroupBaseIndex + i].name"
   send_command dvTp,"'!T',type_cast(bvtPGShortName1 + i),sProductGroup[iProductGroupBaseIndex + i].shortName"
   [dvTp,type_cast(btPGLight1 + i)] = sProductGroup[iProductGroupBaseIndex + i].extraLighting
  }
  else{
   send_command dvTp,"'!T',type_cast(bvtPGName1 + i),''"
   send_command dvTp,"'!T',type_cast(bvtPGShortName1 + i),''"
   off[dvTp,type_cast(btPGLight1 + i)]
  }
 }
 
 //Update the scroll up/down buttons.
 if(iProductGroupTotal <= PRODUCTS_PER_VIEW){
  //PG quantity does not exceed the viewing size of our list.  Disable both scroll buttons.
  send_command dvTp,"'^BMF-',itoa(bvtPGScrollUpBack),',0,%EN0'"
  send_command dvTp,"'^BMF-',itoa(bvtPGScrollDownForward),',0,%EN0'"
 }
 else{  //Our list of PGs is greater than our viewing size.  Enable/disable arrows based on our iProductGroupBaseIndex.
  //Up/back button
  if(iProductGroupBaseIndex > 1)
   send_command dvTp,"'^BMF-',itoa(bvtPGScrollUpBack),',0,%EN1'"
  else
   send_command dvTp,"'^BMF-',itoa(bvtPGScrollUpBack),',0,%EN0'"
  
  //Down/forward button
  if(iProductGroupTotal >= (iProductGroupBaseIndex + PRODUCTS_PER_VIEW))
   send_command dvTp,"'^BMF-',itoa(bvtPGScrollDownForward),',0,%EN1'"
  else
   send_command dvTp,"'^BMF-',itoa(bvtPGScrollDownForward),',0,%EN0'"
 }
}

(***********************************************************)
(*           MUTUALLY EXCLUSIVE CODE GOES BELOW            *)
(***********************************************************)
define_mutually_exclusive
([dvTp,bvtPGName1],[dvTp,bvtPGName2],[dvTp,bvtPGName3],[dvTp,bvtPGName4],[dvTp,bvtPGName5])
([dvTp,bvtPGScrollUpBack],[dvTp,bvtPGScrollDownForward])

(***********************************************************)
(*                  THE EVENTS GOES BELOW                  *)
(***********************************************************)
define_event
button_event[dvTp,btPGRefresh]{  //This button is on the "Confirm ProductGroup Refresh" popup.
 push:{
  to[dvTp,btPGRefresh]
  ClearProductGroupsList()
  send_command vdvEcho,'SERVER PRODUCT GROUPS?'
  RefreshTPProductGroups()
 }
}
button_event[dvTp,btPGSaveToFile]{
 push:{
  to[dvTp,btPGSaveToFile]
  ProdGroupsSaveToFile()
 }
}
button_event[dvTp,btPGLoadFromFile]{
 push:{
  to[dvTp,btPGLoadFromFile]
  ProdGroupsLoadFromFile()
 }
}

//Here is a sample of how to do a scrolling list.
button_event[dvTp,bvtPGScrollUpBack]{
 push:{
  to[dvTp,bvtPGScrollUpBack]
 }
 release:{
  if((iProductGroupBaseIndex > 1) && (iProductGroupTotal > 0)){  //We have more rooms
   //Decrement iProductGroupBaseIndex by PRODUCT_SCROLL_SIZE, but do it safely to avoid negative results
   if(iProductGroupBaseIndex > PRODUCT_SCROLL_SIZE)
    iProductGroupBaseIndex = iProductGroupBaseIndex - PRODUCT_SCROLL_SIZE
   else
    iProductGroupBaseIndex = 1
   RefreshTPProductGroups()
  }
 }
}
button_event[dvTp,bvtPGScrollDownForward]{
 push:{
  to[dvTp,bvtPGScrollDownForward]
 }
 release:{
  if((iProductGroupBaseIndex + PRODUCTS_PER_VIEW - 1) < iProductGroupTotal){  //We have more rooms
   iProductGroupBaseIndex = iProductGroupBaseIndex + PRODUCT_SCROLL_SIZE
   if(iProductGroupBaseIndex > iProductGroupTotal)  //Just a saftey measure to ensure iProductGroupBaseIndex is not greater than iProductGroupTotal
    iProductGroupBaseIndex = iProductGroupTotal
   RefreshTPProductGroups()
  }
 }
}

//This is where we handle button pushes on the actual Product Groups.  A push will invoke the ProductGroup Edit popup.
button_event[dcPGNameButtons]{
 push:{
  to[button.input]
 }
 release:{
  iProductGroupActiveButton = get_last(dcPGNameButtons)
  if(length_array(sProductGroup[iProductGroupBaseIndex + iProductGroupActiveButton - 1].name) > 0){  //Does the item in our array have data in the .name part?
   //We have pushed a button which contains a value.  Fill out the Edit popup then show it.
   editShortName     = sProductGroup[iProductGroupBaseIndex + iProductGroupActiveButton - 1].shortName
   editExtraLighting = sProductGroup[iProductGroupBaseIndex + iProductGroupActiveButton - 1].extraLighting
   
   send_command dvTp,"'!T',vtPGEditName,sProductGroup[iProductGroupBaseIndex + iProductGroupActiveButton - 1].name"
   send_command dvTp,"'!T',bvtPGEditShortName,editShortName"
   if(editExtraLighting)
    on[dvTp,btPGEditExtraLighting]
   else
    off[dvTp,btPGEditExtraLighting]
   send_command dvTp,'@PPN-EditProductGroup'
  }
 }
}
button_event[dcPGShortNameButtons]{  //As above, but handling a press on the Short Name buttons.
 push:{
  to[button.input]
 }
 release:{
  iProductGroupActiveButton = get_last(dcPGShortNameButtons)
  if(length_array(sProductGroup[iProductGroupBaseIndex + iProductGroupActiveButton - 1].name) > 0){  //Does the item in our array have data in the .name part?
   //We have pushed a button which contains a value.  Fill out the Edit popup then show it.
   editShortName     = sProductGroup[iProductGroupBaseIndex + iProductGroupActiveButton - 1].shortName
   editExtraLighting = sProductGroup[iProductGroupBaseIndex + iProductGroupActiveButton - 1].extraLighting
   
   send_command dvTp,"'!T',vtPGEditName,sProductGroup[iProductGroupBaseIndex + iProductGroupActiveButton - 1].name"
   send_command dvTp,"'!T',bvtPGEditShortName,editShortName"
   if(editExtraLighting)
    on[dvTp,btPGEditExtraLighting]
   else
    off[dvTp,btPGEditExtraLighting]
   send_command dvTp,'@PPN-EditProductGroup'
  }
 }
}


button_event[dvTp,bvtPGEditShortName]{
 push:{
  eUserInput = kPGShortName
 }
 release:{
  send_command dvTp,"'@AKB-',editShortName,';Short Name'"
 }
}

button_event[dvTp,btPGEditExtraLighting]{
 push:{
  editExtraLighting = !editExtraLighting
  [dvTp,btPGEditExtraLighting] = editExtraLighting
 }
}
button_event[dvTp,btPGEditAccept]{
 push:{
  sProductGroup[iProductGroupBaseIndex + iProductGroupActiveButton - 1].shortName = editShortName
  sProductGroup[iProductGroupBaseIndex + iProductGroupActiveButton - 1].extraLighting = editExtraLighting
  send_command dvTp,'@PPF-EditProductGroup'
  RefreshTPProductGroups()
 }
}

data_event[dvTp]{
 string:{
  if(find_string(data.text,'KEYB-',1) == 1){  //Keyboard data
   remove_string(data.text,'KEYB-',1)
   if(find_string(data.text,'ABORT',1) != 1){
    switch(eUserInput){
     case kPGShortName:
      //Show the new text on the EditShortName button.
      editShortName = data.text
      send_command dvTp,"'!T',bvtPGEditShortName,editShortName"
      eUserInput = kNone
      break;
    }
   }
  }
 }
}

data_event[vdvEcho]{
 string:{
  stack_var i
  stack_var bFound
  
  //This is how we can parse the response from vdvEcho.
  select{
   active(find_string(data.text,'SERVER PRODUCT GROUP=',1) == 1):{
    i = 1
    //Find the first empty slot in our array.
    while((i <= MAX_PRODUCT_GROUPS) && (length_array(sProductGroup[i].name)))
     i = i + 1
    if(i <= MAX_PRODUCT_GROUPS){
     remove_string(data.text,'SERVER PRODUCT GROUP=',1)
     sProductGroup[i].name = data.text
     sProductGroup[i].shortName = ''
     sProductGroup[i].extraLighting = 0
     iProductGroupTotal = iProductGroupTotal + 1
    }
    wait 10 'refresh PGs'
     RefreshTPProductGroups()
   }
   active(find_string(data.text,'CURRENT PRODUCT GROUP=',1) == 1):{
    remove_string(data.text,'CURRENT PRODUCT GROUP=',1)
    i = 1
    bFound = false
    while(!bFound && (i <= MAX_PRODUCT_GROUPS)){
     if(find_string(sProductGroup[i].name,data.text,1) && (length_array(data.text) == length_array(sProductGroup[i].name)))
      bFound = true
     else
      i = i + 1
    }
    if(bFound){
     send_command dvTp,"'!T',vtCtlCurrentPG,sProductGroup[i].shortName"
     if(sProductGroup[i].extraLighting){
      //Turn on the spot/flood lights.  They are turned off when the appliance goes into the Idle state.
      on[dvTp,btCtlLights]
     }
    }
   }
  }
 }
}

//Turn off the spot/flood light when the appliance goes into the Idle state.  Clear the shortName for the current capture.
channel_event[vdvEcho,241]{
 on:{
  off[dvTp,btCtlLights]
  send_command dvTp,"'!T',vtCtlCurrentPG,''"
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