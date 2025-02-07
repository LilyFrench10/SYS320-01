function Get-ApacheLogs {
    param (
        [string]$Page,
        [int]$HttpCode,
        [string]$Browser,
        [string]$LogFile = "C:\xampp\apache\logs\*.log"
    )

    

    $Pattern = "^(\S+) .*?`"(GET|POST)\s+/" + [regex]::Escape($Page) + "\s+HTTP.*?`\s+" + $HttpCode + "\s+.*?`".*?" + [regex]::Escape($Browser) + ".*?`""
    $Matches = Select-String -Path $LogFile -Pattern $Pattern
    
    $regex = [regex] '((\d{1,3}\.){3}\d{1,3})'

$ipsUnorg = $regex.Matches($notfounds)

$ips = @()
for($i=0; $i -lt $ipsUnorg.Count; $i++)
{
    $ips+= [pscustomobject]@{ "IP" = $ipsUnorg[$i].Value }
}


$ipsoftens= $ips | Where-Object {$_.IP -ilike "10.*"}

$counts = $ipsoftens | Group-Object -Property IP |Sort-Object Count -Descending
$counts | Select-Object Name, Count
    
}
