@echo off
color 03

::set to desktop
cd "C:\Users\UAF Calamine\Desktop"

set /p fn=Script name (remember .bat):
echo filename: %fn%
copy /b NUL %fn%

echo.
set /p r=Add default policies? (y/n):
IF /i "%r%"=="y" (goto setDefaultPolicies) ELSE (echo Policies Not Added)

:top
SETLOCAL
echo.
set /p n=name=
set /p d=dir=
set /p a=action=
set /p p=protocol=
set /p lip=localip=
set /p rip=remoteip=

set /p r=Specify the next set of rules: 1=localport, 2=remoteport, 3=both (1 or blank,2,3):
IF /i "%r%"=="2" (set /p rp=remoteport=) ELSE IF /i "%r%"=="3" (set /p lp=localport= & set /p rp=remoteport=) ELSE (set /p lp=localport=)
IF /i "%r%"=="2" (set ports=remoteport=%rp%) ELSE IF /i "%r%"=="3" (set ports=localport=%lp% remoteport=%rp%) ELSE (set ports=localport=%lp%)

echo.
echo Created Rule:
echo.
echo netsh advfirewall firewall add rule profile=any name="%n%" dir=%d% action=%a% protocol=%p% localip=%lip% remoteip=%rip% %ports%

echo.
set /p r=Add rule to %fn%? (y/n):
cls
IF /i "%r%"=="n" (echo Rule Deleted & goto top) ELSE (echo Rule Added)

::copy from echo above 
echo netsh advfirewall firewall add rule profile=any name="%n%" dir=%d% action=%a% protocol=%p% localip=%lip% remoteip=%rip% %ports%>> %fn%
ENDLOCAL
goto top


:setDefaultPolicies
echo.
echo netsh advfirewall firewall set rule name=all profile=any new enable=no >> %fn%
echo netsh advfirewall firewall delete rule profile=any name=all >> %fn%
echo netsh advfirewall set allprofiles state on >> %fn%
echo netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound >> %fn%
echo netsh advfirewall set allprofiles logging filename "C:\wof.log" >> %fn%
echo. Done writing default policies, entering custom rule loop
echo.
goto top
