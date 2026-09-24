Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All"

$csvPath = ".\bank_users.csv"

$users = Import-Csv -Path $csvPath

foreach ($user in $users) {
    try {
        $mgUser = Get-MgUser -UserId $user.UserPrincipalName -ErrorAction Stop
        $mgGroup = Get-MgGroup -Filter "displayName eq '$($user.SecurityGroup)'" -ErrorAction Stop

        if (-not $mgGroup) {
            Write-Host "FAILED: Group not found - $($user.SecurityGroup)" -ForegroundColor Red
            continue
        }

        New-MgGroupMember -GroupId $mgGroup.Id -DirectoryObjectId $mgUser.Id -ErrorAction Stop

        Write-Host "Added $($user.UserPrincipalName) to $($user.SecurityGroup)" -ForegroundColor Green
    }
    catch {
        Write-Host "FAILED: $($user.UserPrincipalName) - $($_.Exception.Message)" -ForegroundColor Red
    }
}