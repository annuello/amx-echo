PROGRAM_NAME='EchoSystem config'
#if_not_defined ECHOSYSTEM_CONFIG_AXI
#define ECHOSYSTEM_CONFIG_AXI
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
(* This is an example of how you can configure the module  *)
(* from a touch panel.  The module can be configured in two*)
(* different ways: server-based or stand-alone.  Refer to  *)
(* the documentation and EchoSystem demo.axs for details.  *)
(*                                                         *)
(* Regardless of which approach is used, you must still    *)
(* specify how frequently the AMX contacts the capture     *)
(* hardware.  The countdown feature is optional.           *)
(*                                                         *)
(* You may prefer to configure it from a file which resides*)
(* on the AMX.  This would allow you to secure the config  *)
(* via credentials rather than "hidden" admin pages.  This *)
(* touch-panel based page is just to help you get up and   *)
(* running quickly.                                        *)
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
bvtCfServerName           = 171
bvtCfServerConsumerKey    = 172
bvtCfServerConsumerSecret = 173
bvtCfServerRefresh        = 174
bvtCfRoom                 = 175
bvtCfDeviceIP             = 176
bvtCfDeviceUsername       = 177
bvtCfDevicePassword       = 178
bvtCfDeviceRefresh        = 179
bvtCfCountdown            = 170

//Some constants to indicate what the current keypad value is to be used for
kNone                 = 0
kServerName           = 1
kServerConsumerKey    = 2
kServerConsumerSecret = 3
kServerRefresh        = 4
kRoom                 = 5
kDeviceIp             = 6
kDeviceUsername       = 7
kDevicePassword       = 8
kDeviceRefresh        = 9
kCountdown            = 10

(***********************************************************)
(*              VARIABLE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_VARIABLE
volatile char sServerName[128]
volatile char sServerConsumerKey[100]
volatile char sServerConsumerSecret[100]
volatile integer iServerRefresh
volatile char sRoom[255]
volatile char sDeviceIP[15]
volatile char sDeviceUsername[50]
volatile char sDevicePassword[50]
volatile integer iDeviceRefresh
volatile integer iCountdown

volatile integer eUserInput
devchan dcConfig[] = {{dvTp,bvtCfServerName},{dvTp,bvtCfServerConsumerKey},{dvTp,bvtCfServerConsumerSecret},{dvTp,bvtCfServerRefresh},
                      {dvTp,bvtCfRoom},
		      {dvTp,bvtCfDeviceIP},{dvTp,bvtCfDeviceUsername},{dvTp,bvtCfDevicePassword},{dvTp,bvtCfDeviceRefresh},
		      {dvTp,bvtCfCountdown}}

(***********************************************************)
(*             SUBROUTINE DEFINITIONS GO BELOW             *)
(***********************************************************)
define_function RefreshTPConfig(){
   //Audit the module to update our local copy of each variable.
   send_command vdvEcho,'SERVER?'
   send_command vdvEcho,'SERVER CONSUMER KEY?'
   send_command vdvEcho,'SERVER CONSUMER SECRET?'
   send_command vdvEcho,'SERVER REFRESH?'
   send_command vdvEcho,'ROOM?'
   send_command vdvEcho,'DEVICE?'
   send_command vdvEcho,'DEVICE USERNAME?'
   send_command vdvEcho,'DEVICE PASSWORD?'
   send_command vdvEcho,'DEVICE REFRESH?'
   send_command vdvEcho,'COUNTDOWN?'
}

(***********************************************************)
(*                  THE EVENTS GOES BELOW                  *)
(***********************************************************)
DEFINE_EVENT
data_event[vdvEcho]{
 string:{
  //This is how we can parse the response from vdvEcho.
  if(find_string(data.text,'SERVER=',1) == 1){
   remove_string(data.text,'SERVER=',1)
   sServerName = data.text
   send_command dvTp,"'!T', bvtCfServerName, sServerName"
  }
  else if(find_string(data.text,'SERVER CONSUMER KEY=',1) == 1){
   remove_string(data.text,'SERVER CONSUMER KEY=',1)
   sServerConsumerKey = data.text
   send_command dvTp,"'!T', bvtCfServerConsumerKey, sServerConsumerKey"
  }
  if(find_string(data.text,'SERVER CONSUMER SECRET=',1) == 1){
   remove_string(data.text,'SERVER CONSUMER SECRET=',1)
   sServerConsumerSecret = data.text
   send_command dvTp,"'!T', bvtCfServerConsumerSecret, sServerConsumerSecret"
  }
  else if(find_string(data.text,'SERVER REFRESH=',1) == 1){
   remove_string(data.text,'SERVER REFRESH=',1)
   iServerRefresh = atoi(data.text)
   send_command dvTp,"'!T', bvtCfServerRefresh, itoa(iServerRefresh)"
  }
  else if(find_string(data.text,'ROOM=',1) == 1){
   remove_string(data.text,'ROOM=',1)
   sRoom = data.text
   send_command dvTp,"'!T', bvtCfRoom, sRoom"
  }
  else if(find_string(data.text,'DEVICE=',1) == 1){
   remove_string(data.text,'DEVICE=',1)
   sDeviceIP = data.text
   send_command dvTp,"'!T', bvtCfDeviceIP, sDeviceIP"
  }
  else if(find_string(data.text,'DEVICE USERNAME=',1) == 1){
   remove_string(data.text,'DEVICE USERNAME=',1)
   sDeviceUsername = data.text
   send_command dvTp,"'!T', bvtCfDeviceUsername, sDeviceUsername"
  }
/*
//You will need to obtain the device password from your EchoSystem Server
//administrator if they have changed it from the default.
  else if(find_string(data.text,'DEVICE PASSWORD=',1) == 1){
   remove_string(data.text,'DEVICE PASSWORD=',1)
   sDevicePassword = data.text
   send_command dvTp,"'!T', bvtCfDevicePassword, sDevicePassword"
  }
*/
  else if(find_string(data.text,'DEVICE PASSWORD is not empty',1) == 1){
   send_command dvTp,"'!T',bvtCfDevicePassword,'*****'"
  }
  else if(find_string(data.text,'DEVICE REFRESH=',1) == 1){
   remove_string(data.text,'DEVICE REFRESH=',1)
   iDeviceRefresh = atoi(data.text)
   send_command dvTp,"'!T', bvtCfDeviceRefresh, itoa(iDeviceRefresh)"
  }
  else if(find_string(data.text,'COUNTDOWN=',1) == 1){
   remove_string(data.text,'COUNTDOWN=',1)
   iCountdown = atoi(data.text)
   send_command dvTp,"'!T', bvtCfCountdown, itoa(iCountdown)"
  }
 }
}

button_event[dvTp,1]{  //Go to the Config page.
 push:{
  RefreshTPConfig()
 }
}

button_event[dcConfig]{
 push:{
  eUserInput = get_last(dcConfig)
 }
 release:{
  switch(eUserInput){
   case kServerName:
    send_command dvTp,"'@AKB-',sServerName,';Server Name'"
    break;
   case kServerConsumerKey:
    send_command dvTp,"'@AKB-',sServerConsumerKey,';Server Consumer Key'"
    break;
   case kServerConsumerSecret:
    send_command dvTp,"'@AKB-',sServerConsumerSecret,';Server Consumer Secret'"
    break;
   case kServerRefresh:
    send_command dvTp,"'@AKP-',itoa(iServerRefresh),';Server Refresh (min)'"
    break;
   case kRoom:
    send_command dvTp,"'@AKB-',sRoom,';Room'"
    break;
   case kDeviceIp:
    send_command dvTp,"'@AKB-',sDeviceIP,';Device IP'"
    break;
   case kDeviceUsername:
    send_command dvTp,"'@AKB-',sDeviceUsername,';Device Username'"
    break;
   case kDevicePassword:
    send_command dvTp,"'@PKB-',sDevicePassword,';Device Password'"
    break;
   case kDeviceRefresh:
    send_command dvTp,"'@AKP-',itoa(iDeviceRefresh),';Device Refresh (sec)'"
    break;
   case kCountdown:
    send_command dvTp,"'@AKP-',itoa(iCountdown),';Countdown (min)'"
    break;
  }
 }
}

data_event[dvTp]{
 online:{
  wait 70{
   RefreshTPConfig()
  }
 }
 string:{
  if(find_string(data.text,'KEYB-',1) == 1){  //Keyboard data
   remove_string(data.text,'KEYB-',1)
   if(find_string(data.text,'ABORT',1) != 1){
    switch(eUserInput){
     //Server-based config
     case kServerName:
      sServerName = data.text
      send_command dvTp,"'!T',bvtCfServerName,sServerName"
      send_command vdvEcho,"'SERVER=',sServerName"
      eUserInput = kNone
      break;
     case kServerConsumerKey:
      sServerConsumerKey = data.text
      send_command dvTp,"'!T',bvtCfServerConsumerKey,sServerConsumerKey"
      send_command vdvEcho,"'SERVER CONSUMER KEY=',sServerConsumerKey"
      eUserInput = kNone
      break;
     case kServerConsumerSecret:
      sServerConsumerSecret = data.text
      send_command dvTp,"'!T',bvtCfServerConsumerSecret,sServerConsumerSecret"
      send_command vdvEcho,"'SERVER CONSUMER SECRET=',sServerConsumerSecret"
      eUserInput = kNone
      break;
     case kRoom:
      sRoom = data.text
      send_command dvTp,"'!T',bvtCfRoom,sRoom"
      send_command vdvEcho,"'ROOM=',sRoom"
      eUserInput = kNone
      break;
     
     //Stand-alone config
     case kDeviceIp:
      sDeviceIP = data.text
      send_command dvTp,"'!T',bvtCfDeviceIP,sDeviceIP"
      send_command vdvEcho,"'DEVICE=',sDeviceIP"
      eUserInput = kNone
      break;
     case kDeviceUsername:
      sDeviceUsername = data.text
      send_command dvTp,"'!T',bvtCfDeviceUsername,sDeviceUsername"
      send_command vdvEcho,"'DEVICE USERNAME=',sDeviceUsername"
      eUserInput = kNone
      break;
     case kDevicePassword:
      sDevicePassword = data.text
      send_command dvTp,"'!T',bvtCfDevicePassword,sDevicePassword"
      send_command vdvEcho,"'DEVICE PASSWORD=',sDevicePassword"
      eUserInput = kNone
      break;
    }
   }
  }
  if(find_string(data.text,'KEYP-',1) == 1){  //Keypad data
   remove_string(data.text,'KEYP-',1)
   if(find_string(data.text,'ABORT',1) != 1){
    switch(eUserInput){
     //Server-based config
     case kServerRefresh:
      iServerRefresh = atoi(data.text)
      send_command dvTp,"'!T',bvtCfServerRefresh,itoa(iServerRefresh)"
      send_command vdvEcho,"'SERVER REFRESH=',itoa(iServerRefresh)"
      eUserInput = kNone
      break;
     
     //These two should be specified regardless of whether you are using server-based config or stand-alone config.
     case kDeviceRefresh:
      iDeviceRefresh = atoi(data.text)
      send_command dvTp,"'!T',bvtCfDeviceRefresh,itoa(iDeviceRefresh)"
      send_command vdvEcho,"'DEVICE REFRESH=',itoa(iDeviceRefresh)"
      eUserInput = kNone
      break;
     case kCountdown:
      iCountdown = atoi(data.text)
      send_command dvTp,"'!T',bvtCfCountdown,itoa(iCountdown)"
      send_command vdvEcho,"'COUNTDOWN=',itoa(iCountdown)"
      eUserInput = kNone
      break;
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