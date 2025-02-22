. (Join-Path $PSScriptRoot String-Helper.ps1)


<# ******************************
     Function Explaination
****************************** #>
function getLogInAndOffs($timeBack){

$loginouts = Get-EventLog system -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays("-"+"$timeBack")

$loginoutsTable = @()
for($i=0; $i -lt $loginouts.Count; $i++){

$type = ""
if($loginouts[$i].InstanceID -eq 7001) {$type="Logon"}
if($loginouts[$i].InstanceID -eq 7002) {$type="Logoff"}


# Check if user exists first
$user = (New-Object System.Security.Principal.SecurityIdentifier `
         $loginouts[$i].ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])

$loginoutsTable += [pscustomobject]@{"Time" = $loginouts[$i].TimeGenerated; `
                                       "Id" = $loginouts[$i].InstanceId; `
                                    "Event" = $type; `
                                     "User" = $user;
                                     }
} # End of for

return $loginoutsTable
} # End of function getLogInAndOffs




<# ******************************
     Function Explaination
****************************** #>
function getFailedLogins($timeBack){
  
  $failedlogins = Get-EventLog security -After (Get-Date).AddDays("-"+"$timeBack") | Where { $_.InstanceID -eq "4625" } | Select-Object -Last 10

  $failedloginsTable = @()
  for($i=0; $i -lt $failedlogins.Count; $i++){

    $account=""
    $domain="" 

    $usrlines = getMatchingLines $failedlogins[$i].Message "*Account Name*"
    $usr = $usrlines[1].Split(":")[1].trim()

    $dmnlines = getMatchingLines $failedlogins[$i].Message "*Account Domain*"
    $dmn = $dmnlines[1].Split(":")[1].trim()

    $user = $dmn+"\"+$usr;

    $failedloginsTable += [pscustomobject]@{"Time" = $failedlogins[$i].TimeGenerated; `
                                       "Id" = $failedlogins[$i].InstanceId; `
                                    "Event" = "Failed"; `
                                     "User" = $user;
                                     }

    }

    return $failedloginsTable
} # End of function getFailedLogins
function getFailedLogins2($timeBack){
  
  $failedlogins = Get-EventLog security -After (Get-Date).AddDays("-"+"$timeBack") | Where { $_.InstanceID -eq "4625" }

  $failedloginsTable = @()
  for($i=0; $i -lt $failedlogins.Count; $i++){

    $account=""
    $domain="" 

    $usrlines = getMatchingLines $failedlogins[$i].Message "*Account Name*"
    $usr = $usrlines[1].Split(":")[1].trim()

    $dmnlines = getMatchingLines $failedlogins[$i].Message "*Account Domain*"
    $dmn = $dmnlines[1].Split(":")[1].trim()

    $user = $dmn+"\"+$usr;

    $failedloginsTable += [pscustomobject]@{"Time" = $failedlogins[$i].TimeGenerated; `
                                       "Id" = $failedlogins[$i].InstanceId; `
                                    "Event" = "Failed"; `
                                     "User" = $user;
                                     }

    }
    $groupUsers = $failedloginsTable | Group-Object -Property User
    $riskUsers = @()
    $groupUsers | ForEach-Object {
        if($_.Count -ge 10)
        {
            $riskUsers += $_.Name
        }
    }

    return $riskUsers
}
