Connect-MgGraph -Scopes "User.ReadWrite.All"

$csvPath = ".\bank_users.csv"
$outputPath = ".\created_users_passwords.csv"

$users = Import-Csv -Path $csvPath
$report = @()

foreach ($user in $users) {
    $tempPassword = "BankPass2026!" + (Get-Random -Minimum 1000 -Maximum 9999)

    $userParams = @{
        GivenName = $user.FirstName
        Surname = $user.LastName
        DisplayName = $user.DisplayName
        UserPrincipalName = $user.UserPrincipalName
        Department = $user.Department
        JobTitle = $user.JobTitle
        AccountEnabled = $true
        MailNickname = $user.FirstName.ToLower()
        PasswordProfile = @{
            Password = $tempPassword
            ForceChangePasswordNextSignIn = $true
        }
    }

    try {
        $newUser = New-MgUser -BodyParameter $userParams -ErrorAction Stop

        $report += [PSCustomObject]@{
            UserPrincipalName = $user.UserPrincipalName
            TemporaryPassword = $tempPassword
        }

        Write-Host "Successfully created user: $($user.UserPrincipalName)" -ForegroundColor Green
    }
    catch {
        Write-Host "FAILED to create user: $($user.UserPrincipalName) - $($_.Exception.Message)" -ForegroundColor Red
    }
}

$report | Export-Csv -Path $outputPath -NoTypeInformation
Write-Host "Done! Passwords saved to $outputPath" -ForegroundColor Cyan