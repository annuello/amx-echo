PROGRAM_NAME='EchoSystem monitor'
#if_not_defined ECHOSYSTEM_MONITOR_AXI
#define ECHOSYSTEM_MONITOR_AXI
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
(* This shows some monitoring features that may be of more *)
(* interest to system administrators than academics.       *)
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
btMonOnline      = 140

btMonIdle        = 141
btMonPaused      = 142
btMonRecording   = 143
btMonWaiting     = 144

btMonScheduled   = 145
btMonAdHoc       = 146
btMonMonitoring  = 147
btMonLive        = 148

btMonSyncAudio   = 149
btMonSyncVideo1  = 150
btMonSyncVideo2  = 151

bvtMonWarning    = 152
vtMonType        = 153
vtMonSerial      = 154

vtMonTemperature = 155
vtMonDisc        = 156
btMonReboot      = 159

(***********************************************************)
(*              VARIABLE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_VARIABLE

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                  THE EVENTS GOES BELOW                  *)
(***********************************************************)
DEFINE_EVENT
//These audio bargraphs are different from the bargraphs in "EchoSystem control.axi" in that
//we show the audio level regardless of how the recording was started (Scheduled/AdHoc/Monitor).
level_event[vdvEcho,1]{
 send_level dvTp,3,level.value  //Bargraph 3
}
level_event[vdvEcho,2]{
 send_level dvTp,4,level.value  //Bargraph 4
}

level_event[vdvEcho,5]{  //Temperature
 send_level dvTp,5,level.value
 send_command dvTp,"'!T',vtMonTemperature,itoa(level.value),'C'"
}

level_event[vdvEcho,6]{  //Disc capacity
 send_level dvTp,6,level.value
 send_command dvTp,"'!T',vtMonDisc,itoa(level.value),'%'"
}

channel_event[vdvEcho,254]{  //Appliance has just come online.
 on:{
  send_command vdvEcho,'DEVICE TEMPERATURE?'
  send_command vdvEcho,'DEVICE SERIAL?'
 }
}

button_event[dvTp,btMonReboot]{
 push:{
  to[dvTp,btMonReboot]
  send_command vdvEcho,'DEVICE REBOOT'
 }
}

data_event[vdvEcho]{
 string:{
  if(find_string(data.text,'WARNING=',1) == 1){
   remove_string(data.text,'WARNING=',1)
   send_command dvTp,"'!T',bvtMonWarning,'Warning: ',data.text"
   on[dvTp,bvtMonWarning]
  }
  else if(find_string(data.text,'DEVICE TYPE=',1) == 1){
   remove_string(data.text,'DEVICE TYPE=',1)
   send_command dvTp,"'!T',vtMonType,data.text"
  }
  else if(find_string(data.text,'DEVICE SERIAL=',1) == 1){
   remove_string(data.text,'DEVICE SERIAL=',1)
   send_command dvTp,"'!T',vtMonSerial,data.text"
  }
 }
}
button_event[dvTp,bvtMonWarning]{
 push:{
  send_command dvTp,"'!T',bvtMonWarning,'Warning: '"  //Clear the warning message (if any) from the touch panel.
  off[dvTp,bvtMonWarning]
 }
}

(***********************************************************)
(*              THE ACTUAL PROGRAM GOES BELOW              *)
(***********************************************************)
DEFINE_PROGRAM
[dvTp,btMonOnline]    =[vdvEcho,254]  //Online
[dvTp,btMonIdle]      =[vdvEcho,241]  //Idle
[dvTp,btMonPaused]    =[vdvEcho,242]  //Paused
[dvTp,btMonRecording] =[vdvEcho,243]  //Recording
[dvTp,btMonWaiting]   =[vdvEcho,240]  //Waiting/pre-Record
[dvTp,btMonScheduled] =[vdvEcho,245]  //Scheduled
[dvTp,btMonAdHoc]     =[vdvEcho,246]  //AdHoc
[dvTp,btMonMonitoring]=[vdvEcho,247]  //Monitoring
[dvTp,btMonSyncAudio] =[vdvEcho,251]  //Audio "sync"
[dvTp,btMonSyncVideo1]=[vdvEcho,252]  //Video 1 sync
[dvTp,btMonSyncVideo2]=[vdvEcho,253]  //Video 2 sync
[dvTp,btMonLive]      =[vdvEcho,249]  //Live

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*         DO NOT PUT ANY CODE BELOW THIS COMMENT          *)
(***********************************************************)
#end_if