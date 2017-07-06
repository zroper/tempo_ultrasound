@echo off
REM MAKESYSI.BAT - Create SYSTEM.INI network file.
REM %1 is drive letter of network directory (eg: G:)
REM %2 is network card driver (eg: EL90X.DOS)
REM %3 is the servername (eg: KernelServer) - this must be unique
REM 15Nov05 sh  Change $3 to %3 in computername


echo ;                                   >system.ini
echo ; Created by MAKESYSI.BAT          >>system.ini
echo ;                                  >>system.ini
echo [network]                          >>system.ini 
echo filesharing=no                     >>system.ini 
echo printsharing=no                    >>system.ini 
echo autologon=yes                      >>system.ini 
echo computername=%3                    >>system.ini 
echo lanroot=%1\                        >>system.ini 
echo username=YOURNAME                  >>system.ini 
echo workgroup=WORKGROUP                >>system.ini 
echo reconnect=yes                      >>system.ini 
echo dospophotkey=N                     >>system.ini 
echo lmlogon=0                          >>system.ini 
echo logondomain=WORKGROUP              >>system.ini 
echo preferredredir=basic               >>system.ini 
echo autostart=basic                    >>system.ini 
echo maxconnections=8                   >>system.ini 
echo ;                                  >>system.ini
echo [network drivers]                  >>system.ini 
echo netcard=%2                         >>system.ini 
echo transport=ndishlp.sys              >>system.ini 
echo devdir=%1\                         >>system.ini 
echo LoadRMDrivers=yes                  >>system.ini 
echo ;                                  >>system.ini
echo [Password Lists]                   >>system.ini 
echo *Shares=%1\Shares.PWL              >>system.ini 
