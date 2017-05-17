PROGRAM_NAME='EchoSystem control'
#if_not_defined ECHOSYSTEM_CONTROL_AXI
#define ECHOSYSTEM_CONTROL_AXI
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
(* This is an example of how you can control the module.   *)
(*                                                         *)
(* STOP - When the module issues a STOP message to the     *)
(* capture hardware the recording can no longer be resumed.*)
(* It is advisable to use a mechanism that prevents        *)
(* inadvertant stopping of the recording. For touch panels,*)
(* this can be a confirmation page.  For keypads, the STOP *)
(* button can be held in for a duration (e.g. >1.5 sec)    *)
(* before the STOP command is sent.                        *)
(*                                                         *)
(* CONDITIONAL FEEDBACK - the module is aware of how the   *)
(* current recording started (Scheduled/AdHoc/Monitoring). *)
(* You may want to provide different feedback depending on *)
(* how the recording started.  This example provides       *)
(* feedback for Scheduled and Ad Hoc recordings, which     *)
(* both result in a file being produced.  This allows the  *)
(* admins to monitor hardware without creating in-room     *)
(* feedback.  Refer to your institutions policies before   *)
(* deciding what in-room feedback to provide.              *)
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
btCtlStop       = 104 //On the ConfirmStop popup
//The rest are on the Control page
btCtlPause      = 101
btCtlResume     = 102
btCtlExtend     = 103

btCtlIdle       = 110
btCtlPaused     = 111
btCtlRecording  = 112
btCtlWaiting    = 113

btCtlSyncAudio  = 114
btCtlSyncVideo1 = 115
btCtlSyncVideo2 = 116
btCtlLive       = 117

btCtlOnline     = 119

vtCtlTitle      = 105
vtCtlPresenter  = 106
vtCtlCountdown  = 107

//A constant to indicate what the current keypad value is to be used for.
//This .axi relies on eUserInput as defined in "EchoSystem config.axi"
kExtendRecording = 11

//Some module channels which indicate the current recording type
typeScheduled  = 245
typeAdHoc      = 246
typeMonitoring = 247

(***********************************************************)
(*              VARIABLE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_VARIABLE
volatile char sTitle[100]

(***********************************************************)
(*                  THE EVENTS GOES BELOW                  *)
(***********************************************************)
DEFINE_EVENT
data_event[vdvEcho]{
 string:{
  //This is how we can parse the response from vdvEcho.
  if(find_string(data.text,'TITLE=',1) == 1){
   remove_string(data.text,'TITLE=',1)
   if([vdvEcho,typeScheduled] || [vdvEcho,typeAdHoc])
    send_command dvTp,"'!T',vtCtlTitle,data.text"
   else
    send_command dvTp,"'!T',vtCtlTitle,''"
   
   //Note: If the RecordingType is Montitoring, the module will report 'TITLE=Confidence Monitoring'
  }
  if(find_string(data.text,'PRESENTER=',1) == 1){
   remove_string(data.text,'PRESENTER=',1)
   if([vdvEcho,typeScheduled] || [vdvEcho,typeAdHoc])
    send_command dvTp,"'!T',vtCtlTitle,data.text"
   else
    send_command dvTp,"'!T', vtCtlTitle, ''"
  }
  if(find_string(data.text,'TIME=',1) == 1){
   remove_string(data.text,'TIME=',1)
   if([vdvEcho,typeScheduled] || [vdvEcho,typeAdHoc])
    send_command dvTp,"'!T',vtCtlCountdown,data.text"
   else
    send_command dvTp,"'!T',vtCtlCountdown,''"
  }
  //See the "EchoSystem product groups.axi" file for showing "Recording Type" per Product Group.
  //Control of extra spot/flood lights [dvTp,118] is also performed there.
 }
}

data_event[dvTp]{
 online:{
  wait 70{
   if([vdvEcho,typeScheduled] || [vdvEcho,typeAdHoc])
    send_command dvTp,"'!T', vtCtlTitle, sTitle"
   else
    send_command dvTp,"'!T', vtCtlTitle, ''"
  }
 }
 string:{
  if(find_string(data.text,'KEYP-',1) == 1){  //Keypad data
   remove_string(data.text,'KEYP-',1)
   if(find_string(data.text,'ABORT',1) != 1){
    if(eUserInput == kExtendRecording){
     send_command vdvEcho,"'EXTEND=',data.text"
     eUserInput = kNone
    }
   }
  }
 }
}

button_event[dvTp,btCtlStop]{
 push:{
  to[dvTp,btCtlStop]
  send_command vdvEcho,'STOP'
 }
}
button_event[dvTp,btCtlPause]{
 push:{
  to[dvTp,btCtlPause]
  send_command vdvEcho,'PAUSE'
 }
}
button_event[dvTp,btCtlResume]{
 push:{
  to[dvTp,btCtlResume]
  send_command vdvEcho,'RESUME'
 }
}
button_event[dvTp,btCtlExtend]{
 release:{
  eUserInput = kExtendRecording
  send_command dvTp,"'@AKP-5;Extend (minutes)'"  //Suggest to extend by 5 minutes.
 }
}

level_event[vdvEcho,1]{  //Left audio
 if([vdvEcho,typeScheduled] || [vdvEcho,typeAdHoc])
  send_level dvTp,1,level.value  //Bargraph 1 on touchpanel
 else
  send_level dvTp,1,0
}
level_event[vdvEcho,2]{  //Right audio
 if([vdvEcho,typeScheduled] || [vdvEcho,typeAdHoc])
  send_level dvTp,2,level.value  //Bargraph 2 on touchpanel
 else
  send_level dvTp,2,0
}
level_event[vdvEcho,3]{  //Recording Progress
 if([vdvEcho,typeScheduled] || [vdvEcho,typeAdHoc])
  send_level dvTp,7,level.value
 else
  send_level dvTp,7,0
}

(***********************************************************)
(*              THE ACTUAL PROGRAM GOES BELOW              *)
(***********************************************************)
DEFINE_PROGRAM
[dvTp,btCtlOnline]     = [vdvEcho,254]
[dvTp,btCtlWaiting]    = [vdvEcho,240]
[dvTp,btCtlIdle]       = ([vdvEcho,241] || [vdvEcho,typeMonitoring])  //Show Monitoring as being Idle
[dvTp,btCtlPaused]     = ([vdvEcho,242] && ([vdvEcho,typeScheduled] || [vdvEcho,typeAdHoc]))
[dvTp,btCtlRecording]  = ([vdvEcho,243] && ([vdvEcho,typeScheduled] || [vdvEcho,typeAdHoc]))
[dvTp,btCtlLive]       = [vdvEcho,249]
[dvTp,btCtlSyncAudio]  = ([vdvEcho,251] && ([vdvEcho,typeScheduled] || [vdvEcho,typeAdHoc]))
[dvTp,btCtlSyncVideo1] = ([vdvEcho,252] && ([vdvEcho,typeScheduled] || [vdvEcho,typeAdHoc]))
[dvTp,btCtlSyncVideo2] = ([vdvEcho,253] && ([vdvEcho,typeScheduled] || [vdvEcho,typeAdHoc]))

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*         DO NOT PUT ANY CODE BELOW THIS COMMENT          *)
(***********************************************************)
#end_if