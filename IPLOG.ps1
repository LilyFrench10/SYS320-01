$notfounds = Get-Content -Path C:\xampp\apache\logs\*.log | Where-Object {$_ -match '404' }
$notfounds | Out-String 
$regex = [regex] '((\d{1,3}\.){3}\d{1,3})'

$ipsUnorg = $regex.Matches($notfounds)

$ips = @()
for($i=0; $i -lt $ipsUnorg.Count; $i++)
{
    $ips+= [pscustomobject]@{ "IP" = $ipsUnorg[$i].Value }
}
$ips | Where-Object { $_.IP -ilike "10.*"} | Out-String

$ipsoftens= $ips | Where-Object {$_.IP -ilike "10.*"}

$counts = $ipsoftens | Group-Object -Property IP |Sort-Object Count -Descending
$counts | Select-Object Name, Count

