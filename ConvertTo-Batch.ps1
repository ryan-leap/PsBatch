<#
.SYNOPSIS
  Creates a batch file with an embedded PowerShell command
.DESCRIPTION
  Script creates a batch file which when executed will run a PowerShell encoded command.  This utility is meant
  to simplify adding PowerShell commands to a batch file
.PARAMETER Command
  Specifies the date of interest.  Defaults to the current date.
.NOTES
   Author: Ryan Leap
   Email: ryan.leap@gmail.com

   Reference article on 'FOR' batch command:
   https://devblogs.microsoft.com/oldnewthing/20120731-00/?p=7003

   IDERA posted a similar script in their PowerTips Blog
   https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/converting-powershell-to-batch

#>
[CmdletBinding()]
Param (

  [Parameter(Mandatory=$true)]
  [string] $Command

)

[string] $encodedCommand = [convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($Command))

$batchTemplate = @"
@ECHO OFF
SETLOCAL
REM --------------------------------------------------------------------------
REM -
REM -
REM - Batch file made by [$($MyInvocation.MyCommand.Name)] on [$((Get-Date).ToString())]
REM -
REM - PowerShell command which is encoded:
REM -
REM - [$Command]
REM -
REM --------------------------------------------------------------------------

SET RUN_PS_CMD_ENCODED=powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -EncodedCommand
SET PS_CMD_ENCODED=$encodedCommand

REM --------------------------------------------------------------------------
REM - Set an environment variable to the output of the PowerShell Command
REM --------------------------------------------------------------------------
FOR /F "delims=" %%i in ('%RUN_PS_CMD_ENCODED% "%PS_CMD_ENCODED%"') DO SET PS_CMD_OUTPUT=%%i
@ECHO %PS_CMD_OUTPUT%

ENDLOCAL
"@

$batchTemplate