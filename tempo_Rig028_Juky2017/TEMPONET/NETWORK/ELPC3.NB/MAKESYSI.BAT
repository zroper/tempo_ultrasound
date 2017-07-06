@echo off
REM 3C589E 3COM/Megahertz pcmcia card for laptops
REM 
REM MAKESYSI.BAT - Create SYSTEM.INI network file.
REM $1 is drive letter of network directory (eg: G:)
REM $2 is network card driver (eg: ELPC3)
REM $3 is the servername (eg: KernelServer) - this must be unique
REM
REM Note: In config.sys, emm386.exe must have RAM NOEMS X=EF00-EFFF
REM We also need to use 3com's enabler
REM Uses ELPC3.DOS driver from 3com

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


REM Load 3com's enabler for the card, FMENABLE.EXE


fmenable
