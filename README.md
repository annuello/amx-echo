# amx-echo
AMX module for intergrating AMX NetLinx masers with Echo360 EchoSystem Server.

The EchoSystem.axs file shows how to correctly implement: MD5, SHA-1, HMAC-SHA1 and two-legged OAuth.

This is the "as-is" version of EchoSystem module v3.3.0 and accompanying demo code.  At the time of initial module release (2014) AMX masters were all of the NI generation, hence the use of code in the DEFINE_PROGRAM sections.  Something for you to consider when deploying to the newer NX masters.

When used in production environments v3.3.0 there were isolated reports (and first-hand observances) of comms between the SCHD and AMX halting after two weeks.  Due to deployment complexities the root cause was not determined, so the recommendation at the time was to roll back to v3.2.2 of the module.  The root cause may have been due to AMX and/or SCHD firmware, which may have been resolved in subsequent updates.
