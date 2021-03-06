# PsBatch
PsBatch is project with a PowerShell function which converts a PowerShell command (in the form of a string) to a batch-formatted string. 
Specifically, ```ConvertTo-Batch``` accepts PowerShell command(s) (as a string), Base64 encodes the command(s), and embeds the encoding
into a Windows batch file template. This utility is meant to simplify calling PowerShell commands from within a batch file, which is
sometimes complicated by the command line processors handling of quotes and other special characters.

## Installing
#### Download from GitHub repository

* Download the repository from https://github.com/ryan-leap/PsBatch
* Unblock the zip file ((on Windows) Right Click -> Properties -> [v/] Unblock)

## Usage
```powershell
# Dot-source the file to bring the function in scope
. .\ConvertTo-Batch.ps1

# Get help
Get-Help ConvertTo-Batch
```

## Examples
### Produces a batch file which will output the day of the week
```powershell
PS C:\> '(Get-Date).DayOfWeek' | ConvertTo-Batch | Out-File -FilePath '.\day_of_week.bat' -Encoding ascii
PS C:\> Get-Content .\day_of_week.bat
@ECHO OFF
SETLOCAL

REM ---------------------------------------------------------------------------------------------------------
REM -
REM - Created by [ConvertTo-Batch]
REM -
REM - PowerShell command which is encoded:
REM -
REM - [(Get-Date).DayOfWeek]
REM -
REM ---------------------------------------------------------------------------------------------------------
SET RUN_PS_CMD_ENCODED=powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -EncodedCommand
SET PS_CMD_ENCODED=KABHAGUAdAAtAEQAYQB0AGUAKQAuAEQAYQB5AE8AZgBXAGUAZQBrAA==

REM ---------------------------------------------------------------------------------------------------------
REM -
REM - Run PowerShell command
REM -
REM ---------------------------------------------------------------------------------------------------------
%RUN_PS_CMD_ENCODED% "%PS_CMD_ENCODED%"

ENDLOCAL
```
### Produces a batch file which will assign an environment variable to the day of the week
```powershell
PS C:\> '(Get-Date).DayOfWeek' | ConvertTo-Batch -BatchEnvVarName 'DAY_OF_WEEK' | Out-File -FilePath '.\day_of_week.bat' -Encoding ascii
PS C:\> Get-Content .\day_of_week.bat
@ECHO OFF
SETLOCAL

REM ---------------------------------------------------------------------------------------------------------
REM -
REM - Created by [ConvertTo-Batch]
REM -
REM - PowerShell command which is encoded:
REM -
REM - [(Get-Date).DayOfWeek]
REM -
REM ---------------------------------------------------------------------------------------------------------
SET RUN_PS_CMD_ENCODED=powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -EncodedCommand
SET PS_CMD_ENCODED=KABHAGUAdAAtAEQAYQB0AGUAKQAuAEQAYQB5AE8AZgBXAGUAZQBrAA==

REM ---------------------------------------------------------------------------------------------------------
REM -
REM - Set PowerShell output to Env Var
REM -
REM ---------------------------------------------------------------------------------------------------------
FOR /F "delims=" %%i in ('%RUN_PS_CMD_ENCODED% "%PS_CMD_ENCODED%"') DO SET DAY_OF_WEEK=%%i
@ECHO %DAY_OF_WEEK%

ENDLOCAL
```
## Author(s)

* **Ryan Leap** - *Initial work*

## License

Licensed under the MIT License.  See [LICENSE](LICENSE.md) file for details.

## Acknowledgments

* [Using the 'FOR' command in a batch file](https://devblogs.microsoft.com/oldnewthing/20120731-00/?p=7003)
* [IDERA post about converting PowerShell to Batch](https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/converting-powershell-to-batch)
