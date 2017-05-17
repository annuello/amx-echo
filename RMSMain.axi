#if_not_defined RMSMAIN_AXI
#define RMSMAIN_AXI
PROGRAM_NAME='RMSMain'
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
(* This RMS sample is NOT a complete implimentation, since *)
(* the full installation requires numerous RMS modules as  *)
(* provided by AMX.  The code in this file is intended to  *)
(* be copy-n-pasted (i.e. "merged") into your existing RMS *)
(* code to add EchoSystem functionality to your project.   *)
(* This code assumes that the EchoSystem module is set up  *)
(* using the EchoSystem Server-based approach.             *)
(*                                                         *)
(* The RMS code was developed against RMS Server v3.3.     *)
(*                                                         *)
(* Required AMX files:                                     *)
(*  RMS Common.axi, i!-ConnectLinxEngineMod, RMSEngineMod  *)
(*                                                         *)
(* http://opax.swin.edu.au/~romclean/amx/echo              *)
(***********************************************************)
#warn 'RMS code sample needs to be merged into your existing project.'

(***********************************************************)
(*           DEVICE NUMBER DEFINITIONS GO BELOW            *)
(***********************************************************)
DEFINE_DEVICE
//These RMS Core Devices MUST be defined, and should already be defined in your existing RMS code.
vdvRMSEngine             = 35001:1:0
dvRMSSocket              = 0:4:0
vdvCLActions             = 35002:1:0

(***********************************************************)
(*              CONSTANT DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_CONSTANT
//Module channels
chIdle       = 241
chPaused     = 242
chRecording  = 243
chScheduled  = 245
chAdHoc      = 246
chMonitoring = 247
chOnline     = 254

(***********************************************************)
(*                 INCLUDE FILES GO BELOW                  *)
(***********************************************************)
#include 'RMSCommon.axi'

(***********************************************************)
(*              VARIABLE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_VARIABLE
volatile char sRMSServer[] = 'my.rms.server.edu.au'

devchan dcEchoStates[] = {{vdvEcho,chIdle},{vdvEcho,chPaused},{vdvEcho,chRecording},{vdvEcho,chScheduled},{vdvEcho,chAdHoc},{vdvEcho,chMonitoring}}

(***********************************************************)
(*             SUBROUTINE DEFINITIONS GO BELOW             *)
(***********************************************************)
define_function RMSDevMonRegisterCallback(){
/*
 Do your standard device registering here for your non-EchoSystem devices.
 Since the EchoSystem module does not pertain to a physical device (like a serial port)
 we register it differently to traditional RMS devices.
*/
}

define_function RMSDevMonSetParamCallback(dev dvDPS, char cName[], char cValue[]){
 //Handle actions that are initiated by RMS web interface. E.g. Param resetting, etc.
 select{
  //This section allows the AMX master to receive information from the RMS server when someone clicks
  //the 'Reset' icon.  This example clears the Warning that may be generated by a fan or storage error.
  active(dvDPS == vdvEcho):{
   if(cName == 'Warning')
    RMSChangeStringParam(vdvEcho,'Warning',RMS_PARAM_SET,'none')
  }
 }
}

(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)

(***********************************************************)
(*                 MODULE CODE GOES BELOW                  *)
(***********************************************************)
define_module 'i!-ConnectLinxEngineMod' mdlCL(vdvCLActions)
//define_module 'RMSSrcUsageMod' mdlSrcUsage(vdvRMSEngine,vdvCLActions)  //You may have this as part of your source-tracking RMS code.
define_module 'RMSEngineMod' mdlRMSEng(vdvRMSEngine,dvRMSSocket,vdvCLActions)

(***********************************************************)
(*                  THE EVENTS GOES BELOW                  *)
(***********************************************************)
DEFINE_EVENT
//This is where we update RMS with the current state of the EchoSystem module.
channel_event[dcEchoStates]{
 on:{
  if([vdvRMSEngine,250]){
   switch(channel.channel){
    case chIdle:
     RMSChangeStringParam(vdvEcho,'State',RMS_PARAM_SET,'Idle')
     break;
    case chPaused:
     //Lets log what type of recording is happening as well.
     if([vdvEcho,chAdHoc])
      RMSChangeStringParam(vdvEcho,'State',RMS_PARAM_SET,'Paused (Ad Hoc)')
     else if([vdvEcho,chMonitoring])
      RMSChangeStringParam(vdvEcho,'State',RMS_PARAM_SET,'Paused (Monitoring)')
     else
      RMSChangeStringParam(vdvEcho,'State',RMS_PARAM_SET,'Paused')
     break;
    case chRecording:
     if([vdvEcho,chAdHoc])
      RMSChangeStringParam(vdvEcho,'State',RMS_PARAM_SET,'Recording (Ad Hoc)')
     else if([vdvEcho,chMonitoring])
      RMSChangeStringParam(vdvEcho,'State',RMS_PARAM_SET,'Recording (Monitoring)')
     else
      RMSChangeStringParam(vdvEcho,'State',RMS_PARAM_SET,'Recording')
     break;
   }
  }
 }
}

//vdvEcho module has established a connection to the capture hardware.
//By registering the device with RMS at this point (rather than at boot time) we can deploy this
//RMS code to many rooms, including those that do not have EchoSystem hardware.  Rooms that lack
//EchoSystem hardware will simply not register the hardware with RMS.
channel_event[vdvEcho,chOnline]{
 on:{
  wait_until([vdvRMSEngine,250]) 'RMS ready for EchoSystem info'{
   //Register module with RMS.
   RMSRegisterDevice(vdvEcho,'EchoSystem','Swinburne','Module')
   RMSRegisterDeviceStringParam(vdvEcho,'Module Version','???',RMS_COMP_NONE,RMS_STAT_NOT_ASSIGNED,false,'???',RMS_PARAM_UNCHANGED,'')
   RMSRegisterDeviceStringParam(vdvEcho,'Hardware Type','',RMS_COMP_NONE,RMS_STAT_EQUIPMENT_USAGE,false,'???',RMS_PARAM_UNCHANGED,'')
   //We want historical data for the following, so register them as Stock parameters.
   RMSRegisterStockStringParam(vdvEcho,'IP Address','',true,'',RMS_COMP_NONE,RMS_STAT_EQUIPMENT_USAGE,false,'???',RMS_PARAM_UNCHANGED,'')
   RMSRegisterStockStringParam(vdvEcho,'Serial','',true,'',RMS_COMP_NONE,RMS_STAT_EQUIPMENT_USAGE,false,'???',RMS_PARAM_UNCHANGED,'')
   RMSRegisterStockStringParam(vdvEcho,'State','',true,'Offline',RMS_COMP_EQUAL_TO,RMS_STAT_MAINTENANCE,true,'Refresh',RMS_PARAM_UNCHANGED,'')
   RMSRegisterStockNumberParam(vdvEcho,'Temperature','C',true,55,RMS_COMP_GREATER_THAN,RMS_STAT_MAINTENANCE,false,0,RMS_PARAM_UNCHANGED,20,0,100)
   RMSRegisterStockNumberParam(vdvEcho,'Storage','%',true,60,RMS_COMP_GREATER_THAN,RMS_STAT_MAINTENANCE,false,0,RMS_PARAM_UNCHANGED,0,0,100)
   RMSRegisterStockStringParam(vdvEcho,'Warning','',true,'none',RMS_COMP_NOT_EQUAL_TO,RMS_STAT_MAINTENANCE,true,'none',RMS_PARAM_UNCHANGED,'none')
   
   RMSNetLinxDeviceOnline(vdvEcho,'EchoSystem')
   //Update current capture state
   select{
    active([vdvEcho,chIdle]):{      RMSChangeStringParam(vdvEcho,'State',RMS_PARAM_SET,'Idle') }
    active([vdvEcho,chPaused]):{    RMSChangeStringParam(vdvEcho,'State',RMS_PARAM_SET,'Paused') }
    active([vdvEcho,chRecording]):{ RMSChangeStringParam(vdvEcho,'State',RMS_PARAM_SET,'Recording') }
   }
   select{
    active([vdvEcho,chScheduled]):{  RMSChangeStringParam(vdvEcho,'Recording Type',RMS_PARAM_SET,'Scheduled') }
    active([vdvEcho,chAdHoc]):{      RMSChangeStringParam(vdvEcho,'Recording Type',RMS_PARAM_SET,'Ad Hoc') }
    active([vdvEcho,chMonitoring]):{ RMSChangeStringParam(vdvEcho,'Recording Type',RMS_PARAM_SET,'Monitoring') }
   }
   
   //Since we have just come online, lets invoke some replies which get caught in the string handler below.
   send_command vdvEcho,'VERSION?'
   send_command vdvEcho,'DEVICE?'
   send_command vdvEcho,'DEVICE TYPE?'
   send_command vdvEcho,'DEVICE SERIAL?'
   send_command vdvEcho,'DEVICE TEMPERATURE?'
  }
 }
 off:{
  cancel_wait 'RMS ready for EchoSystem info'
  if([vdvRMSEngine,250]){  //Capture platform has gone offline
   RMSChangeStringParam(vdvEcho,'State',RMS_PARAM_SET,'Offline')
   RMSNetLinxDeviceOffline(vdvEcho)
  }
 }
}

//In the above registration we sent a few queries to the EchoSystem module to get details of the venue equipment.
//Here we handle the replies from the module and feed the information to RMS.  Whenever the module
//obtains new capture hardware details from the server (IP address, platform type, etc) the module generates
//some string feedback for the new details.  This is caught below and RMS is updated accordingly.
data_event[vdvEcho]{
 string:{
  stack_var char temp[60]

  if([vdvRMSEngine,250]){  //If connection to RMS is up and okay
   if(find_string(data.text,'VERSION=',1)){  //This is the version of the EchoSystem module, not the capture platform or Lectopia server.
    temp = "data.text"                       //It can be useful to put this info into RMS so you can check that all venues are running
    remove_string(temp,'VERSION=',1)         //the same module version.
    if(length_array(temp) > 0)
     RMSChangeStringParam(vdvEcho,'Module Version',RMS_PARAM_SET,temp)
   }
   else if(find_string(data.text,'DEVICE=',1)){  //Capture platform IP address
    temp = "data.text"
    remove_string(temp,'DEVICE=',1)
    if((length_array(temp) > 0) && (find_string(temp,'<undefined>',1) == 0))
     RMSChangeStringParam(vdvEcho,'IP Address',RMS_PARAM_SET,temp)
   }
   else if(find_string(data.text,'DEVICE TYPE=',1)){
    temp = "data.text"
    remove_string(temp,'DEVICE TYPE=',1)
    if(length_array(temp) > 0)
     RMSChangeStringParam(vdvEcho,'Hardware Type',RMS_PARAM_SET,temp)
   }
   else if(find_string(data.text,'DEVICE SERIAL=',1)){
    temp = "data.text"
    remove_string(temp,'DEVICE SERIAL=',1)
    if((length_array(temp) > 0) && (find_string(temp,'<undefined>',1) == 0))
     RMSChangeStringParam(vdvEcho,'Serial',RMS_PARAM_SET,temp)
   }
   else if(find_string(data.text,'DEVICE TEMPERATURE=',1)){
    temp = "data.text"
    remove_string(temp,'DEVICE TEMPERATURE=',1)
    if(length_array(temp) > 0)
     RMSChangeNumberParam(vdvEcho,'Temperature',RMS_PARAM_SET,atoi(temp))
   }
   else if(find_string(data.text,'WARNING=',1)){
    temp = "data.text"
    remove_string(temp,'WARNING=',1)
    if(length_array(temp) > 0){
     if(find_string(temp,'Fan',1))
      RMSChangeStringParam(vdvEcho,'Warning',RMS_PARAM_SET,'fan')
     if(find_string(temp,'disc mount failure',1))
      RMSChangeStringParam(vdvEcho,'Warning',RMS_PARAM_SET,'disc')
     if(find_string(temp,'Refer to hardware logs.',1))
      RMSChangeStringParam(vdvEcho,'Warning',RMS_PARAM_SET,'Check logs')
     if(find_string(temp,'None',1))
      RMSChangeStringParam(vdvEcho,'Warning',RMS_PARAM_SET,'none')
    }
   }
  }
 }
}
level_event[vdvEcho,6]{  //Storage capacity
 RMSChangeNumberParam(vdvEcho,'Storage',RMS_PARAM_SET,level.value)
}

data_event[vdvRMSEngine]{
 online:{
  if(length_array(sRMSServer) > 0)
   RMSSetserver(sRMSServer)
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