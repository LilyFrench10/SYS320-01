. (Join-Path $PSScriptRoot C:\Users\champuser\Desktop\Eventlog.ps1)

clear

$loginoutsTable = Get-LoginLogoffRecords -Days 15
$loginoutsTable

$shutdownsTable = Get-StartupShutdownRecords2 -Days 25
$shutdownsTable 

$startTable = Get-StartupShutdownRecords -Days 25
$startTable
