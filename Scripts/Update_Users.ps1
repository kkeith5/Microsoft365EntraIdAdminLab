Connect-MgGraph -Scopes "User.ReadWrite.All"

$csvPath = ".\bank_users.csv"

$users = Import-Csv -Path $csvPath

foreach ($user in $users) {
    try {
        Update-MgUser -UserId $user.UserPrincipalName `
                       -Country $user.Country `
                       -Department $user.Department `
                       -UsageLocation "IE" `
                       -ErrorAction Stop

        Write-Host "Updated $($user.UserPrincipalName) - Country: $($user.Country), Department: $($user.Department)" -ForegroundColor Green
    }
    catch {
        Write-Host "FAILED: $($user.UserPrincipalName) - $($_.Exception.Message)" -ForegroundColor Red
    }
}