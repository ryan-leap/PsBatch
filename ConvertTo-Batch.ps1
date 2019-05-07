function ConvertTo-Batch {
<#
.SYNOPSIS
  Converts a PowerShell command (in the form of a string) to a batch-formatted string.
.DESCRIPTION
  Takes a PowerShell command(s), Base64 encodes it, and embeds it into a batch (Windows batch file) template.
  This utility is meant to simplify calling PowerShell commands from within a batch file.
.PARAMETER Command
  Specifies PowerShell command(s) that will be encoded and embedded into a batch file.
.PARAMETER BatchEnvVarName
  Specifies an environment variable (to embed within the batch file) to assign to the output of the 
  PowerShell command(s).
.PARAMETER CharsPerBatchLine
  Specifies a limit to the number of characters to place per comment line of the resultant batch file.
  This is just for formatting purposes.
.EXAMPLE
  '(Get-Date).DayOfWeek' | ConvertTo-Batch | Out-File -FilePath '.\day_of_week.bat' -Encoding ascii
  Produces a batch file which will output the day of the week
.EXAMPLE
  '(Get-Date).DayOfWeek' | ConvertTo-Batch -BatchEnvVarName 'DAY_OF_WEEK' | Out-File -FilePath '.\day_of_week.bat' -Encoding ascii
  Produces a batch file which will assign an environment variable to the day of the week
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

    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [string] $Command,

    [Parameter(Mandatory=$false)]
    [string] $BatchEnvVarName,

    [ValidateRange(79,160)]
    [Parameter(Mandatory=$false)]
    [int] $CharsPerLineInBatchComment = 110
  )

  [string] $encodedCommand = [convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($Command))

  #
  # Place the PowerShell code in a line-wrapped comment block within the batch file
  #
  [string] $commandSansNewLine = $Command.Replace([System.Environment]::NewLine, ' ')
  [int] $charsPerLineLessRemPrefix = $CharsPerLineInBatchComment - 'REM - '.Length
  [string] $dashes = '-' * $charsPerLineLessRemPrefix
  [int] $charsPerLineOfPsCode = $CharsPerLineLessRemPrefix - ' []'.Length
  [string] $psCodeBatchComment = ''
  for ($i = 0; $i -lt [math]::Ceiling($commandSansNewLine.Length / $charsPerLineOfPsCode); $i++) {
    [int] $startIndex = $i * $charsPerLineOfPsCode
    [int] $length = [math]::Min($charsPerLineOfPsCode, $commandSansNewLine.Length - $startIndex)
    $psCodeBatchComment += "REM - [$($commandSansNewLine.Substring($startIndex, $length))]"
    if ($length -eq $charsPerLineOfPsCode) { 
      $psCodeBatchComment += [System.Environment]::NewLine
    }
  }

  if ($BatchEnvVarName) {
    $batchRunSection = @"
REM -$dashes
REM -
REM - Set PowerShell output to Env Var
REM -
REM -$dashes
FOR /F "delims=" %%i in ('%RUN_PS_CMD_ENCODED% "%PS_CMD_ENCODED%"') DO SET $BatchEnvVarName=%%i
@ECHO %$BatchEnvVarName%
"@
  }
  else {
    $batchRunSection = @"
REM -$dashes
REM -
REM - Run PowerShell command
REM -
REM -$dashes
%RUN_PS_CMD_ENCODED% "%PS_CMD_ENCODED%"
"@
  }

  $batchTemplate = @"
@ECHO OFF
SETLOCAL

REM -$dashes
REM -
REM - Created by [$($MyInvocation.MyCommand.Name)]
REM -
REM - PowerShell command which is encoded:
REM -
$psCodeBatchComment
REM -
REM -$dashes
SET RUN_PS_CMD_ENCODED=powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -EncodedCommand
SET PS_CMD_ENCODED=$encodedCommand

$batchRunSection

ENDLOCAL
"@

  $batchTemplate
}