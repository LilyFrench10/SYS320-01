function Get-LoginLogoffRecords 
{
    param ([int]$Days)
$loginouts = Get-EventLog System -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-$Days)

$loginoutsTable = @()
for($i=0; $i -lt $loginouts.Count; $i++) 
{
    $event = ""
    if($loginouts[$i].InstanceId -eq 7001) {$event="Logon"}
    if($loginouts[$i].InstanceId -eq 7002) {$event="Logoff"}

    #unsure
    $userSID = ($loginouts[$i].ReplacementStrings[1])
    try {
            $sid = New-Object System.Security.Principal.SecurityIdentifier($userSID)
            $user = $sid.Translate([System.Security.Principal.NTAccount]).Value
        } catch{
                $user = "Unknown User ($userSID)"
        }

    $loginoutsTable += [PSCustomObject]@{"Time" = $loginouts[$i].TimeGenerated;
                                            "Id" = $loginouts[$i].InstanceId;
                                            "Event" = $event;
                                            "User" = $user;
                                                                                        }
}

return $loginoutsTable
}


function Get-StartupShutdownRecords {
    param ([int]$Days)

    $startupShutdowns = Get-EventLog System -InstanceID 2147489653 -After (Get-Date).AddDays(-$Days)
    $startupShutdownTable = @()

    for ($i = 0; $i -lt $startupShutdowns.count; $i++) 
    {
        if ($startupShutdowns[$i].EventID -eq 6005) { $event = "Startup" }
        
        $user = "System"

        $startupShutdownTable += [PSCustomObject]@{
        
          "Time" = $startupShutdowns[$i].TimeGenerated
          "ID" = $startupShutdowns[$i].EventID
          "Event" = $event 
          "User" = $user 
        }
    }

    return $startupShutdownTable
}

function Get-StartupShutdownRecords2 {
    param ([int]$Days)

    $startupShutdowns = Get-EventLog System -InstanceID 2147489654 -After (Get-Date).AddDays(-$Days)
    $startupShutdownTable = @()

    for ($i = 0; $i -lt $startupShutdowns.count; $i++) 
    {
        
        if ($startupShutdowns[$i].EventID -eq 6006){ $event = "Shutdown" }
        $user = "System"

        $startupShutdownTable += [PSCustomObject]@{
        
          "Time" = $startupShutdowns[$i].TimeGenerated
          "ID" = $startupShutdowns[$i].EventID
          "Event" = $event 
          "User" = $user 
        }
    }

    return $startupShutdownTable
}


$logresults = Get-LoginLogoffRecords -Days $Days
$startresults = Get-StartupShutdownRecords -Days $Days

$logresults 

$startresults
