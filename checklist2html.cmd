@echo off
set CSLDIR=%~dp0
set LUA_PATH=%CSLDIR%;%CSLDIR%?.lua;%LUA_PATH%
lua %CSLDIR%checklist2html %*