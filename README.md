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
```powershell
PS C:\> # Produces a batch file which will output the day of the week
PS C:\> '(Get-Date).DayOfWeek' | ConvertTo-Batch | Out-File -FilePath '.\day_of_week.bat' -Encoding ascii
```
```powershell
PS C:\> # Produces a batch file which will assign an environment variable to the day of the week
PS C:\> '(Get-Date).DayOfWeek' | ConvertTo-Batch -BatchEnvVarName 'DAY_OF_WEEK' | Out-File -FilePath '.\day_of_week.bat' -Encoding ascii
```
## Author(s)

* **Ryan Leap** - *Initial work*

## License

Licensed under the MIT License.  See [LICENSE](LICENSE.md) file for details.

## Acknowledgments

* [Using the 'FOR' command in a batch file](https://devblogs.microsoft.com/oldnewthing/20120731-00/?p=7003)
* [IDERA post about converting PowerShell to Batch](https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/converting-powershell-to-batch)
