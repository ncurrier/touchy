# Touchy 1.0.0
# Define the one-liners
$oneLiners = @(
    { Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Enable-PnpDevice -Confirm:$false },
    { Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Disable-PnpDevice -Confirm:$false },
    { Get-PnpDevice | Where-Object {$_.FriendlyName -like '*compliant pen*'} | Enable-PnpDevice -Confirm:$false },
    { Get-PnpDevice | Where-Object {$_.FriendlyName -like '*compliant pen*'} | Disable-PnpDevice -Confirm:$false }
)

# Display the Touch and Pen Controller header
Write-Host "                                     " -BackgroundColor Yellow -ForegroundColor Black
Write-Host "  Touchy - Touch and Pen Controller  " -BackgroundColor Yellow -ForegroundColor Black
Write-Host "   Version 1.0.0 - Pixelchemist      " -BackgroundColor Yellow -ForegroundColor DarkGray
Write-Host "                                     " -BackgroundColor Yellow -ForegroundColor Black

# Display the available options
Write-Host "Select one of the following options:" -ForegroundColor White
Write-Host "1. Enable Touch Screen" -ForegroundColor Cyan
Write-Host "2. Disable Touch Screen" -ForegroundColor Red
Write-Host "3. Enable Pen Input" -ForegroundColor Green
Write-Host "4. Disable Pen Input" -ForegroundColor Yellow
Write-Host "`n" -ForegroundColor Cyan

# Prompt user for selection
$selection = Read-Host "Enter the option number"

# Validate the selection
if ($selection -ge 1 -and $selection -le $oneLiners.Count) {
    # Run the selected one-liner as an administrator
    $scriptBlock = $oneLiners[$selection - 1]
    $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptBlock.ToString()))
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -EncodedCommand $encodedCommand"
    Write-Host "`n" -ForegroundColor Cyan
    Write-Host "Executing the selected command as an administrator..." -ForegroundColor White
}
else {
    Write-Host "Invalid selection. Please choose a valid option." -ForegroundColor Red
}

# Prompt to press any key to exit
Write-Host "`n" -ForegroundColor Cyan
Write-Host "Press any key to exit..." -ForegroundColor White
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
