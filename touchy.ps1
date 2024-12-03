# Ascii Art
# Define the one-liners
$oneLiners = @(
    { Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Enable-PnpDevice -Confirm:$false },
    { Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Disable-PnpDevice -Confirm:$false },
    { Get-PnpDevice | Where-Object {$_.FriendlyName -like '*pen*'} | Enable-PnpDevice -Confirm:$false },
    { Get-PnpDevice | Where-Object {$_.FriendlyName -like '*pen*'} | Disable-PnpDevice -Confirm:$false },
    { 
        Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*' -or $_.FriendlyName -like '*pen*'} | 
        Enable-PnpDevice -Confirm:$false 
    },
    { 
        Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*' -or $_.FriendlyName -like '*pen*'} | 
        Disable-PnpDevice -Confirm:$false 
    }
)

# Display the header
function Show-Header {
    Write-Host "                                     " -BackgroundColor Yellow -ForegroundColor Black
    Write-Host "  Touchy - Touch and Pen Controller  " -BackgroundColor Yellow -ForegroundColor Black
    Write-Host "   Version 1.2.0 - Pixelchemist      " -BackgroundColor Yellow -ForegroundColor DarkGray
    Write-Host "                                     " -BackgroundColor Yellow -ForegroundColor Black
}

# Display the menu
function Show-Menu {
    Write-Host "`nSelect one of the following options:" -ForegroundColor White
    Write-Host "1. Enable Touch Screen" -ForegroundColor Cyan
    Write-Host "2. Disable Touch Screen" -ForegroundColor Red
    Write-Host "3. Enable Pen Input" -ForegroundColor Green
    Write-Host "4. Disable Pen Input" -ForegroundColor Yellow
    Write-Host "5. Enable Both (Touch Screen & Pen)" -ForegroundColor Cyan
    Write-Host "6. Disable Both (Touch Screen & Pen)" -ForegroundColor Red
    Write-Host "7. Quit" -ForegroundColor Magenta
    Write-Host "`n" -ForegroundColor White
}

# Execute the selected action
function Execute-Selection {
    param ([int]$selection)

    if ($selection -ge 1 -and $selection -le $oneLiners.Count) {
        $scriptBlock = $oneLiners[$selection - 1]
        $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptBlock.ToString()))
        Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -EncodedCommand $encodedCommand"
        Write-Host "`nExecuting the selected command as an administrator..." -ForegroundColor White
    }
    elseif ($selection -eq 7) {
        Write-Host "`nExiting Touchy. Goodbye!" -ForegroundColor Magenta
        exit
    }
    else {
        Write-Host "`nInvalid selection. Please choose a valid option." -ForegroundColor Red
    }
}

# Main loop
while ($true) {
    Clear-Host
    Show-Header
    Show-Menu
    $selection = Read-Host "Enter the option number"

    # Validate the input
    if ([int]::TryParse($selection, [ref]$null)) {
        # Convert to integer after validation
        $selection = [int]$selection
        Execute-Selection -selection $selection
    }
    else {
        Write-Host "`nInvalid input. Please enter a number corresponding to the menu options." -ForegroundColor Red
    }
    
    Write-Host "`nPress any key to continue..." -ForegroundColor White
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
