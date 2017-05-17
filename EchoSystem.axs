MODULE_NAME='EchoSystem' (dev vdvDevice, dev vdvAppliance, dev vdvServer)
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
(* Roger McLean, Swinburne Uni.  20140123                                                            *)
(*****************************************************************************************************)
(* Commands:                                                                                         *)
(*  ROOM=<room name>                 Set the room name.                              (Max 255 chars) *)
(*  ROOM?                            Get the room name.                                              *)
(*                                                                                                   *)
(*      The search parameter for the following commands is case-insensitive.  Some searches          *)
(*      perform an exact match, while others perform a partial match.                                *)
(*  CAMPUSES?                        Get a list of campuses from the server.                         *)
(*  CAMPUSES?<search>                As above - exact match.                                         *)
(*  BUILDINGS?                       Get a list of buildings from the server.                        *)
(*  BUILDINGS?<search>               As above - exact match.                                         *)
(*  ROOMS?                           Get a list of rooms from the server.                            *)
(*  ROOMS?<search>                   As above - partial match on START of room name. API has bug.    *)
(*  BUILDINGS [on/in/at] CAMPUS?<campus>           Get buildings for campus - exact match.           *)
(*  ROOMS [on/in/at] BUILDING?<campus>:<building>  Get rooms in building.  Exact match.              *)
(*                                                                                                   *)
(*  SERVER=<address[:port]>          Set the IP or DNS address for the server.       (Max 128 chars) *)
(*  SERVER?                          Get the IP or DNS address of the server.                        *)
(*  SERVER REFRESH=<minutes>         Set the server update frequency (minutes).                      *)
(*  SERVER REFRESH?                  Get the above polling frequency.                                *)
(*  SERVER REFRESH                   Poll the server immediatly.                                     *)
(*  SERVER CONSUMER KEY=<key>        Set the Trusted System consumer key.            (Max 100 chars) *)
(*  SERVER CONSUMER KEY?             Get the Trusted System consumer key.                            *)
(*  SERVER CONSUMER SECRET=<secret>  Set the Trusted System consumer secret.         (Max 100 chars) *)
(*  SERVER CONSUMER SECRET?          Get the Trusted System consumer secret.                         *)
(*  SERVER PRODUCT GROUPS?           Get all EchoSystem product groups.                              *)
(*                                                                                                   *)
(*  DEVICE?                          Get the IP address of the device.                               *)
(*  DEVICE=<ip address>              Set the IP address of the device.                               *)
(*  DEVICE TYPE?                     Get the device type.                                            *)
(*  DEVICE REFRESH=<seconds>         Set the device update frequency (seconds).                      *)
(*  DEVICE REFRESH?                  Get the above polling frequency.                                *)
(*  DEVICE USERNAME=<value>          Set the device username.                                        *)
(*  DEVICE USERNAME?                 Get the device username.                                        *)
(*  DEVICE PASSWORD=<value>          Set the device password.                                        *)
(*  DEVICE SERIAL?                   Get the serial for the device hardware.                         *)
(*  DEVICE TEMPERATURE?              Get the device temperature.                                     *)
(*  DEVICE PRODUCT GROUPS?           Get a list of supported Product Groups.                         *)
(*  DEVICE CAPTURE PROFILES?         *Alias of above for backwards compatability.  Deprecated.*      *)
(*  DEVICE FIRMWARE?                 Get the firmware version of the device.                         *)
(*  DEVICE API?                      Get the API version in use on the device.                       *)
(*  DEVICE REBOOT                    Issue a reboot request to the device.                           *)
(*                                                                                                   *)
(*  COUNTDOWN=<minutes>                                                                              *)
(*  COUNTDOWN?                                                                                       *)
(*  PRESENTERS?                      Get the preseter names for the current recording.               *)
(*                                                                                                   *)
(*  STOP                                                                                             *)
(*  PAUSE                                                                                            *)
(*  RESUME                                                                                           *)
(*  EXTEND=<minutes>                 Minimum 1, maximum 30                                           *)
(*  AD HOC=<description>;<duration>;<product group>                                                  *)
(*                               Start an Ad Hoc recording.  Duration is in minutes.  Product Groups *)
(*                               can be obtained via the DEVICE PRODUCT GROUPS? query.               *)
(*  CURRENT PRODUCT GROUP?           Get the product group for the current recording.                *)
(*  TITLE?                           Get the title for the current recording.                        *)
(*                                                                                                   *)
(*  DUMP                         Dumps traffic from server/appliance to file for 1 minute.           *)
(*  DEBUG=<level>                                                                                    *)
(*   <level>  0 = OFF                                                                                *)
(*            1 = ON             Send errors to vdvDevice                                            *)
(*            2 = VERBOSE        Send errors to 0 for MSG ON                                         *)
(*            3 = HASH           Include SHA1 hashing debug messages.                                *)
(*  DEBUG?                       Get the current debug level.                                        *)
(*  VERSION?                     Get the module version.                                             *)
(*  INFO?                        Get developer contact information.                                  *)
(*                                                                                                   *)
(*  API SERVER GET <query>       Send a query to the server.  Debug level must be >= 2.              *)
(*  API DEVICE GET <query>       Send a query to the device.  Debug level must be >= 2.              *)
(*  API DEVICE POST <query>      Send a query to the device.  Debug level must be >= 2.              *)
(*                                                                                                   *)
(* Channels:                                                                                         *)
(*  230  Uploads pending                                                                             *)
(*  231  Uploads active                                                                              *)
(*  240  Waiting                                                                                     *)
(*  241  Idle                    Idle/Paused/Recording are mutually exclusive.                       *)
(*  242  Paused                                                                                      *)
(*  243  Recording                                                                                   *)
(*                                                                                                   *)
(*  245  Scheduled recording     Scheduled/AdHoc/Monitoring are mutually exclusive.                  *)
(*  246  AdHoc recording                                                                             *)
(*  247  Monitoring only                                                                             *)
(*  249  Live streaming                                                                              *)
(*                                                                                                   *)
(*  251  Audio detected                                                                              *)
(*  252  Video 1 sync detected                                                                       *)
(*  253  Video 2 sync detected                                                                       *)
(*  254  Hardware online                                                                             *)
(*                                                                                                   *)
(* Levels:                                                                                           *)
(*  1    Audio left                                                                                  *)
(*  2    Audio right                                                                                 *)
(*  3    Recording progress      0 = 0%, 100 = 100%                                                  *)
(*  5    Temperature             0 = 0 deg C, 100 = 100 dec C                                        *)
(*  6    Disk usage              0 = 0%, 100 = 100%                                                  *)
(*                                                                                                   *)
(*****************************************************************************************************)
//ASCII Art generator - http://patorjk.com/software/taag/  Font=StarWars
//OAuth tutorial      - http://hueniverse.com/oauth/guide/authentication/

/*
Known Issues:
HTTP requests to ESS do not contain Content-Length or Connection headers.  Assumes persistent behaviour from ESS, but is not explicitly coded.

Fixed Bugs:
1) RecordingType channels activate while CA is in Idle state.  Fixed in v3.0.1.
2) ESS v5.1 responding with 403 error for all API reqeuests.  OAuth timestamp_refused due to bad handeling of leap-days in getSecondsSinceEpoch().  Fixed in v3.0.2.
3) oauth_signature not URLEncoded.  Fixed in v3.0.2.
4) oauth_consumer_key was hard coded as "key".  Fixed in v3.0.2.
5) DEVICE CAPTURE PROFILE=<profile> response did not un-encode the & < and > characters, making it awkward to intiate an AdHoc recording.  Fixed in v3.0.2.
6) Parsing of Capture Appliance logs assumed 40 entires would fit in buffer.  Made log-parsing more robust.  Fixed in v3.1.0.
7) Bug in log parsing for Capture Appliance (Gen 1) temperature caused loop/lockup of AMX.  Fixed in v3.1.1.
8) status/system was using POST method.  Fixed using GET method in v3.2.0.
9) False IDLE state being generated from Content/Log upload response in status/system.  Fixed in v3.2.0.
10) Various responses contained HTML/UTF-8 encoded characters which were passed as-is.  Fixed in v3.2.0.
11) Dropped buggy RECORDING INPUTS in favour for CURRENT PRODUCT GROUP.  Appliance API v3.0 introduced change.  Fixed in module v3.2.0.
------ new release ------
12) When appliance supports persistent sockets, the module would send the server buffer rather than device buffer to the appliance.  Fixed in v3.2.2.
13) Persistent socket behavior not working correctly.  Fixed in v3.3.0.  PersistentSockets only used for SafeCapHD with NGINX HTTP server (>= v5.4.xxxxx).
14) SafeCapHD v5.4 (NGINX httpd) prior to v5.4.38789 (dev versions) demanded "Content-Length: 0" for POST messages without any message body.  Reported to Echo360 (JIRA US-10268).  Fixed in 5.4.38789.
15) Have observed a case where the module repeated alernates between /status/system, /log-list... and /status/current_capture queries while SCHD is idle.  Terminal shows "Checking hardware details..."  Fixed in v3.3.0.
16) Log parsing issues.  If we request too few we miss temperature.  If we request too many we can lose most recent entries due to buffer FIFO.  Fixed in v3.3.0
17) ESS rooms/{roomID}/devices replies with all devices ever associated with the room.  Instead we now parse rooms/{roomID} for <current-device>.  Fixed in v3.3.0
------ new release ------

Echo360 Bugs/Feature requests:
1) US-9693.  ESS v5.3 onwards uses "filter" instead of "term" (deprecated).  Requested ESS version info in ScheduleAPI replies.
             Zig has suggested http://{ESS URL}/ess/scheduleapi/v1/versions for future inclusion.  Have coded the moudle to dynamically figure it out.
2) US-9694.  ESS API does not reveal credentials for appliance.  Credentials must be manually set.
3) US-10945. Fan tachometer is somtimes reporting 0 rpm immediately after powerup.
*/
//#define DEVELOPMENT_PHASE
//#define BETA_RELEASE

define_constant
char cVersion[] = '3.3.0'  //Addressed persistent socket issues.  Overhauled log parsing.  Fixed issue when ESS reports multiple devices associated with room.  Report Presenter name.  Added "progress" level indicator.  Removed DEVICE CAPTURE PROFILES terminology.
//char cVersion[] = '3.2.2'  //"Fixed" buffer when appliance supports persistent sockets.  Was sending server buffer rather than device buffer.  Socket behavior still faulty.
//char cVersion[] = '3.2.1c'  //Added option for dumping reply-packets.
//char cVersion[] = '3.2.1b'  //Added option for specifying server port.
//char cVersion[] = '3.2.0'  //Improved room cross-checking.  Added Campus:Building to Rooms wizard and CURRENT PRODUCT GROUP feedback.  Removed RECORDING INPUTS feedback.
//char cVersion[] = '3.1.1'  //Fixed bug with Capture Appliance (Gen 1) temperature parsing, which could get the module stuck in a loop.
//char cVersion[] = '3.1.0'  //Added Live channel.  Fixed: OAuth, CA Log parsing, RecType channel feedback, CaptureProfiles &,<,> characters.
//char cVersion[] = '3.0.1'  //Fixed RecordingType feedback when in Idle state.  Pulled immediatly after discovering hard-coded credentials.
//char cVersion[] = '3.0.0'  //Initial release.

//http://www.epochconverter.com/
//When releasing Beta versions of the module we can prevent the module from working beyond a particular epoch.
slong BETA_EPOCH = 1352980800  //15 Nov 2012 12:00:00 GMT

//Time constants for calculating time remaining in a recording and oauth_timestamp.
//Partially inspired by http://code.google.com/p/amx-netlinx-common/source/browse/trunk/unixtime.axi
integer EPOCH_YEAR = 1970  //Epoch moment is taken as January 1, 1970 00:00:00 GMT
long SECONDS_PER_YEAR      = 31536000
long SECONDS_PER_MONTH[12] = { 2678400, 2419200, 2678400, 2592000, 2678400, 2592000,
                               2678400, 2678400, 2592000, 2678400, 2592000, 2678400}
long SECONDS_PER_WEEK      = 604800
long SECONDS_PER_DAY       = 86400
long SECONDS_PER_HOUR      = 3600
long SECONDS_PER_MINUTE    = 60
char MONTH[12][3] = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}

//Hashing constants
integer MAX_INPUT_CHUNK_BYTES = 2000  //Number of bytes per chunk we wish to deal with at a time.  Must be <=2048 due to NetLinx fn() param limitations.
integer MESSAGE_BLOCK_SIZE = 64  //64 bytes (for SHA1)
char iFormatHuman  = 1  //'01234567 89abcdef'  //Hex value as ASCII printable range, with space character every 8 characters
char iFormatString = 2  //'0123456789abcdef'  //As above, but with no space
char iFormatHex    = 3  //$01,$23,$45,$67,$89,$ab,$cd,$ef  //Above value, but hex pairs converted to an 8-bit byte.

//Timelines
long tlServerRefresh = 1
long tlDeviceRefresh = 2
long tlDeviceHealth  = 3

//EchoSystem Server
integer SERVER_INCOMMING_BUFFER_SIZE = 20000
char    SERVER_BASE_URI[] = '/ess/scheduleapi/v1/'
integer SERVER_DEFAULT_HTTP_PORT = 8080
char    ipProtocol[] = 'http'
char crlf[2] = {13,10}
integer MAX_SERVER_RESENDS = 3

//Server queries
char eNone               = 0
char eRoom               = 1  //Get RoomID for specified RoomName.  Expecting one match.  Warn/bail if != 1.
char eRoomCurrentDevice  = 2  //Get the DeviceID for the device currently associated with the room.
char eDeviceDetails      = 3  //Get Device details (IP, etc) for specified DeviceId.
char eCampuses           = 4
char eBuildings          = 5
char eRooms              = 6
char eBuildingsOnCampus  = 7
char eRoomsInBuilding    = 8
char eCampusBuildingRoom = 9
char eProductGroups      = 10

//EchoSystem Capture Appliance
char typeUnknown = 0
char typeProHarwareCapture    = 1
char typeBasicHardwareCapture = 2
//integer DEVICE_INCOMMING_BUFFER_SIZE = 20000
integer DEVICE_INCOMMING_BUFFER_SIZE = 65535
integer DEVICE_MAX_LOG_ENTRIES = 300
integer MAX_DEVICE_RESENDS = 3
integer DEVICE_DEFAULT_HTTP_PORT = 8080

//Device queries
char eGetState     = 1
char eGetSysStatus = 2
char eGetLogs      = 3
char ePause        = 4
char eResume       = 5
char eStop         = 6
char eExtend       = 7
char eAdHoc        = 8
char eReboot       = 9

//Module feedback channels
chUploadPending = 230
chUploadActive  = 231
chWaiting        = 240  //Not mutex with Idle/Pause/Rec
chIdle           = 241
chPaused         = 242
chRecording      = 243
chScheduled      = 245
chAdHoc          = 246
chMonitoring     = 247
chLive           = 249
chAudioDetect    = 251
chVideo1Detect   = 252
chVideo2Detect   = 253
chHardwareOnline = 254

//Debug levels
char db_public     = 0
char db_integrator = 1
char db_developer  = 2
char db_hash       = 3

define_type
structure SHA1Context{
 long Message_Digest[5];    //Message Digest (output)
 long Length_Low;           //Message length in bits
 long Length_High;          //Message length in bits
 char Message_Block[MESSAGE_BLOCK_SIZE];  //512-bit message blocks
 char Corrupted;  //Is the message digest corrupted?
}

structure LogEntry{
 long epochTime
 char name[30]
 char value[30]
}

define_variable
volatile char ES_iDebugLevel
volatile char ES_bDump
volatile slong ES_hDumpFile
volatile ip_address_struct ES_ipMyAddress
volatile char ES_sRoomName[255]
volatile char ES_sRoomID[255]
volatile char ES_sBuildingName[255]
volatile char ES_sBuildingID[255]
volatile char ES_sCampusName[255]
volatile char ES_sCampusID[255]
volatile char ES_sLongResponse[2000]

//Log lookup table for audio level translations.  Each table has 256 entries.
//Derrived from http://www.sosmath.com/tables/logtable/logtable.html
//Extensive audio tests on the Capture Appliance Gen 1 Rev F hardware resulted in the following measurments:
//Sinewave @ 1kHz & 4kHz: Effective input range is -40dBu to -5dBu inclusive.
//API reports the following: -40dBu=1702, -5dBu=32455
volatile integer ES_iLogTableCaptureAppliance[] = {
 1702,  1715,  1728,  1741,  1754,  1767,  1781,  1794,  1808,  1822,  1836,  1851,  1866,  1880,  1895,  1911,
 1926,  1942,  1958,  1974,  1991,  2007,  2024,  2041,  2058,  2076,  2094,  2112,  2130,  2149,  2168,  2187,
 2206,  2226,  2246,  2266,  2287,  2307,  2329,  2350,  2372,  2394,  2416,  2439,  2462,  2485,  2508,  2532,
 2557,  2581,  2606,  2631,  2657,  2683,  2710,  2736,  2763,  2791,  2819,  2847,  2876,  2905,  2935,  2964,
 2995,  3026,  3057,  3088,  3121,  3153,  3186,  3220,  3254,  3288,  3323,  3358,  3394,  3431,  3467,  3505,
 3543,  3581,  3620,  3660,  3700,  3741,  3782,  3824,  3867,  3910,  3953,  3998,  4042,  4088,  4134,  4181,
 4228,  4277,  4325,  4375,  4425,  4476,  4528,  4580,  4633,  4687,  4742,  4797,  4853,  4910,  4968,  5027,
 5086,  5146,  5207,  5269,  5332,  5396,  5461,  5526,  5592,  5660,  5728,  5797,  5868,  5939,  6011,  6085,
 6159,  6234,  6311,  6388,  6467,  6546,  6627,  6709,  6792,  6877,  6962,  7049,  7137,  7226,  7316,  7408,
 7501,  7595,  7691,  7787,  7886,  7985,  8087,  8189,  8293,  8398,  8505,  8614,  8724,  8835,  8948,  9063,
 9179,  9297,  9417,  9538,  9661,  9786,  9912, 10040, 10170, 10302, 10436, 10572, 10709, 10848, 10990, 11133,
11279, 11426, 11576, 11727, 11881, 12037, 12195, 12356, 12519, 12683, 12851, 13020, 13192, 13367, 13544, 13723,
13905, 14090, 14277, 14466, 14659, 14854, 15052, 15252, 15456, 15662, 15871, 16084, 16299, 16517, 16738, 16963,
17190, 17421, 17655, 17892, 18133, 18377, 18625, 18876, 19130, 19388, 19650, 19915, 20184, 20457, 20734, 21015,
21300, 21588, 21881, 22178, 22479, 22784, 23094, 23408, 23726, 24049, 24376, 24708, 25045, 25386, 25733, 26084,
26440, 26801, 27167, 27538, 27915, 28297, 28684, 29077, 29475, 29879, 30288, 30704, 31125, 31552, 31985, 32424
}
//Extensive audio tests on the SafeCapture HD hardware resulted in the following measurments:
//Sinewave @ 1kHz & 4kHz: Effective input range is -40dBu to +0dBu inclusive.
//API reports the following: -40dBu=436, +0dBu=32768
volatile integer ES_iLogTableSafeCaptureHD[] = {
  549,   558,   567,   576,   585,   594,   604,   614,   624,   634,   644,   654,   665,   676,   686,   698,
  709,   720,   732,   744,   756,   768,   780,   793,   806,   819,   832,   845,   859,   873,   887,   901,
  916,   930,   945,   961,   976,   992,  1008,  1024,  1041,  1057,  1074,  1092,  1109,  1127,  1145,  1164,
 1183,  1202,  1221,  1241,  1261,  1281,  1302,  1323,  1344,  1366,  1388,  1410,  1433,  1456,  1480,  1504,
 1528,  1552,  1577,  1603,  1629,  1655,  1682,  1709,  1736,  1764,  1793,  1822,  1851,  1881,  1911,  1942,
 1974,  2005,  2038,  2071,  2104,  2138,  2172,  2207,  2243,  2279,  2316,  2353,  2391,  2430,  2469,  2509,
 2549,  2590,  2632,  2675,  2718,  2762,  2806,  2851,  2897,  2944,  2992,  3040,  3089,  3139,  3189,  3241,
 3293,  3346,  3400,  3455,  3511,  3567,  3625,  3683,  3743,  3803,  3864,  3927,  3990,  4054,  4120,  4186,
 4254,  4322,  4392,  4463,  4535,  4608,  4682,  4758,  4835,  4913,  4992,  5072,  5154,  5237,  5322,  5408,
 5495,  5583,  5674,  5765,  5858,  5953,  6049,  6146,  6245,  6346,  6448,  6552,  6658,  6765,  6874,  6985,
 7098,  7212,  7329,  7447,  7567,  7689,  7813,  7939,  8067,  8197,  8330,  8464,  8600,  8739,  8880,  9023,
 9169,  9317,  9467,  9620,  9775,  9933, 10093, 10255, 10421, 10589, 10760, 10933, 11110, 11289, 11471, 11656,
11844, 12035, 12229, 12426, 12627, 12830, 13037, 13248, 13461, 13678, 13899, 14123, 14351, 14582, 14818, 15057,
15299, 15546, 15797, 16052, 16311, 16574, 16841, 17113, 17389, 17669, 17954, 18244, 18538, 18837, 19141, 19449,
19763, 20082, 20406, 20735, 21069, 21409, 21754, 22105, 22462, 22824, 23192, 23566, 23946, 24333, 24725, 25124,
25529, 25941, 26359, 26784, 27216, 27655, 28101, 28554, 29015, 29483, 29959, 30442, 30933, 31432, 31939, 32454
}  //256 entries in table.

//Hashing variables
//Base 64 encoding table
volatile char cEncrBase64[] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',   //  0 to  7
                               'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',   //  8 to 15
                               'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',   // 16 to 23
                               'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',   // 24 to 31
                               'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',   // 32 to 39
                               'o', 'p', 'q', 'r', 's', 't', 'u', 'v',   // 40 to 47
                               'w', 'x', 'y', 'z', '0', '1', '2', '3',   // 48 to 55
                               '4', '5', '6', '7', '8', '9', '+', '/'}   // 56 to 63
SHA1Context SH_sha1Context
constant long K[4] = {$5A827999,$6ED9EBA1,$8F1BBCDC,$CA62C1D6}  //SHA1 'K' constants
volatile char SH_InputBuffer[MAX_INPUT_CHUNK_BYTES + MESSAGE_BLOCK_SIZE]
volatile char SH_HMACSHA1_key[MAX_INPUT_CHUNK_BYTES]
volatile char SH_HMACSHA1_message[MAX_INPUT_CHUNK_BYTES]

//EchoSystem Server variables
volatile char ES_sServerAddress[128]        // echosystem.your.institution.edu
volatile integer ES_iServerPort

volatile char ES_sServerOutgoingBuffer[5000]
volatile char ES_sServerIncomingBuffer[SERVER_INCOMMING_BUFFER_SIZE]
#if_defined DEVELOPMENT_PHASE
char DEBUG_ServerBuffer1[SERVER_INCOMMING_BUFFER_SIZE]
char DEBUG_ServerBuffer2[SERVER_INCOMMING_BUFFER_SIZE]
volatile char DEBUG_SigBaseString[2000]
volatile char DEBUG_HmacKey[2000]
volatile char DEBUG_Signature[2000]
volatile char DEBUG_SigBase64[2000]
#end_if

volatile char ES_sServerConsumerKey[100]  //Minimum 89 chars required
volatile char ES_sServerConsumerSecret[100]  //Minimum 89 chars required
volatile char ES_sOAuthSignature[1024]
volatile slong ES_iServerTimeOffset
volatile slong ES_iServerTime  //Used for beta-release timeout.
volatile char ES_eServerQuery
volatile long ES_iServerRefreshTime[] = {0}
volatile integer ES_iServerResends
volatile char ES_bServerPortOpen
volatile char ES_bServerDateExtracted
volatile char ES_bServerRefreshInProgress
volatile char ES_sSearchParamName[6]  //ScheduleAPI supports "filter" from v5.3 onwards.  "term" (pre v5.3) is deprecated.
volatile char ES_sSearchParamValue[100]
volatile char ES_sServerVersion[50]

//EchoSystem Capture Appliance variables
volatile char ES_sDeviceID[255]  //E.g. f286bd42-8beb-4713-a678-46041d786551
volatile char ES_sDeviceIP[15]  //255.255.255.255
volatile integer ES_iDevicePort
volatile char ES_sDeviceUsername[50]  //default 'admin'
volatile char ES_sDevicePassword[50]  //default 'password'
volatile char ES_sDeviceKey[128]      //default 'YWRtaW46cGFzc3dvcmQ='
volatile char ES_sDeviceSerial[17]  //00-AA-BB-CC-DD-EE
volatile char ES_sDeviceOutgoingBuffer[5000]
volatile char ES_sDeviceIncomingBuffer[DEVICE_INCOMMING_BUFFER_SIZE]
#if_defined DEVELOPMENT_PHASE
char DEBUG_DeviceBuffer1[DEVICE_INCOMMING_BUFFER_SIZE]
char DEBUG_DeviceBuffer2[DEVICE_INCOMMING_BUFFER_SIZE]
#end_if
volatile char ES_eDeviceType
volatile char ES_eDeviceQuery
volatile long ES_iDeviceRefreshTime[] = {0}
volatile long ES_iDeviceHealthTime[] = {60000}  //Every minute
volatile char ES_bDevicePersistentSocket
volatile char ES_bDevicePortOpen
volatile char ES_bDevicePortBusy
volatile char ES_iDeviceAudioLevelLeft
volatile char ES_iDeviceAudioLevelRight
volatile sinteger ES_iDeviceTemperature
volatile char    ES_iDeviceTemperatureExplicit
volatile sinteger ES_iDeviceSensorArray[6]
volatile char    ES_iDeviceProductGroupsExplicit
volatile integer ES_iDeviceTimeRemaining
volatile integer ES_iDeviceTimeThreshold
volatile integer ES_iDeviceExtendBy
volatile char ES_sDeviceAPIVersions[20]
volatile char ES_SDeviceFWVersion[20]
volatile char ES_bGetHardwareDetails
volatile char ES_bCurrentTitle
volatile char ES_bCurrentPresenters
volatile char ES_bCurrentProductGroup
volatile LogEntry ES_aDeviceLog[11]  //Temperature 1->6, Fan 1->3, /data volume, applianceClockDrift

define_function char moduleDisabled(){
/*
To enable beta-releases we want to ensure that the module is not used beyond an expiration date/time.
We could base this on the local clock, but that would allow the end used to skew their clock to continue to run the module.
We could base this on the server or CA clock derrived from the HTTP reply.  These aught to be time-synced so this is more accurate.
*/ 
 #if_defined BETA_RELEASE
 if(ES_iServerTime >= BETA_EPOCH){
  total_off[vdvDevice,chIdle]
  total_off[vdvDevice,chPaused]
  total_off[vdvDevice,chRecording]
  total_off[vdvDevice,chScheduled]
  total_off[vdvDevice,chAdHoc]
  total_off[vdvDevice,chMonitoring]
  EchoSystemDebugString(db_public,'TIME=')
  EchoSystemDebugString(db_integrator,'Beta module has reached timeout.  Please obtain a General Release edition.')
  return true;
 }
 #end_if
 return false;
}

define_function EchoSystemDebugString(char inAudience, char inMessage[]){
 local_var char theMessage[2024]
/*
All DebugStrings have an intended audience.  Delivery to that audience is controlled
by the current DebugLevel.  Delivery may be via the vdvDevice(D), teminal (T) or both. 

   Debug     |                        Audience
   Level     | db_public | db_integrator | db_developer | dv_hash
-------------+-----------+---------------+--------------+----------
 Off/0       |     D     |               |              |
 On/1        |    D+T    |        T      |              |
 SWIN DEV/2  |    D+T    |        T      |      T       |
 SWIN HASH/3 |    D+T    |        T      |      T       |    T

db_public      For the intergrators program to handle.
db_integrator  For the integrator to clarify what is happening.
db_developer   For the developer.
db_hash        Shows OAuth and packet-forming messages.
*/
 //We sometimes chunk the message over multiple lines.
 //We make a copy of it so the original doesn't get chunked.
 theMessage = inMessage
 
 switch(inAudience){
  case db_public:
   send_string vdvDevice,"theMessage"
   if(ES_iDebugLevel > 0){
    send_string 0,"'EchoSystem: ',left_string(theMessage,100)"
    while(length_array(theMessage) > 100){
     theMessage = right_string(theMessage,length_array(theMessage)-100)
     send_string 0,"'EchoSystem  ',left_string(theMessage,100)"
    }
   }
   break;
  case db_integrator:
   if(ES_iDebugLevel >= 1){
    send_string 0,"'EchoSystem: ',left_string(theMessage,100)"
    while(length_array(theMessage) > 100){
     theMessage = right_string(theMessage,length_array(theMessage)-100)
     send_string 0,"'EchoSystem  ',left_string(theMessage,100)"
    }
   }
   break;
  case db_developer:
   if(ES_iDebugLevel >= 2){
    send_string 0,"'EchoSystem!: ',left_string(theMessage,100)"
    while(length_array(theMessage) > 100){
     theMessage = right_string(theMessage,length_array(theMessage)-100)
     send_string 0,"'EchoSystem!  ',left_string(theMessage,100)"
    }
   }
   break;
  case db_hash:
   if(ES_iDebugLevel >= 3){
    theMessage = inMessage
    send_string 0,"'EchoSystem#: ',left_string(theMessage,100)"
    while(length_array(theMessage) > 100){
     theMessage = right_string(theMessage,length_array(theMessage)-100)
     send_string 0,"'EchoSystem#  ',left_string(theMessage,100)"
    }
   }
   break;
  default:  //Unknown destination
   theMessage = inMessage
   send_string 0,"'EchoSystem?: ',left_string(theMessage,100)"
   while(length_array(theMessage) > 100){
    theMessage = right_string(theMessage,length_array(theMessage)-100)
    send_string 0,"'EchoSystem?  ',left_string(theMessage,100)"
   }
   break;
 }
}
define_function char versionCompare(char inA[], char inOperator[], char inB[]){
 stack_var integer aMajor
 stack_var integer aMinor
 stack_var integer aRev
 stack_var integer bMajor
 stack_var integer bMinor
 stack_var integer bRev
 
 aMajor = atoi(inA)
 remove_string(inA,itoa(aMajor),1)  //Remove the seperating '.' or possible 'rc'/'b' variants.
 aMinor = atoi(inA)
 remove_string(inA,itoa(aMinor),1)
 aRev   = atoi(inA)
 bMajor = atoi(inB)
 remove_string(inB,itoa(bMajor),1)
 bMinor = atoi(inB)
 remove_string(inB,itoa(BMinor),1)
 bRev   = atoi(inB)
 
 select{
  active(inOperator == '>'):{
   if(aMajor > bMajor) return true;
   if(aMajor < bMajor) return false;
   if(aMinor > BMinor) return true;
   if(aMinor < BMinor) return false;
   if(aRev > bRev) return true;
   return false;
  }
  active(inOperator == '>='):{
   if(aMajor > bMajor) return true;
   if(aMajor < bMajor) return false;
   if(aMinor > BMinor) return true;
   if(aMinor < BMinor) return false;
   if(aRev >= bRev) return true;
   return false;
  }
  active(inOperator == '='):{
   if((aMajor == bMajor) && (aMinor == BMinor) && (aRev == bRev))
    return true;
   return false;
  }
  active(inOperator == '<='):{
   if(aMajor < bMajor) return true;
   if(aMajor > bMajor) return false;
   if(aMinor < BMinor) return true;
   if(aMinor > BMinor) return false;
   if(aRev <= bRev) return true;
   return false;
  }
  active(inOperator == '<'):{
   if(aMajor < bMajor) return true;
   if(aMajor > bMajor) return false;
   if(aMinor < BMinor) return true;
   if(aMinor > BMinor) return false;
   if(aRev < bRev) return true;
   return false;
  }
  active(inOperator == '!='):{
   if((aMajor == bMajor) && (aMinor == BMinor) && (aRev == bRev))
    return false;
   return true;
  }
 }
}
define_function integer find_rstring(char inHaystack[], char inNeedle[], integer inStart){
 //Reverse find_string.  Finds last occurance of inNeedle in inHaystack, starting at inStart and working backward.
 stack_var char bFound
 stack_var integer i
 
 if(inStart > length_array(inHaystack))
  i = length_array(inHaystack)
 else
  i = inStart
 while(!bFound && (i > 0)){
  if(find_string(inHaystack,inNeedle,i) == i)
   bFound = true
  i = i - 1
 }
 if(bFound)
  return i + 1
 else
  return 0
}

define_function char[1024] trim(char inString[]){
 stack_var char result[1024]
 stack_var integer len
 stack_var integer start
 stack_var integer end
 stack_var char bFound
 
 result = ''
 len = length_array(inString)
 if(len > 1024)
  EchoSystemDebugString(db_developer,"'trim() inString too long: ',itoa(len)")
 
 start = 1
 bFound = false
 while((start <= len) && (!bFound)){
  if((inString[start] != ' ') && (inString[start] != $09))
   bFound = true
  else
   start = start + 1
 }
 
 end = len
 bFound = false
 while((end > 0) && (!bFound)){
  if((inString[end] != ' ') && (inString[end] != $09))
   bFound = true
  else
   end = end - 1
 }
 
 if(end > 0){
  result = mid_string(inString,start,(end-start + 1))
  return result
 }
 else
  return ''
}

define_function char resolveAudio(integer inValue){
 local_var integer mid
 local_var integer min
 local_var integer max
 
 //For a given "raw" input value, we look up the closest match in the appropriate audio log table.
 min = 1
 max = 256
 
 //The index of the closest match becomes our linear 0-255 value.
 if((ES_eDeviceType == typeBasicHardwareCapture) || (ES_eDeviceType == typeUnknown)){
  //Perform a binary search on the log table for closest match.
  if(inValue <= ES_iLogTableCaptureAppliance[1])
   return 0
  if(inValue >= ES_iLogTableCaptureAppliance[256])
   return 255
  
  while((max - min) > 1){
   mid = (min + max) / 2
   if(ES_iLogTableCaptureAppliance[mid] < inValue)
    min = mid
   else
    max = mid
  }
  //inValue is now somewhere between ES_iLogTableCaptureAppliance[min] and ES_iLogTableCaptureAppliance[max], inclusive.  Return the index which is closest to inValue.
  if(inValue < (ES_iLogTableCaptureAppliance[min] + ((ES_iLogTableCaptureAppliance[max] - ES_iLogTableCaptureAppliance[min]) / 2)))
   return type_cast(min)
  else
   return type_cast(max)
 }
 else if(ES_eDeviceType == typeProHarwareCapture){
  //Perform a binary search on the log table for closest match.
  if(inValue <= ES_iLogTableSafeCaptureHD[1])
   return 0
  if(inValue >= ES_iLogTableSafeCaptureHD[256])
   return 255
  
  while((max - min) > 1){
   mid = (min + max) / 2
   if(ES_iLogTableSafeCaptureHD[mid] < inValue)
    min = mid
   else
    max = mid
  }
  //inValue is now somewhere between ES_iLogTableSafeCaptureHD[min] and ES_iLogTableSafeCaptureHD[max], inclusive.  Return the index which is closest to inValue.
  if(inValue < (ES_iLogTableSafeCaptureHD[min] + ((ES_iLogTableSafeCaptureHD[max] - ES_iLogTableSafeCaptureHD[min]) / 2)))
   return type_cast(min)
  else
   return type_cast(max)
 }
 return 0;
}

define_function char[8] SecondsToTime(long inSeconds){
 stack_var char theTime[8]
 stack_var long theSeconds
 stack_var long theMinutes
 stack_var long theHours

 theSeconds = inSeconds

 if(theSeconds >= 3600){  //We have an hour component
  theHours = theSeconds / 3600
  theSeconds = theSeconds % 3600
 }
 if(theSeconds >= 60){  //We have a minute component
  theMinutes = theSeconds / 60
  theSeconds = theSeconds % 60
 }
 theTime = "format('%02d', theHours),':',format('%02d', theMinutes),':',format('%02d', theSeconds)"
 return theTime
}

/*
.___________. __  .___  ___.  _______     _______..___________.    ___      .___  ___. .______   
|           ||  | |   \/   | |   ____|   /       ||           |   /   \     |   \/   | |   _  \  
`---|  |----`|  | |  \  /  | |  |__     |   (----``---|  |----`  /  ^  \    |  \  /  | |  |_)  | 
    |  |     |  | |  |\/|  | |   __|     \   \        |  |      /  /_\  \   |  |\/|  | |   ___/  
    |  |     |  | |  |  |  | |  |____.----)   |       |  |     /  _____  \  |  |  |  | |  |      
    |__|     |__| |__|  |__| |_______|_______/        |__|    /__/     \__\ |__|  |__| | _|      
*/
define_function char isLeapYear(integer inYear){
//See http://code.google.com/p/amx-netlinx-common/source/browse/trunk/unixtime.axi
 if(inYear % 4 == 0){
  if((inYear % 100 != 0) || (inYear % 400 == 0)){
   return true
  }
 }
 return false
}

define_function long getSecondsSinceEpoch(char inDateTimeString[24]){
 //Sample input: 2010-05-11T05:36:28.964Z
 local_var integer  i
 long result

 result = 0
 result = result + type_cast(atol(mid_string(inDateTimeString,18,2)))                           //Seconds are 0-based.
 result = result + (type_cast(atol(mid_string(inDateTimeString,15,2))) * SECONDS_PER_MINUTE)    //Minutes are 0-based.
 result = result + (type_cast(atol(mid_string(inDateTimeString,12,2))) * SECONDS_PER_HOUR)      //Hours are 0-based.
 result = result + ((type_cast(atol(mid_string(inDateTimeString,9,2)) - 1)) * SECONDS_PER_DAY)  //Days are 1-based.  Subtract 1.
 i = atoi(mid_string(inDateTimeString,6,2)) - 1                                                 //Months are 1-based.  Subtract 1.
 while(i > 0){  //Add the seconds in all previous months for the year to the result (total seconds).
  result = result + SECONDS_PER_MONTH[i]
  i = i - 1
 }
 //Correct for leap years
 i = atoi(mid_string(inDateTimeString,1,4))  //Get the year
 
 if(isLeapYear(i) && (result > (SECONDS_PER_MONTH[1] + SECONDS_PER_MONTH[2])))  //Is timestamp > Feb28, on a leap year? 
  result = result + SECONDS_PER_DAY  //Add an extra days worth of seconds.
 
 //We now have the number of seconds since the start of the year.  Make the time absolute by referencing to EPOCH_YEAR.
 i = i - 1
 while(i >= EPOCH_YEAR){
  result = result + SECONDS_PER_YEAR
  if(isLeapYear(i))
   result = result + SECONDS_PER_DAY
  i = i - 1
 }

 return result
}

/*
 __    __  .___________. _______              ___   
|  |  |  | |           ||   ____|            / _ \  
|  |  |  | `---|  |----`|  |__    ______    | (_) | 
|  |  |  |     |  |     |   __|  |______|    > _ <  
|  `--'  |     |  |     |  |                | (_) | 
 \______/      |__|     |__|                 \___/  
*/
define_function char[2048] UTF8String(char inString[]){
 char cResult[2048]
 char utf8Bytes[4]
 integer i
 
 
 cResult = ''
 for(i=1;i<=length_array(inString);i++){
  if(inString[i] < $80){
   cResult = "cResult,inString[i]"
  }
  else if(inString[i] < $800){
   utf8Bytes[1] = type_cast((inString[i] >> 6) | $C0)
   utf8Bytes[2] = type_cast((inString[i] & $3F) | $80)
   cResult = "cResult,utf8Bytes[1],utf8Bytes[2]"
  }
  //Unless we modify the function so that inString is a widechar, these will never be called.
  //These are not tested.
  else if(inString[i] < $10000){
   utf8Bytes[1] = type_cast((inString[i] >> 12) | $E0)
   utf8Bytes[2] = type_cast(((inString[i] >> 6) & $3F)  | $80)
   utf8Bytes[3] = type_cast((inString[i] & $3F) | $80)
   cResult = "cResult,utf8Bytes[1],utf8Bytes[2],utf8Bytes[3]"
  }
  else if(inString[i] < $110000){
   utf8Bytes[1] = type_cast((inString[i] >> 18) | $F0)
   utf8Bytes[2] = type_cast(((inString[i] >> 12) & $3F) | $80)
   utf8Bytes[3] = type_cast(((inString[i] >>  6) & $3F) | $80)
   utf8Bytes[4] = type_cast((inString[i] & $3F) | $80)
   cResult = "cResult,utf8Bytes[1],utf8Bytes[2],utf8Bytes[3],utf8Bytes[4]"
  }
 }
 return cResult
}

define_function char[1024] URLEncode(char inString[]){
 char cResult[1024]
 integer i
 integer len
 
 cResult = ''
 len = length_array(inString)
 
 for(i = 1;i <= len; i++){
  if(((inString[i] > $40) && (inString[i] < $5B)) || //Uppercase Alpha
     ((inString[i] > $60) && (inString[i] < $7B)) || //Lowercase Alpha
     ((inString[i] > $2F) && (inString[i] < $3A)) || //Digit
     (inString[i] == $2D) || (inString[i] == $2E) || (inString[i] == $5F) || (inString[i] == $7E))  // - . _ ~
   cResult = "cResult,inString[i]"
  else{
   cResult = "cResult,'%',format('%02X',inString[i])"
  }
 }
 return cResult
}

define_function char[1024] AmpGtLtToASCII(char inString[]){
 //Return the string with &#038, &#060 and &#062 converted to '&', '<' and '>' respectivly.
 stack_var char cResult[1024]
 stack_var integer len
 stack_var integer i
 
 len = length_array(inString)
 i = 1
 while(i <= len){
  if(find_string(inString,'&#038;',i) == i){  // '&'
   cResult = "cResult,'&'"
   i = i + 5
  }
  else if(find_string(inString,'&#060;',i) == i){  // '<'
   cResult = "cResult,'<'"
   i = i + 5
  }
  else if(find_string(inString,'&#062;',i) == i){  // '>'
   cResult = "cResult,'>'"
   i = i + 5
  }
  else
   cResult = "cResult,inString[i]"
  i++
 }
 return cResult
}

define_function char[1024] HTMLToASCII(char inString[]){
 //Return the string with &amp; &lt; and &gt; converted to '&', '<' and '>' respectivly.
 stack_var char cResult[1024]
 stack_var integer len
 stack_var integer i
 
 len = length_array(inString)
 i = 1
 while(i <= len){
  if(find_string(inString,'&amp;',i) == i){  // '&'
   cResult = "cResult,'&'"
   i = i + 4
  }
  else if(find_string(inString,'&lt;',i) == i){  // '<'
   cResult = "cResult,'<'"
   i = i + 3
  }
  else if(find_string(inString,'&gt;',i) == i){  // '>'
   cResult = "cResult,'>'"
   i = i + 3
  }
  else
   cResult = "cResult,inString[i]"
  i++
 }
 return cResult
}

/*
.______        ___           _______. _______    __    _  _    
|   _  \      /   \         /       ||   ____|  / /   | || |   
|  |_)  |    /  ^  \       |   (----`|  |__    / /_   | || |_  
|   _  <    /  /_\  \       \   \    |   __|  | '_ \  |__   _| 
|  |_)  |  /  _____  \  .----)   |   |  |____ | (_) |    | |   
|______/  /__/     \__\ |_______/    |_______| \___/     |_|   
                                                               
Borrowed from i!-EquipmentMonitorOut.axi
Requires cEncrBase64[] table as defined in above define_variable section.
*/
define_function char[256] EncrBase64Encode(char cDecStr[]){
 stack_var
 char    cDecodeStr[256]
 char    cEncodeStr[256]
 integer nLoop
 integer nTemp
 char    cIdx1
 char    cIdx2
 char    cIdx3
 char    cIdx4
 char    cByte1
 char    cByte2
 char    cByte3
 char    cChar1
 char    cChar2
 char    cChar3
 char    cChar4
 // Copy string and pad
 cDecodeStr = cDecStr
 nTemp = length_string(cDecodeStr) % 3
 if(nTemp <> 0){
  cDecodeStr[length_string(cDecodeStr)+1] = 0
  cDecodeStr[length_string(cDecodeStr)+2] = 0
  cDecodeStr[length_string(cDecodeStr)+3] = 0
 }
 // Encode
 for(cEncodeStr = "", nLoop = 1; nLoop <= length_string(cDecodeStr); nLoop = nLoop + 3){
  // Get bytes
  cByte1 = cDecodeStr[nLoop]
  cByte2 = cDecodeStr[nLoop+1]
  cByte3 = cDecodeStr[nLoop+2]
  // Get index
  cIdx1  =  TYPE_CAST(((cByte1 & $FC) >> 2) + 1)
  cIdx2  =  TYPE_CAST((((cByte2 & $F0) >> 4) | ((cByte1 & $03) << 4)) + 1)
  cIdx3  =  TYPE_CAST((((cByte3 & $C0) >> 6) | ((cByte2 & $0F) << 2)) + 1)
  cIdx4  =  TYPE_CAST(  (cByte3 & $3F) + 1)
  // Get chars
  cChar1 = cEncrBase64[cIdx1]
  cChar2 = cEncrBase64[cIdx2]
  cChar3 = cEncrBase64[cIdx3]
  cChar4 = cEncrBase64[cIdx4]
  // Pad?
  if(length_string(cDecodeStr) < (nLoop+1))
   cChar3 = $3D // '='
  if(length_string(cDecodeStr) < (nLoop+2))
   cChar4 = $3D // '='
  // Build string
  cEncodeStr = "cEncodeStr, cChar1, cChar2, cChar3, cChar4"
 }
 return cEncodeStr;
}
/*
     _______. __    __       ___                     __  
    /       ||  |  |  |     /   \                   /_ | 
   |   (----`|  |__|  |    /  ^  \        ______     | | 
    \   \    |   __   |   /  /_\  \      |______|    | | 
.----)   |   |  |  |  |  /  _____  \                 | | 
|_______/    |__|  |__| /__/     \__\                |_| 
                                                         
Requires SHA1Context as per define_type section, as well as an instance of the structure as per define_variable section.
This has not been tested on binary data, only string data.  String data always results in a data size where (DATA_SIZE % 8) = 0.
Designed to work with messages 2^64 bits long.
*/
define_function long SHA1CircularShift(long bits, long inWord){
 //A circular-shift is also known as a rotate.
 return (((inWord << bits) & $FFFFFFFF) | (inWord >> (32 - bits)))
}

define_function SHA1Reset(){
 //Tested by filling with content then resetting - appears okay.
 SH_sha1Context.Length_Low = 0
 SH_sha1Context.Length_High = 0
 SH_sha1Context.Message_Block = ''
 
 SH_sha1Context.Message_Digest[1] = $67452301;
 SH_sha1Context.Message_Digest[2] = $EFCDAB89;
 SH_sha1Context.Message_Digest[3] = $98BADCFE;
 SH_sha1Context.Message_Digest[4] = $10325476;
 SH_sha1Context.Message_Digest[5] = $C3D2E1F0;
 
 SH_sha1Context.Corrupted = 0
 SH_InputBuffer = ''
}

define_function SHA1Input(char inMessage[MAX_INPUT_CHUNK_BYTES]){
 stack_var integer i
 stack_var integer len
 
 len = length_array(inMessage)
 if(len == 0)
  return;
 i = 1
 while(i <= len){
  SH_InputBuffer = "SH_InputBuffer,(type_cast(inMessage[i]) & $FF)"
  SH_sha1Context.Length_Low = SH_sha1Context.Length_Low + 8  //We +8 since we are tracking the number of bits, not bytes.
  SH_sha1Context.Length_Low = SH_sha1Context.Length_Low & $FFFFFFFF;  //Force it to 32 bits.
  if(SH_sha1Context.Length_Low == 0){ //Overflow has occured
   SH_sha1Context.Length_High++
   SH_sha1Context.Length_High = SH_sha1Context.Length_High & $FFFFFFFF;  //Force it to 32 bits.
   if(SH_sha1Context.Length_High == 0){ //Overflow has occured - message is too long
    SH_sha1Context.Corrupted = true;
    EchoSystemDebugString(db_hash,'SHA1Digest() corrupted')
   }
  }
  i++
 }
 while(length_array(SH_InputBuffer) >= MESSAGE_BLOCK_SIZE){
  //Extract one block and process it
  SH_sha1Context.Message_Block = left_string(SH_InputBuffer,MESSAGE_BLOCK_SIZE);
  SH_InputBuffer = right_string(SH_InputBuffer,length_array(SH_InputBuffer)-MESSAGE_BLOCK_SIZE)
  SHA1ProcessMessageBlock();
 }
}

define_function SHA1ProcessMessageBlock(){
 //Requires constant K[] as per define_variable section.
 //Typical SHA1 code examples are from 0-based languages (C, etc).  NetLinx is 1-based.
 //Index in for-loops are per C algorithms, with +1 correction made in all W[t] and Message_Block[] refrences.
 long t;
 long temp;
 long W[80];  //Message schedule
 long A;
 long B;
 long C;
 long D;
 long E;
 
 //Initialise the first 16 words (longs) in the array W
 for(t=0; t<16; t++){
  W[t+1] =          (SH_sha1Context.Message_Block[(t * 4) + 1]) << 24;
  W[t+1] = W[t+1] | (SH_sha1Context.Message_Block[(t * 4) + 2]) << 16;
  W[t+1] = W[t+1] | (SH_sha1Context.Message_Block[(t * 4) + 3]) << 8;
  W[t+1] = W[t+1] | (SH_sha1Context.Message_Block[(t * 4) + 4]);
 }
 for(t = 16; t < 80; t++){
  W[t+1] = SHA1CircularShift(1,W[t-2] ^ W[t-7] ^ W[t-13] ^ W[t-15]);
 }
 
 A = SH_sha1Context.Message_Digest[1];
 B = SH_sha1Context.Message_Digest[2];
 C = SH_sha1Context.Message_Digest[3];
 D = SH_sha1Context.Message_Digest[4];
 E = SH_sha1Context.Message_Digest[5];
 
 for(t=0; t<20; t++){
  temp = SHA1CircularShift(5,A) + ((B & C) | ((~B) & D)) + E + W[t+1] + K[1];
  temp = temp & $FFFFFFFF;
  E = D;
  D = C;
  C = SHA1CircularShift(30,B);
  B = A;
  A = temp;
 }
 for(t=20; t<40; t++){
  temp = SHA1CircularShift(5,A) + (B ^ C ^ D) + E + W[t+1] + K[2];
  temp = temp & $FFFFFFFF;
  E = D;
  D = C;
  C = SHA1CircularShift(30,B);
  B = A;
  A = temp;
 }
 for(t=40; t<60; t++){
  temp = SHA1CircularShift(5,A) + ((B & C) | (B & D) | (C & D)) + E + W[t+1] + K[3];
  temp = temp & $FFFFFFFF;
  E = D;
  D = C;
  C = SHA1CircularShift(30,B);
  B = A;
  A = temp;
 }
 for(t=60; t<80; t++){
  temp = SHA1CircularShift(5,A) + (B ^ C ^ D) + E + W[t+1] + K[4];
  temp = temp & $FFFFFFFF;
  E = D;
  D = C;
  C = SHA1CircularShift(30,B);
  B = A;
  A = temp;
 }
 SH_sha1Context.Message_Digest[1] = (SH_sha1Context.Message_Digest[1] + A) & $FFFFFFFF;
 SH_sha1Context.Message_Digest[2] = (SH_sha1Context.Message_Digest[2] + B) & $FFFFFFFF;
 SH_sha1Context.Message_Digest[3] = (SH_sha1Context.Message_Digest[3] + C) & $FFFFFFFF;
 SH_sha1Context.Message_Digest[4] = (SH_sha1Context.Message_Digest[4] + D) & $FFFFFFFF;
 SH_sha1Context.Message_Digest[5] = (SH_sha1Context.Message_Digest[5] + E) & $FFFFFFFF;
}

define_function char[44] SHA1Digest(char iFormat){
 //The Digest() function should be call once there is no more input to be sent to the hashing algorithm.  It pads out
 //the remainder of the message with a single '1' bit, multiple '0's and the bit-length of the message.  The padding process
 //may result in the remaining portion of the message becoming larger than MESSAGE_BLOCK_SIZE, in which case we must
 //process one additional full block.
 if(SH_sha1Context.Corrupted){
  return 'SHA1Digest() corrupted'
 }
 SH_InputBuffer = "SH_InputBuffer,$80"  //Add 1000000b.
 if(length_array(SH_InputBuffer) > (MESSAGE_BLOCK_SIZE - 8)){  //Padding will make (SH_InputBuffer + bitLength) > MESSAGE_BLOCK_SIZE
  while(length_array(SH_InputBuffer) < MESSAGE_BLOCK_SIZE)
   SH_InputBuffer = "SH_InputBuffer,$00"
  SH_sha1Context.Message_Block = left_string(SH_InputBuffer,MESSAGE_BLOCK_SIZE);
  SHA1ProcessMessageBlock();
  SH_InputBuffer = ''
 }
 while(length_array(SH_InputBuffer) < (MESSAGE_BLOCK_SIZE - 8))
  SH_InputBuffer = "SH_InputBuffer,$00"
 SH_sha1Context.Message_Block = left_string(SH_InputBuffer,MESSAGE_BLOCK_SIZE - 8)
 //Fill the last 8 bytes with the bit-length of the message.
 SH_sha1Context.Message_Block[57] = type_cast((SH_sha1Context.Length_High >> 24) & $FF);
 SH_sha1Context.Message_Block[58] = type_cast((SH_sha1Context.Length_High >> 16) & $FF);
 SH_sha1Context.Message_Block[59] = type_cast((SH_sha1Context.Length_High >>  8) & $FF);
 SH_sha1Context.Message_Block[60] = type_cast((SH_sha1Context.Length_High      ) & $FF);
 SH_sha1Context.Message_Block[61] = type_cast((SH_sha1Context.Length_Low  >> 24) & $FF);
 SH_sha1Context.Message_Block[62] = type_cast((SH_sha1Context.Length_Low  >> 16) & $FF);
 SH_sha1Context.Message_Block[63] = type_cast((SH_sha1Context.Length_Low  >>  8) & $FF);
 SH_sha1Context.Message_Block[64] = type_cast((SH_sha1Context.Length_Low       ) & $FF);
 SHA1ProcessMessageBlock();
 
 //The digest now contains the final result.
 EchoSystemDebugString(db_hash,"'DIGEST=',format('%08x',SH_sha1Context.Message_Digest[1]),' ',format('%08x',SH_sha1Context.Message_Digest[2]),' ',
                                          format('%08x',SH_sha1Context.Message_Digest[3]),' ',format('%08x',SH_sha1Context.Message_Digest[4]),' ',
                                          format('%08x',SH_sha1Context.Message_Digest[5])")
 return SHA1Result(iFormat)
}
define_function char[44] SHA1Result(char iFormat){
 //"Print" out the content in SH_sha1Context.Message_Digest[] using the desired formatting.
 local_var char tempBuffer[44]
 local_var char theResult[20]
 local_var char i
 
//Sample value for Message_Digest[]: $BCC2C68C,$ABBBF1C3,$F5B05D8E,$7E73A4D2,$7B7E1B20
 switch(iFormat){
  case iFormatHuman:  //'bcc2c68c abbbf1c3 f5b05d8e 7e73a4d2 7b7e1b20'
   return "format('%08x',SH_sha1Context.Message_Digest[1]),' ',format('%08x',SH_sha1Context.Message_Digest[2]),' ',
           format('%08x',SH_sha1Context.Message_Digest[3]),' ',format('%08x',SH_sha1Context.Message_Digest[4]),' ',
           format('%08x',SH_sha1Context.Message_Digest[5])"
   break;
  case iFormatString:  //'bcc2c68cabbbf1c3f5b05d8e7e73a4d27b7e1b20'
   return "format('%08x',SH_sha1Context.Message_Digest[1]),format('%08x',SH_sha1Context.Message_Digest[2]),
           format('%08x',SH_sha1Context.Message_Digest[3]),format('%08x',SH_sha1Context.Message_Digest[4]),
           format('%08x',SH_sha1Context.Message_Digest[5])"
   break;
  case iFormatHex:  //"$bc,$c2,$c6,$8c,$ab,$bb,$f1,$c3,$f5,$b0,$5d,$8e,$7e,$73,$a4,$d2,$7b,$7e,$1b,$20"
   //This could be optomised one day by performing bit-shifting and/or masking to derive the values direct from Message_Digest[].
   tempBuffer = "format('%08x',SH_sha1Context.Message_Digest[1]),format('%08x',SH_sha1Context.Message_Digest[2]),
                 format('%08x',SH_sha1Context.Message_Digest[3]),format('%08x',SH_sha1Context.Message_Digest[4]),
                 format('%08x',SH_sha1Context.Message_Digest[5])"
   i = 1
   theResult = ''
   while(i < length_array(tempBuffer)){  //Parse the human-readable ASCII string 2 bytes at a time, converting the bytes into an 8-bit numeric value.
    theResult = "theResult, type_cast(hextoi(mid_string(tempBuffer,i,2)))"
    i = i + 2
   }
   return theResult
   break;
 }
}

/*
 __    __  .___  ___.      ___       ______         _______. __    __       ___                     __  
|  |  |  | |   \/   |     /   \     /      |       /       ||  |  |  |     /   \                   /_ | 
|  |__|  | |  \  /  |    /  ^  \   |  ,----'      |   (----`|  |__|  |    /  ^  \        ______     | | 
|   __   | |  |\/|  |   /  /_\  \  |  |            \   \    |   __   |   /  /_\  \      |______|    | | 
|  |  |  | |  |  |  |  /  _____  \ |  `----.   .----)   |   |  |  |  |  /  _____  \                 | | 
|__|  |__| |__|  |__| /__/     \__\ \______|   |_______/    |__|  |__| /__/     \__\                |_| 
                                                                                                        
*/

define_function char[256] HMAC_SHA1(char inKey[], char inMessage[], char iFormat){
 integer len
 char outer_key_pad[64]
 char inner_key_pad[64]
 char blockedKey[64]  //inKey either padded out to, or hashed down and padded out to 64 bytes
 char temp[128]
 
 len = length_array(inKey)
 if(len == 64){  //Step 1
  blockedKey = "inKey"
  set_length_array(blockedKey,64)
 }
 else if(len > 64){  //Step 2
  SHA1Reset()
  while(length_array(inKey) > 2000){
   SHA1Input(left_string(inKey,2000))
   inKey = right_string(inKey, length_array(inKey)-2000)
  }
  SHA1Input(inKey)
  blockedKey = SHA1Digest(iFormatHex)
  while(length_array(blockedKey) < 64)
   blockedKey = "blockedKey,$00"
 }
 else{ //len < 64  Step 3
  blockedKey = inKey
  while(length_array(blockedKey) < 64)
   blockedKey = "blockedKey,$00"
 }
 //Step 4
 for(len=1; len<=64; len++){
  inner_key_pad[len] = blockedKey[len] ^ $36
 }
 set_length_array(inner_key_pad,64)
 
 //Step 5 - merged into step 6
 //Step6
 SHA1Reset()
 if(length_array(inMessage) > 1936){
  SHA1Input("inner_key_pad,left_string(inMessage, 1936)")
  inMessage = right_string(inMessage,length_array(inMessage)-1936)
  while(length_array(inMessage) > 2000){
   SHA1Input(left_string(inMessage, 2000))
   inMessage = right_string(inMessage,length_array(inMessage)-2000)
  }
  SHA1Input(inMessage)
 }
 else
  SHA1Input("inner_key_pad,inMessage")
 inner_key_pad = SHA1Digest(iFormatHex)
 
 //Step 7
 for(len=1; len<=64; len++){
  outer_key_pad[len] = blockedKey[len] ^ $5c
 }
 set_length_array(outer_key_pad,64)
 
 //Step 8 - merged into step 9
 //Step 9
 SHA1Reset()
 SHA1Input("outer_key_pad,inner_key_pad")
 outer_key_pad = SHA1Digest(iFormatHex)
 return SHA1Result(iFormat)
}

/*
 _______   ______  __    __    ______        _______.____    ____  _______..___________. _______ .___  ___. 
|   ____| /      ||  |  |  |  /  __  \      /       |\   \  /   / /       ||           ||   ____||   \/   | 
|  |__   |  ,----'|  |__|  | |  |  |  |    |   (----` \   \/   / |   (----``---|  |----`|  |__   |  \  /  | 
|   __|  |  |     |   __   | |  |  |  |     \   \      \_    _/   \   \        |  |     |   __|  |  |\/|  | 
|  |____ |  `----.|  |  |  | |  `--'  | .----)   |       |  | .----)   |       |  |     |  |____ |  |  |  | 
|_______| \______||__|  |__|  \______/  |_______/        |__| |_______/        |__|     |_______||__|  |__| 
                                                                                                            

     _______. _______ .______     ____    ____  _______ .______      
    /       ||   ____||   _  \    \   \  /   / |   ____||   _  \     
   |   (----`|  |__   |  |_)  |    \   \/   /  |  |__   |  |_)  |    
    \   \    |   __|  |      /      \      /   |   __|  |      /     
.----)   |   |  |____ |  |\  \----.  \    /    |  |____ |  |\  \----.
|_______/    |_______|| _| `._____|   \__/     |_______|| _| `._____|
                                                                     
*/

define_function ServerTimeOffset(char inBuffer[100]){
/*
We could potentially receive one of three different DateTime strings.  HTTP/1.1 says they are all to be interpreted as GMT/UTC.
Date: Sun, 06 Nov 1994 08:49:37 GMT   //RFC822, updated by RFC1123
Date: Sunday, 06-Nov-94 08:49:37 GMT  //RFC850, obsoleted by RFC1036
Date: Sun Nov  6 08:49:37 1994        //ANSI C's asctime() format
*/
 local_var integer iYear
 local_var integer iMonth
 local_var integer iDate
 local_var integer iHour
 local_var integer iMinute
 local_var integer iSecond
 local_var char iPos
 local_var slong iNow
 local_var slong iServerTime
 
 if(find_string(inBuffer,'Date:',1) == 0){
  EchoSystemDebugString(db_developer,"'ServerTimeOffset() inBuffer has bad format: ',inBuffer")
  return
 }
 remove_string(inBuffer,'Date:',1)
 while(inBuffer[1] == ' ')
  inBuffer = right_string(inBuffer,length_array(inBuffer) - 1)

 //Extract month
 for(iMonth = 1; iMonth <= 12; iMonth++){
  iPos =find_string(inBuffer,MONTH[iMonth],1)
  if(iPos > 0)
   break;
 }
 //Extract date
 iDate = atoi(inBuffer)
 //Extract year
 if(find_string(inBuffer,'GMT',1)){
  if(find_string(inBuffer,'-',1)){  //RFC850
   //E.g. Sunday, 06-Nov-94 08:49:37 GMT
   EchoSystemDebugString(db_developer,"'Server date RFC850: ',inBuffer")
   inBuffer = right_string(inBuffer,length_array(inBuffer)-(iPos + 3))
   remove_string(inBuffer,'-',1)
   iYear = atoi(inBuffer)
   if((iYear >= 70) && (iYear < 100))  //Assume the 1900s 
    iYear = iYear + 1900
   else if(iYear < 70)  //Assume the 2000s
    iYear = iYear + 2000
   remove_string(inBuffer,' ',1)
  }
  else{  //RFC822
   //E.g. Sun, 06 Nov 1994 08:49:37 GMT
   EchoSystemDebugString(db_developer,"'Server date RFC822: ',inBuffer")
   inBuffer = right_string(inBuffer,length_array(inBuffer)-(iPos+3))
   iYear = atoi(inBuffer)
   remove_string(inBuffer,"itoa(iYear),' '",1)
  }
 }
 else{  //ANSI C
  //E.g. Sun Nov  6 08:49:37 1994
  EchoSystemDebugString(db_developer,"'Server date ANSI C: ',inBuffer")
  iYear = atoi(right_string(inBuffer,4))
  remove_string(inBuffer,"itoa(iDate),' '",1)
 }
 //inBuffer is now trimmed up to the start of the time.
 iHour = atoi(inBuffer)
 remove_string(inBuffer,':',1)
 iMinute = atoi(inBuffer)
 remove_string(inBuffer,':',1)
 iSecond = atoi(inBuffer)
 
 iNow = type_cast(getSecondsSinceEpoch("itoa(date_to_year(ldate)),'-',format('%02d',date_to_month(ldate)),'-',format('%02d',date_to_day(ldate)),'T',
                                        format('%02d',time_to_hour(time)),':',format('%02d',time_to_minute(time)),':',format('%02d',time_to_second(time)),'.000Z'"))
 iServerTime = type_cast(getSecondsSinceEpoch("itoa(iYear),'-',format('%02d',iMonth),'-',format('%02d',iDate),'T',
                                        format('%02d',iHour),':',format('%02d',iMinute),':',format('%02d',iSecond),'.000Z'"))
 ES_iServerTime = iServerTime  //For beta-release timeouts
 ES_iServerTimeOffset = iServerTime - iNow
 EchoSystemDebugString(db_developer,"'Server time offset (seconds): ',itoa(ES_iServerTimeOffset)")
}

define_function ServerRestCall(char sRequest[1024]){
 local_var char sBody[5000]
 stack_var char sPath[1024]
 stack_var char sQueryName[1024]
 stack_var char sQueryValue[1024]
 local_var long iTimestamp
 local_var integer iNonce  //This must not be a stack_var
 
 local_var char oauth_consumer_key[256]
 local_var char oauth_token[256]
 local_var char oauth_nonce[256]
 local_var char oauth_timestamp[256]
 local_var char oauth_signature_method[256]
 local_var char oauth_version[256]
 local_var char oauth_SignatureBaseString[2048]
 
 #if_defined BETA_RELEASE
 if(moduleDisabled())
  return;
 #end_if
 
 //Cleanup
 sPath = trim(sRequest)
 if(length_array(sPath) == 0)
  return
 while(sPath[1] == '/')  //Drop leading slashes
  sPath = right_string(sPath, length_array(sPath) - 1)
 EchoSystemDebugString(db_developer,"'ServerRestCall(',sPath,')'")
 
 //Break the request down into path and query components.  <path>?<queryName>=<queryValue>  E.g.  rooms?filter=blah
 sQueryName = ''
 sQueryValue = ''
 if(find_string(sPath,'?',1)){
  if(find_string(sPath,'?',1) < find_string(sPath,'=',1)){
   sQueryValue = sPath
   sPath = left_string(sQueryValue,find_string(sQueryValue,'?',1) - 1)
   remove_string(sQueryValue,'?',1)
   sQueryName = remove_string(sQueryValue,'=',1)
   sQueryName = left_string(sQueryName,length_array(sQueryName) - 1)
   remove_string(sQueryValue,'=',1)
   EchoSystemDebugString(db_hash,"'path:',sPath,' queryName:',sQueryName,' queryValue:',sQueryValue")
  }
  else{
   EchoSystemDebugString(db_integrator,"'ERROR=Bad parameter for server query: ',sPath")
   return
  }
 }
 
 //Create the timestamp.  Sample input: 2010-05-11T05:36:28.964Z
 iTimestamp = getSecondsSinceEpoch("itoa(date_to_year(ldate)),'-',format('%02d',date_to_month(ldate)),'-',format('%02d',date_to_day(ldate)),'T',
                                    format('%02d',time_to_hour(time)),':',format('%02d',time_to_minute(time)),':',format('%02d',time_to_second(time)),'.000Z'")
 //Adjust for offset from GMT
 iTimestamp = type_cast(type_cast(iTimestamp) + ES_iServerTimeOffset)
 //Generate a unique nonce.  OAuth uses the timestamp and nonce as a unique identifier.
 iNonce = iNonce + 1
 if(iNonce > 10000)  //We want to contain our nonce increment so we can test for rollaround issues.
  iNonce = 0
 EchoSystemDebugString(db_hash,"'Timestamp: ',itoa(iTimestamp),'  Nonce: ',itoa(iNonce)")
 
 //Create the OAuth signature.  Step-by-step guide http://hueniverse.com/oauth/guide/authentication/
 //Gather parameters
 //UTF-8 encode all parameters
 oauth_consumer_key = UTF8String(ES_sServerConsumerKey)
 oauth_token = UTF8String('')
 oauth_nonce = UTF8String(itoa(iNonce))
 oauth_timestamp = UTF8String(itoa(iTimestamp))
 oauth_signature_method = UTF8String('HMAC-SHA1')
 oauth_version = UTF8String('1.0')
 if(length_array(sQueryName)){
  sQueryName  = UTF8String(sQueryName)
  sQueryValue = UTF8String(sQueryValue)
 }
 #if_defined DEVELOPMENT_PHASE
 send_string 0,"'UTF8 encode all parameters....'"
 send_string 0,"'oauth_consumer_key:     ',oauth_consumer_key"
 send_string 0,"'oauth_token:            ',oauth_token"
 send_string 0,"'oauth_nonce:            ',oauth_nonce"
 send_string 0,"'oauth_timestamp:        ',oauth_timestamp"
 send_string 0,"'oauth_signature_method: ',oauth_signature_method"
 send_string 0,"'oauth_version:          ',oauth_version"
 #end_if
 
 //URL-encode all parameters
 oauth_consumer_key     = URLEncode(oauth_consumer_key)
 oauth_token            = URLEncode(oauth_token)
 oauth_nonce            = URLEncode(oauth_nonce)
 oauth_timestamp        = URLEncode(oauth_timestamp)
 oauth_signature_method = URLEncode(oauth_signature_method)
 oauth_version          = URLEncode(oauth_version)
 if(length_array(sQueryName)){
  sQueryName  = URLEncode(sQueryName)
  sQueryValue = URLEncode(sQueryValue)
 }
 #if_defined DEVELOPMENT_PHASE
 send_string 0,"'URL encode all parameters....'"
 send_string 0,"'oauth_consumer_key:     ',oauth_consumer_key"
 send_string 0,"'oauth_token:            ',oauth_token"
 send_string 0,"'oauth_nonce:            ',oauth_nonce"
 send_string 0,"'oauth_timestamp:        ',oauth_timestamp"
 send_string 0,"'oauth_signature_method: ',oauth_signature_method"
 send_string 0,"'oauth_version:          ',oauth_version"
 #end_if
 
 //Parameters are sorted firstly on lexicographic ordering of encoded names, then secondary sorting on values if required.
 //With possible sQueryName of "filter" or "term", our search string could be before or after the oauth params.
 //Parameters are concatenated with '&'.
 oauth_SignatureBaseString = ''
 if(find_string(sQueryName,'filter',1))
  oauth_SignatureBaseString = "'filter=',sQueryValue,'&'"
 oauth_SignatureBaseString = "oauth_SignatureBaseString,
                              'oauth_consumer_key=',oauth_consumer_key,'&',
                              'oauth_nonce=',oauth_nonce,'&',
                              'oauth_signature_method=',oauth_signature_method,'&',
                              'oauth_timestamp=',oauth_timestamp,'&',
                              'oauth_token=',oauth_token,'&',
                              'oauth_version=',oauth_version"
 if(find_string(sQueryName,'term',1))
  oauth_SignatureBaseString = "oauth_SignatureBaseString,'&term=',sQueryValue"
 
 #if_defined DEVELOPMENT_PHASE
 send_string 0,"'oauth_SignatureBaseString: '"
 send_string 0,"left_string(oauth_SignatureBaseString,100)"
 if(length_array(oauth_SignatureBaseString) > 100)
  send_string 0,"mid_string(oauth_SignatureBaseString,101,100)"
 if(length_array(oauth_SignatureBaseString) > 200)
  send_string 0,"mid_string(oauth_SignatureBaseString,201,100)"
 #end_if
 
 //Add http parts to the SigBaseString, URLEncoding where required.
 if(((ipProtocol == 'http') && (ES_iServerPort == 80)) || ((ipProtocol == 'https') && (ES_iServerPort == 443)))
  oauth_SignatureBaseString = "'GET&',URLEncode("ipProtocol,'://',ES_sServerAddress,SERVER_BASE_URI,sPath"),'&',URLEncode(oauth_SignatureBaseString)"
 else
  oauth_SignatureBaseString = "'GET&',URLEncode("ipProtocol,'://',ES_sServerAddress,':',itoa(ES_iServerPort),SERVER_BASE_URI,sPath"),'&',URLEncode(oauth_SignatureBaseString)"

 #if_defined DEVELOPMENT_PHASE
 send_string 0,"'Add HTTP parts, URLEncode where required:'"
 send_string 0,"left_string(oauth_SignatureBaseString,100)"
 if(length_array(oauth_SignatureBaseString) > 100)
  send_string 0,"mid_string(oauth_SignatureBaseString,101,100)"
 if(length_array(oauth_SignatureBaseString) > 200)
  send_string 0,"mid_string(oauth_SignatureBaseString,201,100)"
 #end_if


 //Create HMAC-SHA1 algorithm key
 ES_sOAuthSignature = "URLEncode(UTF8String(ES_sServerConsumerSecret)),'&',URLEncode(UTF8String(''))"
 #if_defined DEVELOPMENT_PHASE
 send_string 0,"'HMAC-SHA1 algorithm key: ',ES_sOAuthSignature"
 #end_if
 
 //Create signature
 ES_sOAuthSignature = HMAC_SHA1(ES_sOAuthSignature,oauth_SignatureBaseString,iFormatHex)
 #if_defined DEVELOPMENT_PHASE
 send_string 0,"'OAuth Signature: ',ES_sOAuthSignature"
 #end_if
 
 //Base64 encode signature with '=' padding.
 ES_sOAuthSignature = EncrBase64Encode(ES_sOAuthSignature)
 #if_defined DEVELOPMENT_PHASE
 send_string 0,"'Base64 encode signature: ',ES_sOAuthSignature"
 send_string 0,"'URL encode signature: ',URLEncode(ES_sOAuthSignature)"
 #end_if

EchoSystemDebugString(db_hash,"'oauth sig for timestamp <',oauth_timestamp,'> & nonce <',itoa(iNonce),'>: ',ES_sOAuthSignature")
 //DevNote - While the above OAuth creation is http/https aware (with port numbering ONLY where required), our sockets are still http-only.
 ES_sServerOutgoingBuffer = "'GET ',SERVER_BASE_URI,sPath"
 if(length_array(sQueryName))
  ES_sServerOutgoingBuffer = "ES_sServerOutgoingBuffer,'?',sQueryName,'=',sQueryValue"
 ES_sServerOutgoingBuffer = "ES_sServerOutgoingBuffer,' HTTP/1.1',crlf,
                             'User-Agent: AMX EchoSystem module v',cVersion,crlf,
                             'Host: ',ES_sServerAddress,':',itoa(ES_iServerPort),crlf,
                             'Content-Type: application/xml',crlf,
                             'Authorization: ',
                             'OAuth realm="", ',  //Echo360 php test code leaves the Realm defined but empty.
//                             'OAuth realm="',URLEncode("ipProtocol,'://',ES_sServerAddress,':',itoa(ES_iServerPort),SERVER_BASE_URI,sPath"),'", ',
                             'oauth_signature_method="HMAC-SHA1", ',
                             'oauth_signature="',URLEncode(ES_sOAuthSignature),'", ',  //Echo360 php test code does this, as per OAuth spec.
                             'oauth_nonce="',itoa(iNonce),'", ',
                             'oauth_timestamp="',itoa(iTimestamp),'", ',
                             'oauth_token="", ',
                             'oauth_consumer_key="',oauth_consumer_key,'", ',  //Already URLEncoded from above, prior to oauth_SignatureBaseString creation...
                             'oauth_version="1.0"',
                             crlf,
 crlf"
 ClearServerBuffer()
 if(ES_bServerPortOpen)
  send_string vdvServer, ES_sServerOutgoingBuffer
 else{
  EchoSystemDebugString(db_integrator,'opening port to server...')
  ip_client_open(vdvServer.port,ES_sServerAddress,ES_iServerPort,ip_tcp)
 }
}

define_function ClearServerBuffer(){
#if_defined DEVELOPMENT_PHASE
 DEBUG_ServerBuffer2 = "DEBUG_ServerBuffer1"
 DEBUG_ServerBuffer1 = "ES_sServerIncomingBuffer"
#end_if
 ES_sServerIncomingBuffer = ''
}

define_function ParseServerResponse(){
 stack_var long pos1
 stack_var long pos2
 stack_var char buf[128]
 stack_var char tempId[128]
 local_var integer failCount
 stack_var char bRecalcCredentials
 stack_var slong sFileResult
 stack_var char bDumpMarker
 
 if(ES_bDump && (length_array(ES_sServerIncomingBuffer) > 0)){
  //File is alreay open.
  EchoSystemDebugString(db_integrator,'Dumping...')
  pos1 = 1
  pos2 = pos1 + MAX_INPUT_CHUNK_BYTES - 1
  bDumpMarker = false
  while(pos2 < length_array(ES_sServerIncomingBuffer)){
   if(!bDumpMarker){
    sFileResult = file_write(ES_hDumpFile,"'*****',$0d,$0a",7)
    bDumpMarker = true
   }
   sFileResult = file_write(ES_hDumpFile,mid_string(ES_sServerIncomingBuffer,pos1,(pos2-pos1) + 1),MAX_INPUT_CHUNK_BYTES)
   select{
    active(sFileResult == -1):{ EchoSystemDebugString(db_integrator,'Invalid file handle') }
    active(sFileResult == -5):{ EchoSystemDebugString(db_integrator,'Disk I/O error') }
    active(sFileResult == -6):{ EchoSystemDebugString(db_integrator,'Invalid parameter') }
    active(sFileResult == -11):{ EchoSystemDebugString(db_integrator,'Disk full') }
   }
   pos1 = pos2 + 1
   pos2 = pos1 + MAX_INPUT_CHUNK_BYTES - 1
  }
  pos2 = length_array(ES_sServerIncomingBuffer) - pos1 + 1  //Bytes remaining to be dumped.
  sFileResult = file_write(ES_hDumpFile,right_string(ES_sServerIncomingBuffer,pos2),pos2)
  select{
   active(sFileResult == -1):{ EchoSystemDebugString(db_integrator,'Invalid file handle') }
   active(sFileResult == -5):{ EchoSystemDebugString(db_integrator,'Disk I/O error') }
   active(sFileResult == -6):{ EchoSystemDebugString(db_integrator,'Invalid parameter') }
   active(sFileResult == -11):{ EchoSystemDebugString(db_integrator,'Disk full') }
  }
  sFileResult = file_write(ES_hDumpFile,"crlf,crlf",4)
 }
 
 //If there are errors we may want to resend the request.  If there are no errors we can proceed with parsing.
 if((find_string(ES_sServerIncomingBuffer,'HTTP/1.1 4',1) == 1) && (failCount < MAX_SERVER_RESENDS)){  //Error
  /*
   Cases that can cause errors.
    401 - No TrustedSystem found for the given ConsumerKey.
    403 - Forbidden.  This could be due to any number of reasons.
          - OAuth time difference too large.
          - ConsumerSecret is wrong.
          - Unsupported param in URL request.  E.g. "filter" vs "term".
    404 - Not found.  The URL sent to the server is not supported.
    
    An empty result will not create a 4XX code.  Rather it will have <total-results>0</total-results> in the response.
  */
  failCount = failCount + 1
  
  //From ESS v5.3 onwards the ParamName is "filter".  At some point "term" will be discontinued.
  //Toggle between the two for 403 errors.
  if(find_string(ES_sServerIncomingBuffer,'HTTP/1.1 403 Forbidden',1)){
   if(failCount > 1){  //We don't want to toggle until we have synced OAuth times.
    if(find_string(ES_sSearchParamName,'term',1))
     ES_sSearchParamName = 'filter'
    else if(find_string(ES_sSearchParamName,'filter',1))
     ES_sSearchParamName = 'term'
   }
  }
  EchoSystemDebugString(db_developer,left_string(ES_sServerIncomingBuffer,find_string(ES_sServerIncomingBuffer,crlf,1)))
  EchoSystemDebugString(db_developer,"'Resending query to server (',itoa(failCount),')...'")
  ClearServerBuffer()  //Flush the buffer in preparation for the next server response.
  
  switch(ES_eServerQuery){
   case eRoom:
    ES_sRoomID = ''
    wait 11
     ServerRestCall("'rooms?',ES_sSearchParamName,'=',ES_sRoomName")
    break;
   case eRoomCurrentDevice:
    ES_sDeviceID = ''
    wait 11
     ServerRestCall("'rooms/',ES_sRoomID")
    break;
   case eDeviceDetails:
    ES_sDeviceIP = ''
    wait 11
     ServerRestCall("'devices/',ES_sDeviceID")
    break;
   case eCampuses:
    wait 11{
     if(length_array(ES_sSearchParamValue))
      ServerRestCall("'campuses?',ES_sSearchParamName,'=',ES_sSearchParamValue")
     else
      ServerRestCall('campuses')
    }
    break;
   case eBuildings:
    wait 11{
     if(length_array(ES_sSearchParamValue))
      ServerRestCall("'buildings?',ES_sSearchParamName,'=',ES_sSearchParamValue")
     else
      ServerRestCall('buildings')
    }
   case eRooms:
    wait 11{
     if(length_array(ES_sSearchParamValue))
      ServerRestCall("'rooms?',ES_sSearchParamName,'=',ES_sSearchParamValue")
     else
      ServerRestCall('rooms')
    }
    break;
   case eBuildingsOnCampus:
    wait 11{
     if(length_array(ES_sCampusID))  //We already have a CampusID
      ServerRestCall("'campuses/',ES_sCampusID,'/buildings'")
     else if(length_array(ES_sSearchParamValue))  //No CampusID
      ServerRestCall("'campuses?',ES_sSearchParamName,'=',ES_sSearchParamValue")
    }
    break;
   case eRoomsInBuilding:
    wait 11{
     if(length_array(ES_sCampusID)){  //We already have a CampusID
      if(length_array(ES_sBuildingID))  //We already have a BuildingID
       ServerRestCall("'buildings/',ES_sBuildingID,'/rooms'")
      else  //No BuildingID
       ServerRestCall("'campuses/',ES_sCampusID,'/buildings?',ES_sSearchParamName,'=',right_string(ES_sSearchParamValue,length_array(ES_sSearchParamValue)-find_string(ES_sSearchParamValue,':',1))")
     }
     else if(length_array(ES_sSearchParamValue))  //No CampusID
      ServerRestCall("'campuses?',ES_sSearchParamName,'=',ES_sSearchParamValue")
    }
    break;
   case eCampusBuildingRoom:
    wait 11{
     if(length_array(ES_sCampusID)){  //We already have a CampusID
      if(length_array(ES_sBuildingID)){  //We already have a BuildingID
       if(length_array(ES_sRoomID))  //We already have a RoomID
        ServerRestCall("'rooms/',ES_sRoomID")
       else  //No RoomID
        ServerRestCall("'buildings/',ES_sBuildingID,'/rooms?',ES_sSearchParamName,'=',right_string(ES_sRoomName,length_array(ES_sRoomName)-find_rstring(ES_sRoomName,':',length_array(ES_sRoomName)))")
      }
      else  //No BuildingID
       ServerRestCall("'campuses/',ES_sCampusID,'/buildings?',ES_sSearchParamName,'=',ES_sBuildingName")
     }
     else  //No CampusID
      ServerRestCall("'campuses?',ES_sSearchParamName,'=',ES_sCampusName")
    }
    break;
   case eProductGroups:
    wait 11
     ServerRestCall('product-groups')
    break;
  }
 }
 else{
  failCount = 0
  switch(ES_eServerQuery){
   case eRoom:  //Hunt for ES_sRoomID.  Expecting one <room> object.
    if(find_string(ES_sServerIncomingBuffer,'<rooms>',1) && find_string(ES_sServerIncomingBuffer,'</rooms>',1)){
     if(find_string(ES_sServerIncomingBuffer,'<total-results>1</total-results>',1)){
      pos1 = find_string(ES_sServerIncomingBuffer,'</total-results>',1)
      pos1 = find_string(ES_sServerIncomingBuffer,'<id>',pos1) + 4
      pos2 = find_string(ES_sServerIncomingBuffer,'</id>',pos1)
      ES_sRoomID = mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)
      ClearServerBuffer()
      ES_eServerQuery = eRoomCurrentDevice
      ES_sDeviceID = ''
      ServerRestCall("'rooms/',ES_sRoomID")
     }
     else{  //Result != 1 room object.
      if(find_string(ES_sServerIncomingBuffer,'<total-results>0</total-results>',1))
       EchoSystemDebugString(db_public,"'WARNING=Room <',ES_sRoomName,'> not found.'")
      else if(find_string(ES_sServerIncomingBuffer,'</total-results>',1)){
       EchoSystemDebugString(db_public,"'WARNING=Multiple matches for Room <',ES_sRoomName,'> found.'")
       EchoSystemDebugString(db_integrator,"'You may have to use the Campus:Building:Room format.'")
      }
      else
       EchoSystemDebugString(db_integrator,"'PARSE ISSUE=Could not determine Room ID.'")
      //Bail out.
      ES_eServerQuery = eNone
      ClearServerBuffer()
     }
    }
    break;
   case eRoomCurrentDevice:
    if(find_string(ES_sServerIncomingBuffer,'<current-device>',1)){
     pos1 = find_string(ES_sServerIncomingBuffer,'<current-device>',1)
     pos1 = find_string(ES_sServerIncomingBuffer,'<id>',pos1) + 4
     pos2 = find_string(ES_sServerIncomingBuffer,'</id>',pos1)
     ES_sDeviceID = mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)
     ClearServerBuffer()
     ES_eServerQuery = eDeviceDetails
     ES_sDeviceIP = ''
     ServerRestCall("'devices/',ES_sDeviceID")
    }
    else
     EchoSystemDebugString(db_integrator,"'Room <',ES_sRoomName,'> does not have an associated device.'")
    break;
   case eDeviceDetails:  //Hunt for ES_sDeviceIP.
    //At the end of the API response for device details is a list of historical room assignments.  This could potentially grow beyond the size of
    //our buffer, so we will process the data once we have enough of what we are interested in (up to the <device-rooms> element).
    if(find_string(ES_sServerIncomingBuffer,'<device>',1) && find_string(ES_sServerIncomingBuffer,'<device-rooms>',1)){
     pos1 = find_string(ES_sServerIncomingBuffer,'<type>',1) + 6
     pos2 = find_string(ES_sServerIncomingBuffer,'</type>',pos1)
     buf = mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)
     if((find_string(buf,'pro-hardware-capture',1) == 1) || (find_string(buf,'hardware-capture',1) == 1)){  //We have a device we can control
      EchoSystemDebugString(db_developer,"'Device <',buf,'> found'")
      //Echo360 have not put credentials into the API response yet.  Hunt for them anyway.
      if(find_string(ES_sServerIncomingBuffer,'<username>',1) && find_string(ES_sServerIncomingBuffer,'</username>',1)){
       pos1 = find_string(ES_sServerIncomingBuffer,'<username>',1) + 10
       pos2 = find_string(ES_sServerIncomingBuffer,'</username>',pos1)
       buf = mid_string(ES_sServerIncomingBuffer,pos1,(pos2-pos1))
       if(buf != ES_sDeviceUsername){
        ES_sDeviceUsername = buf
        bRecalcCredentials = true
       }
      }
      if(find_string(ES_sServerIncomingBuffer,'<password>',1) && find_string(ES_sServerIncomingBuffer,'</password>',1)){
       pos1 = find_string(ES_sServerIncomingBuffer,'<password>',1) + 10
       pos2 = find_string(ES_sServerIncomingBuffer,'</pasword>',pos1)
       buf = mid_string(ES_sServerIncomingBuffer,pos1,(pos2-pos1))
       if(buf != ES_sDevicePassword){
        ES_sDevicePassword = buf
        bRecalcCredentials = true
       }
      }
      if(bRecalcCredentials)
       ES_sDeviceKey = EncrBase64Encode("ES_sDeviceUsername,':',ES_sDevicePassword")
      
      //Parse for IP address
      //Assigned devices with an address have <address>/ip.addres</address>.  N.B. Leading '/' bug, US-9695.
      //Unassigned devices and new devices which have not yet checked in have <address></address>.
      //Try to grab the MAC address for error reporting.
      pos1 = find_string(ES_sServerIncomingBuffer,'<key>',1) + 5
      pos2 = find_string(ES_sServerIncomingBuffer,'</key>',pos1)
      buf = mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)
      pos1 = find_string(ES_sServerIncomingBuffer,'<address>',1)
      pos2 = find_string(ES_sServerIncomingBuffer,'</address>',1)
      if((pos1 > 0) && (pos2 > pos1)){
       pos1 = pos1 + 9
       if(ES_sServerIncomingBuffer[pos1] == '/')  //Leading '/' in the content of the <address> element.  Ignore it.
        pos1 = pos1 + 1                           //Bug US-9695 reported to Echo360.
       if(pos2 > pos1){
        ES_sDeviceIP = mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)
        on[ES_bDevicePersistentSocket]
        if(ES_bDevicePortOpen){
         ip_client_close(vdvAppliance.port)
         off[ES_bDevicePortOpen]
        }
       }
       else{
        ES_sDeviceIP = ''
        EchoSystemDebugString(db_public,"'WARNING=The device <',buf,'> does not yet have an IP address.'")
       }
      }
      else{
       ES_sDeviceIP = ''
       EchoSystemDebugString(db_public,"'PARSE ISSUE=Could not determine Device IP address for <',buf,'>.'")
      }
     }
     else
      EchoSystemDebugString(db_public,"'WARNING=Can not control <',buf,'> devices.'")
     ES_eServerQuery = eNone
     ClearServerBuffer()
    }
    break;
   case eCampuses:
    if(find_string(ES_sServerIncomingBuffer,'</campuses>',1)){
     pos1 = find_string(ES_sServerIncomingBuffer,'<total-results>',1) + 15
     pos2 = find_string(ES_sServerIncomingBuffer,'</total-results>',pos1)
     if(atoi(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)) > 0){
      pos1 = find_string(ES_sServerIncomingBuffer,'<name>',pos1)
      ES_sLongResponse = 'CAMPUSES='
      while(pos1 > 0){
       pos1 = pos1 + 6
       pos2 = find_string(ES_sServerIncomingBuffer,'</name>',pos1)
       EchoSystemDebugString(db_developer,"'CAMPUS=<',HTMLToASCII(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)),'>'")
       ES_sLongResponse = "ES_sLongResponse,HTMLToASCII(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)),';'"
       pos1 = find_string(ES_sServerIncomingBuffer,'<name>',pos1)
      }
      if(length_array(ES_sLongResponse) > 9){
       ES_sLongResponse = left_string(ES_sLongResponse,length_array(ES_sLongResponse)-1)  //Drop trailing ';'
       EchoSystemDebugString(db_public,ES_sLongResponse)
      }
     }
     else{
      if(length_array(ES_sSearchParamValue)){
       EchoSystemDebugString(db_public,"'WARNING=No campuses found for <',ES_sSearchParamValue,'>.'")
       ES_sSearchParamValue = ''
      }
      else
       EchoSystemDebugString(db_public,"'WARNING=No campuses found.'")
     }
     ES_eServerQuery = eNone
     ClearServerBuffer()
    }
    break;
   case eBuildings:
    if(find_string(ES_sServerIncomingBuffer,'</buildings>',1)){
     pos1 = find_string(ES_sServerIncomingBuffer,'<total-results>',1) + 15
     pos2 = find_string(ES_sServerIncomingBuffer,'</total-results>',pos1)
     if(atoi(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)) > 0){
      pos1 = find_string(ES_sServerIncomingBuffer,'<name>',pos1)
      ES_sLongResponse = 'BUILDINGS='
      while(pos1 > 0){
       pos1 = pos1 + 6
       pos2 = find_string(ES_sServerIncomingBuffer,'</name>',pos1)
       EchoSystemDebugString(db_developer,"'BUILDING=<',HTMLToASCII(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)),'>'")
       ES_sLongResponse = "ES_sLongResponse,HTMLToASCII(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)),';'"
       pos1 = find_string(ES_sServerIncomingBuffer,'<name>',pos1)
      }
      if(length_array(ES_sLongResponse) > 10){
       ES_sLongResponse = left_string(ES_sLongResponse,length_array(ES_sLongResponse)-1)  //Drop trailing ';'
       EchoSystemDebugString(db_public,ES_sLongResponse)
      }
     }
     else{
      if(length_array(ES_sSearchParamValue)){
       EchoSystemDebugString(db_public,"'WARNING=No buildings found for <',ES_sSearchParamValue,'>.'")
       ES_sSearchParamValue = ''
      }
      else
       EchoSystemDebugString(db_public,"'WARNING=No buildings found.'")
     }
     ES_eServerQuery = eNone
     ClearServerBuffer()
    }
    break;
   case eRooms:
    //If the deployment has many rooms, we may not be able to fit the entire response in the buffer - warn for such cases.
    //This code might get called multiple times before the server has finished its response.  Wait for full response and parse on room-by-room basis.
    if(find_string(ES_sServerIncomingBuffer,'</rooms>',1)){
     pos1 = find_string(ES_sServerIncomingBuffer,'<total-results>',1)
     pos2 = find_string(ES_sServerIncomingBuffer,'</total-results>',1)
     if((pos1 == 0) || (pos2 == 0)){
      //So many rooms have pushed the start of the buffer into oblivion.
      EchoSystemDebugString(db_integrator,'There are many rooms in your deployment!')
      EchoSystemDebugString(db_integrator,'Some rooms may not get parsed properly - we will do our best effort.')
      EchoSystemDebugString(db_integrator,'Consider using the campus:building:room approach.')
     }
     else{
      pos1 = pos1 + 15
      if(atoi(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)) == 0){
       if(length_array(ES_sSearchParamValue))
        EchoSystemDebugString(db_public,"'WARNING=No rooms found for <',ES_sSearchParamValue,'>.'")
       else
        EchoSystemDebugString(db_public,'WARNING=No rooms found.')
      }
     }
     
     pos1 = find_string(ES_sServerIncomingBuffer,'<name>',1)
     if(pos1)
      pos2 = find_string(ES_sServerIncomingBuffer,'</name>',pos1)
     ES_sLongResponse = 'ROOMS='
     while((pos1 > 0) && (pos2 > 0)){
      pos1 = pos1 + 6
      EchoSystemDebugString(db_developer,"'ROOM=<',HTMLToASCII(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)),'>'")
      ES_sLongResponse = "ES_sLongResponse,HTMLToASCII(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)),';'"
      pos1 = find_string(ES_sServerIncomingBuffer,'<name>',pos1)
      if(pos1 > 0)
       pos2 = find_string(ES_sServerIncomingBuffer,'</name>',pos1)
     }
     if(length_array(ES_sLongResponse) > 6){
      ES_sLongResponse = left_string(ES_sLongResponse,length_array(ES_sLongResponse)-1)  //Drop trailing ';'
      EchoSystemDebugString(db_public,ES_sLongResponse)
     }
     ES_eServerQuery = eNone
     ClearServerBuffer()
    }
    break;
   case eBuildingsOnCampus:
    if(find_string(ES_sServerIncomingBuffer,'</campuses>',1)){
     if(find_string(ES_sServerIncomingBuffer,'<total-results>1</total-results>',1)){
      pos1 = find_string(ES_sServerIncomingBuffer,'</total-results>',1)
      pos1 = find_string(ES_sServerIncomingBuffer,'<campus>',pos1)
      pos1 = find_string(ES_sServerIncomingBuffer,'<id>',pos1) + 4
      pos2 = find_string(ES_sServerIncomingBuffer,'</id>',pos1)
      ES_sCampusID = mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)
      if(length_array(ES_sCampusID)){
       pos1 = find_string(ES_sServerIncomingBuffer,'<name>',pos1) + 6
       pos2 = find_string(ES_sServerIncomingBuffer,'</name>',pos1)
       ES_sCampusName = mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)
       ClearServerBuffer()
       ES_eServerQuery = eBuildingsOnCampus
       ServerRestCall("'campuses/',ES_sCampusID,'/buildings'")
      }
      else
       EchoSystemDebugString(db_public,'PARSE ISSUE=Could not determine Campus ID.')
     }
     else if(find_string(ES_sServerIncomingBuffer,'<total-results>0</total-results>',1)){
      if(length_array(ES_sSearchParamValue))
       EchoSystemDebugString(db_public,"'WARNING=No campuses found for <',ES_sSearchParamValue,'>.'")
      else
       EchoSystemDebugString(db_public,'WARNING=No campuses found.')
      ES_sSearchParamValue = ''
     }
     else{
      if(find_string(ES_sServerIncomingBuffer,'<total-results>',1) && find_string(ES_sServerIncomingBuffer,'</total-results>',1))
       EchoSystemDebugString(db_integrator,'Can not determine unique campus!')
      else
       EchoSystemDebugString(db_public,'PARSE ISSUE=Could not determine Campus ID.')
      ES_sCampusID = ''
      ES_eServerQuery = eNone
      ClearServerBuffer()
     }
    }
    else if(find_string(ES_sServerIncomingBuffer,'</buildings>',1)){
     pos1 = find_string(ES_sServerIncomingBuffer,'<total-results>',1) + 15
     pos2 = find_string(ES_sServerIncomingBuffer,'</total-results>',pos1)
     if(atoi(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)) > 0){
      pos1 = find_string(ES_sServerIncomingBuffer,'<name>',pos1)
      ES_sLongResponse = 'BUILDINGS='
      while(pos1 > 0){
       pos1 = pos1 + 6
       pos2 = find_string(ES_sServerIncomingBuffer,'</name>',pos1)
       EchoSystemDebugString(db_developer,"'BUILDING=<',HTMLToASCII(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)),'>'")
       ES_sLongResponse = "ES_sLongResponse,HTMLToASCII(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)),';'"
       pos1 = find_string(ES_sServerIncomingBuffer,'<name>',pos1)
      }
      if(length_array(ES_sLongResponse) > 10){
       ES_sLongResponse = left_string(ES_sLongResponse,length_array(ES_sLongResponse)-1)  //Drop trailing ';'
       EchoSystemDebugString(db_public,ES_sLongResponse)
      }
      else
       EchoSystemDebugString(db_integrator,"'PARSE ISSUE=Could not retrieve building names for <',ES_sCampusName,'>.'")
     }
     else
      EchoSystemDebugString(db_public,"'WARNING=No buildings found for <',ES_sCampusName,'>.'")
     ES_eServerQuery = eNone
     ClearServerBuffer()
    }
    break;
   case eRoomsInBuilding:
    if(find_string(ES_sServerIncomingBuffer,'</campuses>',1)){
     if(find_string(ES_sServerIncomingBuffer,'<total-results>1</total-results>',1)){
      pos1 = find_string(ES_sServerIncomingBuffer,'<campus>',1)
      pos1 = find_string(ES_sServerIncomingBuffer,'<id>',pos1) + 4
      pos2 = find_string(ES_sServerIncomingBuffer,'</id>',pos1)
      ES_sCampusID = mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)
      if(length_array(ES_sCampusID)){
       pos1 = find_string(ES_sServerIncomingBuffer,'<name>',pos1) + 6
       pos2 = find_string(ES_sServerIncomingBuffer,'</name>',pos1)
       ES_sCampusName = mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)
       ClearServerBuffer()
       ES_eServerQuery = eRoomsInBuilding
       ServerRestCall("'campuses/',ES_sCampusID,'/buildings?',ES_sSearchParamName,'=',right_string(ES_sSearchParamValue,length_array(ES_sSearchParamValue)-find_string(ES_sSearchParamValue,':',1))")
      }
      else
       EchoSystemDebugString(db_integrator,'PARSE ISSUE=Could not get campus ID.')
     }
     else if(find_string(ES_sServerIncomingBuffer,'<total-results>0</total-results>',1)){
      if(length_array(ES_sSearchParamValue))
       EchoSystemDebugString(db_public,"'WARNING=No campuses found for <',ES_sSearchParamValue,'>.'")
      else
       EchoSystemDebugString(db_public,'WARNING=No campuses found.')
      ES_sSearchParamValue = ''
     }
     else{
      if(find_string(ES_sServerIncomingBuffer,'<total-results>',1) && find_string(ES_sServerIncomingBuffer,'</total-results>',1))
       EchoSystemDebugString(db_integrator,'Can not determine unique campus!')
      else
       EchoSystemDebugString(db_public,'PARSE ISSUE=Could not determine Campus ID.')
     }
    }
    else if(find_string(ES_sServerIncomingBuffer,'</buildings>',1)){
     if(find_string(ES_sServerIncomingBuffer,'<total-results>1</total-results>',1)){
      pos1 = find_string(ES_sServerIncomingBuffer,'<building>',1)
      pos1 = find_string(ES_sServerIncomingBuffer,'<id>',pos1) + 4
      pos2 = find_string(ES_sServerIncomingBuffer,'</id>',pos1)
      ES_sBuildingID = mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)
      if(length_array(ES_sBuildingID)){
       pos1 = find_string(ES_sServerIncomingBuffer,'<name>',pos1) + 6
       pos2 = find_string(ES_sServerIncomingBuffer,'</name>',pos1)
       ES_sBuildingName = mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)
       ClearServerBuffer()
       ES_eServerQuery = eRoomsInBuilding
       ServerRestCall("'buildings/',ES_sBuildingID,'/rooms'")
      }
      else
       EchoSystemDebugString(db_integrator,'PARSE ISSUE=Could not get Building ID.')
     }
     else if(find_string(ES_sServerIncomingBuffer,'<total-results>0</total-results>',1)){
      if(length_array(ES_sSearchParamValue))
       EchoSystemDebugString(db_public,"'WARNING=No buildings found for <',ES_sSearchParamValue,'>.'")
      else
       EchoSystemDebugString(db_public,'WARNING=No campus:building specified.')
      ES_sSearchParamValue = ''
     }
     else{
      if(find_string(ES_sServerIncomingBuffer,'<total-results>',1) && find_string(ES_sServerIncomingBuffer,'</total-results>',1))
       EchoSystemDebugString(db_integrator,'Can not determine unique campus:building!')
      else
       EchoSystemDebugString(db_public,'PARSE ISSUE=Could not determine Building ID.')
      ES_eServerQuery = eNone
      ClearServerBuffer()
     }
    }
    else if(find_string(ES_sServerIncomingBuffer,'</rooms>',1)){
     pos1 = find_string(ES_sServerIncomingBuffer,'<total-results>',1) + 15
     pos2 = find_string(ES_sServerIncomingBuffer,'</total-results>',pos1)
     if(atoi(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)) > 0){
      pos1 = find_string(ES_sServerIncomingBuffer,'<name>',pos1)
      ES_sLongResponse = 'ROOMS='
      while(pos1 > 0){
       pos1 = pos1 + 6
       pos2 = find_string(ES_sServerIncomingBuffer,'</name>',pos1)
       EchoSystemDebugString(db_developer,"'ROOM=<',HTMLToASCII(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)),'>'")
       ES_sLongResponse = "ES_sLongResponse,HTMLToASCII(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)),';'"
       pos1 = find_string(ES_sServerIncomingBuffer,'<name>',pos1)
      }
      if(length_array(ES_sLongResponse) > 6){
       ES_sLongResponse = left_string(ES_sLongResponse,length_array(ES_sLongResponse)-1)  //Drop trailing ';'
       EchoSystemDebugString(db_public,ES_sLongResponse)
      }
      else
       EchoSystemDebugString(db_public,"'WARNING=No rooms found for <',ES_sSearchParamValue,'>.'")
     }
     else{  //Fail on room name.
      EchoSystemDebugString(db_public,"'WARNING=No rooms found for <',ES_sSearchParamValue,'>.'")
     }
     ES_eServerQuery = eNone
     ClearServerBuffer()
    }
    break;
   case eCampusBuildingRoom:  //This branch is used when ES_sRoomName is in <campus>:<building>:<room> format.
    if(find_string(ES_sServerIncomingBuffer,'</campuses>',1)){
     if(find_string(ES_sServerIncomingBuffer,'<total-results>1</total-results>',1)){
      pos1 = find_string(ES_sServerIncomingBuffer,'<campus>',1)
      pos1 = find_string(ES_sServerIncomingBuffer,'<id>',pos1) + 4
      pos2 = find_string(ES_sServerIncomingBuffer,'</id>',pos1)
      ES_sCampusID = mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)
      if(length_array(ES_sCampusID)){
       ES_sBuildingName = mid_string(ES_sRoomName,find_string(ES_sRoomName,':',1)+1, find_rstring(ES_sRoomName,':',length_array(ES_sRoomName))-find_string(ES_sRoomName,':',1)-1)
       ClearServerBuffer()
       ES_eServerQuery = eCampusBuildingRoom
       ServerRestCall("'campuses/',ES_sCampusID,'/buildings?',ES_sSearchParamName,'=',ES_sBuildingName")
      }
      else
       EchoSystemDebugString(db_integrator,'PARSE ISSUE=Could not get CampusID.')
     }
     else{  //Fail on Campus.
      if(find_string(ES_sServerIncomingBuffer,'<total-results>0</total-results>',1))
       EchoSystemDebugString(db_public,"'WARNING=No campuses found for <',ES_sRoomName,'>'")
      else
       EchoSystemDebugString(db_integrator,"'Multiple campuses found for <',ES_sRoomName,'>'")
     }
    }
    else if(find_string(ES_sServerIncomingBuffer,'</buildings>',1)){
     if(find_string(ES_sServerIncomingBuffer,'<total-results>1</total-results>',1)){
      pos1 = find_string(ES_sServerIncomingBuffer,'<building>',1)
      pos1 = find_string(ES_sServerIncomingBuffer,'<id>',pos1) + 4
      pos2 = find_string(ES_sServerIncomingBuffer,'</id>',pos1)
      ES_sBuildingID = mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)
      if(length_array(ES_sBuildingID)){
       ClearServerBuffer()
       ES_eServerQuery = eCampusBuildingRoom
       ServerRestCall("'buildings/',ES_sBuildingID,'/rooms?',ES_sSearchParamName,'=',right_string(ES_sRoomName,length_array(ES_sRoomName)-find_rstring(ES_sRoomName,':',length_array(ES_sRoomName)))")
      }
      else
       EchoSystemDebugString(db_integrator,'PARSE ISSUE=Could not get BuildingID.')
     }
     else{  //Fail on Buildings
      if(find_string(ES_sServerIncomingBuffer,'<total-results>0</total-results>',1))
       EchoSystemDebugString(db_public,"'WARNING=No buildings found for <',ES_sRoomName,'>'")
      else
       EchoSystemDebugString(db_integrator,"'Multiple buildings found for <',ES_sRoomName,'>'")
     }
    }
    else if(find_string(ES_sServerIncomingBuffer,'</rooms>',1)){
     if(find_string(ES_sServerIncomingBuffer,'<total-results>1</total-results>',1)){
      pos1 = find_string(ES_sServerIncomingBuffer,'<room>',1)
      pos1 = find_string(ES_sServerIncomingBuffer,'<id>',pos1) + 4
      pos2 = find_string(ES_sServerIncomingBuffer,'</id>',pos1)
      ES_sRoomID = mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)
      if(length_array(ES_sRoomID)){
       ClearServerBuffer()
       ES_eServerQuery = eCampusBuildingRoom
       ServerRestCall("'rooms/',ES_sRoomID")
      }
      else
       EchoSystemDebugString(db_integrator,'PARSE ISSUE=Could not get BuildingID.')
     }
     else{  //Fail on Rooms
      if(find_string(ES_sServerIncomingBuffer,'<total-results>0</total-results>',1))
       EchoSystemDebugString(db_public,"'WARNING=No rooms found for <',ES_sRoomName,'>'")
      else
       EchoSystemDebugString(db_integrator,"'Multiple rooms found for <',ES_sRoomName,'>'")
     }
    }
    else if(find_string(ES_sServerIncomingBuffer,'</devices>',1)){
     if(find_string(ES_sServerIncomingBuffer,'<total-results>1</total-results>',1)){
      pos1 = find_string(ES_sServerIncomingBuffer,'<device>',1)
      pos1 = find_string(ES_sServerIncomingBuffer,'<id>',pos1) + 4
      pos2 = find_string(ES_sServerIncomingBuffer,'</id>',pos1)
      ES_sDeviceID = mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)
      if(length_array(ES_sDeviceID)){
       ClearServerBuffer()
       ES_eServerQuery = eDeviceDetails
       ServerRestCall("'devices/',ES_sDeviceID")
      }
      else
       EchoSystemDebugString(db_integrator,'PARSE ISSUE=Could not get DeviceID.')
     }
     else{  //Fail on Rooms
      if(find_string(ES_sServerIncomingBuffer,'<total-results>0</total-results>',1))
       EchoSystemDebugString(db_public,"'WARNING=Room <',ES_sRoomName,'> has no associated devices.'")
      else{
       EchoSystemDebugString(db_public,"'WARNING=Room <',ES_sRoomName,'> has multiple capture devices.'")
       EchoSystemDebugString(db_integrator,"'Unable to determine which one you want to control.'")
      }
     }
    }
    else
     EchoSystemDebugString(db_integrator,"'PARSE ISSUE=Could not retrieve details for <',ES_sRoomName,'>'")
    break;
   case eProductGroups:
    if(find_string(ES_sServerIncomingBuffer,'</product-groups>',1)){
     pos1 = find_string(ES_sServerIncomingBuffer,'<total-results>',1) + 15
     pos2 = find_string(ES_sServerIncomingBuffer,'</total-results>',pos1)
     if(atoi(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1)) > 0){
      pos1 = find_string(ES_sServerIncomingBuffer,'<name>',pos1)
      while(pos1 > 1){
       pos1 = pos1 + 6
       pos2 = find_string(ES_sServerIncomingBuffer,'</name>',pos1)
       if(pos2 > 0){
        EchoSystemDebugString(db_public,"'SERVER PRODUCT GROUP=',HTMLToASCII(mid_string(ES_sServerIncomingBuffer,pos1,pos2-pos1))")
        pos1 = find_string(ES_sServerIncomingBuffer,'<name>',pos2)
       }
       else{  //no closing </name>
        pos1 = 0  //bail out
        EchoSystemDebugString(db_integrator,"'PARSE ISSUE=No closing </name> element while parsing for SERVER PRODUCT GROUP.'")
       }
      }
     }
     else{
      EchoSystemDebugString(db_public,"'WARNING=No product groups found.'")
     }
     ES_eServerQuery = eNone
     ClearServerBuffer()
    }
  }
 }
}

define_function EchoSystemServerRefresh(){
 if(length_array(ES_sRoomName) == 0)
  return;
 if(length_array(ES_sServerAddress) == 0)
  return;
 
 EchoSystemDebugString(db_integrator,'Server refresh...')
 if(find_rstring(ES_sRoomName,':',1) != find_rstring(ES_sRoomName,':',length_array(ES_sRoomName))){  //ES_sRoomName is campus:building:room
  ES_sCampusID = ''
  ES_sCampusName = left_string(ES_sRoomName,find_string(ES_sRoomName,':',1) - 1)
  ES_sBuildingID = ''
  ES_sRoomID = ''
  ES_eServerQuery = eCampusBuildingRoom
  ServerRestCall("'campuses?',ES_sSearchParamName,'=',ES_sCampusName")
  //The rest of this process is handeled in ParseServerResponse()
 }
 else{  //ES_sRoomName is short-form.
  ES_eServerQuery = eRoom
  ES_sRoomID = ''
  ServerRestCall("'rooms?',ES_sSearchParamName,'=',ES_sRoomName")
  //The rest of this process is handeld in ParseServerResponse()
 }
}


/*
 _______   ______  __    __    ______        _______.____    ____  _______.___________. _______ .___  ___. 
|   ____| /      ||  |  |  |  /  __  \      /       |\   \  /   / /       |           ||   ____||   \/   | 
|  |__   |  ,----'|  |__|  | |  |  |  |    |   (----` \   \/   / |   (----`---|  |----`|  |__   |  \  /  | 
|   __|  |  |     |   __   | |  |  |  |     \   \      \_    _/   \   \       |  |     |   __|  |  |\/|  | 
|  |____ |  `----.|  |  |  | |  `--'  | .----)   |       |  | .----)   |      |  |     |  |____ |  |  |  | 
|_______| \______||__|  |__|  \______/  |_______/        |__| |_______/       |__|     |_______||__|  |__| 
                                                                                                           
 _______   ___________    ____  __    ______  _______                                                      
|       \ |   ____\   \  /   / |  |  /      ||   ____|                                                     
|  .--.  ||  |__   \   \/   /  |  | |  ,----'|  |__                                                        
|  |  |  ||   __|   \      /   |  | |  |     |   __|                                                       
|  '--'  ||  |____   \    /    |  | |  `----.|  |____                                                      
|_______/ |_______|   \__/     |__|  \______||_______|                                                     
*/

define_function ClearDeviceBuffer(){
#if_defined DEVELOPMENT_PHASE
 DEBUG_DeviceBuffer2 = "DEBUG_DeviceBuffer1"
 DEBUG_DeviceBuffer1 = "ES_sDeviceIncomingBuffer"
#end_if
 ES_sDeviceIncomingBuffer = ''
}
define_function ClearDeviceSensors(){
 stack_var char i
 for(i = 1; i <= 6; i++)
  ES_iDeviceSensorArray[i] = 0
}

define_function DeviceGetMessage(char inMessage[]){
 #if_defined BETA_RELEASE
 if(moduleDisabled())
  return;
 #end_if
 
 timeline_set(tlDeviceRefresh,0)  //Delay the background polling from firing for a little while.
 EchoSystemDebugString(db_developer,"'DeviceGetMessage(',inMessage,')'") 
 ES_sDeviceOutgoingBuffer = "'GET ',inMessage,' HTTP/1.1',crlf,
                             'Host: ',ES_sDeviceIP,':',itoa(ES_iDevicePort),crlf,
                             'Authorization: Basic ',ES_sDeviceKey,crlf"  //Base64(<username>:<password>)
 //Persistent sockets introduced in SafeCapHD fw v5.4.xxxxx.  Earlier versions forced socket closed.
 if(ES_bDevicePersistentSocket){
  ES_sDeviceOutgoingBuffer = "ES_sDeviceOutgoingBuffer,'Connection: Keep-Alive',crlf"
  ES_sDeviceOutgoingBuffer = "ES_sDeviceOutgoingBuffer,'Content-Length: 0',crlf"
 }
 else
  ES_sDeviceOutgoingBuffer = "ES_sDeviceOutgoingBuffer,'Connection: close',crlf"
 ES_sDeviceOutgoingBuffer = "ES_sDeviceOutgoingBuffer,'User-Agent: AMX EchoSystem module v',cVersion,crlf,crlf"
 
 if(find_string(inMessage,'/log-list-last-count',1))
  ClearDeviceSensors()
 
 if(length_array(ES_sDeviceIP) > 1){
  //Send the message
  ClearDeviceBuffer()
  if(ES_bDevicePortOpen)
   send_string vdvAppliance,ES_sDeviceOutgoingBuffer
  else{
   EchoSystemDebugString(db_developer,'opening port to device...')
   ip_client_open(vdvAppliance.port,ES_sDeviceIP,ES_iDevicePort,ip_tcp)
  }
 }
 else
  EchoSystemDebugString(db_integrator,"'Device address is empty.  Ignoring <',inMessage,'> message.'")
}

define_function DevicePostMessage(char inMessage[]){
 stack_var integer paramStart
 stack_var char    parameters[1024]
 
 #if_defined BETA_RELEASE
 if(moduleDisabled())
  return;
 #end_if
 
 timeline_set(tlDeviceRefresh,0)  //Delay the background polling from firing for a little while.
 EchoSystemDebugString(db_developer,"'DevicePostMessage(',inMessage,')'") 
 if(length_array(inMessage) >= 1000)
  EchoSystemDebugString(db_developer,"'My, what big parameters you have! DevicePostMessage(',left_string(inMessage,100),')<snip>'") 
 
 //Check for parameters
 paramStart = find_string(inMessage,'?',1)
 if(paramStart > 0){
  parameters = right_string(inMessage,length_array(inMessage) - paramStart)
  //For time extentions, the CA will default to 10 min if the parameters are URL encoded.
  //Tested on [fw2.5.17078|api2.0/2.1/2.2] [fw4.0.25278|api3.0]
  //if(versionCompare(ES_SDeviceFWVersion,'>=','5.0'))
  // parameters = URLEncode(parameters)
  inMessage = left_string(inMessage,paramStart - 1)  //Remove the parameters from the base url.
 }
 ES_sDeviceOutgoingBuffer = "'POST ',inMessage,' HTTP/1.1',crlf,
                             'Host: ',ES_sDeviceIP,':',itoa(ES_iDevicePort),crlf,
                             'Authorization: Basic ',ES_sDeviceKey,crlf"  //Base64(<username>:<password>)
 //Gen1 and SafeCapture HD CAs force the socket closed.  Tested on fw v4.0.25278 and v5.1.30095.
 //Persistent sockets introduced in SafeCapHD fw v5.4.38633. 
 if(ES_bDevicePersistentSocket)
  ES_sDeviceOutgoingBuffer = "ES_sDeviceOutgoingBuffer,'Connection: Keep-Alive',crlf"
 else
  ES_sDeviceOutgoingBuffer = "ES_sDeviceOutgoingBuffer,'Connection: close',crlf"
 if(ES_bDevicePersistentSocket || (length_array(parameters) > 0))  //HTTP/1.1 requires Content-Length in all persistent socket packets.
  ES_sDeviceOutgoingBuffer = "ES_sDeviceOutgoingBuffer,'Content-Length: ',itoa(length_array(parameters)),crlf"
 ES_sDeviceOutgoingBuffer = "ES_sDeviceOutgoingBuffer,'User-Agent: AMX EchoSystem module v',cVersion,crlf,crlf"  //End of header
 //HTTP body
 if(paramStart > 0)  //Put parameters into HTTP body
  ES_sDeviceOutgoingBuffer = "ES_sDeviceOutgoingBuffer,parameters"

 if(length_array(ES_sDeviceIP) > 1){
  //Send the message
  ClearDeviceBuffer()
  if(ES_bDevicePortOpen)
   send_string vdvAppliance, ES_sDeviceOutgoingBuffer
  else{
   EchoSystemDebugString(db_developer,'opening port to device...')
   ip_client_open(vdvAppliance.port,ES_sDeviceIP,ES_iDevicePort,ip_tcp)
  }
 }
 else
  EchoSystemDebugString(db_integrator,"'Device address is empty.  Ignoring <',inMessage,'> message.'")
}

define_function SetDeviceLogFilters(){
 if(ES_eDeviceType == typeProHarwareCapture){
  ES_aDeviceLog[1].name = 'Temperature: Sensor 1:'
  ES_aDeviceLog[2].name = 'Temperature: Sensor 2:'
  ES_aDeviceLog[3].name = 'Temperature: Sensor 3:'
  ES_aDeviceLog[4].name = 'Temperature: Sensor 4:'
  ES_aDeviceLog[5].name = 'Temperature: Sensor 5:'
  ES_aDeviceLog[6].name = 'Temperature: Sensor 6:'
  ES_aDeviceLog[7].name = 'Fan 1: Speed:'
  ES_aDeviceLog[8].name = 'Fan 2: Speed:'
  ES_aDeviceLog[9].name = 'Fan 3: Speed:'
  ES_aDeviceLog[10].name = 'Filesystem /data'  //Make sure we don't grab the FilesystemSpace log entry for /opt.
  ES_aDeviceLog[11].name = 'Timeout was reached'
 }
 else if(ES_eDeviceType == typeBasicHardwareCapture){
  ES_aDeviceLog[1].name = 'temperature:'
  ES_aDeviceLog[2].name = ''
  ES_aDeviceLog[3].name = ''
  ES_aDeviceLog[4].name = ''
  ES_aDeviceLog[5].name = ''
  ES_aDeviceLog[6].name = ''
  ES_aDeviceLog[7].name = ''
  ES_aDeviceLog[8].name = ''
  ES_aDeviceLog[9].name = ''
  ES_aDeviceLog[10].name = 'Filesystem /data'
  ES_aDeviceLog[11].name = 'Timeout was reached'
 }
}

define_function ParseDeviceLogEntry(integer inIndex, char inLogText[1024]){
 stack_var long logTime
 stack_var integer pos1
 
 pos1 = find_string(inLogText,'when: ',1) + 6
 logTime = getSecondsSinceEpoch(mid_string(inLogText,pos1,24))
 if(logTime > ES_aDeviceLog[inIndex].epochTime){  //The log entry is newer.  Store it.
  ES_aDeviceLog[inIndex].epochTime = logTime
  select{
   //This is where we parse the individual log message based on the type of message that it appears to be.
   active(find_string(inLogText,'type: SystemTemperature',1)):{  //temp: 45.0
    if(find_string(inLogText,'temperature: ',1))  //Gen1 v4.0.25278 has "temperature: <value>".  Newer firmware has "temp: <value>".
     remove_string(inLogText,'temperature: ',1)
    else
     remove_string(inLogText,'temp: ',1)
    ES_aDeviceLog[inIndex].value = itoa(atoi(remove_string(inLogText,'.',1)))
    EchoSystemDebugString(db_developer,"'DeviceLog[',itoa(inIndex),'] updated to <',ES_aDeviceLog[inIndex].value,'> with epoch:',itoa(ES_aDeviceLog[inIndex].epochTime),'.'")
   }
   active(find_string(inLogText,'type: SystemFanSpeeds',1)):{  //rpm: 3721.000000
    remove_string(inLogText,'rpm: ',1)
    ES_aDeviceLog[inIndex].value = itoa(atoi(remove_string(inLogText,'.',1)))
    EchoSystemDebugString(db_developer,"'DeviceLog[',itoa(inIndex),'] updated to <',ES_aDeviceLog[inIndex].value,'> with epoch:',itoa(ES_aDeviceLog[inIndex].epochTime),'.'")
   }
   active(find_string(inLogText,'type: FilesystemSpace',1)):{  //percent: 2 total: 210179108864
    remove_string(inLogText,'percent: ',1)
    ES_aDeviceLog[inIndex].value = "itoa(atoi(inLogText)),'%'"
    remove_string(inLogText,'total: ',1)
    ES_aDeviceLog[inIndex].value = "ES_aDeviceLog[inIndex].value,ftoa(atof(inLogText))"
    EchoSystemDebugString(db_developer,"'DeviceLog[',itoa(inIndex),'] updated to <',ES_aDeviceLog[inIndex].value,'> with epoch:',itoa(ES_aDeviceLog[inIndex].epochTime),'.'")
   }
   active((find_string(inLogText,'type: POSTTransferFailed',1)) && (find_string(inLogText,'transfer-error: Timeout was reached',1))):{
    ES_aDeviceLog[inIndex].value = 'timeout'
    EchoSystemDebugString(db_developer,"'DeviceLog[',itoa(inIndex),'] updated to <',ES_aDeviceLog[inIndex].value,'> with epoch:',itoa(ES_aDeviceLog[inIndex].epochTime),'.'")
   }
   active(1):
    EchoSystemDebugString(db_developer,"'Unrecognised log entry: ',inLogText")
  }
 }
}

define_function ParseDeviceResponse(){
 local_var integer failCount
 stack_var integer pos1
 stack_var integer pos2
 stack_var char buffer[255]
 stack_var char tempCampus[255]
 stack_var char tempBuilding[255]
 stack_var long wallClock
 stack_var long startClock
 local_var long prevStartClock
 stack_var integer duration
 stack_var integer varOldTime
 stack_var sinteger varOldTemperature
 stack_var long varOldClockDriftEpoch
 stack_var sinteger varParamValue
 stack_var char varParamCount
 stack_var float capacity
 stack_var char bUploadPending
 stack_var char bUploadActive
 stack_var char i
 stack_var slong sFileResult
 stack_var char bDumpMarker
 
 if(ES_bDump && (length_array(ES_sDeviceIncomingBuffer) > 0)){
  //File is alreay open.
  EchoSystemDebugString(db_integrator,'Dumping...')
  pos1 = 1
  pos2 = pos1 + MAX_INPUT_CHUNK_BYTES - 1
  bDumpMarker = false
  while(pos2 < length_array(ES_sDeviceIncomingBuffer)){
   if(!bDumpMarker){
    sFileResult = file_write(ES_hDumpFile,"'*****',$0d,$0a",7)
    bDumpMarker = true
   }
   sFileResult = file_write(ES_hDumpFile,mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1) + 1),MAX_INPUT_CHUNK_BYTES)
   select{
    active(sFileResult == -1):{ EchoSystemDebugString(db_integrator,'Invalid file handle') }
    active(sFileResult == -5):{ EchoSystemDebugString(db_integrator,'Disk I/O error') }
    active(sFileResult == -6):{ EchoSystemDebugString(db_integrator,'Invalid parameter') }
    active(sFileResult == -11):{ EchoSystemDebugString(db_integrator,'Disk full') }
   }
   pos1 = pos2 + 1
   pos2 = pos1 + MAX_INPUT_CHUNK_BYTES - 1
  }
  pos2 = length_array(ES_sDeviceIncomingBuffer) - pos1 + 1  //Bytes remaining to be dumped.
  sFileResult = file_write(ES_hDumpFile,right_string(ES_sDeviceIncomingBuffer,pos2),pos2)
  select{
   active(sFileResult == -1):{ EchoSystemDebugString(db_integrator,'Invalid file handle') }
   active(sFileResult == -5):{ EchoSystemDebugString(db_integrator,'Disk I/O error') }
   active(sFileResult == -6):{ EchoSystemDebugString(db_integrator,'Invalid parameter') }
   active(sFileResult == -11):{ EchoSystemDebugString(db_integrator,'Disk full') }
  }
  sFileResult = file_write(ES_hDumpFile,"crlf,crlf",4)
 }
 
 //If there are errors we may want to resend the request.  If there are no errors we can proceed with parsing.
 if(find_string(ES_sDeviceIncomingBuffer,'HTTP/1.1 4',1) == 1){  //Error
/*
Rog - we shouldn't be hammering the CA based on a 4xx response.  We need to be more specific with our hammering.
See http://tools.ietf.org/html/rfc2616#section-6 for status codes.  We should request that Echo360 update their response codes to more-closely reflect the standard.

401 Unauthorized         - Username/password is incorrect.
403 Invalid Request      - CA is Idle and we mistakenly issue a STOP command.
404 Not Found            - We issued an unsupported command, like "GET HTTP/1.1 /garbage".
406 Not Acceptable Input - Bad parameters in a command to the CA.
411 Length Required      - HTTP header "Content-Length: " doesn't match body length.  Bug in NGINX default config.
*/
  wait 10
   off[ES_bDevicePortBusy]
  if(failCount < MAX_DEVICE_RESENDS){
   failCount++
   pos1 = find_string(ES_sDeviceIncomingBuffer,'HTTP/1.1 ',1) + 9
   pos2 = find_string(ES_sDeviceIncomingBuffer,"crlf",1)
   if(find_string(mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1),'401',1)){
    EchoSystemDebugString(db_public,'WARNING=Device credentials are not authorized.')
    if(find_string(ES_sDeviceIncomingBuffer,'echo360',1) == 0)
     EchoSystemDebugString(db_integrator,"'Are you sure the device <',ES_sDeviceIP,'> is capture hardware?'")
    else
     EchoSystemDebugString(db_integrator,'Check your device credentials.')
   }
   EchoSystemDebugString(db_developer,"'Device response <',mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)),'>, fail count <',itoa(failCount),'>'")
   if(find_string(ES_sDeviceIncomingBuffer,'<error text="',1)){
    remove_string(ES_sDeviceIncomingBuffer,'<error text="',1)
    pos2 = find_string(ES_sDeviceIncomingBuffer,'"',1)
    EchoSystemDebugString(db_developer,"'Device reason <',left_string(ES_sDeviceIncomingBuffer,pos2),'>'")
   }
   timeline_set(tlDeviceRefresh,0)
   switch(ES_eDeviceQuery){
    case eGetState:
     wait_until(!ES_bDevicePortBusy){
      ClearDeviceBuffer()
      DeviceGetMessage('/status/current_capture')
     }
     break;
    case eGetSysStatus:
     wait_until(!ES_bDevicePortBusy){
      ClearDeviceBuffer()
      DeviceGetMessage('/status/system')
     }
     break;
    case eGetLogs:
     wait_until(!ES_bDevicePortBusy){
      ClearDeviceBuffer()
      DeviceGetMessage("'/log-list-last-count/',itoa(DEVICE_MAX_LOG_ENTRIES)")
     }
     break;
    case eStop:
     wait_until(!ES_bDevicePortBusy){
      if(find_string(ES_sDeviceIncomingBuffer,'No capture is running.',1) == 0){
       ClearDeviceBuffer()
       DevicePostMessage('/capture/stop')
      }
     }
     break;
    case ePause:
     wait_until(!ES_bDevicePortBusy){
      if(find_string(ES_sDeviceIncomingBuffer,'No capture is running.',1) == 0){
       ClearDeviceBuffer()
       DevicePostMessage('/capture/pause')
      }
     }
     break;
    case eResume:
     wait_until(!ES_bDevicePortBusy){
      if(find_string(ES_sDeviceIncomingBuffer,'No capture is running.',1) == 0){
       ClearDeviceBuffer()
       DevicePostMessage('/capture/record')
      }
     }
     break;
    case eExtend:
     wait_until(!ES_bDevicePortBusy){
      if(find_string(ES_sDeviceIncomingBuffer,'No capture is running.',1) == 0){
       ClearDeviceBuffer()
       DevicePostMessage("'/capture/extend?duration=',itoa(ES_iDeviceExtendBy),'&extend=submit'")
      }
     }
     break;
    case eReboot:
     wait_until(!ES_bDevicePortBusy){
      ClearDeviceBuffer()
      DevicePostMessage('/diagnostics/reboot')
     }
     break;
    default:
     off[vdvDevice,chHardwareOnline]
     total_off[vdvDevice,chIdle]
     total_off[vdvDevice,chPaused]
     total_off[vdvDevice,chRecording]
     total_off[vdvDevice,chScheduled]
     total_off[vdvDevice,chAdHoc]
     total_off[vdvDevice,chMonitoring]
     off[vdvDevice,chLive]
     off[vdvDevice,chAudioDetect]
     off[vdvDevice,chVideo1Detect]
     off[vdvDevice,chVideo2Detect]
     break;
   }
  }
  else{
   EchoSystemDebugString(db_integrator,"'Exceeded max device attempts (',itoa(MAX_DEVICE_RESENDS),').  Bailing out.'")
   off[vdvDevice,chHardwareOnline]
   total_off[vdvDevice,chIdle]
   total_off[vdvDevice,chPaused]
   total_off[vdvDevice,chRecording]
   total_off[vdvDevice,chScheduled]
   total_off[vdvDevice,chAdHoc]
   total_off[vdvDevice,chMonitoring]
   off[vdvDevice,chLive]
   off[vdvDevice,chAudioDetect]
   off[vdvDevice,chVideo1Detect]
   off[vdvDevice,chVideo2Detect]
   failCount = 0
   ClearDeviceBuffer()
  }
 }
 else if(find_string(ES_sDeviceIncomingBuffer,'</status>',1)){
  failCount = 0
  on[vdvDevice,chHardwareOnline]
  
  //Parse the HTTP header
  if(find_string(ES_sDeviceIncomingBuffer,'Server: hardware-capture',1) || find_string(ES_sDeviceIncomingBuffer,'Server: pro-hardware-capture',1)
     || find_string(ES_sDeviceIncomingBuffer,'Server: nginx',1)){
   //Extract firmware version
   buffer = ''
   select{
/*
    active(find_string(ES_sDeviceIncomingBuffer,'Server: nginx',1) > 0):{
     //Only seen in dev (non-release) versions of SCHD from v5.4.0 < v5.4.38789.  Keep it here in case they accidently revert.
     if(ES_eDeviceType != typeProHarwareCapture){
      ES_eDeviceType = typeProHarwareCapture
      SetDeviceLogFilters()
     }
#warn 'persistent socket tweeking'
//Here and below as well.
     on[ES_bDevicePersistentSocket]
     if(find_string(ES_sDeviceIncomingBuffer,'Connection: close',1)){
      EchoSystemDebugString(db_developer,'Header had Connection: close')
      off[ES_bDevicePersistentSocket]
      if(ES_bDevicePortOpen)
       ip_client_close(vdvAppliance.port)
      off[ES_bDevicePortOpen]
     }
     pos1 = find_string(ES_sDeviceIncomingBuffer,'Server: nginx',1)
     EchoSystemDebugString(db_developer,'Appliance is using NGINX in HTTP header again.')
    }
*/
    active(find_string(ES_sDeviceIncomingBuffer,'Server: pro-hardware-capture',1) > 0):{
     if(ES_eDeviceType != typeProHarwareCapture){
      ES_eDeviceType = typeProHarwareCapture
      SetDeviceLogFilters()
     }
     if(!ES_bDevicePersistentSocket){  //Try to put the module back into persistent mode.
      pos1 = find_string(ES_sDeviceIncomingBuffer,'Server: pro-hardware-capture',1)
      pos1 = find_string(ES_sDeviceIncomingBuffer,'/',pos1) + 1
      pos2 = find_string(ES_sDeviceIncomingBuffer,"crlf",pos1)
      buffer = mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1))
      if(versionCompare(buffer,'>=','5.4.38789'))  //We only support persistence for this verison and greater.
       on[ES_bDevicePersistentSocket]
     }
//*
     //SCHD v5.4 introdud support for persistent sockets.
     //SCHD v5.4.38789 handeled 0-length message bodies correctly.

//     if(versionCompare(buffer,'>=','5.4.38789'))
//     if((find_string(ES_sDeviceIncomingBuffer,'Connection: close',1) == 0) && (versionCompare(buffer,'>=','5.4.38789')))
//      on[ES_bDevicePersistentSocket]
//     else
//      off[ES_bDevicePersistentSocket]
//     if(find_string(ES_sDeviceIncomingBuffer,'Connection: close',1)){
//      EchoSystemDebugString(db_developer,'Header had Connection: close')
//      off[ES_bDevicePersistentSocket]
//      if(ES_bDevicePortOpen)
//       ip_client_close(vdvAppliance.port)
//      off[ES_bDevicePortOpen]
//     }
//*/
    }
    active(find_string(ES_sDeviceIncomingBuffer,'Server: hardware-capture',1) > 0):{
     if(ES_eDeviceType != typeBasicHardwareCapture){
      ES_eDeviceType = typeBasicHardwareCapture
      SetDeviceLogFilters()
     }
//     off[ES_bDevicePersistentSocket]
     pos1 = find_string(ES_sDeviceIncomingBuffer,'Server: hardware-capture',1)
    }
    active(1):{
     ES_eDeviceType = typeUnknown
//     off[ES_bDevicePersistentSocket]
    }
   }
   //Determine socket behavior.  Persistent or non-persistent.
   if(find_string(ES_sDeviceIncomingBuffer,'Connection: keep-alive',1) > 0)
    on[ES_bDevicePersistentSocket]
   else if(find_string(ES_sDeviceIncomingBuffer,'Connection: close',1) > 0)
    off[ES_bDevicePersistentSocket]
   else
    off[ES_bDevicePersistentSocket]
   
   //Extract API version(s).  Store the highest version.
   buffer = ''
   pos1 = find_string(ES_sDeviceIncomingBuffer,'<api-version>',1)
   while(pos1){
    pos1 = pos1 + 13
    pos2 = find_string(ES_sDeviceIncomingBuffer,'</api-version>',pos1)
    buffer = "buffer,trim(mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1)),','"
    pos1 = find_string(ES_sDeviceIncomingBuffer,'<api-version>',pos2)
   }
   if(length_array(buffer)){
    buffer = left_string(buffer,length_array(buffer)-1)  //Drop trailing ','.
    if(ES_sDeviceAPIVersions != buffer)
     ES_sDeviceAPIVersions = buffer
   }
  }
  
  //Product Groups are reported regardless of hardware recording state.  We only want to parse them if the end-user requires them.
  //Appliances will only report Product Groups that can be used for Ad Hoc recordings.
  if(ES_iDeviceProductGroupsExplicit && find_string(ES_sDeviceIncomingBuffer,'</capture-profile>',1)){
   //"Capture Profile" is a deprecated term for "Product Group".  The terminology was updated in ESS v4, but CA API v3.0 still
   //uses the old terminology.  We expect that this will change some day.  Parse for the old terminology, but present it as the
   //new, since this is what ESS admins will be familiar with.
   pos1 = find_string(ES_sDeviceIncomingBuffer,'<capture-profile>',1)
   while(pos1 > 0){
    pos1 = pos1 + 17
    pos2 = find_string(ES_sDeviceIncomingBuffer,'</capture-profile>',pos1)
    //Copy the profile into buffer, converting '&' (&#038;), '<' (&#060;) and '>' (&#062;) at the same time.
    buffer = AmpGtLtToASCII(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)))
    EchoSystemDebugString(db_public,"'DEVICE PRODUCT GROUP=',buffer")
    pos1 = find_string(ES_sDeviceIncomingBuffer,'<capture-profile>',pos2)
   }
   off[ES_iDeviceProductGroupsExplicit]
  }
  else if(ES_iDeviceProductGroupsExplicit && find_string(ES_sDeviceIncomingBuffer,'</product-group>',1)){
   //This reply does not appear in CA API v3.0, but we expect that one day it will.
   pos1 = find_string(ES_sDeviceIncomingBuffer,'<product-group>',1)
   while(pos1 > 0){
    pos1 = pos1 + 15
    pos2 = find_string(ES_sDeviceIncomingBuffer,'</product-group>',pos1)
    //Copy the Product Group into buffer, converting '&' (&#038;), '<' (&#060;) and '>' (&#062;) at the same time.
    buffer = AmpGtLtToASCII(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)))
    EchoSystemDebugString(db_public,"'DEVICE PRODUCT GROUP=',buffer")
    pos1 = find_string(ES_sDeviceIncomingBuffer,'<product-group>',pos2)
   }
   off[ES_iDeviceProductGroupsExplicit]
  }
  
  select{
   //Parse response to /status/current_capture
   active(ES_eDeviceQuery == eGetState):{
    if(find_string(ES_sDeviceIncomingBuffer,'</status>',1)){
     //We've got a response from the appliance.
     if(![vdvDevice,chHardwareOnline]){
      on[ES_bGetHardwareDetails]
      timeline_set(tlDeviceHealth,0)  //Avoid back-to-back health checks.
      on[ES_bCurrentTitle]
      on[ES_bCurrentPresenters]
      on[ES_bCurrentProductGroup]
      on[vdvDevice,chHardwareOnline]
     }
     
     //Determine state of appliance.
     select{
      active(find_string(ES_sDeviceIncomingBuffer,'<state>',1) == 0):{  //Idle
       EchoSystemDebugString(db_developer,'State = idle')
       GoToIdleState()
       off[vdvDevice,chWaiting]
      }
      active(find_string(ES_sDeviceIncomingBuffer,'<state>waiting</state>',1)):{
       EchoSystemDebugString(db_developer,'State = waiting')
       GoToIdleState()
       on[vdvDevice,chWaiting]
      }
      active(find_string(ES_sDeviceIncomingBuffer,'<state>paused</state>',1)):{
       EchoSystemDebugString(db_developer,'State = paused')
       on[vdvDevice,chPaused]
       off[vdvDevice,chWaiting]
      }
      active(find_string(ES_sDeviceIncomingBuffer,'<state>active</state>',1)):{
       EchoSystemDebugString(db_developer,'State = active')
       on[vdvDevice,chRecording]
       off[vdvDevice,chWaiting]
      }
      active(find_string(ES_sDeviceIncomingBuffer,'<state>complete</state>',1)):{
       //Treat COMPLETE as IDLE
       EchoSystemDebugString(db_developer,'State = complete')
       GoToIdleState()
       off[vdvDevice,chWaiting]
      }
      active(1):{  //Unknown <state>
       pos1 = find_string(ES_sDeviceIncomingBuffer,'<state>',1) + 7
       pos2 = find_string(ES_sDeviceIncomingBuffer,'</state>',pos1)
       EchoSystemDebugString(db_integrator,"'Appliance returned unknown state: ',mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1))")
       GoToIdleState()
       off[vdvDevice,chWaiting]
      }
     }
     
     //Determine if Live Streaming is occuring.
     pos1 = find_string(ES_sDeviceIncomingBuffer,'<output-type',1)
     if((![vdvDevice,chIdle]) && (pos1 > 0)){
      pos2 = find_string(ES_sDeviceIncomingBuffer,'</output-type>',pos1)
      //The <output-type> element may be "archive", "archive-live" or "live", depending on the current Product Group.
      if(find_string(mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1),'live',1))
       on[vdvDevice,chLive]
      else
       off[vdvDevice,chLive]
     }
     
     //Determine the recording type (Scheduled/AdHoc/Monitor)
     pos1 = find_string(ES_sDeviceIncomingBuffer,'<schedule>',1)
     if(pos1){
      if(find_string(ES_sDeviceIncomingBuffer,'<type>media</type>',pos1)){  //It is a scheduled recording.
       if([vdvDevice,chRecording] || [vdvDevice,chPaused]){
        //The following feedback is only relevent when a recording is taking place.
        on[vdvDevice,chScheduled]  //True, due to the above <type>media</type> condition.
       }
      }
      else if(find_string(ES_sDeviceIncomingBuffer,'<type>adhoc-capture</type>',pos1)){
       if(find_string(ES_sDeviceIncomingBuffer,'<confidence-monitoring>false</confidence-monitoring>',pos1))
        on[vdvDevice,chAdHoc]
       else if(find_string(ES_sDeviceIncomingBuffer,'<confidence-monitoring>true</confidence-monitoring>',pos1))
        on[vdvDevice,chMonitoring]
      }
      else{
       total_off[vdvDevice,chScheduled]
       total_off[vdvDevice,chAdHoc]
       total_off[vdvDevice,chMonitoring]
      }
      
      //Determine/re-sync countdown time and check for back-to-back recording using start-time.
      if([vdvDevice,chRecording] || [vdvDevice,chPaused]){
       //Re-sync the countdown time.  Since the start-time comparison can potentially turn on the ES_bCurrentTitle,
       //ES_bCurrentPersenters and ES_bCurrentProductGroup flags, we do this before the TITLE and CURRENT PRODUCT GROUP checks below.
       pos1 = find_string(ES_sDeviceIncomingBuffer,'<wall-clock-time',1)
       pos1 = find_string(ES_sDeviceIncomingBuffer,'>',pos1) + 1
       pos2 = find_string(ES_sDeviceIncomingBuffer,'</wall-clock-time',pos1)
       wallClock = getSecondsSinceEpoch(mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1))
       pos1 = find_string(ES_sDeviceIncomingBuffer,'<state',pos1)  //Skip forward to second instance of <start-time> and <duration>
       pos1 = find_string(ES_sDeviceIncomingBuffer,'<start-time',pos1)
       pos1 = find_string(ES_sDeviceIncomingBuffer,'>',pos1) + 1
       pos2 = find_string(ES_sDeviceIncomingBuffer,'</start-time',pos1)
       startClock = getSecondsSinceEpoch(mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1))
       if(startClock != prevStartClock){  //Check to see if this is a new recording.
        on[ES_bCurrentTitle]
        on[ES_bCurrentPresenters]
        on[ES_bCurrentProductGroup]
       }
       prevStartClock = startClock
       pos1 = find_string(ES_sDeviceIncomingBuffer,'<duration',pos1)
       pos1 = find_string(ES_sDeviceIncomingBuffer,'>',pos1) + 1
       pos2 = find_string(ES_sDeviceIncomingBuffer,'</duration',pos1)
       duration = atoi(mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1))
       varOldTime = ES_iDeviceTimeRemaining
       ES_iDeviceTimeRemaining = type_cast(duration - (wallClock - startClock))
       if((ES_iDeviceTimeRemaining > varOldTime) && (ES_iDeviceTimeRemaining > ES_iDeviceTimeThreshold))
        EchoSystemDebugString(db_public,'TIME=')  //Clear remining time since it is greater than the threshold.
       //Calculate percentage complete.
       send_level vdvDevice,3,atoi(itoa(((wallClock - startClock)/(duration*1.0))*100.0))  //Decimals are required to prevent integer-casting issues.
      }
      
      //Determine title of current capture
      if(ES_bCurrentTitle && ([vdvDevice,chRecording] || [vdvDevice,chPaused])){
       pos1 = find_string(ES_sDeviceIncomingBuffer,'<title>',1)
       if(pos1 > 0){
        pos1 = pos1 + 7
        pos2 = find_string(ES_sDeviceIncomingBuffer,'</title>',pos1)
        //Copy the title into buffer, converting '&' (&#038;), '<' (&#060;) and '>' (&#062;) at the same time.
        buffer = AmpGtLtToASCII(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)))
        pos2 = find_rstring(buffer,' (',length_array(buffer))
        if(pos2)  //The title is probably in the <Name> (<Code>) <Term> format.  Show <Name> only.
         buffer = left_string(buffer,pos2-1)
        buffer = trim(buffer)
        EchoSystemDebugString(db_public,"'TITLE=',buffer")
       }
       else{  //AdHoc or monitoring
        EchoSystemDebugString(db_public,'TITLE=')
       }
       off[ES_bCurrentTitle]
      }
      
      //Determine presenter(s) of current capture
      if(ES_bCurrentPresenters && ([vdvDevice,chRecording] || [vdvDevice,chPaused])){
       buffer = ''
       pos1 = find_string(ES_sDeviceIncomingBuffer,'<presenters>',1)
       if(pos1 > 0){
        pos1 = find_string(ES_sDeviceIncomingBuffer,'<presenter',pos1 + 1)
        while(pos1 > 0){
         pos1 = find_string(ES_sDeviceIncomingBuffer,'>',pos1) + 1
         pos2 = find_string(ES_sDeviceIncomingBuffer,'</presenter>',pos1)
         buffer = "buffer,AmpGtLtToASCII(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1))),';'"
         pos1 = find_string(ES_sDeviceIncomingBuffer,'<presenter',pos1)
        }
        if(length_array(buffer) > 0)
         buffer = left_string(buffer,length_array(buffer)-1)  //Drop trailing delimiter.
        EchoSystemDebugString(db_public,"'PRESENTERS=',buffer")
       }
       else{  //AdHoc or monitoring
        EchoSystemDebugString(db_public,'PRESENTERS=')
       }
       off[ES_bCurrentPresenters]
      }
      
      //Determine Product Group
      if(ES_bCurrentProductGroup && ([vdvDevice,chRecording] || [vdvDevice,chPaused])){
       //CA API < v3.0 reported <video> and <display>, which was used to report RECORDING TYPE=audio[+video][+disaply].
       //Not supported as of module v3.2.0.
       //CA API >= v3.0 reports the Product Group using the deprecated "capture profile" terminology.  Present it using
       //"product group" since this is what is seen by admins in ESS.
       pos2 = find_string(ES_sDeviceIncomingBuffer,'<parameters',1)
       pos1 = find_string(ES_sDeviceIncomingBuffer,'<capture-profile',pos2)
       if(pos1 == 0)
        pos1 = find_string(ES_sDeviceIncomingBuffer,'<product-group',pos2)  //Hunt for possible alternative terminology.
       if(pos1){
        pos1 = find_string(ES_sDeviceIncomingBuffer,'<name>',pos1) + 6
        pos2 = find_string(ES_sDeviceIncomingBuffer,'</name>',pos1)
        EchoSystemDebugString(db_public,"'CURRENT PRODUCT GROUP=',AmpGtLtToASCII(mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1))")
       }
       else if(versionCompare(ES_sDeviceAPIVersions,'>=','3.0'))  //Only notify if we expect the API to support the <capture-profile> or <product-group>.
        EchoSystemDebugString(db_integrator,'PARSE ISSUE=Could not determine current product group.')
       off[ES_bCurrentProductGroup]
      }
      
      //Determine audio levels
      if([vdvDevice,chRecording] || [vdvDevice,chPaused]){
       //Determine the state of AV signals
       pos1 = find_string(ES_sDeviceIncomingBuffer,'<class>audio</class>',1)
       if(pos1){
        pos1 = find_string(ES_sDeviceIncomingBuffer,'<signal-present',pos1)
        pos1 = find_string(ES_sDeviceIncomingBuffer,'>',pos1) + 1
        pos2 = find_string(ES_sDeviceIncomingBuffer,'</signal-present',pos1)
        [vdvDevice,chAudioDetect] = (mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1) == 'true')
        pos1 = find_string(ES_sDeviceIncomingBuffer,'<position>left</position>',pos1)
        pos1 = find_string(ES_sDeviceIncomingBuffer,'<peak',pos1)
        pos1 = find_string(ES_sDeviceIncomingBuffer,'>',pos1) + 1
        pos2 = find_string(ES_sDeviceIncomingBuffer,'</peak',pos1)
        /*
         A few words about audio:
         The original Gen 1 Capture Appliance records from the white RCA.  The RCAs are not labeled, so we assume
         white is left.  However, the level value in the API is reported as the right channel.  We do a swap-around
         here to correct for this.
         The SafeCapture HD phoenix input has left/right labels.  The API reports the audio on the correct channel.
         The SafeCapture HD RCA inputs appear to do a mono-mix prior to the API, since a signal on one RCA is reported
         on both API channels.  We are not coding for RCA audio just yet due to the wild dBu levels it requires.
        */
        //EchoSystemDebugString(db_developer,"'Raw Audio L: ',itoa(atoi(mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1)))")
        if(ES_eDeviceType == typeBasicHardwareCapture)
         ES_iDeviceAudioLevelRight = resolveAudio(atoi(mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1)))
        else if(ES_eDeviceType == typeProHarwareCapture)
         ES_iDeviceAudioLevelLeft = resolveAudio(atoi(mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1)))
        pos1 = find_string(ES_sDeviceIncomingBuffer,'<position>right</position>',pos1)
        pos1 = find_string(ES_sDeviceIncomingBuffer,'<peak',pos1)
        pos1 = find_string(ES_sDeviceIncomingBuffer,'>',pos1) + 1
        pos2 = find_string(ES_sDeviceIncomingBuffer,'</peak',pos1)
        //EchoSystemDebugString(db_developer,"'Raw Audio R: ',itoa(atoi(mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1)))")
        if(ES_eDeviceType == typeBasicHardwareCapture)
         ES_iDeviceAudioLevelLeft = resolveAudio(atoi(mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1)))
        else if(ES_eDeviceType == typeProHarwareCapture)
         ES_iDeviceAudioLevelRight = resolveAudio(atoi(mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1)))
        //EchoSystemDebugString(db_developer,"'Scaled Audio L:',itoa(ES_iDeviceAudioLevelLeft)")
        //EchoSystemDebugString(db_developer,"'Scaled Audio R:',itoa(ES_iDeviceAudioLevelRight)")
       }
       pos1 = find_string(ES_sDeviceIncomingBuffer,'<class>video</class>',1)
       if(pos1){
        pos1 = find_string(ES_sDeviceIncomingBuffer,'<signal-present',pos1)
        pos1 = find_string(ES_sDeviceIncomingBuffer,'>',pos1) + 1
        pos2 = find_string(ES_sDeviceIncomingBuffer,'</signal-present',pos1)
        [vdvDevice,chVideo1Detect] = (mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1) == 'true')
       }
       pos1 = find_string(ES_sDeviceIncomingBuffer,'<class>vga</class>',1)
       if(pos1){
        pos1 = find_string(ES_sDeviceIncomingBuffer,'<signal-present',pos1)
        pos1 = find_string(ES_sDeviceIncomingBuffer,'>',pos1) + 1
        pos2 = find_string(ES_sDeviceIncomingBuffer,'</signal-present',pos1)
        [vdvDevice,chVideo2Detect] = (mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1) == 'true')
       }
      }
      
      if([vdvDevice,chIdle]){
       ES_iDeviceAudioLevelLeft  = 0
       ES_iDeviceAudioLevelRight = 0
       total_off[vdvDevice,chScheduled]
       total_off[vdvDevice,chAdHoc]
       total_off[vdvDevice,chMonitoring]
       off[vdvDevice,chLive]
       off[vdvDevice,chAudioDetect]
       off[vdvDevice,chVideo1Detect]
       off[vdvDevice,chVideo2Detect]
      }
      send_level vdvDevice,1,ES_iDeviceAudioLevelLeft
      send_level vdvDevice,2,ES_iDeviceAudioLevelRight
     }
    }//End of parsing <status>...</status> XML.
    
    if(ES_bGetHardwareDetails){
     EchoSystemDebugString(db_integrator,'Checking hardware details...')
     timeline_set(tlDeviceHealth,0)  //Delay the background health-check.
     ES_eDeviceQuery = eGetSysStatus
     DeviceGetMessage('/status/system')
    }
   }
   //Parse response to /status/system
   active((ES_eDeviceQuery == eGetSysStatus) || (find_string(ES_sDeviceIncomingBuffer,'<serial-number',1) && find_string(ES_sDeviceIncomingBuffer,'<location',1))):{
    //Parse for <serial-number> and <location>
    if(find_string(ES_sDeviceIncomingBuffer,'<serial-number',1)){  //Parse for <serial-number>
     pos1 = find_string(ES_sDeviceIncomingBuffer,'<serial-number',1)
     pos1 = find_string(ES_sDeviceIncomingBuffer,'>',pos1) + 1
     pos2 = find_string(ES_sDeviceIncomingBuffer,'</serial-number>',pos1)
     buffer = mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1))
     if(buffer != ES_sDeviceSerial){
      ES_sDeviceSerial = buffer
      EchoSystemDebugString(db_public,"'DEVICE SERIAL=',ES_sDeviceSerial")
      select{
       active(ES_eDeviceType == typeProHarwareCapture):{    EchoSystemDebugString(db_public,'DEVICE TYPE=SafeCapture HD') }
       active(ES_eDeviceType == typeBasicHardwareCapture):{ EchoSystemDebugString(db_public,'DEVICE TYPE=Capture Appliance') }
       active(1):{                                          EchoSystemDebugString(db_public,'DEVICE TYPE=<undefined>') }
      }
      EchoSystemDebugString(db_public,"'DEVICE=',ES_sDeviceIP")
     }
    }
    if(find_string(ES_sDeviceIncomingBuffer,'<system-version',1)){  //Parse for <system-version>
     pos1 = find_string(ES_sDeviceIncomingBuffer,'<system-version',1)
     pos1 = find_string(ES_sDeviceIncomingBuffer,'>',pos1) + 1
     pos2 = find_string(ES_sDeviceIncomingBuffer,'</system-version>',pos1)
     buffer = mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1))
     //Remove potential 'v' from start of version, not that we've ever seen it yet...
     if((buffer[1] == 'v') || (buffer[1] == 'V'))
      buffer = right_string(buffer,length_array(buffer)-1)
     buffer = trim(buffer)
     if(ES_sDeviceFWVersion != buffer){
      ES_sDeviceFWVersion = buffer
      EchoSystemDebugString(db_public,"'DEVICE FIRMWARE=',ES_SDeviceFWVersion")
     }
    }
    if(find_string(ES_sDeviceIncomingBuffer,'<location',1)){  //Parse for <location>
     pos1 = find_string(ES_sDeviceIncomingBuffer,'<location',1)
     pos1 = find_string(ES_sDeviceIncomingBuffer,'>',pos1) + 1
     pos2 = find_string(ES_sDeviceIncomingBuffer,'</location>',pos1)
     //Copy the location into the buffer, replacing encoded chars along the way.
     buffer = AmpGtLtToASCII(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)))
     //Compare the location with the modules ROOM value.
     //In EchoSystem, the Location is fully-qualified.  The format is <location>{CAMPUS}: {BUILDING}, {ROOM}</location>
     //In Lectopia, the Location is simply the venue name.  <location>venue</location>
     //The module allows for either a basic room name, or fully-qualified name in either exact EchoSystem format or CAMPUS:BUILDING:ROOM
     // We will consider the following cases as a "match":
     // 1) Exact match.  This caters for Lectopia contexts.
     // 2) Location ends in exact match, and is preceeded by ': ' and ', '.  This allows for basic name.
     // 3) Location matches ROOM, taking into account formatting differences of EchoSystem vs module.
     //Case 1 - Exact match
     if((find_string(buffer,ES_sRoomName,1) == 1) && (length_array(buffer) == length_array(ES_sRoomName))){
      //This will pass for Lectopia exact-match, and EchoSystem if ROOM is configured as "CAMPUS: BUILDING, ROOM" (not recommended, but possible).
      EchoSystemDebugString(db_developer,"'Exact match for room name: ',buffer")
     }
     else{
      pos1 = find_string(buffer,': ',1)  //EchoSystem locations ALWAYS have "CAMPUS: BUILDING, ROOM".
      if(pos1 > 0)                       //Lectopia not so.  Avoid find_string with starting pos of 0.
       pos2 = find_string(buffer,', ',pos1)
      else
       pos2 = 0
      if((pos1 > 0) && (pos2 > pos1)){
       tempCampus = left_string(buffer,pos1-1)
       tempBuilding = mid_string(buffer,pos1+2,(pos2-pos1-2))
       buffer = right_string(buffer,length_array(buffer)-pos2-1)  //buffer now contains the RoomName only.
       if(find_string(ES_sRoomName,':',1) != find_rstring(ES_sRoomName,':',length_array(ES_sRoomName))){  //ES_sRoomName is campus:building:room format.
        if(find_string("tempCampus,':',tempBuilding,':',buffer",ES_sRoomName,1) == 1)
         EchoSystemDebugString(db_developer,"'Room match using fully qualified name: ',ES_sRoomName")
        else
         EchoSystemDebugString(db_public,"'WARNING=Hardware room name <',tempCampus,':',tempBuilding,':',buffer,'> does not match module room name <',ES_sRoomName,'>.'")
       }
       else{  //check end of <location> to see if it matches ES_sRoomName
        if(find_string(buffer,ES_sRoomName,1) == 1)
         EchoSystemDebugString(db_developer,"'Room match using short name: ',ES_sRoomName")
        else
         EchoSystemDebugString(db_public,"'WARNING=Hardware room name <',buffer,'> does not match module room name <',ES_sRoomName,'>.'")
       }
      }
      else{  //Location is not in "CAMPUS: BUILDING, ROOM" format.  Probably Lectopia, with mismatching room name.
       EchoSystemDebugString(db_public,"'WARNING=Hardware room name <',buffer,'> does not match module room name <',ES_sRoomName,'>.'")
      }
     }
    }
    //The following block works okay, but its usefullness is questionable.  Appliances will often report pending uploads though there doesn't
    //appear to be anything to upload.  This code only checks every minute as part of the health-check, so channel feedback would be sparse.
//    if(find_string(ES_sDeviceIncomingBuffer,'<content>',1) && find_string(ES_sDeviceIncomingBuffer,'</log>',1)){  //Parse for pending/active uploads
//     bUploadPending = false
//     bUploadActive = false
//     pos1 = find_string(ES_sDeviceIncomingBuffer,'<content>',1)
//     pos1 = find_string(ES_sDeviceIncomingBuffer,'<uploads-pending>',pos1) + 17
//     if(atoi(mid_string(ES_sDeviceIncomingBuffer,pos1,3)) > 0)
//      bUploadPending = true
//     pos1 = find_string(ES_sDeviceIncomingBuffer,'<uploading>',pos1) + 11
//     if(find_string(ES_sDeviceIncomingBuffer,'true',pos1))
//      bUploadActive = true
//     pos1 = find_string(ES_sDeviceIncomingBuffer,'<log>',pos1)
//     pos1 = find_string(ES_sDeviceIncomingBuffer,'<uploads-pending>',pos1) + 17
//     if(atoi(mid_string(ES_sDeviceIncomingBuffer,pos1,3)) > 0)
//      bUploadPending = true
//     pos1 = find_string(ES_sDeviceIncomingBuffer,'<uploading>',pos1) + 11
//     if(find_string(ES_sDeviceIncomingBuffer,'true',pos1))
//      bUploadActive = true
//     [vdvDevice,chUploadPending] = bUploadPending
//     [vdvDevice,chUploadActive] = bUploadActive
//    }
    if(ES_bGetHardwareDetails){
     ES_eDeviceQuery = eGetLogs
     DeviceGetMessage("'/log-list-last-count/',itoa(DEVICE_MAX_LOG_ENTRIES)")
    }
   }
  }
  ClearDeviceBuffer()
  ES_eDeviceQuery = eNone
  off[ES_bDevicePortBusy]
 }//end of </status>
 //Parse response to /log-list-last-count/<integer>
 else if((ES_eDeviceQuery == eGetLogs) || (find_string(ES_sDeviceIncomingBuffer,'</log-entry>',1) > 0)){
  //Log replies can arrive in chunks, generating multiple string events for the socket.  We call ParseDeviceResponse() for each event.
  //Log replies can be very large.  Our FIFO buffer will drop early data in favor for later data.  Logs report most recent data first.
  //We process logs on a per-log-entry basis, and remove them from the buffer as we go.  Log event times are compared, with newer entries
  //writing over older ones.  Once the entire log file has been read/parsed, we do checks on our cached values.
  varOldTemperature = ES_iDeviceTemperature  //For later comparison.
  varOldClockDriftEpoch = ES_aDeviceLog[11].epochTime
  pos1 = find_string(ES_sDeviceIncomingBuffer,'<log-entry>',1)
  if(pos1 > 0)
   pos2 = find_string(ES_sDeviceIncomingBuffer,'</log-entry>',pos1)
  while((pos1 > 0) && (pos2 > pos1)){  //We have a <log-entry>...</log-entry> element
   pos1 = pos1 + 11
   //Parse the log entry
   if((length_array(ES_aDeviceLog[1].name) > 0) && (find_string(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)),ES_aDeviceLog[1].name,pos1) > 0))
    ParseDeviceLogEntry(1,mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)))
   else if((length_array(ES_aDeviceLog[2].name) > 0) && (find_string(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)),ES_aDeviceLog[2].name,pos1) > 0))
    ParseDeviceLogEntry(2,mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)))
   else if((length_array(ES_aDeviceLog[3].name) > 0) && (find_string(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)),ES_aDeviceLog[3].name,pos1) > 0))
    ParseDeviceLogEntry(3,mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)))
   else if((length_array(ES_aDeviceLog[4].name) > 0) && (find_string(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)),ES_aDeviceLog[4].name,pos1) > 0))
    ParseDeviceLogEntry(4,mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)))
   else if((length_array(ES_aDeviceLog[5].name) > 0) && (find_string(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)),ES_aDeviceLog[5].name,pos1) > 0))
    ParseDeviceLogEntry(5,mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)))
   else if((length_array(ES_aDeviceLog[6].name) > 0) && (find_string(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)),ES_aDeviceLog[6].name,pos1) > 0))
    ParseDeviceLogEntry(6,mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)))
   else if((length_array(ES_aDeviceLog[7].name) > 0) && (find_string(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)),ES_aDeviceLog[7].name,pos1) > 0))
    ParseDeviceLogEntry(7,mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)))
   else if((length_array(ES_aDeviceLog[8].name) > 0) && (find_string(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)),ES_aDeviceLog[8].name,pos1) > 0))
    ParseDeviceLogEntry(8,mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)))
   else if((length_array(ES_aDeviceLog[9].name) > 0) && (find_string(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)),ES_aDeviceLog[9].name,pos1) > 0))
    ParseDeviceLogEntry(9,mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)))
   else if((length_array(ES_aDeviceLog[10].name) > 0) && (find_string(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)),ES_aDeviceLog[10].name,pos1) > 0))
    ParseDeviceLogEntry(10,mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)))
   else if((length_array(ES_aDeviceLog[11].name) > 0) && (find_string(mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)),ES_aDeviceLog[11].name,pos1) > 0))
    ParseDeviceLogEntry(11,mid_string(ES_sDeviceIncomingBuffer,pos1,(pos2-pos1)))
   
/*
//Remove this once verfied against Gen1 hardware.
   if(ES_eDeviceType == typeBasicHardwareCapture){  //Capture Appliance (Gen 1) specific
    if(find_string(mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1),'temperature:',1)){
     pos1 = find_string(ES_sDeviceIncomingBuffer,'temperature:',pos1)
     pos2 = find_string(ES_sDeviceIncomingBuffer,'type: SystemTemperature',pos1)
     ES_iDeviceTemperature = type_cast(atoi(mid_string(ES_sDeviceIncomingBuffer,pos1,pos2-pos1)))
    }
   }
*/   
   remove_string(ES_sDeviceIncomingBuffer,'</log-entry>',1)
   //Get next log entry
   pos1 = find_string(ES_sDeviceIncomingBuffer,'<log-entry>',1)
   if(pos1 > 0)
    pos2 = find_string(ES_sDeviceIncomingBuffer,'</log-entry>',pos1)
  }
  //We've run out of complete <log-entry></log-entry> to process, but the buffer may still be filling up.
  //Don't analyse results until we have looked at the entire results.
  if((find_string(ES_sDeviceIncomingBuffer,'</log-entries>',1) > 0) && (find_string(ES_sDeviceIncomingBuffer,'</log-entries>',1) < 10)){  //Log processing complete.
   
   //Check temperature
   if(ES_eDeviceType == typeProHarwareCapture){  //Average multiple sensors.
    varParamValue = 0
    varParamCount = 0
    for(i = 1; i <= 6; i++){
     if(ES_aDeviceLog[i].epochTime > 0){
      varParamValue = varParamValue + atoi(ES_aDeviceLog[i].value)
      varParamCount = varParamCount + 1
     }
    }
    if(varParamCount > 0)  //Avoid div-by-0 error.
     ES_iDeviceTemperature = varParamValue / varParamCount
   }
   else if(ES_eDeviceType == typeBasicHardwareCapture){  //One sensor on Gen1 model.
    if(ES_aDeviceLog[1].epochTime > 0)
     ES_iDeviceTemperature = atoi(ES_aDeviceLog[1].value)
   }
   if((ES_iDeviceTemperature != varOldTemperature) || (ES_iDeviceTemperatureExplicit))   //Compare with previous temperature.
    EchoSystemDebugString(db_public,"'DEVICE TEMPERATURE=',itoa(ES_iDeviceTemperature)")
   if(ES_iDeviceTemperature < -100)
    EchoSystemDebugString(db_public,'WARNING=I2C bus lockup')
   off[ES_iDeviceTemperatureExplicit]
   if(ES_iDeviceTemperature > 0)  //Generate a level event, 0 - 100+.  DEVICE TEMPERATURE? will still report negative temperature values, while the level is limited to 0.
    send_level vdvDevice,5,ES_iDeviceTemperature
   else
    send_level vdvDevice,5,0
   
   //Check fan speeds - SCHD only.
   if(ES_eDeviceType == typeProHarwareCapture){
    if((atoi(ES_aDeviceLog[7].value) < 1000) && (ES_aDeviceLog[7].epochTime > 0))
     EchoSystemDebugString(db_public,"'WARNING=Fan 1 rpm: ',ES_aDeviceLog[7].value")
    if((atoi(ES_aDeviceLog[8].value) < 1000) && (ES_aDeviceLog[8].epochTime > 0))
     EchoSystemDebugString(db_public,"'WARNING=Fan 2 rpm: ',ES_aDeviceLog[8].value")
    if((atoi(ES_aDeviceLog[9].value) < 1000) && (ES_aDeviceLog[9].epochTime > 0))
     EchoSystemDebugString(db_public,"'WARNING=Fan 3 rpm: ',ES_aDeviceLog[9].value")
   }
   
   //Disc capacity for /data.  Stored in ES_aDeviceLog[10].value as <percentage>%<totalBytesAsFloat>
   if(ES_aDeviceLog[10].epochTime > 0){
    send_level vdvDevice,6,atoi(ES_aDeviceLog[10].value)
    capacity = atof(right_string(ES_aDeviceLog[10].value,length_array(ES_aDeviceLog[10].value) - find_string(ES_aDeviceLog[10].value,'%',1)))
    if(capacity < 10737418240)  //10Gb
     EchoSystemDebugString(db_public,"'WARNING=Possible disc mount failure for /data (',ftoa(capacity),')'")
   }
   
   //Clock drift
   if(ES_aDeviceLog[11].epochTime > varOldClockDriftEpoch)
    EchoSystemDebugString(db_public,"'Warning=Possible clock drift on appliance.'")
   
   //The logs have been dealt with.
   ES_eDeviceQuery = eNone
   off[ES_bGetHardwareDetails]  //End of our health-check and hardware-check.
   off[ES_bDevicePortBusy]
   ClearDeviceBuffer()
  }
 }  //end of log parsing
 //Parse response to Pause/Resume/Stop/Extend/AdHoc commands
 else if((ES_eDeviceQuery != 0) || (find_string(ES_sDeviceIncomingBuffer,'<ok',1) == 1)){
  //Handle responses to POST messages (pause/record/stop/extend/etc)
  if(find_string(ES_sDeviceIncomingBuffer,'stop',1) && (ES_eDeviceQuery == eStop)){
   ES_eDeviceQuery = eNone
   GoToIdleState()
   ClearDeviceBuffer()
  }
  else if(find_string(ES_sDeviceIncomingBuffer,'pause',1) && (ES_eDeviceQuery == ePause)){
   ES_eDeviceQuery = eNone
   on[vdvDevice,chPaused]
   ClearDeviceBuffer()
  }
  else if(find_string(ES_sDeviceIncomingBuffer,'record',1) && (ES_eDeviceQuery == eResume)){
   ES_eDeviceQuery = eNone
   on[vdvDevice,chRecording]
   ClearDeviceBuffer()
  }
  else if(find_string(ES_sDeviceIncomingBuffer,'xtend by',1) && (ES_eDeviceQuery == eExtend)){
   if((ES_iDeviceTimeRemaining < ES_iDeviceTimeThreshold) && ((ES_iDeviceTimeRemaining + ES_iDeviceExtendBy) > ES_iDeviceTimeThreshold))
    EchoSystemDebugString(db_public,'TIME=')
   ES_iDeviceTimeRemaining = ES_iDeviceTimeRemaining + ES_iDeviceExtendBy
   ES_eDeviceQuery = eNone
   ClearDeviceBuffer()
  }
  off[vdvDevice,chWaiting]
  if(find_string(ES_sDeviceIncomingBuffer,'Capture scheduled for start',1) && (ES_eDeviceQuery == eAdHoc)){
   on[vdvDevice,chWaiting]
   ES_eDeviceQuery = eNone
   ClearDeviceBuffer()
  }
  off[ES_bDevicePortBusy]
 }
 //Parse respons to Reboot command
 else if(find_string(ES_sDeviceIncomingBuffer,'Rebooting appliance...',1)){
  EchoSystemDebugString(db_public,'WARNING=Device rebooting.  Please standby...')
  off[vdvDevice,chHardwareOnline]
  off[vdvDevice,chWaiting]
  total_off[vdvDevice,chIdle]
  total_off[vdvDevice,chPaused]
  total_off[vdvDevice,chRecording]
  off[vdvDevice,chLive]
  total_off[vdvDevice,chScheduled]
  total_off[vdvDevice,chAdHoc]
  total_off[vdvDevice,chMonitoring]
  off[vdvDevice,chAudioDetect]
  off[vdvDevice,chVideo1Detect]
  off[vdvDevice,chVideo2Detect]
  ES_eDeviceQuery = eNone
  ClearDeviceBuffer()
  off[ES_bDevicePortBusy]
 }
}

define_function GoToIdleState(){
 if(![vdvDevice,chIdle]){
  on[ES_bGetHardwareDetails]
  timeline_set(tlDeviceHealth,0)  //Avoid back-to-back health checks.
  on[ES_bCurrentTitle]
  on[ES_bCurrentPresenters]
  on[ES_bCurrentProductGroup]
  on[vdvDevice,chIdle]
  total_off[vdvDevice,chScheduled]
  total_off[vdvDevice,chAdHoc]
  total_off[vdvDevice,chMonitoring]
  off[vdvDevice,chLive]
  send_level vdvDevice,1,0
  send_level vdvDevice,2,0
  send_level vdvDevice,3,0
  ES_iDeviceTimeRemaining = 0
  EchoSystemDebugString(db_public,'TIME=')
  EchoSystemDebugString(db_public,'TITLE=')
  EchoSystemDebugString(db_public,'PRESENTERS=')
 }
}

define_function EchoSystemDeviceRefresh(){
 if(length_array(ES_sDeviceIP) > 0){
  ES_eDeviceQuery = eGetState
  DeviceGetMessage('/status/current_capture')
 }
}
define_mutually_exclusive
([vdvDevice,chIdle],[vdvDevice,chPaused],[vdvDevice,chRecording])
([vdvDevice,chScheduled],[vdvDevice,chAdHoc],[vdvDevice,chMonitoring])

define_start
create_buffer vdvServer,ES_sServerIncomingBuffer
create_buffer vdvAppliance,ES_sDeviceIncomingBuffer

ES_sDeviceUsername  = 'admin'
ES_sDevicePassword  = 'password'
ES_sDeviceKey       = 'YWRtaW46cGFzc3dvcmQ='  //EncrBase64Encode('admin:password')
on[ES_bDevicePersistentSocket]
ES_sSearchParamName = 'filter'
ES_iServerPort      = SERVER_DEFAULT_HTTP_PORT
ES_iDevicePort      = DEVICE_DEFAULT_HTTP_PORT
on[ES_bCurrentTitle]
on[ES_bCurrentPresenters]
on[ES_bCurrentProductGroup]
wait 100{
 timeline_create(tlDeviceHealth,ES_iDeviceHealthTime,1,timeline_relative,timeline_repeat)
}

define_event
timeline_event[tlServerRefresh]{
 EchoSystemServerRefresh()
}
timeline_event[tlDeviceRefresh]{
 if(!ES_bDevicePortBusy)
  EchoSystemDeviceRefresh()
}
timeline_event[tlDeviceHealth]{
 //We only perform the health-check if the module has device-polling enabled.
 //The health-check occurs every minute.
 if((ES_iDeviceRefreshTime[1] > 0) && (length_array(ES_sDeviceIP) > 0)){
  wait_until((ES_eDeviceQuery == eNone) && (!ES_bDevicePortBusy)){
   on[ES_bGetHardwareDetails]
   EchoSystemDebugString(db_integrator,'Health check...')
   ES_eDeviceQuery = eGetSysStatus
   DeviceGetMessage('/status/system')
  }
 }
}

data_event[vdvServer]{
 onerror:{
  switch(data.number){
   case  2:  //General failure (Out of memory)
    EchoSystemDebugString(db_integrator,'IP socket failure - out of memory!')
    break;
   case  4:  //Unknown host
    EchoSystemDebugString(db_integrator,"'Server <',ES_sServerAddress,'> is unknown.'")
    EchoSystemDebugString(db_integrator,'Check that the server address is correct.')
    break;
   case  6:  //Connection refused
    EchoSystemDebugString(db_integrator,"'Connection to server <',ES_sServerAddress,'> was refused.'")
    EchoSystemDebugString(db_integrator,' Check that the server address is correct and EchoSystem is running.')
    break;
   case  7:  //Connection timed out
    get_ip_address(0,ES_ipMyAddress)  //Get the current AMX IP address.
    EchoSystemDebugString(db_integrator,"'Connection to server <',ES_sServerAddress,'> timed out.'")
    EchoSystemDebugString(db_integrator,"'Check that the server address is correct and reachable from the AMX IP <',ES_ipMyAddress.ipaddress,'>.'")
    break;
   case  8:  //Unknown connection error
    EchoSystemDebugString(db_integrator,'Unknown IP socket connection error.')
    break;
   case  9:
    EchoSystemDebugString(db_developer,"'vdvServer ERROR=IP error ', itoa(data.number), '. Local port already closed'")
    break;
   case 14:  //Local port alread used
    EchoSystemDebugString(db_integrator,'Previous server command has not yet finished.  Latter command ignored.')
    break;
   case 16:  //Too many open sockets
    EchoSystemDebugString(db_integrator,'There are too many IP sockets open at the same time.')
    break;
   case 17:  //Local port not open
    EchoSystemDebugString(db_developer,"'vdvServer ERROR=IP error ', itoa(data.number), '. Local port not open'")
    break;
   default:  //Catch all...
    EchoSystemDebugString(db_developer,"'vdvServer ERROR=IP error ', itoa(data.number), '. I wonder what that means...'")
    break;
  }
 }
 online:{
  on[ES_bServerPortOpen]
  off[ES_bServerDateExtracted]
  send_string vdvServer,ES_sServerOutgoingBuffer
 }
 offline:{  //Handle reply from the server
  ParseServerResponse()
  off[ES_bServerPortOpen]
  off[ES_bServerDateExtracted]
 }
 string:{
  local_var integer pos1
  local_var integer pos2
  
  //We update our ServerTimeOffset with every reply from the server.  Server replies contain GMT time.
  if((!ES_bServerDateExtracted) && find_string(ES_sServerIncomingBuffer,"crlf,'Date:'",1)){
   pos1 = find_string(ES_sServerIncomingBuffer,"crlf,'Date:'",1) + 2
   pos2 = find_string(ES_sServerIncomingBuffer,"crlf",pos1)
   ServerTimeOffset(mid_string(ES_sServerIncomingBuffer,pos1,(pos2-pos1)))
   on[ES_bServerDateExtracted]
  }
  ParseServerResponse()
 }
}

data_event[vdvAppliance]{
 onerror:{
  switch(data.number){
   case  2:  //General failure (Out of memory)
    EchoSystemDebugString(db_integrator,'IP socket failure - out of memory!')
    break;
   case  4:  //Unknown host
    EchoSystemDebugString(db_integrator,"'Device <',ES_sDeviceIP,'> is unknown.'")
    EchoSystemDebugString(db_integrator,'Check that the device address is correct.')
    break;
   case  6:  //Connection refused
    EchoSystemDebugString(db_integrator,"'Connection to device <',ES_sDeviceIP,'> was refused.'")
    break;
   case  7:  //Connection timed out
    get_ip_address(0,ES_ipMyAddress)  //Get the current AMX IP address.
    EchoSystemDebugString(db_integrator,"'Could not contact device <',ES_sDeviceIP,'>.  Connection timed out.'")
    EchoSystemDebugString(db_integrator,"'Check that it is reachable from the AMX IP <',ES_ipMyAddress.ipaddress,'>.'")
    break;
   case  8:  //Unknown connection error
    EchoSystemDebugString(db_integrator,'Unknown IP socket error')
    break;
   case  9:
    EchoSystemDebugString(db_developer,"'vdvAppliance ERROR=IP error ', itoa(data.number), '. Local port already closed'")
    break;
   case 14:  //Local port alread used
    EchoSystemDebugString(db_integrator,'Previous device command has not yet finished.  Latter command ignored.')
    break;
   case 16:  //Too many open sockets
    EchoSystemDebugString(db_integrator,'There are too many IP sockets open at the same time.')
    break;
   case 17:  //Local port not open
    EchoSystemDebugString(db_developer,"'vdvAppliance ERROR=IP error ', itoa(data.number), '. Local port not open'")
    break;
   default:  //Catch all...
    EchoSystemDebugString(db_developer,"'vdvAppliance ERROR=IP error ', itoa(data.number), '. I wonder what that means...'")
    break;
  }
  if((data.number != 9) && (data.number != 14)){
   off[vdvDevice,chHardwareOnline]
   total_off[vdvDevice,chIdle]
   total_off[vdvDevice,chPaused]
   total_off[vdvDevice,chRecording]
   total_off[vdvDevice,chScheduled]
   total_off[vdvDevice,chAdHoc]
   total_off[vdvDevice,chMonitoring]
   off[vdvDevice,chAudioDetect]
   off[vdvDevice,chVideo1Detect]
   off[vdvDevice,chVideo2Detect]
   off[ES_bDevicePortOpen]
   off[ES_bDevicePortBusy]
  }
 }
 online:{
  if(ES_bDevicePersistentSocket){
  }
  //Required for both types of socket
  on[ES_bDevicePortOpen]
  on[ES_bDevicePortBusy]
  send_string vdvAppliance,ES_sDeviceOutgoingBuffer
 }
 offline:{
  off[ES_bDevicePortOpen]
  //When using persistent sockets the data is parsed in the string event below rather than offline event.
  if(!ES_bDevicePersistentSocket)
   ParseDeviceResponse()
 }
 string:{
  //Regardless of socket type, this string handler prevents processing of the event in mainline, which improves CPU efficiency.
  if(ES_bDevicePersistentSocket)
   ParseDeviceResponse()
 }
}

data_event[vdvDevice]{
 command:{
  local_var char sAdHocDescription[256]
  local_var integer iAdHocDuration
  local_var char sAdHocProductGroup[256]
  local_var char sCampus[128]
  local_var char sBuilding[128]
  stack_var integer i
  stack_var integer j
  select{
   active(find_string(upper_string(data.text),'ROOM',1) == 1):{
    data.text = right_string(data.text,length_array(data.text)-4)
    data.text = trim(data.text)
    if((data.text[1] == 'S') || (data.text[1] == 's')){  //ROOMS?[searchValue], ROOMS IN BUILDING?<Campus>:<Building>
     data.text = right_string(data.text,length_array(data.text) - 1)
     data.text = trim(data.text)
     if(data.text[1] == '?'){  //ROOMS?, ROOMS?myRoom
      remove_string(data.text,'?',1)
      ES_sSearchParamValue = trim(data.text)
      ES_eServerQuery = eRooms
      if(length_array(ES_sSearchParamValue))  //ROOMS?myRoom
       ServerRestCall("'rooms?',ES_sSearchParamName,'=',ES_sSearchParamValue")
      else
       ServerRestCall('rooms')
     }
     else if(find_string(upper_string(data.text),'BUILDING',1) && find_string(data.text,'?',1) && find_string(data.text,':',1)){
      remove_string(data.text,'?',1)
      ES_sSearchParamValue = trim(data.text)
      if(length_array(ES_sSearchParamValue)){
       ES_eServerQuery = eRoomsInBuilding
       ServerRestCall("'campuses?',ES_sSearchParamName,'=',left_string(ES_sSearchParamValue,find_string(ES_sSearchParamValue,':',1)-1)")
      }
      else  //Search term not specified
       EchoSystemDebugString(db_integrator,'Format: ROOMS? or ROOMS IN BUILDING?myCampus:myBuilding')
     }
     else{  //no '?' or ':'
      EchoSystemDebugString(db_integrator,'Format: ROOMS? or ROOMS IN BUILDING?myCampus:myBuilding')
     }
    }
    else{  //ROOM=<name>, ROOM=<campus>:<building>:<name>, ROOM?
     if(data.text[1] == '='){  //ROOM=<name>, ROOM=<campus>:<building>:<name>
      remove_string(data.text,'=',1)
      data.text = trim(data.text)
      if(AmpGtLtToASCII(data.text) != ES_sRoomName){
       ES_sRoomName = AmpGtLtToASCII(data.text)
       //If the format is provided in the EchoSystem native format (<Campus>: <Building>, <Room>) convert it.
       j = 0
       for(i = 1; i <= length_array(ES_sRoomName); i++){
        if(ES_sRoomName[i] == ':')
         j = j + 1
       }
       if(j = 1){  //Only one ':'.
        i = find_string(ES_sRoomName,': ',1)  //Note the <space> characters
        j = find_string(ES_sRoomName,', ',1)
        if((i > 0) && (j > i)){  //Assume EchoSystem native format.
         sCampus = left_string(ES_sRoomName,i-1)
         sBuilding = mid_string(ES_sRoomName,i+2,j-i-2)
         remove_string(ES_sRoomName,', ',1)
         ES_sRoomName = "sCampus,':',sBuilding,':',ES_sRoomName"  //Reconstruct the room in <campus>:<buidling>:<room> format.
         EchoSystemDebugString(db_integrator,"'Reconstructed room as <',ES_sRoomName,'>'")
        }
        else
         EchoSystemDebugString(db_integrator,"'Format: <room> or <campus>:<building>:<room>'")
       }
       if(ES_iServerRefreshTime[1] != 0){  //We have server-refresh enabled.  Look up the new room now.
        timeline_set(tlServerRefresh,(ES_iServerRefreshTime[1] - 5000))
       }
      }
     }
     else if(data.text[1] == '?'){  //ROOM?
      if(length_array(ES_sRoomName))
       EchoSystemDebugString(db_public,"'ROOM=',ES_sRoomName")
      else
       EchoSystemDebugString(db_public,'ROOM=<undefined>')
     }
    }
   }
   active(find_string(upper_string(data.text),'CAMPUSES',1) == 1):{  //CAMPUSES?
    data.text = right_string(data.text,length_array(data.text)-8)
    data.text = trim(data.text)
    if(data.text[1] == '?'){  //CAMPUSES?, CAMPSUES?myCampus
     remove_string(data.text,'?',1)
     ES_sSearchParamValue = trim(data.text)
     ES_eServerQuery = eCampuses
     if(length_array(ES_sSearchParamValue))  //CAMPUSES?myCampus
      ServerRestCall("'campuses?',ES_sSearchParamName,'=',ES_sSearchParamValue")
     else
      ServerRestCall('campuses')
    }
    else
     EchoSystemDebugString(db_integrator,'Format: CAMPUSES? or CAMPUSES?myCampus')
   }
   active(find_string(upper_string(data.text),'BUILDINGS',1) == 1):{  //BUILDINGS?[searchTerm], BUILDINGS on/in/at CAMPUS?myCampus
    data.text = right_string(data.text,length_array(data.text)-9)
    data.text = trim(data.text)
    if(data.text[1] == '?'){  //BUILDINGS?, BUILDINGS?myBuilding
     remove_string(data.text,'?',1)
     ES_sSearchParamValue = trim(data.text)
     ES_eServerQuery = eBuildings
     if(length_array(ES_sSearchParamValue))  //BUILDINGS?myBuilding
      ServerRestCall("'buildings?',ES_sSearchParamName,'=',ES_sSearchParamValue")
     else
      ServerRestCall('buildings')
    }
    else if(find_string(upper_string(data.text),'CAMPUS',1) && (find_string(data.text,'?',1))){  //BUILDINGS on/in/at CAMPUS?myCampus
     remove_string(data.text,'?',1)
     ES_sSearchParamValue = trim(data.text)
     if(length_array(ES_sSearchParamValue)){
      ES_eServerQuery = eBuildingsOnCampus
      ServerRestCall("'campuses?',ES_sSearchParamName,'=',ES_sSearchParamValue")
     }
     else  //Campus not specified
      EchoSystemDebugString(db_integrator,'Format: BUILDINGS? or BUILDINGS ON CAMPUS?myCampus')
    }
    else  //No '?'.
     EchoSystemDebugString(db_integrator,'Format: BUILDINGS? or BUILDINGS ON CAMPUS?myCampus')
   }
   active(find_string(upper_string(data.text),'SERVER',1) == 1):{  //All server-related commands
    data.text = right_string(data.text,length_array(data.text)-6)
    while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
     data.text = right_string(data.text,length_array(data.text)-1)
    if(find_string(upper_string(data.text),'REFRESH',1) == 1){  //SERVER REFRESH, SERVER REFRESH?, SERVER REFRESH=<minutes>
     data.text = right_string(data.text,length_array(data.text)-7)
     while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
      data.text = right_string(data.text,length_array(data.text)-1)
     if(data.text[1] == '='){  //SERVER REFRESH=<minutes>
      remove_string(data.text,'=',1)
      if(atol(data.text) != (ES_iServerRefreshTime[1] / 60000)){
       ES_iServerRefreshTime[1] = abs_value(atol(data.text)) * 60000  //Minutes-to-miliseconds
       if(ES_iServerRefreshTime[1] == 0){  //Stop server polling
        if(timeline_active(tlServerRefresh))
         timeline_pause(tlServerRefresh)
       }
       else{
        if(!timeline_active(tlServerRefresh)){  //Server has not been polled since system power-up.  Turn on repeat polling.
         timeline_create(tlServerRefresh,ES_iServerRefreshTime,1,timeline_relative,timeline_repeat)
         timeline_reload(tlServerRefresh,ES_iServerRefreshTime,1)  //Reload after create, to avoid Reload-Error in terminal.
        }
        else{
         timeline_reload(tlServerRefresh,ES_iServerRefreshTime,1)
         timeline_restart(tlServerRefresh)
        }
        //Perform an initial hit on the server.  Minimum polling period is 1 minute, so we jump to <max_time> - 5 seconds.
        timeline_set(tlServerRefresh,(ES_iServerRefreshTime[1] - 5000))
       }
      }
     }
     else if(data.text[1] == '?'){  //SERVER REFRESH?
      switch(ES_iServerRefreshTime[1] / 60000){
       case 0: EchoSystemDebugString(db_public,'SERVER REFRESH=0')
       case 1: EchoSystemDebugString(db_public,'SERVER REFRESH=1 minute')
       default: EchoSystemDebugString(db_public,"'SERVER REFRESH=',itoa(ES_iServerRefreshTime[1] / 60000),' minutes'")
      }
     }
     else{  //SERVER REFRESH
      EchoSystemServerRefresh()
     }
    }
    else if(find_string(upper_string(data.text),'CONSUMER',1) == 1){  //SERVER CONSUMER KEY=<key>, SERVER CONSUMER KEY?, SERVER CONSUMER SECRET=<secret>, SERVER CONSUMER SECRET?
     data.text = right_string(data.text,length_array(data.text)-8)
     while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
      data.text = right_string(data.text,length_array(data.text)-1)
     if(find_string(upper_string(data.text),'KEY',1) == 1){  //SERVER CONSUMER KEY=<key>, SERVER CONSUMER KEY?
      data.text = right_string(data.text,length_array(data.text)-3)
      while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
       data.text = right_string(data.text,length_array(data.text)-1)
      if(data.text[1] == '='){  //SERVER CONSUMER KEY=<key>
       remove_string(data.text,'=',1)
       while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
        data.text = right_string(data.text,length_array(data.text)-1)
       ES_sServerConsumerKey = data.text
      }
      else if(find_string(data.text,'?',1))  //SERVER CONSUMER KEY?
       EchoSystemDebugString(db_public,"'SERVER CONSUMER KEY=',ES_sServerConsumerKey")
     }
     else if(find_string(upper_string(data.text),'SECRET',1) == 1){  //SERVER CONSUMER SECRET=<secret>, SERVER CONSUMER SECRET?
      data.text = right_string(data.text,length_array(data.text)-6)
      while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
       data.text = right_string(data.text,length_array(data.text)-1)
      if(data.text[1] == '='){  //SERVER CONSUMER SECRET=<secret>
       remove_string(data.text,'=',1)
       while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
        data.text = right_string(data.text,length_array(data.text)-1)
       ES_sServerConsumerSecret = data.text
      }
      else if(find_string(data.text,'?',1))  //SERVER CONSUMER SECRET?
       EchoSystemDebugString(db_public,"'SERVER CONSUMER SECRET=',ES_sServerConsumerSecret")
     }
    }
    else if(find_string(upper_string(data.text),'PRODUCT GROUPS',1) == 1){  //SERVER PRODUCT GROUPS?
     if(find_string(data.text,'?',1) && length_array(ES_sServerAddress)){
      ES_eServerQuery = eProductGroups
      ServerRestCall('product-groups')
     }
    }
    else{  //SERVER?, SERVER=<address>
     if(find_string(data.text,'=',1)){  //SERVER = <address>
      remove_string(data.text,'=',1)
      while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
       data.text = right_string(data.text,length_array(data.text)-1)
      if(find_string(upper_string(data.text),'HTTPS://',1))
       EchoSystemDebugString(db_integrator,'This module uses HTTP sockets, not HTTPS sockets.')
      if(find_string(data.text,'://',1))
       remove_string(data.text,'://',1)
      if(find_string(data.text,':',1)){  //We have a port
       i = abs_value(atol(right_string(data.text,length_array(data.text) - find_string(data.text,':',1))))
       if(i == 0)
        i = SERVER_DEFAULT_HTTP_PORT
       data.text = left_string(data.text,find_string(data.text,':',1)-1)
      }
      else
       i = SERVER_DEFAULT_HTTP_PORT
      if((data.text != ES_sServerAddress) || (i != ES_iServerPort)){
       ES_sServerAddress = data.text
       ES_iServerPort = i
      }
     }
     else if(find_string(data.text,'?',1)){  //SERVER?
      if(length_array(ES_sServerAddress)){
       if(ES_iServerPort != SERVER_DEFAULT_HTTP_PORT)
        EchoSystemDebugString(db_public,"'SERVER=',ES_sServerAddress,':',itoa(ES_iServerPort)")
       else
        EchoSystemDebugString(db_public,"'SERVER=',ES_sServerAddress")
      }
      else
       EchoSystemDebugString(db_public,'SERVER=<undefined>')
     }
    }
   }
   active(find_string(upper_string(data.text),'DEVICE',1) == 1):{  //All device-related commands
    data.text = right_string(data.text,length_array(data.text)-6)
    while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
     data.text = right_string(data.text,length_array(data.text)-1)
    if(find_string(upper_string(data.text),'REFRESH',1) == 1){  //DEVICE REFRESH=<seconds>, DEVICE REFRESH?
     data.text = right_string(data.text,length_array(data.text)-7)
     while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
      data.text = right_string(data.text,length_array(data.text)-1)
     if(data.text[1] == '='){  //DEVICE REFRESH=<seconds>
      remove_string(data.text,'=',1)
      if(atol(data.text) != (ES_iDeviceRefreshTime[1] / 1000)){
       ES_iDeviceRefreshTime[1] = abs_value(atol(data.text)) * 1000  //Seconds-to-miliseconds
       if(ES_iDeviceRefreshTime[1] == 0){  //Stop device polling
        if(timeline_active(tlDeviceRefresh))
         timeline_pause(tlDeviceRefresh)
       }
       else{
        if(!timeline_active(tlDeviceRefresh)){  //Device has not been polled since system power-up.  Turn on repeat polling.
         timeline_create(tlDeviceRefresh,ES_iDeviceRefreshTime,1,timeline_relative,timeline_repeat)
         timeline_reload(tlDeviceRefresh,ES_iDeviceRefreshTime,1)  //Reload after create, to avoid Reload-Error in terminal.
        }
        else{
         timeline_reload(tlDeviceRefresh,ES_iDeviceRefreshTime,1)
         timeline_restart(tlDeviceRefresh)
        }
        //Perform an initial hit on the device.  Minimum polling period is 1 second, so we jump to <max_time> - 0.5 seconds.
        timeline_set(tlDeviceRefresh,(ES_iDeviceRefreshTime[1] - 500))
       }
      }
     }
     else if(data.text[1] == '?'){  //DEVICE REFRESH?
      switch(ES_iDeviceRefreshTime[1] / 1000){
       case 0: EchoSystemDebugString(db_public,'DEVICE REFRESH=0')
       case 1: EchoSystemDebugString(db_public,'DEVICE REFRESH=1 second')
       default: EchoSystemDebugString(db_public,"'DEVICE REFRESH=',itoa(ES_iDeviceRefreshTime[1] / 1000),' seconds'")
      }
     }
     else{  //DEVICE REFRESH
      EchoSystemDeviceRefresh()  //A one-shot check of the device state
     }
    }
    else if(find_string(upper_string(data.text),'TYPE',1) == 1){  //DEVICE TYPE?
     data.text = right_string(data.text,length_array(data.text)-4)
     while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
      data.text = right_string(data.text,length_array(data.text)-1)
     if(data.text[1] == '?'){  //DEVICE TYPE?
      select{
       active(ES_eDeviceType == typeProHarwareCapture):{    EchoSystemDebugString(db_public,'DEVICE TYPE=SafeCapture HD') }
       active(ES_eDeviceType == typeBasicHardwareCapture):{ EchoSystemDebugString(db_public,'DEVICE TYPE=Capture Appliance') }
       active(1):{                                          EchoSystemDebugString(db_public,'DEVICE TYPE=<undefined>') }
      }
     }
    }
    else if(find_string(upper_string(data.text),'SERIAL',1) == 1){  //DEVICE SERIAL?
     data.text = right_string(data.text,length_array(data.text)-6)
     while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
      data.text = right_string(data.text,length_array(data.text)-1)
     if(data.text[1] == '?'){  //DEVICE SERIAL?
      if(length_array(ES_sDeviceSerial))
       EchoSystemDebugString(db_public,"'DEVICE SERIAL=',ES_sDeviceSerial")
      else
       EchoSystemDebugString(db_public,'DEVICE SERIAL=<undefined>')
     }
    }
    else if(find_string(upper_string(data.text),'TEMPERATURE',1) == 1){  //DEVICE TEMPERATURE?
     data.text = right_string(data.text,length_array(data.text)-11)
     while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
      data.text = right_string(data.text,length_array(data.text)-1)
     if(data.text[1] == '?'){  //DEVICE TEMPERATURE?
      ES_eDeviceQuery = eGetLogs
      on[ES_iDeviceTemperatureExplicit]  //Force a response from the module regardless of current temperature.
      wait_until(!ES_bDevicePortBusy) 'low priority device query'
       DeviceGetMessage("'/log-list-last-count/',itoa(DEVICE_MAX_LOG_ENTRIES)")
     }
    }
    else if(find_string(upper_string(data.text),'PRODUCT GROUPS',1) == 1){  //DEVICE PRODUCT GROUPS?
     if(find_string(data.text,'?',1)){
      on[ES_iDeviceProductGroupsExplicit]
      send_command vdvDevice,'DEVICE REFRESH'
     }
    }
    else if(find_string(upper_string(data.text),'REBOOT',1) == 1){  //DEVICE REBOOT
     data.text = right_string(data.text,length_array(data.text)-6)
     ES_eDeviceQuery = eReboot
     cancel_wait 'low priority device query'
     wait_until(!ES_bDevicePortBusy)
      DevicePostMessage('/diagnostics/reboot')
    }
    //The following credential features are provided since ESS Schedule API does not yet supply hardware credentials.
    else if(find_string(upper_string(data.text),'USERNAME',1) == 1){  //DEVICE USERNAME=<value>, DEVICE USERNAME?
     data.text = right_string(data.text,length_array(data.text)-8)
     while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
      data.text = right_string(data.text,length_array(data.text)-1)
     if(data.text[1] == '='){  //DEVICE USERNAME=<value>
      remove_string(data.text,'=',1)
      while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
       data.text = right_string(data.text,length_array(data.text)-1)
      ES_sDeviceUsername = data.text
      ES_sDeviceKey = EncrBase64Encode("ES_sDeviceUsername,':',ES_sDevicePassword")
     }
     else if(data.text[1] == '?'){
      EchoSystemDebugString(db_public,"'DEVICE USERNAME=',ES_sDeviceUsername")
     }
    }
    else if(find_string(upper_string(data.text),'PASSWORD',1) == 1){  //DEVICE PASSWORD=<value>
     data.text = right_string(data.text,length_array(data.text)-8)
     while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
      data.text = right_string(data.text,length_array(data.text)-1)
     if(data.text[1] == '='){  //DEVICE PASSWORD=<value>
      remove_string(data.text,'=',1)
      while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
       data.text = right_string(data.text,length_array(data.text)-1)
      ES_sDevicePassword = data.text
      ES_sDeviceKey = EncrBase64Encode("ES_sDeviceUsername,':',ES_sDevicePassword")
     }
     else if(data.text[1] == '?'){
      if(length_array(ES_sDevicePassword) > 0)
       EchoSystemDebugString(db_public,'DEVICE PASSWORD is not empty')
      else
       EchoSystemDebugString(db_public,'DEVICE PASSWORD is empty')
     }
    }
    else if(find_string(upper_string(data.text),'FIRMWARE?',1) == 1){  //DEVICE FIRMWARE?
     if(length_array(ES_SDeviceFWVersion) > 0)
      EchoSystemDebugString(db_public,"'DEVICE FIRMWARE=v',ES_SDeviceFWVersion")
     else
      EchoSystemDebugString(db_public,'DEVICE FIRMWARE=<unknown>')
    }
    else if(find_string(upper_string(data.text),'API?',1) == 1){  //DEVICE API?
     if(length_array(ES_sDeviceAPIVersions) > 0)
      EchoSystemDebugString(db_public,"'DEVICE API=v',ES_sDeviceAPIVersions")
     else
      EchoSystemDebugString(db_public,'DEVICE API=<unknown>')
    }
    else{                                                             //DEVICE=<address>, DEVICE?
     while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
      data.text = right_string(data.text,length_array(data.text)-1)
     if(data.text[1] == '='){  //DEVICE=<address>
      remove_string(data.text,'=',1)
      while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
       data.text = right_string(data.text,length_array(data.text)-1)
      if(data.text != ES_sDeviceIP){
       ES_sDeviceIP = data.text
       on[ES_bDevicePersistentSocket]
       if(ES_bDevicePortOpen){
        ip_client_close(vdvAppliance.port)
        off[ES_bDevicePortOpen]
       }
       DeviceGetMessage('/status/system')
      }
     }
     else if(find_string(data.text,'?',1)){  //DEVICE?
      if(length_array(ES_sDeviceIP) > 0)
       EchoSystemDebugString(db_public,"'DEVICE=',ES_sDeviceIP")
      else
       EchoSystemDebugString(db_public,"'DEVICE=<undefined>'")
     }
    }
   }
   active(find_string(upper_string(data.text),'COUNTDOWN',1) == 1):{  //COUNTDOWN=<minutes>, COUNTDOWN?
    data.text = right_string(data.text,length_array(data.text)-9)
    while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
     data.text = right_string(data.text,length_array(data.text)-1)
    if(data.text[1] == '='){  //COUNTDOWN=<minutes>
     remove_string(data.text,'=',1)
     ES_iDeviceTimeThreshold = abs_value(atoi(data.text)) * 60  //Minutes to seconds
    }
    else if(find_string(data.text,'?',1)){
     switch(ES_iDeviceTimeThreshold / 60){
      case 0: EchoSystemDebugString(db_public,'COUNTDOWN=0')
      case 1: EchoSystemDebugString(db_public,'COUNTDOWN=1 minute')
      default: EchoSystemDebugString(db_public,"'COUNTDOWN=',itoa(ES_iDeviceTimeThreshold / 60),' minutes'")
     }
    }
   }
   active(find_string(upper_string(data.text),'STOP',1) == 1):{  //STOP
    ES_eDeviceQuery = eStop
    DevicePostMessage('/capture/stop')
   }
   active(find_string(upper_string(data.text),'PAUSE',1) == 1):{  //PAUSE
    ES_eDeviceQuery = ePause
    DevicePostMessage('/capture/pause')
   }
   active(find_string(upper_string(data.text),'RESUME',1) == 1):{  //RESUME
    ES_eDeviceQuery = eResume
    DevicePostMessage('/capture/record')
   }
   active(find_string(upper_string(data.text),'EXTEND',1) == 1):{  //EXTEND=<minutes>
    if(find_string(data.text,'=',1)){
     remove_string(data.text,'=',1)
     ES_iDeviceExtendBy = type_cast(abs_value(atol(data.text))) * 60  //CA extension is in seconds
     if(ES_iDeviceExtendBy > 1800){
      ES_iDeviceExtendBy = 1800
      EchoSystemDebugString(db_integrator,'Capture hardware can only be extended by a maximum of 30min at a time.')
     }
    }
    else
     ES_iDeviceExtendBy = 300  //Default 5 minutes
    if(ES_iDeviceExtendBy > 0){
     ES_eDeviceQuery = eExtend
     DevicePostMessage("'/capture/extend?duration=',itoa(ES_iDeviceExtendBy),'&extend=submit'")
    }
   }
   active(find_string(upper_string(data.text),'AD HOC',1) == 1):{  //AD HOC=<description>;<minutes>;<product group>
    if(find_string(data.text,'=',1)){
     remove_string(data.text,'=',1)
     //Check to ensure we have only two ';' characters.
     i = 1  //index
     j = 0  //counter
     for(i = 1; i <= length_array(data.text); i++){
      if(data.text[i] == ';')
       j = j + 1
     }
     if(j == 2){  //Correct format
      //Description and ProductGroup may not necessarily be URL-safe, espectially when there is an '&' involved.
      sAdHocDescription = remove_string(data.text,';',1)
      sAdHocDescription = left_string(sAdHocDescription, length_array(sAdHocDescription) - 1)  //Drop the ';'
      sAdHocDescription = URLEncode(sAdHocDescription)  //Make URL-safe
      
      iAdHocDuration = (atoi(left_string(data.text,find_string(data.text,';',1))) * 60)
      if(iAdHocDuration > 14400)
       iAdHocDuration = 14400  //Restrict to 4 hours (14400 seconds).
      remove_string(data.text,';',1)
      sAdHocProductGroup = URLEncode(data.text)  //Make URL-safe
      wait_until(!ES_bDevicePortBusy){
       DevicePostMessage("'/capture/new_capture?description=',sAdHocDescription,
                                              '&duration=',itoa(iAdHocDuration),
                                              '&capture_profile_name=',sAdHocProductGroup")
       //Rog - This may change one day to use product_group parameter.
      }
     }
     else if(j > 2){
      EchoSystemDebugString(db_integrator,'Too many ; characters in Ad Hoc request!  Only use ; for separating parameters!')
      EchoSystemDebugString(db_integrator,'Format: AD HOC=<desc>;<minutes>;<product group>')
     }
     else
      EchoSystemDebugString(db_integrator,'Format: AD HOC=<desc>;<minutes>;<product group>')
    }
   }
   active(find_string(upper_string(data.text),'CURRENT PRODUCT GROUP?',1) == 1):{
    if([vdvDevice,chRecording] || [vdvDevice,chPaused])
     on[ES_bCurrentProductGroup]
    else
     EchoSystemDebugString(db_integrator,'No capture is running.  Can not get CURRENT PRODUCT GROUP.')
   }
   active(find_string(upper_string(data.text),'TITLE?',1) == 1):{
    if([vdvDevice,chRecording] || [vdvDevice,chPaused])
     on[ES_bCurrentTitle]
    else
     EchoSystemDebugString(db_integrator,'No capture is running.  Can not get TITLE.')
   }
   active(find_string(upper_string(data.text),'PRESENTERS?',1) == 1):{
    if([vdvDevice,chRecording] || [vdvDevice,chPaused])
     on[ES_bCurrentPresenters]
    else
     EchoSystemDebugString(db_integrator,'No capture is running.  Can not get PRESENTERS.')
   }
   active(find_string(upper_string(data.text),'DUMP',1) == 1):{  //DUMP
    if(!ES_bDump){
     EchoSystemDebugString(db_integrator,'Beginning packet dump...')
     ES_hDumpFile = file_open('echo_dump.log',file_rw_new)  //Overwrite existing file.
     select{
      active(ES_hDumpFile == -2):{ EchoSystemDebugString(db_integrator,'Invalid file path or name.') }
      active(ES_hDumpFile == -3):{ EchoSystemDebugString(db_integrator,'Invalid valud supplied for IO flag') }
      active(ES_hDumpFile == -5):{ EchoSystemDebugString(db_integrator,'Disk I/O error') }
      active(ES_hDumpFile == -14):{ EchoSystemDebugString(db_integrator,'Maximum number of files (10) already open') }
      active(ES_hDumpFile == -15):{ EchoSystemDebugString(db_integrator,'Invalid file format') }
     }
     on[ES_bDump]
     wait 600 'Dumping'{
      off[ES_bDump]
      file_close(ES_hDumpFile)
      EchoSystemDebugString(db_integrator,'Packet dump complete.')
     }
    }
   }
   active(find_string(upper_string(data.text),'DEBUG',1) == 1):{  //DEBUG=<level>
    data.text = right_string(data.text,length_array(data.text)-5)
    while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
     data.text = right_string(data.text,length_array(data.text)-1)
    if(data.text[1] == '='){  //DEBUG=<level>
     remove_string(data.text,'=',1)
     data.text = trim(data.text)
     select{
      active(find_string(data.text,'0',1)):{
       ES_iDebugLevel = 0
       send_string 0,'EchoSystem: Debug is off.'
      }
      active(atoi(data.text) > 0):{  //All other numbers result in debug level 1.
       ES_iDebugLevel = 1
       send_string 0,'EchoSystem: Debug is on.'
      }
      active(find_string(upper_string(data.text),'SWIN DEV',1)):{
       ES_iDebugLevel = 2
       send_string 0,'EchoSystem: Debug is developer.'
      }
      active(find_string(upper_string(data.text),'SWIN HASH',1)):{
       ES_iDebugLevel = 3
       send_string 0,'EchoSystem: Debug is on dev + hash.'
      }
     }
    }
    else if(find_string(data.text,'?',1)){
     switch(ES_iDebugLevel){
      case 0: send_string 0,'EchoSystem: Debug is off.'
      case 1: send_string 0,'EchoSystem: Debug is on.'
      case 2: send_string 0,'EchoSystem: Debug is developer.'
      case 3: send_string 0,'EchoSystem: Debug is dev + hash.'
     }
    }
   }
   active(find_string(upper_string(data.text),'VERSION',1) == 1):{
    data.text = right_string(data.text,length_array(data.text)-7)
    while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
     data.text = right_string(data.text,length_array(data.text)-1)
    if(data.text[1] == '?'){  //VERSION?
     EchoSystemDebugString(db_public,"'VERSION=',cVersion")
    }
   }
   active(find_string(upper_string(data.text),'INFO',1) == 1):{
    data.text = right_string(data.text,length_array(data.text)-4)
    while((data.text[1] == ' ') && length_array(data.text))  //Slirp space
     data.text = right_string(data.text,length_array(data.text)-1)
    if(data.text[1] == '?'){  //INFO?
     EchoSystemDebugString(db_public,"'INFO=EchoSystem module v',cVersion")
     EchoSystemDebugString(db_public,'INFO=Roger McLean, Swinburne University')
     EchoSystemDebugString(db_public,'INFO=http://opax.swin.edu.au/~romclean/amx/echo')
     EchoSystemDebugString(db_public,'INFO=AMX Forum ID: annuello')
    }
   }
   active(find_string(upper_string(data.text),'API SERVER GET',1) == 1):{
    if(ES_iDebugLevel >= 2){  //Developer-only
     data.text = right_string(data.text,length_array(data.text) - 14)
     ES_eServerQuery = eNone
     ClearServerBuffer()
     ServerRestCall(trim(data.text))
    }
   }
   active(find_string(upper_string(data.text),'API DEVICE GET',1) == 1):{
    if(ES_iDebugLevel >= 2){  //Developer-only
     data.text = right_string(data.text,length_array(data.text) - 14)
     ClearDeviceBuffer()
     DeviceGetMessage(trim(data.text))
    }
   }
   active(find_string(upper_string(data.text),'API DEVICE POST',1) == 1):{
    if(ES_iDebugLevel >= 2){  //Developer-only
     data.text = right_string(data.text,length_array(data.text) - 15)
     ClearDeviceBuffer()
     DevicePostMessage(trim(data.text))
    }
   }
//   active(find_string(data.text,'test=',1) == 1):{
//    if(ES_iDebugLevel >= 2){  //Developer-only
//     remove_string(data.text,'test=',1)
//     send_string 0,"'Pre trim(',data.text,') length: ',itoa(length_array(data.text))"
//     send_string 0,"'Post trim(',trim(data.text),') length: ',itoa(length_array(trim(data.text)))"
//    }
//   }
  }
 }
}

define_program
wait 10{
 if(ES_iDeviceTimeRemaining > 0){
  ES_iDeviceTimeRemaining = ES_iDeviceTimeRemaining - 1
  if((ES_iDeviceTimeRemaining <= ES_iDeviceTimeThreshold) && (ES_iDeviceTimeRemaining > 0)){
   if(![vdvDevice,chIdle])
    EchoSystemDebugString(db_public,"'TIME=',SecondsToTime(ES_iDeviceTimeRemaining)")
  }
  else if(ES_iDeviceTimeRemaining == 0){
   EchoSystemDebugString(db_public,'TIME=')
  }
 }
 ES_iServerTime =  ES_iServerTime + 1  //For beta-release timeouts only.
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
