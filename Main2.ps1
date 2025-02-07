. C:\Users\champuser\Desktop\Apache-Logs.ps1


$ipcount = Get-ApacheLogs -Page "sdf" -Http 404 -Browser "Chrome" 
$ipcount | Out-String
