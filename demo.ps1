#
# Lighting Demo - Using PowerShell.exe -EncodedCommand argument
#
# Use your PowerShell Fu from batch scripts by encoding the PowerShell Command(s)
#


# Easy to do in PowerShell and from Command Prompt
(Get-Date).Hour


# Easy to do in PowerShell, not so easy from Command Prompt
"[Hour:Minute:Second] is [$((Get-Date).Hour):$((Get-Date).Minute):$((Get-Date).Second)]"


# Copy and paste the powershell.exe encoded command example
$command = '"[Hour:Minute:Second] is [$((Get-Date).Hour):$((Get-Date).Minute):$((Get-Date).Second)]"'
$bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
$encodedCommand = [Convert]::ToBase64String($bytes)


# ConvertTo-Batch Demo
. .\ConvertTo-Batch.ps1
ConvertTo-Batch -Command $command | clip
ConvertTo-Batch -Command $command -BatchEnvVarName HOUR_MIN_SEC | clip


# Batch is_admin.bat
ConvertTo-Batch -Command (Get-Content .\Test-ForAdmin.ps1 -Raw) -BatchEnvVarName IS_RUNNING_AS_ADMIN | clip


# Quick Recap
#
# 1. Practical - add some PowerShell to an existing batch file w/out rewriting the batch
#
# 2. Effective - doesn't get tripped up on quoting/escaping
#
# 3. Portable - allows you to embed PowerShell within a Batch File (no external PowerShell file)
#
# Get 'ConvertTo-Batch' function from my GitHub
#
# https://github.com/ryan-leap/PsBatch
#
