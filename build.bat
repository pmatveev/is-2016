@echo off

if "%1" == "recreate" (
	cd workspace\Tracker\SQL
 	call recreate.bat %2 %3 %4
	cd ..\..\..
	if %errorlevel% gtr 0 goto error
)

echo starting maven...
cd workspace\Tracker
call mvn clean install
if %errorlevel% gtr 0 goto error
echo maven OK

echo stopping Tomcat
call %CATALINA_HOME%\bin\shutdown.bat

echo deleting Tomcat application
rd /s /q %CATALINA_HOME%\webapps\Tracker
del /q %CATALINA_HOME%\webapps\Tracker.war

echo publishing Tomcat application
cd target
copy /B Tracker.war %CATALINA_HOME%\webapps\
cd ../../..

echo starting Tomcat
call %CATALINA_HOME%\bin\startup.bat

goto ok

:error
echo there were errors during build
goto finish
:ok
echo finished successfully
:finish