@echo off
title Campaign Desk
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Start-CampaignDesk.ps1"
if errorlevel 1 (
  echo.
  echo Campaign Desk could not start. Read the message above, then press any key.
  pause >nul
)
