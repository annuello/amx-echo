PROGRAM_NAME='EchoSystem demo'
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
(* EchoSystem module v3.3.0 demo for both stand-alone and  *)
(*  server-based deployment.                               *)
(* All .axi files are optional.  RMS code will require     *)
(* modification according to your existing RMS deployment. *)
(*                                                         *)
(* How to understand my programming conventions...         *)
(* Constants:                                              *)
(*  Used for button channel and addresses.  If a button    *)
(*  uses both channel and address, it will have the same   *)
(*  exclusive number.                                      *)
(*  All buttons have a constant declared at the start of   *)
(*  the relevent .axi file.  The constant is named         *)
(*   <addressing><PageRef><ButtonFunction>                 *)
(*   addressing: bt=push-only, vt=varText-only, bvt=both   *)
(*   Note: Enabling/diabling buttons uses the button       *)
(*         address, not the button channel.                *)
(* Lists:                                                  *)
(*  Pages with lists all follow the same implimentation    *)
(*  approach.  An array stores the data, and the list      *)
(*  buttons are a "sliding window" over the data.  The     *)
(*  xxx_SCROLL_SIZE adjusts how many items scroll by each  *)
(*  time the up/down buttons are pressed. A xxxBaseIndex   *)
(*  variable tracks the data array index of the lowest     *)
(*  visible item.                                          *)
(*                                                         *)
(* http://opax.swin.edu.au/~romclean/amx/echo              *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
dvTp                = 10001:1:0
vdvEcho             = 33001:1:0
vdvEchoDeviceIpPort = 0:2:0
vdvEchoServerIpPort = 0:3:0

#include 'EchoSystem config.axi'
#include 'EchoSystem room list.axi'
#include 'EchoSystem monitor.axi'
#include 'EchoSystem control.axi'
#include 'EchoSystem ad hoc.axi'
#include 'EchoSystem product groups.axi'

//#include 'RMSMain.axi'  //This is the sample code supplied with this bundle.
#warn 'You will need to add some AMX RMS files before the RMS code will compile.'
//The following files are required to compile the RMS code:
// RMS Common.axi, i!-ConnectLinxEngineMod & RMSEngineMod

(***********************************************************)
(*                MODULES ARE DECLARED BELOW               *)
(***********************************************************)
define_module 'EchoSystem' modEchoSystem(vdvEcho, vdvEchoDeviceIpPort, vdvEchoServerIpPort)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
data_event[dvTp]{
 online:{
  wait 30{
   send_command dvTp,'PAGE-Main'
  }
 }
}

data_event[vdvEcho]{
 online:{
  wait 50{
#warn 'Change these details to suit your deployment'
   //For server-based mode you should configure the module like this...
   send_command vdvEcho,'SERVER=my.ess.server.edu.au'
   send_command vdvEcho,'SERVER CONSUMER KEY=myKey'
   send_command vdvEcho,'SERVER CONSUMER SECRET=gD3myRediculouslyLongGarbledSecret4gjQFqlGKT4qJjuaA=='
   send_command vdvEcho,'SERVER REFRESH=60'  //Every hour.  See below for further dynamic querying of the ESS.
   
   //For stand-alone mode you would instead configure the module like this...
//   send_command vdvEcho,"'DEVICE=',myDeviceIp"
   
   //Regardless of stand-alone or server-based config, you should still do the following...
   send_command vdvEcho,'ROOM=myRoom'  //Setting the room name (even in stand-alone mode) will give you room-name cross checking.
   send_command vdvEcho,'DEVICE REFRESH=5'  //5 seconds
   //If the capture hardware is using non-default credentials you should specify them here.
//   send_command vdvEcho,'DEVICE USERNAME=admin'
//   send_command vdvEcho,'DEVICE PASSWORD=password'
   
   //Optional setting to get TIME= strings when the recording is about to end.
   send_command vdvEcho,'COUNTDOWN=2'  //2 minutes
  }
 }
}

data_event[vdvEcho]{
 string:{
  //How to deal with a fully-DHCP environment, part #1.  Cause: the capture hardware IPs shuffle around, and what
  //was previously our hardware IP is now occupied by a different capture device.
  if(find_string(data.text,'Hardware room name',1) && find_string(data.text,'does not match module room name',1)
     && (length_array(sServerName) > 0)){
   send_command vdvEcho,'SERVER REFRESH'  //Update the hardware details from the server.
  }
 }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
//How to deal with a fully-DHCP environment, part #2.  Cause: the capture hardware has gone offline and we are
//getting no response from the old IP address.  It may have been allocated a new IP, so let's re-query
//the server for details.  You could configure vdvEcho with the command SERVER REFRESH=1 (every minute),
//but that would increase hits/load on the server even while the hardware is online.
wait 600 'Re-query server'{
 if((![vdvEcho,254]) && (length_array(sServerName) > 0)){  //sServerName is defined/updated in EchoSystem config.axi
  send_command vdvEcho,'SERVER REFRESH'
 }
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
