ReadMe first.txt - EchoSystem bundle
Roger McLean, Swinburne University
v3.3.0, 20140123
http://opax.swin.edu.au/~romclean/amx/echo

This EchoSystem bundle contains a module with documentation, as well as numerous code sample demos.
All code samples are optional and are not required for a successful deployment.  They are provided
simply to get you up and running quickly.  The sample code assumes a touch panel is being used.

EchoSytem.pdf
Documentation for the module.

EchoSystem.tko
The module itself, for incorporation into your project.

EchoSystem demo.axs
This is the main file which calls in the module.  It shows how to set up the module using a server-based
config or stand-alone config.  It also shows a few tricks with the server-based config so that you can
run a completely DHCP-based deployment.

EchoSystem config.axi
This shows how to configure the bulk of the module parameters from a touch panel.  (In practice you
would not make such features accessible to the general public.)  It may be preferable to store and load
the Consumer Key and Consumer Secret from a file on the AMX.

EchoSystem room list.axi
This feature requires server-based config.  It queries the EchoSystem Server for rooms and presents
them as a list on the touch panel.  You can then select the room you want from the scrolling list.
It also has a three-step wizard which allows you to configure the room via Campus->Building->Room.

EchoSystem monitor.axi
This shows various string, channel and level feedback from the module.  It also allows you to issue
a soft-reboot of the capture hardware.

EchoSystem control.axi
This is a typical set of controls and feedback that you can provide to an academic.  The example includes
selective feedback: Scheduled and Ad Hoc recordings are shown as "Recording", and Monitoring recordings
are shown as Idle.  This allows the EchoSystem admins to remotely monitor capture hardware functionality
without turning on OnAir lights in the room.  Refer to your institutions policies prior to creating
selective feedback.  Be aware that the LEDs on the front of the capture hardware will still light up
regardless of what feedback the AMX provides.

EchoSystem ad hoc.axi
This shows how to perform an Ad Hoc recording, initiated from the AMX.  An Ad Hoc recording requires the
following before it can be created: Description, Duration and Product Group.  The example retrieves the
available Product Groups from the device and displays them as a list.  You may wish to provide such a
list to an academic, or simply hard-code a default Duration and Product Group.  At the time of writing
(20140123), Ad Hoc recordings are sent to the EchoSystem Server upon completion.  EchoSystem admins
need to manually process and associate the Ad Hoc recordings with an existing Course/Module.

EchoSystem product groups.axi
This shows how to retrive all Product Groups from the EchoSystem server, and set up human-readable
alternatives for each Product Group.  (The Product Group names can be rather long, and not necessarily
understandable to non-technical people.)  It also shows how particular Product Groups can be flagged to
turn on additional spot/flood lights for improved camera quality.

ECHOSYSTEM_PRODGROUPS.txt
An example file used with the above "EchoSystem product groups.axi" demonstration.  The .txt file can be
placed on the AMX master and loaded by the demonstration.  Note that multiple Capture Profiles can have
the same alias/shortName.

RMSMain.axi
This is sample code to be integrated with your existing RMSMain.axi file.  This has been tested with RMS v3.3.
