@echo off
set user=%1
set password=%2

if "%3" == "show" (
	echo using user "%user%" with password "%password%"
) 

echo recreating tables...
mysql --user=%user% --password=%password% mysql < _tables.sql
if %errorlevel% gtr 0 goto error
echo tables OK

echo creating views
mysql --user=%user% --password=%password% pathfinder < _view.sql
if %errorlevel% gtr 0 goto error
echo views OK

echo creating methods
mysql --user=%user% --password=%password% pathfinder < auth.sql
if %errorlevel% gtr 0 goto error
mysql --user=%user% --password=%password% pathfinder < issue.sql
if %errorlevel% gtr 0 goto error
mysql --user=%user% --password=%password% pathfinder < setup.sql
if %errorlevel% gtr 0 goto error
mysql --user=%user% --password=%password% pathfinder < user.sql
if %errorlevel% gtr 0 goto error
echo methods OK

echo creating standard data
mysql --user=%user% --password=%password% pathfinder < _data.sql
if %errorlevel% gtr 0 goto error
echo data OK

goto ok

:error
echo there were errors during database recreation
goto finish
:ok
echo database recreated
:finish