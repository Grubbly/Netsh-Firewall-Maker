::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: firewallMaker.bat                                                                                    ::
:: Tristan Van Cise                                                                                     ::
:: 03/14/2018                                                                                           ::
:: For ALCCDC 2018                                                                                      ::
::                                                                                                      ::
:: Tired of windows firewall rules taking 8 hours to type? Use this script, save yourself the pain.     ::
::                                                                                                      ::
:: How to use:                                                                                          ::
:: Typical IO program, except this one creates netsh firewall rules and outputs them to                 ::
:: a batch script (just remember to add the .bat suffix to your filename...                             ::
:: or change it after if you're a pleb)                                                                 ::
::                                                                                                      ::
:: Yes, I am using gotos (feelsbadman.jpg) but the only other loop (for) breaks everything >:(          ::
:: CMD sucks, but Windows 2003 Servers need firewall rules too.                                         ::
:: Also, I made this at 3am so there are probably bugs that I'll fix later                              ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@ECHO OFF
color 03

echo.
echo *** WARNING: Entering the name of a script that already exist will overwrite the content of that file. ***
echo *** Backup firewall rules using: netsh advfirewall export "C:\temp\fwBackup.wfw" ***
echo.

set /P fileName=Script Name (remember to add the .bat suffix ex. firewall.bat):
echo FILENAME: %fileName%
copy /b NUL %fileName%


echo.
echo netsh advfirewall firewall set rule name=all profile=any new enable=no
echo netsh advfirewall firewall delete rule profile=any name=all
echo netsh advfirewall set allprofiles state on
echo netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound
echo netsh advfirewall set allprofiles logging filename "C:\wof.log"
echo.
set /P response=Add above policies? (y/n):
IF /i "%response%"=="y" (goto setDefaultPolicies) ELSE (echo Policies Not Added)

:top
SETLOCAL
echo.
set /P name=name=
set /P dir=dir=
set /P action=action=
set /P protocol=protocol=
set /P localip=localip=
set /P remoteip=remoteip=

set /P response=Specify the next set of rules: 1=localport, 2=remoteport, 3=both (1 or blank,2,3):
IF /i "%response%"=="2" (set /P remoteport=remoteport=) ELSE IF /i "%response%"=="3" (set /P localport=localport= & set /P remoteport=remoteport=) ELSE (set /P localport=localport=)
IF /i "%response%"=="2" (set ports=remoteport=%remoteport%) ELSE IF /i "%response%"=="3" (set ports=localport=%localport% remoteport=%remoteport%) ELSE (set ports=localport=%localport%)

echo.
echo Created Rule:
echo.
echo netsh advfirewall firewall add rule profile=any name="%name%" dir=%dir% action=%action% protocol=%protocol% localip=%localip% remoteip=%remoteip% %ports%

echo.
set /P response=Add rule to %fileName%? (y/n):
cls
IF /i "%response%"=="n" (echo Rule Deleted & goto top) ELSE (echo Rule Added)

echo netsh advfirewall firewall add rule profile=any name="%name%" dir=%dir% action=%action% protocol=%protocol% localip=%localip% remoteip=%remoteip% %ports%>> %fileName%
ENDLOCAL
goto top


:setDefaultPolicies
echo.
echo netsh advfirewall firewall set rule name=all profile=any new enable=no >> %fileName%
echo netsh advfirewall firewall delete rule profile=any name=all >> %fileName%
echo netsh advfirewall set allprofiles state on >> %fileName%
echo netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound >> %fileName%
echo netsh advfirewall set allprofiles logging filename "C:\wof.log" >> %fileName%
echo. Done writing default policies, entering custom rule loop
echo.
goto top
