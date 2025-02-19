. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)

clear

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - Get at Risk Users `n"
$Prompt += "10 - Exit`n"



$operation = $true

while($operation){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 10){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }

    elseif($choice -eq 1){
        $enabledUsers = getEnabledUsers
        Write-Host ($enabledUsers | Format-Table | Out-String)
    }

    elseif($choice -eq 2){
        $notEnabledUsers = getNotEnabledUsers
        Write-Host ($notEnabledUsers | Format-Table | Out-String)
    }


    # Create a user
    elseif($choice -eq 3){ 

        $name = Read-Host -Prompt "Please enter the username for the new user"
        $password = Read-Host -AsSecureString -Prompt "Please enter the password for the new user"

        
        $checkUser = checkUser -name $name
        Write-Host $checkUser "user" | Out-String
        
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
        $PasswordText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
        
        $checkPass = checkPassword -PasswordText $PasswordText
        Write-Host $checkPass "pass" | Out-String

        
        if ($checkPass -and -not $checkUser)
        {
            createAUser $name $password

            Write-Host "User: $name is created." | Out-String
        }
        else
        {
            Write-Host "User not created"
        }
        
    }


    # Remove a user
    elseif($choice -eq 4){

        $name = Read-Host -Prompt "Please enter the username for the user to be removed"

        
        $checkUser = checkUser -name $name

        if ($checkUser)
        {
            removeAUser $name

            Write-Host "User: $name Removed." | Out-String
        }
        
    }


    # Enable a user
    elseif($choice -eq 5){


        $name = Read-Host -Prompt "Please enter the username for the user to be enabled"

        
        $checkUser = checkUser -name $name

        if ($checkUser)
        {
            enableAUser $name

            Write-Host "User: $name Enabled." | Out-String
        }

        
    }


    # Disable a user
    elseif($choice -eq 6){

        $name = Read-Host -Prompt "Please enter the username for the user to be disabled"

        
        $checkUser = checkUser -name $name

        if ($checkUser)
        {
            disableAUser $name

            Write-Host "User: $name Disabled." | Out-String
        }
        
    }


    elseif($choice -eq 7){

        $name = Read-Host -Prompt "Please enter the username for the user logs"
        $days = Read-Host -Prompt "Enter number of days"
        
        $checkUser = checkUser -name $name

        if ($checkUser = $true)
        {
            $userLogins = getLogInAndOffs -timeBack $days
               

            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
        }
        
    }


    elseif($choice -eq 8){

        $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"
        $days = Read-Host -Prompt "Enter number of days"

        
        if ($checkUser = $true)
        {
            $userLogins = getFailedLogins -timeBack $days

            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
        }
        
    }


    
    elseif($choice -eq 9){

            $days = Read-Host -Prompt "Enter number of days"
            
            $userList = getFailedLogins2 -timeBack $days
            Write-Host $UserList | Out-String
        
    }
    else
    {
        Write-Host "Please enter a valid option"
    }




    

}




